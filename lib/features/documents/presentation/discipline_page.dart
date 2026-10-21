import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';
import '../../children/presentation/child_scope.dart';
import '../data/documents_repository.dart';
import '../domain/documents_models.dart';

/// Vie scolaire : sanctions, avertissements, félicitations, convocations.
class DisciplinePage extends ConsumerWidget {
  const DisciplinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final isParent = ref.watch(sessionProvider).value?.isParent ?? false;
    return Scaffold(
      appBar: AppBar(title: Text(l.disciplineTitle)),
      body: ChildScope(
        builder: (context, child) => CachedAsyncView<List<DisciplineRecord>>(
          value: ref.watch(disciplineProvider(child.id)),
          onRetry: () => ref.invalidate(disciplineProvider(child.id)),
          isEmpty: (d) => d.isEmpty,
          emptyTitle: l.noDiscipline,
          emptyIcon: Icons.sentiment_satisfied_alt_rounded,
          builder: (context, records) => ListView(
            padding: const EdgeInsets.all(16),
            children: records.map((r) {
              final color = r.positif ? AppColors.success : r.type == 'CONVOCATION_PARENT' ? AppColors.error : AppColors.warning;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(r.positif ? Icons.emoji_events_rounded : Icons.report_rounded, color: color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(r.libelle, style: AppTextStyles.h3.copyWith(color: color))),
                      Text(Fmt.shortDate(r.dateIncident), style: AppTextStyles.caption),
                    ]),
                    const SizedBox(height: 8),
                    Text(r.motif, style: AppTextStyles.bodyMedium),
                    if (r.sanction != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(r.sanction!, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic))),
                    if (r.convocationDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(l.convocationOn(Fmt.dateTime(r.convocationDate!)), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      ),
                    if (r.accuseRequis && isParent)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.task_alt_rounded),
                          label: Text(l.acknowledge),
                          onPressed: () async {
                            try {
                              await ref.read(documentsRepositoryProvider).acknowledge(r.id);
                              ref.invalidate(disciplineProvider(child.id));
                              if (context.mounted) context.showSnack(l.acknowledged);
                            } catch (e) {
                              if (context.mounted) context.showError(e);
                            }
                          },
                        ),
                      ),
                    if (r.accuseReception && r.accuseReceptionLe != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: StatusChip.status('VALIDE', '${l.acknowledged} · ${Fmt.shortDate(r.accuseReceptionLe!)}'),
                      ),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
