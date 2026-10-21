import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../../auth/application/session_controller.dart';
import '../domain/notification_models.dart';

class NotificationsRepository {
  final ApiClient _api;
  final CacheStore _cache;
  NotificationsRepository(this._api, this._cache);

  Future<Cached<CursorPage<AppNotification>>> list({String? cursor, String? categorie}) => _cache.fetch(
        'notifications:${categorie ?? 'all'}:${cursor ?? 'first'}',
        () => _api.get<Map<String, dynamic>>(ApiEndpoints.notifications, query: {'cursor': cursor, 'take': 30, 'categorie': categorie}),
        (json) => CursorPage.fromJson(json! as Map<String, dynamic>, AppNotification.fromJson),
      );

  Future<int> unreadCount() async => ((await _api.get<Map<String, dynamic>>(ApiEndpoints.unreadCount))['count'] as num).toInt();
  Future<void> markRead(String id) => _api.patch(ApiEndpoints.markRead(id));
  Future<void> markAllRead() => _api.post(ApiEndpoints.readAll);

  Future<List<NotificationPreference>> preferences() async =>
      (await _api.get<List<dynamic>>(ApiEndpoints.notificationPreferences)).map((e) => NotificationPreference.fromJson(e as Map<String, dynamic>)).toList();

  Future<List<NotificationPreference>> savePreferences(List<NotificationPreference> prefs) async =>
      (await _api.put<List<dynamic>>(ApiEndpoints.notificationPreferences, data: {'items': prefs.map((p) => p.toJson()).toList()}))
          .map((e) => NotificationPreference.fromJson(e as Map<String, dynamic>))
          .toList();
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) => NotificationsRepository(ref.watch(apiClientProvider), ref.watch(cacheStoreProvider)));

final notificationsProvider = FutureProvider.autoDispose.family<Cached<CursorPage<AppNotification>>, String?>((ref, categorie) => ref.read(notificationsRepositoryProvider).list(categorie: categorie));

/// Compteur de non-lus (badge). Rafraîchi au retour au premier plan et après lecture.
final unreadCountProvider = FutureProvider<int>((ref) async {
  if (ref.watch(sessionProvider).value == null) return 0;
  try {
    return await ref.read(notificationsRepositoryProvider).unreadCount();
  } catch (_) {
    return 0;
  }
});

final notificationPreferencesProvider = FutureProvider.autoDispose<List<NotificationPreference>>((ref) => ref.read(notificationsRepositoryProvider).preferences());
