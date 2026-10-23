import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

Color categoryColor(String c) => switch (c) {
      'FINANCE' => const Color(0xFFF2C063),
      'PRESENCE' => const Color(0xFF34D399),
      'NOTES' => const Color(0xFF8B7BFF),
      'EMPLOI_DU_TEMPS' => const Color(0xFF7AA8FF),
      'MESSAGERIE' => const Color(0xFF22D3EE),
      'DISCIPLINE' => const Color(0xFFFB923C),
      _ => const Color(0xFFF87171),
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
    final s = context.strato;
    Widget chip(String? value, String label) {
      final selected = _category == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          avatar: value == null ? null : Icon(categoryIcon(value), size: 16, color: selected ? s.onGold : categoryColor(value)),
          label: Text(label),
          selected: selected,
          selectedColor: s.gold,
          labelStyle: AppTextStyles.bodySmall.copyWith(color: selected ? s.onGold : s.text, fontWeight: FontWeight.w700),
          onSelected: (_) => setState(() => _category = value),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsTitle),
        actions: [
          IconButton(
            tooltip: l.markAllRead,
            icon: Icon(Icons.done_all_rounded, color: s.gold),
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
          const SizedBox(width: 6),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
            children: [
              chip(null, l.allPayments),
              for (final c in ['FINANCE', 'PRESENCE', 'NOTES', 'EMPLOI_DU_TEMPS', 'MESSAGERIE', 'DISCIPLINE']) chip(c, categoryLabel(l, c)),
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
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 6, 16, 28 + context.bottomInset),
                itemCount: page.items.length,
                itemBuilder: (_, i) {
                  final n = page.items[i];
                  final color = categoryColor(n.categorie);
                  return Reveal(
                    key: ValueKey('${_category}_${n.id}'),
                    index: i,
                    child: GlassCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      tint: n.estLu ? null : color.withValues(alpha: s.isDark ? 0.08 : 0.05),
                      borderColor: n.estLu ? null : color.withValues(alpha: 0.4),
                      onTap: () => _open(n),
                      semanticLabel: n.titre,
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        GlowIcon(categoryIcon(n.categorie), color: color, size: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Expanded(
                                child: Text(n.titre, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: n.estLu ? FontWeight.w600 : FontWeight.w800)),
                              ),
                              if (!n.estLu)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 8)]),
                                ),
                            ]),
                            const SizedBox(height: 3),
                            Text(n.corps, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
                            const SizedBox(height: 6),
                            Text(Fmt.relative(n.createdAt), style: AppTextStyles.caption.copyWith(color: s.textFaint)),
                          ]),
                        ),
                      ]),
                    ),
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
