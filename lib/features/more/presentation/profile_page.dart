import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';

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
    final user = ref.watch(sessionProvider).value;
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(title: Text(l.profile)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: Avatar(user.displayName.split(' ').map((w) => w.isEmpty ? '' : w[0]).take(2).join().toUpperCase(), radius: 40)),
        const SizedBox(height: 12),
        Center(child: Text(user.displayName, style: AppTextStyles.h2)),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              KeyValueRow(l.email, user.email ?? '—'),
              KeyValueRow(l.phone, user.telephone ?? '—'),
              if (user.studentProfile?.matricule != null) KeyValueRow('Matricule', user.studentProfile!.matricule!),
            ]),
          ),
        ),
        if (user.isParent) ...[
          const SizedBox(height: 16),
          TextField(controller: _profession, decoration: InputDecoration(labelText: l.profession)),
          const SizedBox(height: 12),
          TextField(controller: _address, decoration: InputDecoration(labelText: l.address)),
          const SizedBox(height: 12),
          TextField(controller: _emergency, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: l.emergencyContact)),
          const SizedBox(height: 20),
          FilledButton(onPressed: _saving ? null : _save, child: Text(l.save)),
        ],
      ]),
    );
  }
}
