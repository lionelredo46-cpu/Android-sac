import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/notifications/push_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../data/notifications_repository.dart';
import '../domain/notification_models.dart';

String categoryLabel(AppLocalizations l, String c) => switch (c) {
      'FINANCE' => l.category_FINANCE,
      'PRESENCE' => l.category_PRESENCE,
      'NOTES' => l.category_NOTES,
      'EMPLOI_DU_TEMPS' => l.category_EMPLOI_DU_TEMPS,
      'MESSAGERIE' => l.category_MESSAGERIE,
      'DISCIPLINE' => l.category_DISCIPLINE,
      _ => l.category_URGENCE,
    };

IconData categoryIcon(String c) => switch (c) {
      'FINANCE' => Icons.account_balance_wallet_rounded,
      'PRESENCE' => Icons.how_to_reg_rounded,
      'NOTES' => Icons.grade_rounded,
      'EMPLOI_DU_TEMPS' => Icons.calendar_month_rounded,
      'MESSAGERIE' => Icons.chat_rounded,
      'DISCIPLINE' => Icons.gavel_rounded,
      _ => Icons.warning_rounded,
    };

/// Centre de notifications : historique, filtres par catégorie, lecture.
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  String? _category;

  Future<void> _open(AppNotification n) async {
    if (!n.estLu) {
      ref.read(notificationsRepositoryProvider).markRead(n.id).then((_) {
        ref.invalidate(notificationsProvider(_category));
        ref.invalidate(unreadCountProvider);
      }).catchError((_) {});
    }
    final data = n.dataPayload ?? const {};
    if (data['type'] != null) context.push(PushService.routeFor(data));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsTitle),
        actions: [
          IconButton(
            tooltip: l.markAllRead,
            icon: const Icon(Icons.done_all_rounded),
            onPressed: () async {
              try {
                await ref.read(notificationsRepositoryProvider).markAllRead();
                ref.invalidate(notificationsProvider(_category));
                ref.invalidate(unreadCountProvider);
              } catch (e) {
                if (context.mounted) context.showError(e);
              }
            },
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(label: Text(l.allPayments), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
              ),
              for (final c in ['FINANCE', 'PRESENCE', 'NOTES', 'EMPLOI_DU_TEMPS', 'MESSAGERIE', 'DISCIPLINE'])
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(label: Text(categoryLabel(l, c)), selected: _category == c, onSelected: (_) => setState(() => _category = c)),
                ),
            ],
          ),
        ),
        Expanded(
          child: CachedAsyncView<CursorPage<AppNotification>>(
            value: ref.watch(notificationsProvider(_category)),
            onRetry: () => ref.invalidate(notificationsProvider(_category)),
            isEmpty: (p) => p.items.isEmpty,
            emptyTitle: l.noNotifications,
            emptyIcon: Icons.notifications_off_outlined,
            builder: (context, page) => RefreshIndicator(
              onRefresh: () => ref.refresh(notificationsProvider(_category).future),
              child: ListView.separated(
                itemCount: page.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final n = page.items[i];
                  return ListTile(
                    tileColor: n.estLu ? null : AppColors.aframPrimary.withValues(alpha: 0.05),
                    leading: CircleAvatar(backgroundColor: AppColors.aframPrimary.withValues(alpha: 0.1), child: Icon(categoryIcon(n.categorie), color: AppColors.aframPrimary)),
                    title: Text(n.titre, style: AppTextStyles.bodyMedium.copyWith(fontWeight: n.estLu ? FontWeight.w500 : FontWeight.w800)),
                    subtitle: Text('${n.corps}\n${Fmt.relative(n.createdAt)}'),
                    isThreeLine: true,
                    onTap: () => _open(n),
                  );
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
