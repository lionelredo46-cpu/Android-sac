import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/attendance_models.dart';

class AttendanceRepository {
  final ApiClient _api;
  final CacheStore _cache;
  AttendanceRepository(this._api, this._cache);

  Future<Cached<List<AttendanceItem>>> list(String childId) => _cache.fetch(
        'attendance:$childId',
        () => _api.get<List<dynamic>>(ApiEndpoints.attendance(childId)),
        (json) => (json! as List).map((e) => AttendanceItem.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<Cached<AttendanceStats>> stats(String childId) => _cache.fetch(
        'attendance-stats:$childId',
        () => _api.get<Map<String, dynamic>>(ApiEndpoints.attendanceStats(childId)),
        (json) => AttendanceStats.fromJson(json! as Map<String, dynamic>),
      );

  Future<void> justify(String attendanceId, String motif, MultipartFile file) =>
      _api.upload(ApiEndpoints.justify(attendanceId), fields: {'motif': motif}, file: file);

  Future<Map<String, dynamic>> scan(String code) => _api.post<Map<String, dynamic>>(ApiEndpoints.attendanceScan, data: {'code': code});
}

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) => AttendanceRepository(ref.watch(apiClientProvider), ref.watch(cacheStoreProvider)));

final attendanceProvider = FutureProvider.autoDispose.family<Cached<List<AttendanceItem>>, String>((ref, id) => ref.read(attendanceRepositoryProvider).list(id));
final attendanceStatsProvider = FutureProvider.autoDispose.family<Cached<AttendanceStats>, String>((ref, id) => ref.read(attendanceRepositoryProvider).stats(id));
