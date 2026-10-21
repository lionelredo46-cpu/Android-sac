import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers.dart';
import '../../../core/security/app_lock.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/auth_scaffold.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../notifications/domain/notification_models.dart';
import '../../notifications/presentation/notifications_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final prefs = ref.watch(sharedPrefsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(children: [
        _Header(l.language),
        RadioGroup<String>(
          groupValue: locale.languageCode,
          onChanged: (v) async {
            if (v == null) return;
            await ref.read(localeProvider.notifier).set(Locale(v));
            ref.read(authRepositoryProvider).updateLocale(v).catchError((_) {});
          },
          child: const Column(children: [
            RadioListTile<String>(value: 'fr', title: Text('Français')),
            RadioListTile<String>(value: 'en', title: Text('English')),
          ]),
        ),
        _Header(l.theme),
        RadioGroup<ThemeMode>(
          groupValue: theme,
          onChanged: (v) => ref.read(themeModeProvider.notifier).set(v ?? ThemeMode.system),
          child: Column(children: [
            RadioListTile<ThemeMode>(value: ThemeMode.system, title: Text(l.themeSystem)),
            RadioListTile<ThemeMode>(value: ThemeMode.light, title: Text(l.themeLight)),
            RadioListTile<ThemeMode>(value: ThemeMode.dark, title: Text(l.themeDark)),
          ]),
        ),
        _Header(l.security),
        _BiometricTile(enabled: prefs.isBiometricEnabled),
        ListTile(leading: const Icon(Icons.password_rounded), title: Text(l.changePassword), onTap: () => _changePassword(context, ref)),
        ListTile(
          leading: const Icon(Icons.devices_other_rounded),
          title: Text(l.logoutAll),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                content: Text('${l.logoutAll} ?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                  FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.confirm)),
                ],
              ),
            );
            if (ok == true) await ref.read(sessionProvider.notifier).logout(allDevices: true);
          },
        ),
        _Header(l.notificationPrefs),
        const _NotificationPrefs(),
        if (ref.watch(localBackendProvider) case final local?) ...[
          const _Header('Mode démo'),
          ListTile(
            leading: const Icon(Icons.restart_alt_rounded),
            title: const Text('Réinitialiser les données de démo'),
            subtitle: const Text('Factures, messages, notifications… reviennent à leur état initial'),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: const Text('Réinitialiser toutes les données de démonstration ? Vous serez déconnecté.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.confirm)),
                  ],
                ),
              );
              if (ok != true) return;
              await local.db.reset();
              await ref.read(sessionProvider.notifier).logout();
            },
          ),
        ],
        const SizedBox(height: 32),
      ]),
    );
  }

  Future<void> _changePassword(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final current = TextEditingController();
    final next = TextEditingController();
    final key = GlobalKey<FormState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.changePassword),
        content: Form(
          key: key,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(controller: current, obscureText: true, decoration: InputDecoration(labelText: l.currentPassword)),
            TextFormField(
              controller: next,
              obscureText: true,
              decoration: InputDecoration(labelText: l.newPassword, helperText: l.passwordRules, helperMaxLines: 3),
              validator: (v) => passwordRegex.hasMatch(v ?? '') ? null : l.passwordRules,
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, key.currentState!.validate()), child: Text(l.save)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(authRepositoryProvider).changePassword(current.text, next.text);
      if (context.mounted) context.showSnack(l.passwordChanged);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(text.toUpperCase(), style: AppTextStyles.caption.copyWith(letterSpacing: 1, fontWeight: FontWeight.w700)),
      );
}

class _BiometricTile extends ConsumerStatefulWidget {
  final bool enabled;
  const _BiometricTile({required this.enabled});

  @override
  ConsumerState<_BiometricTile> createState() => _BiometricTileState();
}

class _BiometricTileState extends ConsumerState<_BiometricTile> {
  late bool _on = widget.enabled;
  bool? _available;

  @override
  void initState() {
    super.initState();
    ref.read(biometricServiceProvider).isAvailable().then((v) => mounted ? setState(() => _available = v) : null);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SwitchListTile(
      secondary: const Icon(Icons.fingerprint_rounded),
      title: Text(l.biometrics),
      subtitle: _available == false ? Text(l.biometricsUnavailable) : null,
      value: _on,
      onChanged: _available != true
          ? null
          : (v) async {
              if (v && !await ref.read(biometricServiceProvider).authenticate(l.biometricReason)) return;
              await ref.read(sharedPrefsProvider).setBiometricEnabled(v);
              setState(() => _on = v);
            },
    );
  }
}

class _NotificationPrefs extends ConsumerStatefulWidget {
  const _NotificationPrefs();

  @override
  ConsumerState<_NotificationPrefs> createState() => _NotificationPrefsState();
}

class _NotificationPrefsState extends ConsumerState<_NotificationPrefs> {
  List<NotificationPreference>? _prefs;

  Future<void> _update(NotificationPreference p) async {
    final next = _prefs!.map((x) => x.categorie == p.categorie ? p : x).toList();
    setState(() => _prefs = next);
    try {
      await ref.read(notificationsRepositoryProvider).savePreferences([p]);
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final value = ref.watch(notificationPreferencesProvider);
    _prefs ??= value.value;
    if (_prefs == null) {
      return value.hasError ? Padding(padding: const EdgeInsets.all(16), child: Text(l.requiresNetwork)) : const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator());
    }
    return Column(
      children: _prefs!
          .map((p) => ListTile(
                title: Text(categoryLabel(l, p.categorie)),
                subtitle: Wrap(spacing: 8, children: [
                  FilterChip(label: Text(l.push), selected: p.push, onSelected: (v) => _update(p.copyWith(push: v))),
                  FilterChip(label: Text(l.sms), selected: p.sms, onSelected: (v) => _update(p.copyWith(sms: v))),
                ]),
              ))
          .toList(),
    );
  }
}
