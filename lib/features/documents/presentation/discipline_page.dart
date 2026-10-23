import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final s = context.strato;
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
            padding: EdgeInsets.fromLTRB(16, 6, 16, 28 + context.bottomInset),
            children: [
              for (var i = 0; i < records.length; i++)
                Reveal(
                  index: i,
                  child: Builder(builder: (context) {
                    final r = records[i];
                    final color = r.positif ? s.success : r.type == 'CONVOCATION_PARENT' ? s.danger : s.warning;
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      borderColor: color.withValues(alpha: 0.45),
                      glow: r.positif ? color : null,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          GlowIcon(r.positif ? Icons.emoji_events_rounded : Icons.report_rounded, color: color, size: 42),
                          const SizedBox(width: 12),
                          Expanded(child: Text(r.libelle, style: AppTextStyles.h3.copyWith(color: s.text))),
                          Text(Fmt.shortDate(r.dateIncident), style: AppTextStyles.caption.copyWith(color: s.textFaint)),
                        ]),
                        const SizedBox(height: 12),
                        Text(r.motif, style: AppTextStyles.bodyMedium.copyWith(color: s.text)),
                        if (r.sanction != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(r.sanction!, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, color: s.textMuted)),
                          ),
                        if (r.convocationDate != null)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: s.danger.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(14), border: Border.all(color: s.danger.withValues(alpha: 0.35))),
                            child: Row(children: [
                              Icon(Icons.event_rounded, color: s.danger, size: 18),
                              const SizedBox(width: 8),
                              Expanded(child: Text(l.convocationOn(Fmt.dateTime(r.convocationDate!)), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: s.text))),
                            ]),
                          ),
                        if (r.accuseRequis && isParent)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(backgroundColor: s.gold, foregroundColor: s.onGold),
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
                          ),
                        if (r.accuseReception && r.accuseReceptionLe != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: StatusChip.status('VALIDE', '${l.acknowledged} · ${Fmt.shortDate(r.accuseReceptionLe!)}'),
                          ),
                      ]),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
