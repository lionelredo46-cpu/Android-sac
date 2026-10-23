import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/spring_pressable.dart';
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
    _text.addListener(() => setState(() {}));
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
    HapticFeedback.lightImpact();
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
    final s = context.strato;
    final value = ref.watch(conversationProvider(widget.conversationId));
    return Scaffold(
      appBar: AppBar(title: Text(value.value?.sujet ?? l.messagesTitle, style: AppTextStyles.h3.copyWith(color: s.text, fontSize: 19))),
      body: value.when(
        skipLoadingOnRefresh: true,
        loading: () => Center(child: CircularProgressIndicator(color: s.gold)),
        error: (e, _) => ErrorStateView(title: l.errorTitle, message: ErrorHandler.message(e), onRetry: () => ref.invalidate(conversationProvider(widget.conversationId))),
        data: (c) {
          final closed = c.statut == 'CLOTURE';
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Row(children: [
                GlowIcon(serviceIcon(c.service), color: serviceColor(c.service), size: 30, radius: 10),
                const SizedBox(width: 10),
                Expanded(child: Text('${serviceLabel(l, c.service)} · ${c.numeroTicket}', style: AppTextStyles.caption.copyWith(color: s.textMuted))),
                StatusChip.status(c.statut, ticketStatusLabel(l, c.statut)),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                itemCount: c.messages.length,
                itemBuilder: (_, i) => Reveal(
                  key: ValueKey(c.messages[c.messages.length - 1 - i].id),
                  index: i,
                  offset: 14,
                  child: _Bubble(c.messages[c.messages.length - 1 - i]),
                ),
              ),
            ),
            if (c.statut == 'RESOLU' && c.satisfaction == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Column(children: [
                    Text(l.rateService, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: s.text)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (i) => IconButton(tooltip: '${i + 1}/5', icon: Icon(Icons.star_rounded, color: s.gold, size: 34), onPressed: () => _rate(i + 1)),
                      ),
                    ),
                  ]),
                ),
              ),
            if (!closed)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (_file != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Chip(
                          avatar: Icon(Icons.attach_file_rounded, size: 16, color: s.gold),
                          label: Text(_file!.name, overflow: TextOverflow.ellipsis),
                          onDeleted: () => setState(() => _file = null),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      decoration: BoxDecoration(
                        color: s.isDark ? const Color(0xE6102F66) : const Color(0xF2FFFFFF),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: s.hairlineStrong),
                        boxShadow: [BoxShadow(color: s.shadow, blurRadius: 20, offset: const Offset(0, 6))],
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        IconButton(
                          tooltip: l.attachment,
                          icon: Icon(Icons.add_circle_outline_rounded, color: s.textMuted),
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
                            cursorColor: s.gold,
                            textCapitalization: TextCapitalization.sentences,
                            style: AppTextStyles.bodyMedium.copyWith(color: s.text),
                            decoration: InputDecoration(
                              hintText: l.writeMessage,
                              isDense: true,
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                            ),
                          ),
                        ),
                        SpringPressable(
                          onTap: _sending || _text.text.trim().isEmpty ? null : _send,
                          semanticLabel: l.send,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _text.text.trim().isEmpty ? null : Strato.goldGradient,
                              color: _text.text.trim().isEmpty ? s.glassStrong : null,
                              boxShadow: _text.text.trim().isEmpty ? null : [BoxShadow(color: s.gold.withValues(alpha: 0.5), blurRadius: 14)],
                            ),
                            child: _sending
                                ? Padding(padding: const EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2, color: s.onGold))
                                : Icon(Icons.arrow_upward_rounded, color: _text.text.trim().isEmpty ? s.textFaint : s.onGold),
                          ),
                        ),
                      ]),
                    ),
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
    final s = context.strato;
    final mine = m.moi;
    final fg = mine ? Colors.white : s.text;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(mine ? 20 : 6),
      bottomRight: Radius.circular(mine ? 6 : 20),
    );
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        decoration: BoxDecoration(
          gradient: mine ? Strato.sapphireGradient : null,
          color: mine ? null : s.glassStrong,
          borderRadius: radius,
          border: mine ? null : Border.all(color: s.hairline),
          boxShadow: mine ? [BoxShadow(color: const Color(0xFF3E7BFF).withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))] : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!mine) Padding(padding: const EdgeInsets.only(bottom: 3), child: Text(m.auteur, style: AppTextStyles.caption.copyWith(color: s.gold, fontWeight: FontWeight.w800))),
          Text(m.contenu, style: AppTextStyles.bodyMedium.copyWith(color: fg)),
          if (m.piecesJointes > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.attach_file_rounded, size: 14, color: fg.withValues(alpha: 0.8)),
                Text(' ${m.piecesJointes}', style: AppTextStyles.caption.copyWith(color: fg.withValues(alpha: 0.8))),
              ]),
            ),
          const SizedBox(height: 4),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(Fmt.dateTime(m.createdAt), style: AppTextStyles.caption.copyWith(color: fg.withValues(alpha: 0.65), fontSize: 10.5)),
            if (mine) ...[
              const SizedBox(width: 4),
              Icon(m.estLu ? Icons.done_all_rounded : Icons.done_rounded, size: 14, color: m.estLu ? const Color(0xFFFBE0A4) : fg.withValues(alpha: 0.7)),
            ],
          ]),
        ]),
      ),
    );
  }
}
