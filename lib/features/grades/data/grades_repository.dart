import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/grades_models.dart';

class GradesRepository {
  final ApiClient _api;
  final CacheStore _cache;
  GradesRepository(this._api, this._cache);

  Future<Cached<SemesterResults>> results(String childId, {String? semesterId}) => _cache.fetch(
        'grades:$childId:${semesterId ?? 'current'}',
        () => _api.get<Map<String, dynamic>>(ApiEndpoints.grades(childId), query: {'semesterId': semesterId}),
        (json) => SemesterResults.fromJson(json! as Map<String, dynamic>),
      );

  Future<Cached<List<SemesterAverage>>> history(String childId) => _cache.fetch(
        'grades-history:$childId',
        () => _api.get<List<dynamic>>(ApiEndpoints.gradesHistory(childId)),
        (json) => (json! as List).map((e) => SemesterAverage.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Uint8List> bulletin(String childId, String semesterId) async {
    final c = await _cache.fetch(
      'bulletin:$childId:$semesterId',
      () async => (await _api.bytes(ApiEndpoints.bulletin(childId, semesterId))).toList(),
      (j) => Uint8List.fromList((j! as List).cast<int>()),
    );
    return c.data;
  }

  Future<void> dispute(String gradeId, String motif) => _api.post(ApiEndpoints.disputeGrade(gradeId), data: {'motif': motif});
}

final gradesRepositoryProvider = Provider<GradesRepository>((ref) => GradesRepository(ref.watch(apiClientProvider), ref.watch(cacheStoreProvider)));

typedef GradesKey = ({String childId, String? semesterId});

final gradesProvider = FutureProvider.autoDispose.family<Cached<SemesterResults>, GradesKey>(
  (ref, k) => ref.read(gradesRepositoryProvider).results(k.childId, semesterId: k.semesterId),
);
final gradesHistoryProvider = FutureProvider.autoDispose.family<Cached<List<SemesterAverage>>, String>((ref, id) => ref.read(gradesRepositoryProvider).history(id));
