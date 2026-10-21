import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_models.freezed.dart';
part 'finance_models.g.dart';

@freezed
abstract class YearRef with _$YearRef {
  const factory YearRef({required String id, required String libelle}) = _YearRef;
  factory YearRef.fromJson(Map<String, dynamic> json) => _$YearRefFromJson(json);
}

@freezed
abstract class InvoiceLine with _$InvoiceLine {
  const factory InvoiceLine({
    required String id,
    required String titre,
    required String type,
    required int montant,
    required DateTime dateLimite,
    @Default(0) int montantPaye,
    @Default(0) int resteAPayer,
    @Default('A_PAYER') String statut,
  }) = _InvoiceLine;
  factory InvoiceLine.fromJson(Map<String, dynamic> json) => _$InvoiceLineFromJson(json);
}

@freezed
abstract class ReceiptRef with _$ReceiptRef {
  const factory ReceiptRef({required String id, required String numeroRecu}) = _ReceiptRef;
  factory ReceiptRef.fromJson(Map<String, dynamic> json) => _$ReceiptRefFromJson(json);
}

@freezed
abstract class PaymentRecord with _$PaymentRecord {
  const factory PaymentRecord({
    required String id,
    required String reference,
    required DateTime date,
    required int montant,
    @Default('XAF') String devise,
    required String statut,
    required String canal,
    @Default(false) bool enLigne,
    String? fournisseur,
    String? referenceExterne,
    @Default('PARENT') String payeurType,
    String? auteur,
    String? enregistrePar,
    required String invoiceId,
    ReceiptRef? receipt,
  }) = _PaymentRecord;
  factory PaymentRecord.fromJson(Map<String, dynamic> json) => _$PaymentRecordFromJson(json);
}

@freezed
abstract class InstallmentRequest with _$InstallmentRequest {
  const factory InstallmentRequest({
    required String id,
    required String statut,
    required int nombreTranches,
    required String motif,
    String? reponse,
    required DateTime createdAt,
  }) = _InstallmentRequest;
  factory InstallmentRequest.fromJson(Map<String, dynamic> json) => _$InstallmentRequestFromJson(json);
}

@freezed
abstract class Invoice with _$Invoice {
  const Invoice._();

  const factory Invoice({
    required String id,
    required String numeroFacture,
    required int montantTotal,
    required int montantPaye,
    required int soldeRestant,
    @Default('XAF') String devise,
    required String statut,
    required DateTime dateEcheance,
    YearRef? academicYear,
    @Default([]) List<InvoiceLine> lines,
    @Default([]) List<PaymentRecord> payments,
    @Default([]) List<InstallmentRequest> installmentRequests,
  }) = _Invoice;
  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

  String get title => lines.isNotEmpty ? lines.first.titre : numeroFacture;
  bool get payable => soldeRestant > 0 && statut != 'ANNULE';
  double get progress => montantTotal == 0 ? 1 : montantPaye / montantTotal;
}

@freezed
abstract class YearBalance with _$YearBalance {
  const factory YearBalance({required String academicYearId, required String libelle, required int total, required int paye, required int reste}) = _YearBalance;
  factory YearBalance.fromJson(Map<String, dynamic> json) => _$YearBalanceFromJson(json);
}

@freezed
abstract class MonthlyPayment with _$MonthlyPayment {
  const factory MonthlyPayment({required String mois, required int montant, required int cumul}) = _MonthlyPayment;
  factory MonthlyPayment.fromJson(Map<String, dynamic> json) => _$MonthlyPaymentFromJson(json);
}

@freezed
abstract class FinanceSummary with _$FinanceSummary {
  const factory FinanceSummary({@Default([]) List<YearBalance> parAnnee, @Default([]) List<MonthlyPayment> evolution}) = _FinanceSummary;
  factory FinanceSummary.fromJson(Map<String, dynamic> json) => _$FinanceSummaryFromJson(json);
}

@freezed
abstract class ProviderOption with _$ProviderOption {
  const factory ProviderOption({required String code, @Default([]) List<String> canaux, @Default(false) bool parDefaut}) = _ProviderOption;
  factory ProviderOption.fromJson(Map<String, dynamic> json) => _$ProviderOptionFromJson(json);
}

@freezed
abstract class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    required String paymentId,
    required String reference,
    required String statut,
    required int montant,
    @Default('XAF') String devise,
    String? paymentUrl,
    String? instructions,
    ReceiptRef? receipt,
  }) = _PaymentIntent;
  factory PaymentIntent.fromJson(Map<String, dynamic> json) => _$PaymentIntentFromJson(json);
}
