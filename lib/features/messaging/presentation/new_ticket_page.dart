import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';
import '../../attendance/presentation/justify_absence_page.dart';
import '../../children/application/children_providers.dart';
import '../data/messaging_repository.dart';
import 'conversations_page.dart';

/// Parcours P6 : ticket par service (finances, scolarité…), pièce jointe facultative.
class NewTicketPage extends ConsumerStatefulWidget {
  const NewTicketPage({super.key});

  @override
  ConsumerState<NewTicketPage> createState() => _NewTicketPageState();
}

class _NewTicketPageState extends ConsumerState<NewTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String _service = 'FINANCES';
  String _priority = 'NORMALE';
  PickedFile? _file;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() => _loading = true);
    try {
      final res = await ref.read(messagingRepositoryProvider).create(
            sujet: _subject.text.trim(),
            service: _service,
            message: _message.text.trim(),
            priorite: _priority,
            studentId: ref.read(activeChildProvider)?.id,
            file: _file == null ? null : await _file!.toMultipart(),
          );
      ref.invalidate(conversationsProvider);
      if (mounted) context.pushReplacement(RoutePaths.conversation(res['id'] as String));
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final child = ref.watch(activeChildProvider);
    final s = context.strato;
    return Scaffold(
      appBar: AppBar(title: Text(l.newTicket)),
      body: Form(
        key: _formKey,
        child: ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 28 + context.bottomInset), children: [
          if (child != null)
            Reveal(
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Avatar(child.initials, radius: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(child.fullName, style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: FontWeight.w700)),
                      Text(child.matricule, style: AppTextStyles.caption.copyWith(color: s.gold, letterSpacing: 1)),
                    ]),
                  ),
                ]),
              ),
            ),
          SectionLabel(l.service),
          Reveal(
            index: 1,
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (final svc in ['FINANCES', 'SCOLARITE', 'PEDAGOGIE', 'DISCIPLINE', 'SUPPORT_TECHNIQUE'])
                ChoiceChip(
                  avatar: Icon(serviceIcon(svc), size: 16, color: _service == svc ? s.onGold : serviceColor(svc)),
                  label: Text(serviceLabel(l, svc)),
                  selected: _service == svc,
                  selectedColor: s.gold,
                  labelStyle: AppTextStyles.bodySmall.copyWith(color: _service == svc ? s.onGold : s.text, fontWeight: FontWeight.w700),
                  onSelected: (_) => setState(() => _service = svc),
                ),
            ]),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: _priority,
            decoration: InputDecoration(labelText: l.priority),
            items: const [('BASSE', 'Basse'), ('NORMALE', 'Normale'), ('HAUTE', 'Haute'), ('URGENTE', 'Urgente')]
                .map((p) => DropdownMenuItem(value: p.$1, child: Text(p.$2)))
                .toList(),
            onChanged: (v) => setState(() => _priority = v ?? 'NORMALE'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _subject,
            maxLength: 150,
            decoration: InputDecoration(labelText: l.subject),
            validator: (v) => (v ?? '').trim().isEmpty ? l.fieldRequired : null,
          ),
          TextFormField(
            controller: _message,
            minLines: 5,
            maxLines: 10,
            maxLength: 4000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l.message, alignLabelWithHint: true),
            validator: (v) => (v ?? '').trim().isEmpty ? l.fieldRequired : null,
          ),
          AttachmentPicker(file: _file, label: l.attachment, onPicked: (f) => setState(() => _file = f)),
          const SizedBox(height: 24),
          AppButton(text: l.send, icon: Icons.send_rounded, isLoading: _loading, onPressed: _submit),
        ]),
      ),
    );
  }
}
