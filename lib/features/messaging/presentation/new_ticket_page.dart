import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(l.newTicket)),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          if (child != null) Card(child: ListTile(leading: Avatar(child.initials, radius: 18), title: Text(child.fullName), subtitle: Text(child.matricule))),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _service,
            decoration: InputDecoration(labelText: l.service),
            items: ['FINANCES', 'SCOLARITE', 'PEDAGOGIE', 'DISCIPLINE', 'SUPPORT_TECHNIQUE'].map((s) => DropdownMenuItem(value: s, child: Text(serviceLabel(l, s)))).toList(),
            onChanged: (v) => setState(() => _service = v ?? 'FINANCES'),
          ),
          const SizedBox(height: 12),
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
          OutlinedButton.icon(
            icon: Icon(_file == null ? Icons.attach_file_rounded : Icons.check_circle_rounded),
            label: Text(_file?.name ?? l.attachment, overflow: TextOverflow.ellipsis),
            onPressed: () async {
              final f = await pickProof(context);
              if (f != null) setState(() => _file = f);
            },
          ),
          const SizedBox(height: 24),
          AppButton(text: l.send, icon: Icons.send_rounded, isLoading: _loading, onPressed: _submit),
        ]),
      ),
    );
  }
}
