import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_repository.dart';
import '../router/route_paths.dart';

/// Notifications push (FCM / APNs) + affichage local au premier plan.
/// Si Firebase n'est pas configuré (pas de google-services.json), le service
/// se désactive proprement : le centre de notifications in-app reste actif.
class PushService {
  final Ref _ref;
  PushService(this._ref);

  bool _enabled = false;
  final _local = FlutterLocalNotificationsPlugin();
  final ValueNotifier<String?> pendingRoute = ValueNotifier(null);

  static const _channel = AndroidNotificationChannel('uniparent_default', 'UniParent', description: 'Alertes de scolarité', importance: Importance.high);

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      _enabled = true;
    } catch (e) {
      debugPrint('[Push] Firebase non configuré : push désactivé ($e)');
      return;
    }

    await _local.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings()),
      onDidReceiveNotificationResponse: (r) => pendingRoute.value = r.payload,
    );
    await _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen((m) {
      final n = m.notification;
      if (n == null) return;
      _local.show(
        m.hashCode,
        n.title,
        n.body,
        NotificationDetails(android: AndroidNotificationDetails(_channel.id, _channel.name, importance: Importance.high, priority: Priority.high)),
        payload: routeFor(m.data),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((m) => pendingRoute.value = routeFor(m.data));
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) pendingRoute.value = routeFor(initial.data);
  }

  /// À appeler après connexion : demande l'autorisation et enregistre le jeton.
  Future<void> registerDevice() async {
    if (!_enabled) return;
    try {
      await FirebaseMessaging.instance.requestPermission();
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _ref.read(authRepositoryProvider).registerDevice(token, Platform.isIOS ? 'ios' : 'android');
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((t) => _ref.read(authRepositoryProvider).registerDevice(t, Platform.isIOS ? 'ios' : 'android'));
    } catch (e) {
      debugPrint('[Push] Enregistrement impossible : $e');
    }
  }

  /// Ouvre l'écran correspondant au type de notification.
  static String routeFor(Map<String, dynamic> data) => switch (data['type']) {
        'PAYMENT_VALIDATED' || 'PAYMENT_FAILED' || 'PAYMENT_REMINDER' || 'INVOICE_CREATED' || 'INSTALLMENT_REVIEWED' => RoutePaths.finances,
        'ATTENDANCE' || 'ATTENDANCE_THRESHOLD' || 'JUSTIFICATION_REVIEWED' || 'GRADES_PUBLISHED' || 'GRADE_DISPUTE_REVIEWED' => RoutePaths.tracking,
        'MESSAGE' || 'TICKET_RESOLVED' => data['conversationId'] != null ? RoutePaths.conversation(data['conversationId'] as String) : RoutePaths.messages,
        'ANNOUNCEMENT' => RoutePaths.announcements,
        'SLOT_CHANGED' => RoutePaths.timetable,
        'DISCIPLINE' => RoutePaths.discipline,
        'DOCUMENT_REQUEST' || 'DOCUMENT_REVIEWED' => RoutePaths.documents,
        'APPOINTMENT' => RoutePaths.appointments,
        _ => RoutePaths.notifications,
      };
}

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));
