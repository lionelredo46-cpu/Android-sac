import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pdf_viewer_page.dart';
import '../../../core/widgets/ui.dart';
import '../../children/domain/child.dart';
import '../data/grades_repository.dart';
import '../domain/grades_models.dart';

/// Notes publiées uniquement (le serveur filtre brouillons et notes en validation).
class GradesTab extends ConsumerStatefulWidget {
  final Child child;
  const GradesTab({super.key, required this.child});

  @override
  ConsumerState<GradesTab> createState() => _GradesTabState();
}

class _GradesTabState extends ConsumerState<GradesTab> {
  String? _semesterId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final key = (childId: widget.child.id, semesterId: _semesterId);
    final history = ref.watch(gradesHistoryProvider(widget.child.id)).value?.data ?? const <SemesterAverage>[];

    return CachedAsyncView<SemesterResults>(
      value: ref.watch(gradesProvider(key)),
      onRetry: () => ref.invalidate(gradesProvider(key)),
      builder: (context, r) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(gradesHistoryProvider(widget.child.id));
          ref.invalidate(gradesProvider(key));
          await ref.read(gradesProvider(key).future);
        },
        child: ListView(padding: const EdgeInsets.all(16), children: [
          if (history.length > 1)
            DropdownButtonFormField<String>(
              initialValue: r.semestre.id,
              decoration: InputDecoration(labelText: l.semester),
              items: history.map((h) => DropdownMenuItem(value: h.semesterId, child: Text('${h.libelle} (${h.annee})'))).toList(),
              onChanged: (v) => setState(() => _semesterId = v),
            ),
          const SizedBox(height: 12),
          _Summary(r),
          if (history.where((h) => h.moyenne != null).length > 1) ...[const SizedBox(height: 12), _History(history)],
          const SizedBox(height: 12),
          if (r.matieres.isEmpty) Padding(padding: const EdgeInsets.all(24), child: Text(l.noGrades, textAlign: TextAlign.center)),
          ...r.matieres.map((m) => _CourseCard(m)),
          const SizedBox(height: 12),
          if (r.matieres.isNotEmpty)
            OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: Text(l.bulletin),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (_) => PdfViewerPage(
                  title: '${l.bulletin} ${r.semestre.code}',
                  filename: 'bulletin-${widget.child.matricule}-${r.semestre.code}.pdf',
                  loader: () => ref.read(gradesRepositoryProvider).bulletin(widget.child.id, r.semestre.id),
                ),
              )),
            ),
        ]),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final SemesterResults r;
  const _Summary(this.r);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final avg = r.moyenneGenerale;
    return Card(
      color: AppColors.aframPrimary,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${l.generalAverage} · ${r.semestre.libelle}', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
          Text(avg == null ? '—' : Fmt.grade(avg), style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 34)),
          const SizedBox(height: 10),
          Wrap(spacing: 16, runSpacing: 8, children: [
            if (r.moyenneClasse != null) _pill(l.classAverage, Fmt.grade(r.moyenneClasse!)),
            if (r.rang != null) _pill(l.rank, '${r.rang} / ${r.effectif}'),
            _pill(l.credits, '${r.creditsAcquis} / ${r.creditsTotal}'),
            if (r.mention != null) _pill(l.mention, r.mention!),
            if (r.decision != null) _pill(l.decision, r.decision!),
          ]),
        ]),
      ),
    );
  }

  Widget _pill(String label, String value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.aframGoldLight)),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
      ]);
}

class _History extends StatelessWidget {
  final List<SemesterAverage> history;
  const _History(this.history);

  @override
  Widget build(BuildContext context) {
    final data = history.where((h) => h.moyenne != null).toList();
    return SectionCard(
      title: context.l10n.evolution,
      icon: Icons.bar_chart_rounded,
      child: SizedBox(
        height: 170,
        child: BarChart(BarChartData(
          maxY: 20,
          minY: 0,
          gridData: const FlGridData(drawVerticalLine: false, horizontalInterval: 5),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 5, reservedSize: 28)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text(data[v.toInt()].code, style: AppTextStyles.caption))),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: data[i].moyenne!, width: 22, borderRadius: BorderRadius.circular(6), color: data[i].moyenne! >= 10 ? AppColors.aframPrimary : AppColors.error),
              ]),
          ],
        )),
      ),
    );
  }
}

class _CourseCard extends ConsumerWidget {
  final CourseResult m;
  const _CourseCard(this.m);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ok = m.moyenne >= 10;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(m.nom, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
        subtitle: Text('${m.code} · ${l.coefficient(m.coefficient.toStringAsFixed(m.coefficient % 1 == 0 ? 0 : 1))} · ${m.credits} ECTS'
            '${m.moyenneClasse != null ? ' · ${l.classAverage} ${Fmt.grade(m.moyenneClasse!)}' : ''}'),
        trailing: Text(Fmt.grade(m.moyenne), style: AppTextStyles.h3.copyWith(color: ok ? AppColors.success : AppColors.error)),
        children: m.notes
            .map((n) => ListTile(
                  dense: true,
                  title: Text(n.evaluation),
                  subtitle: Text('${Fmt.date(n.date)} · ${l.coefficient(n.coefficient.toStringAsFixed(n.coefficient % 1 == 0 ? 0 : 1))}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(Fmt.grade(n.valeur, n.bareme), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    PopupMenuButton<String>(
                      tooltip: l.disputeGrade,
                      onSelected: (_) => _dispute(context, ref, n),
                      itemBuilder: (_) => [PopupMenuItem(value: 'dispute', child: Text(l.disputeGrade))],
                    ),
                  ]),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _dispute(BuildContext context, WidgetRef ref, GradeEntry n) async {
    final l = context.l10n;
    final motif = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.disputeGrade),
        content: TextField(controller: motif, maxLines: 4, maxLength: 1000, decoration: InputDecoration(labelText: l.reason)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, motif.text.trim().isNotEmpty), child: Text(l.send)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(gradesRepositoryProvider).dispute(n.id, motif.text.trim());
      if (context.mounted) context.showSnack(l.disputeSent);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }
}
