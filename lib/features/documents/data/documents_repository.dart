import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/documents_models.dart';

class DocumentsRepository {
  final ApiClient _api;
  final CacheStore _cache;
  DocumentsRepository(this._api, this._cache);

  Future<Cached<List<VaultDocument>>> vault(String childId) => _cache.fetch(
        'vault:$childId',
        () => _api.get<List<dynamic>>(ApiEndpoints.vault(childId)),
        (json) => (json! as List).map((e) => VaultDocument.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Cached<List<DocumentRequest>>> requests(String childId) => _cache.fetch(
        'requests:$childId',
        () => _api.get<List<dynamic>>(ApiEndpoints.requests(childId)),
        (json) => (json! as List).map((e) => DocumentRequest.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Cached<List<DisciplineRecord>>> discipline(String childId) => _cache.fetch(
        'discipline:$childId',
        () => _api.get<List<dynamic>>(ApiEndpoints.discipline(childId)),
        (json) => (json! as List).map((e) => DisciplineRecord.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Uint8List> download(String documentId) async {
    final c = await _cache.fetch('doc:$documentId', () async => (await _api.bytes(ApiEndpoints.downloadDocument(documentId))).toList(), (j) => Uint8List.fromList((j! as List).cast<int>()));
    return c.data;
  }

  Future<Uint8List> requestDocument(String requestId) => _api.bytes(ApiEndpoints.requestDocument(requestId));
  Future<Uint8List> enrollmentCertificate(String childId) => _api.bytes(ApiEndpoints.enrollmentCertificate(childId));

  Future<void> sign(String documentId) => _api.post(ApiEndpoints.signDocument(documentId));

  Future<void> upload(String childId, String titre, String categorie, MultipartFile file) =>
      _api.upload(ApiEndpoints.uploadDocument(childId), fields: {'titre': titre, 'categorie': categorie}, file: file);

  Future<void> createRequest(String childId, String type, String? motif) =>
      _api.post(ApiEndpoints.createRequest, data: {'studentId': childId, 'type': type, if (motif != null && motif.isNotEmpty) 'motif': motif});

  Future<void> acknowledge(String recordId) => _api.post(ApiEndpoints.acknowledge(recordId));
}

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) => DocumentsRepository(ref.watch(apiClientProvider), ref.watch(cacheStoreProvider)));

final vaultProvider = FutureProvider.autoDispose.family<Cached<List<VaultDocument>>, String>((ref, id) => ref.read(documentsRepositoryProvider).vault(id));
final requestsProvider = FutureProvider.autoDispose.family<Cached<List<DocumentRequest>>, String>((ref, id) => ref.read(documentsRepositoryProvider).requests(id));
final disciplineProvider = FutureProvider.autoDispose.family<Cached<List<DisciplineRecord>>, String>((ref, id) => ref.read(documentsRepositoryProvider).discipline(id));
