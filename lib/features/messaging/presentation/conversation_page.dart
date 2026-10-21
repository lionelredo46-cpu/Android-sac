import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/ui.dart';
import '../../attendance/presentation/justify_absence_page.dart';
import '../data/messaging_repository.dart';
import '../domain/messaging_models.dart';
import 'conversations_page.dart';

/// Fil de discussion d'un ticket. Les nouveaux messages arrivent par
/// rafraîchissement périodique (et par notification push).
class ConversationPage extends ConsumerStatefulWidget {
  final String conversationId;
  const ConversationPage({super.key, required this.conversationId});

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  final _text = TextEditingController();
  PickedFile? _file;
  bool _sending = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 15), (_) => ref.invalidate(conversationProvider(widget.conversationId)));
  }

  @override
  void dispose() {
    _poll?.cancel();
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final content = _text.text.trim();
    if (content.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(messagingRepositoryProvider).reply(widget.conversationId, content, file: _file == null ? null : await _file!.toMultipart());
      _text.clear();
      setState(() => _file = null);
      ref.invalidate(conversationProvider(widget.conversationId));
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _rate(int stars) async {
    try {
      await ref.read(messagingRepositoryProvider).rate(widget.conversationId, stars);
      ref.invalidate(conversationProvider(widget.conversationId));
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final value = ref.watch(conversationProvider(widget.conversationId));
    return Scaffold(
      appBar: AppBar(title: Text(value.value?.sujet ?? l.messagesTitle)),
      body: value.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorStateView(title: l.errorTitle, message: ErrorHandler.message(e), onRetry: () => ref.invalidate(conversationProvider(widget.conversationId))),
        data: (c) {
          final closed = c.statut == 'CLOTURE';
          return Column(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.aframPrimary.withValues(alpha: 0.05),
              child: Row(children: [
                StatusChip.status(c.statut, ticketStatusLabel(l, c.statut)),
                const SizedBox(width: 8),
                Expanded(child: Text('${serviceLabel(l, c.service)} · ${c.numeroTicket}', style: AppTextStyles.caption)),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: c.messages.length,
                itemBuilder: (_, i) => _Bubble(c.messages[c.messages.length - 1 - i]),
              ),
            ),
            if (c.statut == 'RESOLU' && c.satisfaction == null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Text(l.rateService, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) => IconButton(tooltip: '${i + 1}/5', icon: const Icon(Icons.star_rounded, color: AppColors.aframGold, size: 32), onPressed: () => _rate(i + 1))),
                  ),
                ]),
              ),
            if (!closed)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (_file != null)
                      Chip(label: Text(_file!.name, overflow: TextOverflow.ellipsis), onDeleted: () => setState(() => _file = null)),
                    Row(children: [
                      IconButton(
                        tooltip: l.attachment,
                        icon: const Icon(Icons.attach_file_rounded),
                        onPressed: () async {
                          final f = await pickProof(context);
                          if (f != null) setState(() => _file = f);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _text,
                          minLines: 1,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(hintText: l.writeMessage, isDense: true),
                        ),
                      ),
                      IconButton.filled(
                        tooltip: l.send,
                        onPressed: _sending ? null : _send,
                        icon: _sending ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded),
                      ),
                    ]),
                  ]),
                ),
              ),
          ]);
        },
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage m;
  const _Bubble(this.m);

  @override
  Widget build(BuildContext context) {
    final mine = m.moi;
    final bg = mine ? AppColors.aframPrimary : Theme.of(context).cardColor;
    final fg = mine ? Colors.white : Theme.of(context).colorScheme.onSurface;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine ? null : Border.all(color: AppColors.borderLight),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!mine) Text(m.auteur, style: AppTextStyles.caption.copyWith(color: AppColors.aframGold, fontWeight: FontWeight.w700)),
          Text(m.contenu, style: AppTextStyles.bodyMedium.copyWith(color: fg)),
          if (m.piecesJointes > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.attach_file_rounded, size: 14, color: fg), Text(' ${m.piecesJointes}', style: TextStyle(color: fg))]),
            ),
          const SizedBox(height: 4),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(Fmt.dateTime(m.createdAt), style: AppTextStyles.caption.copyWith(color: fg.withValues(alpha: 0.7))),
            if (mine) ...[
              const SizedBox(width: 4),
              Icon(m.estLu ? Icons.done_all_rounded : Icons.done_rounded, size: 14, color: m.estLu ? AppColors.aframGoldLight : fg.withValues(alpha: 0.7)),
            ],
          ]),
        ]),
      ),
    );
  }
}
