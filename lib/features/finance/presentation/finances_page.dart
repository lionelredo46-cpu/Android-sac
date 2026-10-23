import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/pdf_viewer_page.dart';
import '../../../core/widgets/ui.dart';
import '../../children/domain/child.dart';
import '../../children/presentation/child_scope.dart';
import '../data/finance_repository.dart';
import '../domain/finance_models.dart';
import 'finance_widgets.dart';

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.financesTitle),
          bottom: StratoTabBar(tabs: [l.schedule, l.history, l.summary]),
        ),
        body: ChildScope(
          builder: (context, child) => TabBarView(children: [_ScheduleTab(child), _HistoryTab(child), _SummaryTab(child)]),
        ),
      ),
    );
  }
}

class _ScheduleTab extends ConsumerWidget {
  final Child child;
  const _ScheduleTab(this.child);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = context.strato;
    return CachedAsyncView<List<Invoice>>(
      value: ref.watch(invoicesProvider(child.id)),
      onRetry: () => ref.invalidate(invoicesProvider(child.id)),
      isEmpty: (d) => d.isEmpty,
      emptyTitle: l.noInvoices,
      emptyIcon: Icons.receipt_long_outlined,
      builder: (context, invoices) {
        final active = invoices.where((i) => i.statut != 'ANNULE');
        final total = active.fold<int>(0, (sum, i) => sum + i.soldeRestant);
        final due = active.fold<int>(0, (sum, i) => sum + i.montantTotal);
        final paid = active.fold<int>(0, (sum, i) => sum + i.montantPaye);
        return RefreshIndicator(
          onRefresh: () => ref.refresh(invoicesProvider(child.id).future),
          child: ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 24 + context.bottomInset), children: [
            Reveal(
              child: GlassCard(
                gradient: s.heroGradient,
                glow: s.accentDeep,
                radius: 28,
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.remaining.toUpperCase(), style: AppTextStyles.overline.copyWith(color: const Color(0xB3FFFFFF))),
                      const SizedBox(height: 6),
                      CountUp(value: total.toDouble(), format: (v) => Fmt.money(v), style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 32)),
                      const SizedBox(height: 6),
                      Text('${l.totalPaid} ${Fmt.money(paid)} · ${l.totalDue} ${Fmt.money(due)}',
                          style: AppTextStyles.caption.copyWith(color: const Color(0xB3FFFFFF)), maxLines: 2),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  OrbitGauge(
                    value: due == 0 ? 1 : paid / due,
                    color: const Color(0xFFF2C063),
                    size: 78,
                    stroke: 7,
                    center: Text('${due == 0 ? 100 : (paid * 100 / due).round()}%', style: AppTextStyles.h3.copyWith(color: Colors.white)),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < invoices.length; i++) Reveal(index: i + 1, child: _InvoiceCard(invoices[i], canPay: child.estPayeur)),
          ]),
        );
      },
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice inv;
  final bool canPay;
  const _InvoiceCard(this.inv, {required this.canPay});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final status = inv.statut == 'A_PAYER' ? 'A_PAYER' : inv.statut;
    final color = StatusStyle.of(inv.soldeRestant == 0 ? 'PAYE' : status).color;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => context.push(RoutePaths.invoice(inv.id)),
      semanticLabel: inv.title,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GlowIcon(Icons.receipt_long_rounded, color: color, size: 40, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(inv.title, style: AppTextStyles.h3.copyWith(color: s.text, fontSize: 16)),
              const SizedBox(height: 2),
              Text('${l.dueDate} : ${Fmt.date(inv.dateEcheance)} · ${inv.numeroFacture}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
            ]),
          ),
          const SizedBox(width: 8),
          StatusChip.status(status, lineStatusLabel(l, status)),
        ]),
        const SizedBox(height: 14),
        ProgressBar(inv.progress, color: color),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(text: Fmt.money(inv.montantPaye, inv.devise), style: TextStyle(color: s.text, fontWeight: FontWeight.w700)),
              TextSpan(text: '  /  ${Fmt.money(inv.montantTotal, inv.devise)}'),
            ]), style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
          ),
          if (inv.payable && canPay)
            FilledButton.icon(
              onPressed: () => context.push(RoutePaths.pay(inv.id)),
              style: FilledButton.styleFrom(backgroundColor: s.gold, foregroundColor: s.onGold, minimumSize: const Size(0, 40)),
              icon: const Icon(Icons.bolt_rounded, size: 18),
              label: Text(Fmt.money(inv.soldeRestant, inv.devise)),
            ),
        ]),
      ]),
    );
  }
}

class _HistoryTab extends ConsumerStatefulWidget {
  final Child child;
  const _HistoryTab(this.child);

  @override
  ConsumerState<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<_HistoryTab> {
  String _filter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final repo = ref.read(financeRepositoryProvider);
    return CachedAsyncView<List<PaymentRecord>>(
      value: ref.watch(paymentsProvider(widget.child.id)),
      onRetry: () => ref.invalidate(paymentsProvider(widget.child.id)),
      isEmpty: (d) => d.isEmpty,
      emptyTitle: l.noPayments,
      emptyIcon: Icons.history_rounded,
      builder: (context, all) {
        final list = all.where((p) => _filter == 'ALL' || (_filter == 'ONLINE') == p.enLigne).toList();
        return RefreshIndicator(
          onRefresh: () => ref.refresh(paymentsProvider(widget.child.id).future),
          child: ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 24 + context.bottomInset), children: [
            Reveal(
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: 'ALL', label: Text(l.allPayments)),
                  ButtonSegment(value: 'ONLINE', label: Text(l.online)),
                  ButtonSegment(value: 'COUNTER', label: Text(l.counter)),
                ],
                selected: {_filter},
                onSelectionChanged: (s) => setState(() => _filter = s.first),
              ),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < list.length; i++)
              Reveal(
                key: ValueKey('${_filter}_${list[i].id}'),
                index: i + 1,
                child: PaymentTile(list[i], onReceipt: () => openReceipt(context, list[i].receipt!, () => repo.receiptPdf(list[i].receipt!.id))),
              ),
            const SizedBox(height: 10),
            Reveal(
              index: list.length + 1,
              child: AppButton(
                text: l.paymentCertificate,
                icon: Icons.verified_outlined,
                isOutlined: true,
                onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (_) => PdfViewerPage(
                    title: l.paymentCertificate,
                    filename: 'attestation-paiement-${widget.child.matricule}.pdf',
                    loader: () => repo.paymentCertificate(widget.child.id),
                  ),
                )),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class _SummaryTab extends ConsumerWidget {
  final Child child;
  const _SummaryTab(this.child);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = context.strato;
    return CachedAsyncView<FinanceSummary>(
      value: ref.watch(financeSummaryProvider(child.id)),
      onRetry: () => ref.invalidate(financeSummaryProvider(child.id)),
      builder: (context, sum) => ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 24 + context.bottomInset), children: [
        if (sum.evolution.isNotEmpty) ...[
          Reveal(
            child: SectionCard(
              title: l.paymentsEvolution,
              icon: Icons.show_chart_rounded,
              iconColor: s.gold,
              child: SizedBox(
                height: 210,
                child: Semantics(
                  label: l.paymentsEvolution,
                  child: LineChart(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    LineChartData(
                      minY: 0,
                      gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: s.hairline, strokeWidth: 1, dashArray: [4, 4])),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => s.elevated,
                          getTooltipItems: (spots) => [for (final p in spots) LineTooltipItem(Fmt.money(p.y), AppTextStyles.bodySmall.copyWith(color: s.gold, fontWeight: FontWeight.w700))],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 44, getTitlesWidget: (v, _) => Text('${(v / 1000).round()}k', style: AppTextStyles.caption.copyWith(color: s.textFaint))),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (v, _) {
                              final i = v.toInt();
                              if (i < 0 || i >= sum.evolution.length) return const SizedBox.shrink();
                              return Padding(padding: const EdgeInsets.only(top: 6), child: Text(sum.evolution[i].mois.substring(5), style: AppTextStyles.caption.copyWith(color: s.textFaint)));
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [for (var i = 0; i < sum.evolution.length; i++) FlSpot(i.toDouble(), sum.evolution[i].cumul.toDouble())],
                          isCurved: true,
                          curveSmoothness: 0.3,
                          gradient: LinearGradient(colors: [s.accent, s.gold]),
                          barWidth: 3.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 4, color: s.gold, strokeWidth: 2, strokeColor: s.elevated),
                          ),
                          shadow: Shadow(color: s.gold.withValues(alpha: 0.5), blurRadius: 12),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [s.gold.withValues(alpha: 0.28), s.accent.withValues(alpha: 0.0)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Reveal(
          index: 1,
          child: SectionCard(
            title: l.balanceByYear,
            icon: Icons.event_note_rounded,
            child: Column(
              children: [
                for (final y in sum.parAnnee)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(y.libelle, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: s.gold)),
                      const SizedBox(height: 6),
                      ProgressBar(y.total == 0 ? 1 : y.paye / y.total, color: y.reste > 0 ? s.warning : s.success, height: 6),
                      const SizedBox(height: 6),
                      KeyValueRow(l.totalDue, Fmt.money(y.total)),
                      KeyValueRow(l.totalPaid, Fmt.money(y.paye), valueColor: s.success),
                      KeyValueRow(l.remaining, Fmt.money(y.reste), valueColor: y.reste > 0 ? s.danger : s.success, bold: true),
                    ]),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
