import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';
import '../../children/application/children_providers.dart';
import '../data/finance_repository.dart';
import '../domain/finance_models.dart';
import 'finance_widgets.dart';

class InvoicePage extends ConsumerWidget {
  final String invoiceId;
  const InvoicePage({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = context.strato;
    final canPay = ref.watch(activeChildProvider)?.estPayeur ?? false;
    final repo = ref.read(financeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.invoice)),
      body: CachedAsyncView<Invoice>(
        value: ref.watch(invoiceProvider(invoiceId)),
        onRetry: () => ref.invalidate(invoiceProvider(invoiceId)),
        builder: (context, inv) {
          var i = 0;
          Widget r(Widget w) => Reveal(index: i++, child: w);
          final color = StatusStyle.of(inv.statut).color;
          return ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 28 + context.bottomInset), children: [
            r(GlassCard(
              gradient: s.heroGradient,
              glow: s.accentDeep,
              radius: 28,
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(inv.numeroFacture, style: AppTextStyles.overline.copyWith(color: const Color(0xB3FFFFFF)))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(99), border: Border.all(color: color.withValues(alpha: 0.6))),
                    child: Text(lineStatusLabel(l, inv.statut), style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ]),
                if (inv.academicYear != null) Text(inv.academicYear!.libelle, style: AppTextStyles.bodySmall.copyWith(color: const Color(0xB3FFFFFF))),
                const SizedBox(height: 14),
                Text(l.remaining, style: AppTextStyles.bodySmall.copyWith(color: const Color(0xB3FFFFFF))),
                CountUp(value: inv.soldeRestant.toDouble(), format: (v) => Fmt.money(v, inv.devise), style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 32)),
                const SizedBox(height: 12),
                ProgressBar(inv.progress, color: const Color(0xFFF2C063)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _Fig(l.totalDue, Fmt.money(inv.montantTotal, inv.devise))),
                  Expanded(child: _Fig(l.totalPaid, Fmt.money(inv.montantPaye, inv.devise), color: const Color(0xFF6EE7B7))),
                  Expanded(child: _Fig(l.dueDate, Fmt.dayMonth(inv.dateEcheance))),
                ]),
              ]),
            )),
            SectionLabel(l.schedule),
            for (final line in inv.lines)
              r(GlassCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                child: Row(children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(color: StatusStyle.of(line.statut).color, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: StatusStyle.of(line.statut).color.withValues(alpha: 0.6), blurRadius: 8)]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(line.titre, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w700)),
                      Text('${l.dueDate} : ${Fmt.date(line.dateLimite)}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
                    ]),
                  ),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(Fmt.money(line.montant, inv.devise), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: s.text)),
                    const SizedBox(height: 4),
                    StatusChip.status(line.statut, lineStatusLabel(l, line.statut)),
                  ]),
                ]),
              )),
            if (inv.payments.isNotEmpty) ...[
              SectionLabel(l.history),
              for (final p in inv.payments)
                r(PaymentTile(p, onReceipt: p.receipt == null ? null : () => openReceipt(context, p.receipt!, () => repo.receiptPdf(p.receipt!.id)))),
            ],
            if (inv.installmentRequests.isNotEmpty) ...[
              const SizedBox(height: 6),
              for (final req in inv.installmentRequests)
                r(GlassCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    GlowIcon(StatusStyle.of(req.statut).icon, color: StatusStyle.of(req.statut).color, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${l.requestInstallment} — ${req.nombreTranches}x', style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w700)),
                        Text(req.reponse ?? req.motif, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
                      ]),
                    ),
                  ]),
                )),
            ],
            const SizedBox(height: 18),
            if (inv.payable && canPay) ...[
              r(AppButton(text: l.payNow, icon: Icons.bolt_rounded, onPressed: () => context.push(RoutePaths.pay(inv.id)))),
              const SizedBox(height: 10),
              if (!inv.installmentRequests.any((r) => r.statut == 'SOUMISE'))
                r(AppButton(text: l.requestInstallment, icon: Icons.splitscreen_rounded, isOutlined: true, onPressed: () => _askInstallment(context, ref, inv))),
            ],
          ]);
        },
      ),
    );
  }

  Future<void> _askInstallment(BuildContext context, WidgetRef ref, Invoice inv) async {
    final l = context.l10n;
    final motif = TextEditingController();
    var tranches = 3;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.requestInstallment),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<int>(
              initialValue: tranches,
              decoration: InputDecoration(labelText: l.installments),
              items: [2, 3, 4, 6].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
              onChanged: (v) => setState(() => tranches = v ?? 3),
            ),
            const SizedBox(height: 12),
            TextField(controller: motif, maxLines: 3, decoration: InputDecoration(labelText: l.reason)),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, motif.text.trim().isNotEmpty), child: Text(l.send)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(financeRepositoryProvider).requestInstallment(inv.id, tranches, motif.text.trim());
      ref.invalidate(invoiceProvider(inv.id));
      if (context.mounted) context.showSnack(l.requestSent);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }
}

class _Fig extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Fig(this.label, this.value, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: const Color(0xB3FFFFFF))),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(value, style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w800))),
      ]);
}
