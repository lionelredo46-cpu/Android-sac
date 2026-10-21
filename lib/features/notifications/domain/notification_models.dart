import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String titre,
    required String corps,
    required String categorie,
    @Default(false) bool estLu,
    required DateTime createdAt,
    Map<String, dynamic>? dataPayload,
  }) = _AppNotification;
  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}

@freezed
abstract class NotificationPreference with _$NotificationPreference {
  const factory NotificationPreference({required String categorie, @Default(true) bool push, @Default(false) bool sms, @Default(false) bool email}) = _NotificationPreference;
  factory NotificationPreference.fromJson(Map<String, dynamic> json) => _$NotificationPreferenceFromJson(json);
}

/// Page de résultats paginée par curseur.
class CursorPage<T> {
  final List<T> items;
  final String? nextCursor;
  const CursorPage(this.items, this.nextCursor);

  factory CursorPage.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) item) => CursorPage(
        (json['items'] as List).map((e) => item(e as Map<String, dynamic>)).toList(),
        json['nextCursor'] as String?,
      );
}
