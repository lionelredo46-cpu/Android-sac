import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
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
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColors.aframGold,
            tabs: [Tab(text: l.schedule), Tab(text: l.history), Tab(text: l.summary)],
          ),
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
    return CachedAsyncView<List<Invoice>>(
      value: ref.watch(invoicesProvider(child.id)),
      onRetry: () => ref.invalidate(invoicesProvider(child.id)),
      isEmpty: (d) => d.isEmpty,
      emptyTitle: l.noInvoices,
      emptyIcon: Icons.receipt_long_outlined,
      builder: (context, invoices) {
        final total = invoices.where((i) => i.statut != 'ANNULE').fold<int>(0, (s, i) => s + i.soldeRestant);
        return RefreshIndicator(
          onRefresh: () => ref.refresh(invoicesProvider(child.id).future),
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Card(
              color: AppColors.aframPrimary,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.remaining, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                  Text(Fmt.money(total), style: AppTextStyles.h1.copyWith(color: Colors.white)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            ...invoices.map((inv) => _InvoiceCard(inv, canPay: child.estPayeur)),
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
    final status = inv.statut == 'A_PAYER' ? 'A_PAYER' : inv.statut;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(RoutePaths.invoice(inv.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(inv.title, style: AppTextStyles.h3)),
              StatusChip.status(status, lineStatusLabel(l, status)),
            ]),
            const SizedBox(height: 4),
            Text('${l.dueDate} : ${Fmt.date(inv.dateEcheance)} · ${inv.numeroFacture}', style: AppTextStyles.bodySmall),
            const SizedBox(height: 10),
            ProgressBar(inv.progress, color: StatusStyle.of(inv.soldeRestant == 0 ? 'PAYE' : status).color),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text('${Fmt.money(inv.montantPaye, inv.devise)} / ${Fmt.money(inv.montantTotal, inv.devise)}', style: AppTextStyles.bodySmall)),
              if (inv.payable && canPay)
                FilledButton.tonal(onPressed: () => context.push(RoutePaths.pay(inv.id)), child: Text('${l.pay} ${Fmt.money(inv.soldeRestant, inv.devise)}')),
            ]),
          ]),
        ),
      ),
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
      builder: (context, all) {
        final list = all.where((p) => _filter == 'ALL' || (_filter == 'ONLINE') == p.enLigne).toList();
        return RefreshIndicator(
          onRefresh: () => ref.refresh(paymentsProvider(widget.child.id).future),
          child: ListView(padding: const EdgeInsets.all(16), children: [
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'ALL', label: Text(l.allPayments)),
                ButtonSegment(value: 'ONLINE', label: Text(l.online)),
                ButtonSegment(value: 'COUNTER', label: Text(l.counter)),
              ],
              selected: {_filter},
              onSelectionChanged: (s) => setState(() => _filter = s.first),
            ),
            const SizedBox(height: 12),
            ...list.map((p) => PaymentTile(p, onReceipt: () => openReceipt(context, p.receipt!, () => repo.receiptPdf(p.receipt!.id)))),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.verified_outlined),
              label: Text(l.paymentCertificate),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (_) => PdfViewerPage(
                  title: l.paymentCertificate,
                  filename: 'attestation-paiement-${widget.child.matricule}.pdf',
                  loader: () => repo.paymentCertificate(widget.child.id),
                ),
              )),
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
    return CachedAsyncView<FinanceSummary>(
      value: ref.watch(financeSummaryProvider(child.id)),
      onRetry: () => ref.invalidate(financeSummaryProvider(child.id)),
      builder: (context, s) => ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(
          title: l.balanceByYear,
          icon: Icons.event_note_outlined,
          child: Column(
            children: s.parAnnee
                .map((y) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(y.libelle, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                        KeyValueRow(l.totalDue, Fmt.money(y.total)),
                        KeyValueRow(l.totalPaid, Fmt.money(y.paye), valueColor: AppColors.success),
                        KeyValueRow(l.remaining, Fmt.money(y.reste), valueColor: y.reste > 0 ? AppColors.error : AppColors.success, bold: true),
                      ]),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (s.evolution.isNotEmpty)
          SectionCard(
            title: l.paymentsEvolution,
            icon: Icons.show_chart_rounded,
            child: SizedBox(
              height: 200,
              child: Semantics(
                label: l.paymentsEvolution,
                child: LineChart(LineChartData(
                  minY: 0,
                  gridData: const FlGridData(drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 44, getTitlesWidget: (v, _) => Text('${(v / 1000).round()}k', style: AppTextStyles.caption))),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= s.evolution.length) return const SizedBox.shrink();
                          return Text(s.evolution[i].mois.substring(5), style: AppTextStyles.caption);
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [for (var i = 0; i < s.evolution.length; i++) FlSpot(i.toDouble(), s.evolution[i].cumul.toDouble())],
                      isCurved: true,
                      color: AppColors.aframPrimary,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: true, color: AppColors.aframPrimary.withValues(alpha: 0.1)),
                    ),
                  ],
                )),
              ),
            ),
          ),
      ]),
    );
  }
}
