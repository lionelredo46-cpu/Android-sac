import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../../notifications/domain/notification_models.dart';
import '../domain/messaging_models.dart';

class MessagingRepository {
  final ApiClient _api;
  final CacheStore _cache;
  MessagingRepository(this._api, this._cache);

  Future<Cached<CursorPage<ConversationSummary>>> conversations({String? cursor}) => _cache.fetch(
        'conversations:${cursor ?? 'first'}',
        () => _api.get<Map<String, dynamic>>(ApiEndpoints.conversations, query: {'cursor': cursor, 'take': 30}),
        (json) => CursorPage.fromJson(json! as Map<String, dynamic>, ConversationSummary.fromJson),
      );

  Future<ConversationDetail> conversation(String id) async =>
      ConversationDetail.fromJson(await _api.get<Map<String, dynamic>>(ApiEndpoints.conversationMessages(id)));

  Future<Map<String, dynamic>> create({
    required String sujet,
    required String service,
    required String message,
    String? studentId,
    String priorite = 'NORMALE',
    MultipartFile? file,
  }) =>
      _api.upload<Map<String, dynamic>>(ApiEndpoints.conversations, fields: {
        'sujet': sujet,
        'service': service,
        'message': message,
        'priorite': priorite,
        if (studentId != null) 'studentId': studentId,
      }, file: file);

  Future<void> reply(String id, String contenu, {MultipartFile? file}) =>
      _api.upload(ApiEndpoints.conversationMessages(id), fields: {'contenu': contenu}, file: file);

  Future<void> rate(String id, int satisfaction) => _api.post(ApiEndpoints.rateConversation(id), data: {'satisfaction': satisfaction});

  Future<Cached<CursorPage<Announcement>>> announcements() => _cache.fetch(
        'announcements',
        () => _api.get<Map<String, dynamic>>(ApiEndpoints.announcements, query: {'take': 50}),
        (json) => CursorPage.fromJson(json! as Map<String, dynamic>, Announcement.fromJson),
      );

  Future<List<AppointmentHost>> hosts() async =>
      (await _api.get<List<dynamic>>(ApiEndpoints.appointmentHosts)).map((e) => AppointmentHost.fromJson(e as Map<String, dynamic>)).toList();

  Future<Cached<List<Appointment>>> appointments() => _cache.fetch(
        'appointments',
        () => _api.get<List<dynamic>>(ApiEndpoints.appointments),
        (json) => (json! as List).map((e) => Appointment.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Future<void> requestAppointment(String hoteId, String objet, DateTime debut, DateTime fin) => _api.post(ApiEndpoints.appointments, data: {
        'hoteId': hoteId,
        'objet': objet,
        'debut': debut.toUtc().toIso8601String(),
        'fin': fin.toUtc().toIso8601String(),
      });

  Future<void> cancelAppointment(String id) => _api.patch(ApiEndpoints.appointment(id), data: {'statut': 'ANNULE'});
}

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) => MessagingRepository(ref.watch(apiClientProvider), ref.watch(cacheStoreProvider)));

final conversationsProvider = FutureProvider.autoDispose<Cached<CursorPage<ConversationSummary>>>((ref) => ref.read(messagingRepositoryProvider).conversations());
final conversationProvider = FutureProvider.autoDispose.family<ConversationDetail, String>((ref, id) => ref.read(messagingRepositoryProvider).conversation(id));
final announcementsProvider = FutureProvider.autoDispose<Cached<CursorPage<Announcement>>>((ref) => ref.read(messagingRepositoryProvider).announcements());
final appointmentsProvider = FutureProvider.autoDispose<Cached<List<Appointment>>>((ref) => ref.read(messagingRepositoryProvider).appointments());
final appointmentHostsProvider = FutureProvider.autoDispose<List<AppointmentHost>>((ref) => ref.read(messagingRepositoryProvider).hosts());
