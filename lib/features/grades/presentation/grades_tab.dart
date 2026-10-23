import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
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
    final s = context.strato;
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
        child: ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 24 + context.bottomInset), children: [
          if (history.length > 1) ...[
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final h = history[i];
                  final selected = h.semesterId == r.semestre.id;
                  return ChoiceChip(
                    label: Text('${h.code} · ${h.annee}'),
                    selected: selected,
                    onSelected: (_) => setState(() => _semesterId = h.semesterId),
                    labelStyle: AppTextStyles.bodySmall.copyWith(color: selected ? s.onGold : s.text, fontWeight: FontWeight.w700),
                    selectedColor: s.gold,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          Reveal(key: ValueKey(r.semestre.id), child: _Summary(r)),
          if (history.where((h) => h.moyenne != null).length > 1) ...[const SizedBox(height: 12), Reveal(index: 1, child: _History(history))],
          SectionLabel(l.gradesTitle),
          if (r.matieres.isEmpty) Padding(padding: const EdgeInsets.all(24), child: Text(l.noGrades, textAlign: TextAlign.center, style: TextStyle(color: s.textMuted))),
          for (var i = 0; i < r.matieres.length; i++) Reveal(key: ValueKey('${r.semestre.id}_$i'), index: i + 2, child: _CourseCard(r.matieres[i])),
          const SizedBox(height: 12),
          if (r.matieres.isNotEmpty)
            AppButton(
              icon: Icons.picture_as_pdf_rounded,
              text: l.bulletin,
              isOutlined: true,
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
    final s = context.strato;
    final avg = r.moyenneGenerale;
    const muted = Color(0xB3FFFFFF);
    return GlassCard(
      gradient: s.heroGradient,
      glow: s.accentDeep,
      radius: 28,
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${l.generalAverage} · ${r.semestre.libelle}'.toUpperCase(), style: AppTextStyles.overline.copyWith(color: muted)),
              const SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                avg == null
                    ? Text('—', style: AppTextStyles.display.copyWith(color: Colors.white))
                    : CountUp(value: avg, format: (v) => v.toStringAsFixed(2).replaceAll('.', ','), style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 44)),
                Padding(padding: const EdgeInsets.only(bottom: 7, left: 4), child: Text('/ 20', style: AppTextStyles.h3.copyWith(color: muted))),
              ]),
            ]),
          ),
          OrbitGauge(
            value: avg == null ? null : avg / 20,
            color: const Color(0xFFF2C063),
            size: 74,
            stroke: 6,
            center: Icon(avg != null && avg >= 10 ? Icons.auto_awesome_rounded : Icons.trending_up_rounded, color: const Color(0xFFFBE0A4)),
          ),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          if (r.moyenneClasse != null) _pill(l.classAverage, Fmt.grade(r.moyenneClasse!)),
          if (r.rang != null) _pill(l.rank, '${r.rang} / ${r.effectif}'),
          _pill(l.credits, '${r.creditsAcquis} / ${r.creditsTotal}'),
          if (r.mention != null) _pill(l.mention, r.mention!),
          if (r.decision != null) _pill(l.decision, r.decision!),
        ]),
      ]),
    );
  }

  Widget _pill(String label, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: const Color(0xFFFBE0A4))),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        ]),
      );
}

class _History extends StatelessWidget {
  final List<SemesterAverage> history;
  const _History(this.history);

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final data = history.where((h) => h.moyenne != null).toList();
    return SectionCard(
      title: context.l10n.evolution,
      icon: Icons.bar_chart_rounded,
      iconColor: s.accent,
      child: SizedBox(
        height: 180,
        child: BarChart(
          swapAnimationDuration: const Duration(milliseconds: 900),
          swapAnimationCurve: Curves.easeOutCubic,
          BarChartData(
            maxY: 20,
            minY: 0,
            gridData: FlGridData(drawVerticalLine: false, horizontalInterval: 5, getDrawingHorizontalLine: (_) => FlLine(color: s.hairline, strokeWidth: 1, dashArray: [4, 4])),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => s.elevated,
                getTooltipItem: (g, _, rod, __) => BarTooltipItem(rod.toY.toStringAsFixed(2), AppTextStyles.bodySmall.copyWith(color: s.gold, fontWeight: FontWeight.w800)),
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 5, reservedSize: 28, getTitlesWidget: (v, _) => Text(v.toInt().toString(), style: AppTextStyles.caption.copyWith(color: s.textFaint))),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) => Padding(padding: const EdgeInsets.only(top: 6), child: Text(data[v.toInt()].code, style: AppTextStyles.caption.copyWith(color: s.textMuted))),
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < data.length; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: data[i].moyenne!,
                    width: 24,
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: data[i].moyenne! >= 10 ? [s.accentDeep, s.accent, s.gold] : [s.danger.withValues(alpha: 0.6), s.danger],
                    ),
                    backDrawRodData: BackgroundBarChartRodData(show: true, toY: 20, color: s.hairline),
                  ),
                ]),
            ],
          ),
        ),
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
    final s = context.strato;
    final ok = m.moyenne >= 10;
    final color = ok ? s.success : s.danger;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
          leading: SizedBox.square(
            dimension: 46,
            child: OrbitGauge(
              value: m.moyenne / 20,
              color: color,
              size: 46,
              stroke: 4,
              duration: const Duration(milliseconds: 1100),
              center: Text(m.moyenne.toStringAsFixed(1).replaceAll('.', ','), style: AppTextStyles.bodySmall.copyWith(color: s.text, fontWeight: FontWeight.w800)),
            ),
          ),
          title: Text(m.nom, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700, color: s.text)),
          subtitle: Text(
            '${m.code} · ${l.coefficient(m.coefficient.toStringAsFixed(m.coefficient % 1 == 0 ? 0 : 1))} · ${m.credits} ECTS'
            '${m.moyenneClasse != null ? '\n${l.classAverage} ${Fmt.grade(m.moyenneClasse!)}' : ''}',
            style: AppTextStyles.bodySmall.copyWith(color: s.textMuted),
          ),
          children: [
            for (final n in m.notes)
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 8, 8),
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(border: Border(left: BorderSide(color: s.hairlineStrong, width: 2))),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(n.evaluation, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w600)),
                      Text('${Fmt.date(n.date)} · ${l.coefficient(n.coefficient.toStringAsFixed(n.coefficient % 1 == 0 ? 0 : 1))}',
                          style: AppTextStyles.caption.copyWith(color: s.textFaint)),
                    ]),
                  ),
                  Text(Fmt.grade(n.valeur, n.bareme),
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: n.valeur / n.bareme >= 0.5 ? s.success : s.danger)),
                  PopupMenuButton<String>(
                    tooltip: l.disputeGrade,
                    icon: Icon(Icons.more_vert_rounded, color: s.textMuted),
                    onSelected: (_) => _dispute(context, ref, n),
                    itemBuilder: (_) => [PopupMenuItem(value: 'dispute', child: Text(l.disputeGrade))],
                  ),
                ]),
              ),
          ],
        ),
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
