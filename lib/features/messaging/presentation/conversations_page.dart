import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../../notifications/domain/notification_models.dart';
import '../data/messaging_repository.dart';
import '../domain/messaging_models.dart';

String serviceLabel(AppLocalizations l, String s) => switch (s) {
      'FINANCES' => l.service_FINANCES,
      'SCOLARITE' => l.service_SCOLARITE,
      'PEDAGOGIE' => l.service_PEDAGOGIE,
      'DISCIPLINE' => l.service_DISCIPLINE,
      _ => l.service_SUPPORT_TECHNIQUE,
    };

String ticketStatusLabel(AppLocalizations l, String s) => switch (s) {
      'OUVERT' => l.status_OUVERT,
      'EN_COURS' => l.status_EN_COURS,
      'RESOLU' => l.status_RESOLU,
      _ => l.status_CLOTURE,
    };

IconData serviceIcon(String s) => switch (s) {
      'FINANCES' => Icons.account_balance_wallet_rounded,
      'SCOLARITE' => Icons.school_rounded,
      'PEDAGOGIE' => Icons.menu_book_rounded,
      'DISCIPLINE' => Icons.gavel_rounded,
      _ => Icons.support_agent_rounded,
    };

Color serviceColor(String s) => switch (s) {
      'FINANCES' => const Color(0xFFF2C063),
      'SCOLARITE' => const Color(0xFF7AA8FF),
      'PEDAGOGIE' => const Color(0xFF34D399),
      'DISCIPLINE' => const Color(0xFFF87171),
      _ => const Color(0xFF8B7BFF),
    };

class ConversationsPage extends ConsumerWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = context.strato;
    Widget action(IconData icon, String tooltip, String route) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
            tooltip: tooltip,
            onPressed: () => context.push(route),
            icon: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(shape: BoxShape.circle, color: s.glass, border: Border.all(color: s.hairlineStrong)),
              child: Icon(icon, size: 20),
            ),
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(l.messagesTitle),
        actions: [
          action(Icons.campaign_outlined, l.announcementsTitle, RoutePaths.announcements),
          action(Icons.event_available_outlined, l.appointmentsTitle, RoutePaths.appointments),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: context.dockInset),
        child: FloatingActionButton.extended(
          onPressed: () => context.push(RoutePaths.newTicket),
          icon: const Icon(Icons.edit_rounded),
          label: Text(l.newTicket),
        ),
      ),
      body: CachedAsyncView<CursorPage<ConversationSummary>>(
        value: ref.watch(conversationsProvider),
        onRetry: () => ref.invalidate(conversationsProvider),
        isEmpty: (p) => p.items.isEmpty,
        emptyTitle: l.noConversations,
        emptyIcon: Icons.forum_outlined,
        builder: (context, page) => RefreshIndicator(
          onRefresh: () => ref.refresh(conversationsProvider.future),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 100 + context.bottomInset),
            itemCount: page.items.length,
            itemBuilder: (context, i) {
              final c = page.items[i];
              final unread = c.nonLus > 0;
              final color = serviceColor(c.service);
              return Reveal(
                index: i,
                child: GlassCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  borderColor: unread ? s.gold.withValues(alpha: 0.55) : null,
                  semanticLabel: c.sujet,
                  onTap: () async {
                    await context.push(RoutePaths.conversation(c.id));
                    ref.invalidate(conversationsProvider);
                  },
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GlowIcon(serviceIcon(c.service), color: color, size: 46),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(
                            child: Text(c.sujet,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: unread ? FontWeight.w800 : FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Text(Fmt.relative(c.dernierMessage?.createdAt ?? c.updatedAt), style: AppTextStyles.caption.copyWith(color: unread ? s.gold : s.textFaint)),
                        ]),
                        if (c.dernierMessage != null) ...[
                          const SizedBox(height: 3),
                          Text(c.dernierMessage!.contenu, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall.copyWith(color: unread ? s.text : s.textMuted)),
                        ],
                        const SizedBox(height: 8),
                        Row(children: [
                          StatusChip.status(c.statut, ticketStatusLabel(l, c.statut)),
                          const SizedBox(width: 8),
                          Flexible(child: Text('${serviceLabel(l, c.service)} · ${c.numeroTicket}', style: AppTextStyles.caption.copyWith(color: s.textFaint), overflow: TextOverflow.ellipsis)),
                          const Spacer(),
                          if (unread)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(gradient: Strato.goldGradient, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: s.gold.withValues(alpha: 0.5), blurRadius: 10)]),
                              child: Text('${c.nonLus}', style: AppTextStyles.caption.copyWith(color: s.onGold, fontWeight: FontWeight.w900)),
                            ),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
