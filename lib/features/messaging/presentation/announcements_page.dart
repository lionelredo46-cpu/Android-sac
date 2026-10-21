import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
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
            padding: const EdgeInsets.all(16),
            itemCount: page.items.length,
            itemBuilder: (_, i) {
              final a = page.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.campaign_rounded, color: AppColors.aframGold),
                      const SizedBox(width: 8),
                      Expanded(child: Text(a.titre, style: AppTextStyles.h3)),
                    ]),
                    const SizedBox(height: 4),
                    Text(Fmt.date(a.datePublication), style: AppTextStyles.caption),
                    const SizedBox(height: 10),
                    SelectableText(a.contenu, style: AppTextStyles.bodyMedium),
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
