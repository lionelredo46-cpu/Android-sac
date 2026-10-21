// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YearRef _$YearRefFromJson(Map<String, dynamic> json) =>
    _YearRef(id: json['id'] as String, libelle: json['libelle'] as String);

Map<String, dynamic> _$YearRefToJson(_YearRef instance) => <String, dynamic>{
  'id': instance.id,
  'libelle': instance.libelle,
};

_InvoiceLine _$InvoiceLineFromJson(Map<String, dynamic> json) => _InvoiceLine(
  id: json['id'] as String,
  titre: json['titre'] as String,
  type: json['type'] as String,
  montant: (json['montant'] as num).toInt(),
  dateLimite: DateTime.parse(json['dateLimite'] as String),
  montantPaye: (json['montantPaye'] as num?)?.toInt() ?? 0,
  resteAPayer: (json['resteAPayer'] as num?)?.toInt() ?? 0,
  statut: json['statut'] as String? ?? 'A_PAYER',
);

Map<String, dynamic> _$InvoiceLineToJson(_InvoiceLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'type': instance.type,
      'montant': instance.montant,
      'dateLimite': instance.dateLimite.toIso8601String(),
      'montantPaye': instance.montantPaye,
      'resteAPayer': instance.resteAPayer,
      'statut': instance.statut,
    };

_ReceiptRef _$ReceiptRefFromJson(Map<String, dynamic> json) => _ReceiptRef(
  id: json['id'] as String,
  numeroRecu: json['numeroRecu'] as String,
);

Map<String, dynamic> _$ReceiptRefToJson(_ReceiptRef instance) =>
    <String, dynamic>{'id': instance.id, 'numeroRecu': instance.numeroRecu};

_PaymentRecord _$PaymentRecordFromJson(Map<String, dynamic> json) =>
    _PaymentRecord(
      id: json['id'] as String,
      reference: json['reference'] as String,
      date: DateTime.parse(json['date'] as String),
      montant: (json['montant'] as num).toInt(),
      devise: json['devise'] as String? ?? 'XAF',
      statut: json['statut'] as String,
      canal: json['canal'] as String,
      enLigne: json['enLigne'] as bool? ?? false,
      fournisseur: json['fournisseur'] as String?,
      referenceExterne: json['referenceExterne'] as String?,
      payeurType: json['payeurType'] as String? ?? 'PARENT',
      auteur: json['auteur'] as String?,
      enregistrePar: json['enregistrePar'] as String?,
      invoiceId: json['invoiceId'] as String,
      receipt: json['receipt'] == null
          ? null
          : ReceiptRef.fromJson(json['receipt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentRecordToJson(_PaymentRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'date': instance.date.toIso8601String(),
      'montant': instance.montant,
      'devise': instance.devise,
      'statut': instance.statut,
      'canal': instance.canal,
      'enLigne': instance.enLigne,
      'fournisseur': instance.fournisseur,
      'referenceExterne': instance.referenceExterne,
      'payeurType': instance.payeurType,
      'auteur': instance.auteur,
      'enregistrePar': instance.enregistrePar,
      'invoiceId': instance.invoiceId,
      'receipt': instance.receipt,
    };

_InstallmentRequest _$InstallmentRequestFromJson(Map<String, dynamic> json) =>
    _InstallmentRequest(
      id: json['id'] as String,
      statut: json['statut'] as String,
      nombreTranches: (json['nombreTranches'] as num).toInt(),
      motif: json['motif'] as String,
      reponse: json['reponse'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$InstallmentRequestToJson(_InstallmentRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statut': instance.statut,
      'nombreTranches': instance.nombreTranches,
      'motif': instance.motif,
      'reponse': instance.reponse,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['id'] as String,
  numeroFacture: json['numeroFacture'] as String,
  montantTotal: (json['montantTotal'] as num).toInt(),
  montantPaye: (json['montantPaye'] as num).toInt(),
  soldeRestant: (json['soldeRestant'] as num).toInt(),
  devise: json['devise'] as String? ?? 'XAF',
  statut: json['statut'] as String,
  dateEcheance: DateTime.parse(json['dateEcheance'] as String),
  academicYear: json['academicYear'] == null
      ? null
      : YearRef.fromJson(json['academicYear'] as Map<String, dynamic>),
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => InvoiceLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => PaymentRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  installmentRequests:
      (json['installmentRequests'] as List<dynamic>?)
          ?.map((e) => InstallmentRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'numeroFacture': instance.numeroFacture,
  'montantTotal': instance.montantTotal,
  'montantPaye': instance.montantPaye,
  'soldeRestant': instance.soldeRestant,
  'devise': instance.devise,
  'statut': instance.statut,
  'dateEcheance': instance.dateEcheance.toIso8601String(),
  'academicYear': instance.academicYear,
  'lines': instance.lines,
  'payments': instance.payments,
  'installmentRequests': instance.installmentRequests,
};

_YearBalance _$YearBalanceFromJson(Map<String, dynamic> json) => _YearBalance(
  academicYearId: json['academicYearId'] as String,
  libelle: json['libelle'] as String,
  total: (json['total'] as num).toInt(),
  paye: (json['paye'] as num).toInt(),
  reste: (json['reste'] as num).toInt(),
);

Map<String, dynamic> _$YearBalanceToJson(_YearBalance instance) =>
    <String, dynamic>{
      'academicYearId': instance.academicYearId,
      'libelle': instance.libelle,
      'total': instance.total,
      'paye': instance.paye,
      'reste': instance.reste,
    };

_MonthlyPayment _$MonthlyPaymentFromJson(Map<String, dynamic> json) =>
    _MonthlyPayment(
      mois: json['mois'] as String,
      montant: (json['montant'] as num).toInt(),
      cumul: (json['cumul'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlyPaymentToJson(_MonthlyPayment instance) =>
    <String, dynamic>{
      'mois': instance.mois,
      'montant': instance.montant,
      'cumul': instance.cumul,
    };

_FinanceSummary _$FinanceSummaryFromJson(Map<String, dynamic> json) =>
    _FinanceSummary(
      parAnnee:
          (json['parAnnee'] as List<dynamic>?)
              ?.map((e) => YearBalance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      evolution:
          (json['evolution'] as List<dynamic>?)
              ?.map((e) => MonthlyPayment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FinanceSummaryToJson(_FinanceSummary instance) =>
    <String, dynamic>{
      'parAnnee': instance.parAnnee,
      'evolution': instance.evolution,
    };

_ProviderOption _$ProviderOptionFromJson(Map<String, dynamic> json) =>
    _ProviderOption(
      code: json['code'] as String,
      canaux:
          (json['canaux'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parDefaut: json['parDefaut'] as bool? ?? false,
    );

Map<String, dynamic> _$ProviderOptionToJson(_ProviderOption instance) =>
    <String, dynamic>{
      'code': instance.code,
      'canaux': instance.canaux,
      'parDefaut': instance.parDefaut,
    };

_PaymentIntent _$PaymentIntentFromJson(Map<String, dynamic> json) =>
    _PaymentIntent(
      paymentId: json['paymentId'] as String,
      reference: json['reference'] as String,
      statut: json['statut'] as String,
      montant: (json['montant'] as num).toInt(),
      devise: json['devise'] as String? ?? 'XAF',
      paymentUrl: json['paymentUrl'] as String?,
      instructions: json['instructions'] as String?,
      receipt: json['receipt'] == null
          ? null
          : ReceiptRef.fromJson(json['receipt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentIntentToJson(_PaymentIntent instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'reference': instance.reference,
      'statut': instance.statut,
      'montant': instance.montant,
      'devise': instance.devise,
      'paymentUrl': instance.paymentUrl,
      'instructions': instance.instructions,
      'receipt': instance.receipt,
    };
