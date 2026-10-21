import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
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
    final canPay = ref.watch(activeChildProvider)?.estPayeur ?? false;
    final repo = ref.read(financeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.invoice)),
      body: CachedAsyncView<Invoice>(
        value: ref.watch(invoiceProvider(invoiceId)),
        onRetry: () => ref.invalidate(invoiceProvider(invoiceId)),
        builder: (context, inv) => ListView(padding: const EdgeInsets.all(16), children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(inv.numeroFacture, style: AppTextStyles.h3)),
                  StatusChip.status(inv.statut, lineStatusLabel(l, inv.statut)),
                ]),
                if (inv.academicYear != null) Text(inv.academicYear!.libelle, style: AppTextStyles.bodySmall),
                const Divider(height: 24),
                KeyValueRow(l.totalDue, Fmt.money(inv.montantTotal, inv.devise)),
                KeyValueRow(l.totalPaid, Fmt.money(inv.montantPaye, inv.devise), valueColor: AppColors.success),
                KeyValueRow(l.remaining, Fmt.money(inv.soldeRestant, inv.devise), valueColor: inv.soldeRestant > 0 ? AppColors.error : AppColors.success, bold: true),
                KeyValueRow(l.dueDate, Fmt.date(inv.dateEcheance)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Text(l.schedule, style: AppTextStyles.h3),
          const SizedBox(height: 8),
          ...inv.lines.map((line) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(line.titre),
                  subtitle: Text('${l.dueDate} : ${Fmt.date(line.dateLimite)}'),
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(Fmt.money(line.montant, inv.devise), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    StatusChip.status(line.statut, lineStatusLabel(l, line.statut)),
                  ]),
                ),
              )),
          if (inv.payments.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l.history, style: AppTextStyles.h3),
            const SizedBox(height: 8),
            ...inv.payments.map((p) => PaymentTile(p, onReceipt: p.receipt == null ? null : () => openReceipt(context, p.receipt!, () => repo.receiptPdf(p.receipt!.id)))),
          ],
          if (inv.installmentRequests.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...inv.installmentRequests.map((r) => Card(
                  child: ListTile(
                    leading: Icon(StatusStyle.of(r.statut).icon, color: StatusStyle.of(r.statut).color),
                    title: Text('${l.requestInstallment} — ${r.nombreTranches}x'),
                    subtitle: Text(r.reponse ?? r.motif),
                  ),
                )),
          ],
          const SizedBox(height: 16),
          if (inv.payable && canPay) ...[
            ElevatedButton.icon(onPressed: () => context.push(RoutePaths.pay(inv.id)), icon: const Icon(Icons.payments_rounded), label: Text(l.payNow)),
            const SizedBox(height: 8),
            if (!inv.installmentRequests.any((r) => r.statut == 'SOUMISE'))
              OutlinedButton(onPressed: () => _askInstallment(context, ref, inv), child: Text(l.requestInstallment)),
          ],
        ]),
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
