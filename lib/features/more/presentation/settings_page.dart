import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final s = context.strato;
    final theme = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final prefs = ref.watch(sharedPrefsProvider);
    var i = 0;
    Widget r(Widget w) => Reveal(index: i++, child: w);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(padding: EdgeInsets.fromLTRB(16, 0, 16, 32 + context.bottomInset), children: [
        SectionLabel(l.theme),
        r(Row(children: [
          for (final (mode, label, icon) in [
            (ThemeMode.dark, l.themeDark, Icons.nights_stay_rounded),
            (ThemeMode.light, l.themeLight, Icons.wb_sunny_rounded),
            (ThemeMode.system, l.themeSystem, Icons.brightness_auto_rounded),
          ])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _ThemeChoice(
                  mode: mode,
                  label: label,
                  icon: icon,
                  selected: theme == mode,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref.read(themeModeProvider.notifier).set(mode);
                  },
                ),
              ),
            ),
        ])),
        SectionLabel(l.language),
        r(SegmentedButton<String>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 'fr', label: Text('Français'), icon: Text('🇫🇷')),
            ButtonSegment(value: 'en', label: Text('English'), icon: Text('🇬🇧')),
          ],
          selected: {locale.languageCode},
          onSelectionChanged: (v) async {
            await ref.read(localeProvider.notifier).set(Locale(v.first));
            ref.read(authRepositoryProvider).updateLocale(v.first).catchError((_) {});
          },
        )),
        SectionLabel(l.security),
        r(GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(children: [
            _BiometricTile(enabled: prefs.isBiometricEnabled),
            Divider(height: 1, indent: 18, endIndent: 18, color: s.hairline),
            ListTile(
              leading: GlowIcon(Icons.password_rounded, color: s.accent, size: 36, radius: 12),
              title: Text(l.changePassword),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: s.textFaint),
              onTap: () => _changePassword(context, ref),
            ),
            Divider(height: 1, indent: 18, endIndent: 18, color: s.hairline),
            ListTile(
              leading: GlowIcon(Icons.devices_other_rounded, color: s.danger, size: 36, radius: 12),
              title: Text(l.logoutAll),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: s.textFaint),
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
          ]),
        )),
        SectionLabel(l.notificationPrefs),
        r(const _NotificationPrefs()),
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
            const SizedBox(height: 12),
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

/// Aperçu miniature d'un thème (ciel, carte et bouton) à toucher pour l'appliquer.
class _ThemeChoice extends StatelessWidget {
  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeChoice({required this.mode, required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final previews = switch (mode) {
      ThemeMode.dark => [Strato.night],
      ThemeMode.light => [Strato.dawn],
      ThemeMode.system => [Strato.dawn, Strato.night],
    };
    return GlassCard(
      padding: const EdgeInsets.all(8),
      radius: 20,
      onTap: onTap,
      semanticLabel: label,
      borderColor: selected ? s.gold : null,
      glow: selected ? s.gold : null,
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 74,
            child: Row(children: [
              for (final p in previews)
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: p.sky)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(height: 18, decoration: BoxDecoration(color: p.glassStrong, borderRadius: BorderRadius.circular(6), border: Border.all(color: p.hairline))),
                        const SizedBox(height: 5),
                        Container(height: 10, width: 30, decoration: BoxDecoration(color: p.textFaint.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4))),
                        const Spacer(),
                        Container(height: 12, decoration: BoxDecoration(gradient: Strato.goldGradient, borderRadius: BorderRadius.circular(6))),
                      ]),
                    ),
                  ),
                ),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 15, color: selected ? s.gold : s.textMuted),
          const SizedBox(width: 5),
          Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.caption.copyWith(color: selected ? s.text : s.textMuted, fontWeight: FontWeight.w700))),
        ]),
      ]),
    );
  }
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
    final s = context.strato;
    return SwitchListTile(
      secondary: GlowIcon(Icons.fingerprint_rounded, color: s.gold, size: 36, radius: 12),
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

/// Pastille activable (canal de notification) : dorée quand active.
class _Toggle extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.label, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Semantics(
      toggled: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(!selected);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            gradient: selected ? Strato.goldGradient : null,
            color: selected ? null : s.glass,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: selected ? Colors.transparent : s.hairlineStrong),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(selected ? Icons.check_rounded : Icons.add_rounded, size: 14, color: selected ? s.onGold : s.textMuted),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.caption.copyWith(color: selected ? s.onGold : s.textMuted, fontWeight: FontWeight.w800)),
          ]),
        ),
      ),
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
    final s = context.strato;
    final value = ref.watch(notificationPreferencesProvider);
    _prefs ??= value.value;
    if (_prefs == null) {
      return value.hasError
          ? Padding(padding: const EdgeInsets.all(16), child: Text(l.requiresNetwork, style: TextStyle(color: s.textMuted)))
          : const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator());
    }
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(children: [
        for (var i = 0; i < _prefs!.length; i++) ...[
          if (i > 0) Divider(height: 1, indent: 18, endIndent: 18, color: s.hairline),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
            child: Row(children: [
              GlowIcon(categoryIcon(_prefs![i].categorie), color: categoryColor(_prefs![i].categorie), size: 34, radius: 11),
              const SizedBox(width: 12),
              Expanded(child: Text(categoryLabel(l, _prefs![i].categorie), style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w600))),
              _Toggle(label: l.push, selected: _prefs![i].push, onChanged: (v) => _update(_prefs![i].copyWith(push: v))),
              const SizedBox(width: 6),
              _Toggle(label: l.sms, selected: _prefs![i].sms, onChanged: (v) => _update(_prefs![i].copyWith(sms: v))),
            ]),
          ),
        ],
      ]),
    );
  }
}
