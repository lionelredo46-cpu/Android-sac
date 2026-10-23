import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';
import 'more_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final _profession = TextEditingController(text: ref.read(sessionProvider).value?.parentProfile?.profession ?? '');
  late final _address = TextEditingController(text: ref.read(sessionProvider).value?.parentProfile?.adresse ?? '');
  late final _emergency = TextEditingController(text: ref.read(sessionProvider).value?.parentProfile?.contactUrgence ?? '');
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(apiClientProvider).patch('/api/v1/me', data: {
        'profession': _profession.text.trim(),
        'adresse': _address.text.trim(),
        'contactUrgence': _emergency.text.trim(),
      });
      await ref.read(sessionProvider.notifier).refreshProfile();
      if (mounted) context.showSnack(context.l10n.save);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final user = ref.watch(sessionProvider).value;
    if (user == null) return const SizedBox.shrink();
    Widget info(IconData icon, String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            GlowIcon(icon, color: s.accent, size: 36, radius: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: AppTextStyles.caption.copyWith(color: s.textMuted)),
                Text(value, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.profile)),
      body: ListView(padding: EdgeInsets.fromLTRB(16, 4, 16, 32 + context.bottomInset), children: [
        Reveal(
          child: Column(children: [
            Avatar(user.displayName.split(' ').map((w) => w.isEmpty ? '' : w[0]).take(2).join().toUpperCase(), radius: 52, spin: true),
            const SizedBox(height: 14),
            Text(user.displayName, style: AppTextStyles.h1.copyWith(color: s.text, fontSize: 26), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(roleLabel(user.role).toUpperCase(), style: AppTextStyles.overline.copyWith(color: s.gold)),
          ]),
        ),
        const SizedBox(height: 22),
        Reveal(
          index: 1,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(children: [
              info(Icons.alternate_email_rounded, l.email, user.email ?? '—'),
              info(Icons.phone_iphone_rounded, l.phone, user.telephone ?? '—'),
              if (user.studentProfile?.matricule != null) info(Icons.badge_rounded, 'Matricule', user.studentProfile!.matricule!),
            ]),
          ),
        ),
        if (user.isParent) ...[
          SectionLabel(l.profile),
          Reveal(index: 2, child: TextField(controller: _profession, decoration: InputDecoration(labelText: l.profession, prefixIcon: const Icon(Icons.work_outline_rounded)))),
          const SizedBox(height: 12),
          Reveal(index: 3, child: TextField(controller: _address, decoration: InputDecoration(labelText: l.address, prefixIcon: const Icon(Icons.home_outlined)))),
          const SizedBox(height: 12),
          Reveal(
            index: 4,
            child: TextField(
              controller: _emergency,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l.emergencyContact, prefixIcon: const Icon(Icons.emergency_outlined)),
            ),
          ),
          const SizedBox(height: 22),
          Reveal(index: 5, child: AppButton(text: l.save, icon: Icons.check_rounded, isLoading: _saving, onPressed: _save)),
        ],
      ]),
    );
  }
}
