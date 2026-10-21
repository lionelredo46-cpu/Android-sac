import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
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

class ConversationsPage extends ConsumerWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.messagesTitle),
        actions: [
          IconButton(tooltip: l.announcementsTitle, icon: const Icon(Icons.campaign_outlined), onPressed: () => context.push(RoutePaths.announcements)),
          IconButton(tooltip: l.appointmentsTitle, icon: const Icon(Icons.event_available_outlined), onPressed: () => context.push(RoutePaths.appointments)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RoutePaths.newTicket),
        icon: const Icon(Icons.edit_rounded),
        label: Text(l.newTicket),
      ),
      body: CachedAsyncView<CursorPage<ConversationSummary>>(
        value: ref.watch(conversationsProvider),
        onRetry: () => ref.invalidate(conversationsProvider),
        isEmpty: (p) => p.items.isEmpty,
        emptyTitle: l.noConversations,
        emptyIcon: Icons.forum_outlined,
        builder: (context, page) => RefreshIndicator(
          onRefresh: () => ref.refresh(conversationsProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 96),
            itemCount: page.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, i) {
              final c = page.items[i];
              return ListTile(
                onTap: () async {
                  await context.push(RoutePaths.conversation(c.id));
                  ref.invalidate(conversationsProvider);
                },
                leading: CircleAvatar(
                  backgroundColor: AppColors.aframPrimary.withValues(alpha: 0.1),
                  child: Icon(_serviceIcon(c.service), color: AppColors.aframPrimary),
                ),
                title: Row(children: [
                  Expanded(child: Text(c.sujet, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium.copyWith(fontWeight: c.nonLus > 0 ? FontWeight.w800 : FontWeight.w600))),
                  Text(Fmt.relative(c.dernierMessage?.createdAt ?? c.updatedAt), style: AppTextStyles.caption),
                ]),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (c.dernierMessage != null) Text(c.dernierMessage!.contenu, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    StatusChip.status(c.statut, ticketStatusLabel(l, c.statut)),
                    const SizedBox(width: 6),
                    Flexible(child: Text('${serviceLabel(l, c.service)} · ${c.numeroTicket}', style: AppTextStyles.caption, overflow: TextOverflow.ellipsis)),
                  ]),
                ]),
                trailing: c.nonLus > 0 ? Badge(label: Text('${c.nonLus}')) : null,
              );
            },
          ),
        ),
      ),
    );
  }

  static IconData _serviceIcon(String s) => switch (s) {
        'FINANCES' => Icons.account_balance_wallet_outlined,
        'SCOLARITE' => Icons.school_outlined,
        'PEDAGOGIE' => Icons.menu_book_outlined,
        'DISCIPLINE' => Icons.gavel_outlined,
        _ => Icons.support_agent_outlined,
      };
}
