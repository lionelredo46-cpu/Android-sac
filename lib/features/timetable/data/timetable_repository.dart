import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/timetable_models.dart';

class TimetableRepository {
  final ApiClient _api;
  final CacheStore _cache;
  TimetableRepository(this._api, this._cache);

  Future<Cached<Timetable>> week(String childId, DateTime monday) {
    final from = DateTime(monday.year, monday.month, monday.day);
    final to = from.add(const Duration(days: 7));
    return _cache.fetch(
      'timetable:$childId:${from.toIso8601String().substring(0, 10)}',
      () => _api.get<Map<String, dynamic>>(ApiEndpoints.timetable(childId), query: {'from': from.toUtc().toIso8601String(), 'to': to.toUtc().toIso8601String()}),
      (json) => Timetable.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<Cached<List<CalendarEvent>>> events() => _cache.fetch(
        'calendar',
        () => _api.get<List<dynamic>>(ApiEndpoints.calendarEvents),
        (json) => (json! as List).map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<String> ics(String childId) => _api.text(ApiEndpoints.timetableIcs(childId));
}

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) => TimetableRepository(ref.watch(apiClientProvider), ref.watch(cacheStoreProvider)));

typedef WeekKey = ({String childId, DateTime monday});

final timetableProvider = FutureProvider.autoDispose.family<Cached<Timetable>, WeekKey>((ref, k) => ref.read(timetableRepositoryProvider).week(k.childId, k.monday));
final calendarEventsProvider = FutureProvider.autoDispose<Cached<List<CalendarEvent>>>((ref) => ref.read(timetableRepositoryProvider).events());
