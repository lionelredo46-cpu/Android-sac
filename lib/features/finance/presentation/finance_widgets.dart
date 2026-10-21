import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pdf_viewer_page.dart';
import '../../../core/widgets/ui.dart';
import '../domain/finance_models.dart';

String lineStatusLabel(AppLocalizations l, String status) => switch (status) {
      'PAYE' => l.lineStatus_PAYE,
      'PARTIELLEMENT_PAYE' => l.lineStatus_PARTIELLEMENT_PAYE,
      'EN_RETARD' => l.lineStatus_EN_RETARD,
      'ANNULE' => l.lineStatus_ANNULE,
      _ => l.lineStatus_A_PAYER,
    };

String channelLabel(String canal) => switch (canal) {
      'ONLINE_MOBILE_MONEY' => 'Mobile Money',
      'ONLINE_CARD' => 'Carte bancaire',
      'GUICHET_ESPECES' => 'Espèces (guichet)',
      'GUICHET_CHEQUE' => 'Chèque (guichet)',
      'GUICHET_VIREMENT' => 'Virement bancaire',
      _ => canal,
    };

IconData channelIcon(String canal) => switch (canal) {
      'ONLINE_MOBILE_MONEY' => Icons.phone_android_rounded,
      'ONLINE_CARD' => Icons.credit_card_rounded,
      'GUICHET_VIREMENT' => Icons.account_balance_rounded,
      _ => Icons.storefront_rounded,
    };

void openReceipt(BuildContext context, ReceiptRef receipt, Future<dynamic> Function() loader) {
  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
    builder: (_) => PdfViewerPage(title: '${context.l10n.receipt} ${receipt.numeroRecu}', filename: '${receipt.numeroRecu}.pdf', loader: () async => await loader()),
  ));
}

/// Ligne d'historique de versement : montant, canal, auteur, reçu.
class PaymentTile extends StatelessWidget {
  final PaymentRecord p;
  final VoidCallback? onReceipt;
  const PaymentTile(this.p, {super.key, this.onReceipt});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: (p.enLigne ? AppColors.info : AppColors.aframGold).withValues(alpha: 0.15),
          child: Icon(channelIcon(p.canal), color: p.enLigne ? AppColors.info : AppColors.aframGold),
        ),
        title: Text(Fmt.money(p.montant, p.devise), style: AppTextStyles.h3.copyWith(color: AppColors.success)),
        subtitle: Text(
          '${Fmt.dateTime(p.date)}\n${channelLabel(p.canal)} · ${p.enLigne ? l.online : l.counter}'
          '${p.auteur != null ? '\n${l.paidBy(p.auteur!)}' : ''}',
          style: AppTextStyles.bodySmall,
        ),
        isThreeLine: true,
        trailing: p.receipt != null
            ? IconButton(tooltip: l.viewReceipt, icon: const Icon(Icons.receipt_long_rounded, color: AppColors.aframPrimary), onPressed: onReceipt)
            : null,
      ),
    );
  }
}
