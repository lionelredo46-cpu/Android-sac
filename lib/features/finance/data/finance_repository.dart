import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/finance_models.dart';

class FinanceRepository {
  final ApiClient _api;
  final CacheStore _cache;
  FinanceRepository(this._api, this._cache);

  Future<Cached<List<Invoice>>> invoices(String childId) => _cache.fetch(
        'invoices:$childId',
        () => _api.get<List<dynamic>>(ApiEndpoints.invoices(childId)),
        (json) => (json! as List).map((e) => Invoice.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Cached<Invoice>> invoice(String id) => _cache.fetch(
        'invoice:$id',
        () => _api.get<Map<String, dynamic>>(ApiEndpoints.invoice(id)),
        (json) => Invoice.fromJson(json! as Map<String, dynamic>),
      );

  Future<Cached<List<PaymentRecord>>> payments(String childId, {String? canal}) => _cache.fetch(
        'payments:$childId:${canal ?? 'all'}',
        () => _api.get<List<dynamic>>(ApiEndpoints.payments(childId), query: {'canal': canal}),
        (json) => (json! as List).map((e) => PaymentRecord.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Cached<FinanceSummary>> summary(String childId) => _cache.fetch(
        'finance-summary:$childId',
        () => _api.get<Map<String, dynamic>>(ApiEndpoints.financeSummary(childId)),
        (json) => FinanceSummary.fromJson(json! as Map<String, dynamic>),
      );

  Future<List<ProviderOption>> providers() async =>
      (await _api.get<List<dynamic>>(ApiEndpoints.paymentProviders)).map((e) => ProviderOption.fromJson(e as Map<String, dynamic>)).toList();

  /// La clé d'idempotence est générée une seule fois par intention de paiement :
  /// un double appui ou une relance réseau renvoie le même paiement.
  Future<PaymentIntent> initiate({
    required String invoiceId,
    required int montant,
    required String canal,
    required String provider,
    String? telephone,
    required String idempotencyKey,
  }) async =>
      PaymentIntent.fromJson(await _api.post<Map<String, dynamic>>(
        ApiEndpoints.initiatePayment,
        data: {'invoiceId': invoiceId, 'montant': montant, 'canal': canal, 'provider': provider, if (telephone != null && telephone.isNotEmpty) 'telephone': telephone},
        headers: {'Idempotency-Key': idempotencyKey},
      ));

  Future<PaymentIntent> status(String paymentId) async =>
      PaymentIntent.fromJson(await _api.get<Map<String, dynamic>>(ApiEndpoints.paymentStatus(paymentId)));

  Future<PaymentIntent> sandboxConfirm(String paymentId, bool success) async =>
      PaymentIntent.fromJson(await _api.post<Map<String, dynamic>>(ApiEndpoints.sandboxConfirm(paymentId), data: {'success': success}));

  /// Les reçus sont conservés en cache pour la consultation hors ligne.
  Future<Uint8List> receiptPdf(String receiptId) => _bytesCached('receipt:$receiptId', ApiEndpoints.receiptPdf(receiptId));

  Future<Uint8List> paymentCertificate(String childId) => _api.bytes(ApiEndpoints.paymentCertificate(childId));

  Future<void> requestInstallment(String invoiceId, int tranches, String motif) =>
      _api.post(ApiEndpoints.installmentRequests, data: {'invoiceId': invoiceId, 'nombreTranches': tranches, 'motif': motif});

  Future<Uint8List> _bytesCached(String key, String path) async {
    final cached = await _cache.fetch(key, () async => (await _api.bytes(path)).toList(), (j) => Uint8List.fromList((j! as List).cast<int>()));
    return cached.data;
  }
}

final financeRepositoryProvider = Provider<FinanceRepository>((ref) => FinanceRepository(ref.watch(apiClientProvider), ref.watch(cacheStoreProvider)));

final invoicesProvider = FutureProvider.autoDispose.family<Cached<List<Invoice>>, String>((ref, childId) => ref.read(financeRepositoryProvider).invoices(childId));
final invoiceProvider = FutureProvider.autoDispose.family<Cached<Invoice>, String>((ref, id) => ref.read(financeRepositoryProvider).invoice(id));
final paymentsProvider = FutureProvider.autoDispose.family<Cached<List<PaymentRecord>>, String>((ref, childId) => ref.read(financeRepositoryProvider).payments(childId));
final financeSummaryProvider = FutureProvider.autoDispose.family<Cached<FinanceSummary>, String>((ref, childId) => ref.read(financeRepositoryProvider).summary(childId));
final paymentProvidersProvider = FutureProvider.autoDispose<List<ProviderOption>>((ref) => ref.read(financeRepositoryProvider).providers());
