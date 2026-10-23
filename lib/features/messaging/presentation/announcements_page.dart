import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../../notifications/domain/notification_models.dart';
import '../data/messaging_repository.dart';
import '../domain/messaging_models.dart';

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.announcementsTitle)),
      body: CachedAsyncView<CursorPage<Announcement>>(
        value: ref.watch(announcementsProvider),
        onRetry: () => ref.invalidate(announcementsProvider),
        isEmpty: (p) => p.items.isEmpty,
        emptyIcon: Icons.campaign_outlined,
        builder: (context, page) => RefreshIndicator(
          onRefresh: () => ref.refresh(announcementsProvider.future),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 28 + context.bottomInset),
            itemCount: page.items.length,
            itemBuilder: (_, i) {
              final a = page.items[i];
              final s = context.strato;
              return Reveal(
                index: i,
                child: GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      GlowIcon(Icons.campaign_rounded, color: s.gold, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(a.titre, style: AppTextStyles.h3.copyWith(color: s.text)),
                          Text(Fmt.date(a.datePublication), style: AppTextStyles.caption.copyWith(color: s.textFaint)),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    SelectableText(a.contenu, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted)),
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
