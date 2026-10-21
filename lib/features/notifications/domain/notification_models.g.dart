// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      titre: json['titre'] as String,
      corps: json['corps'] as String,
      categorie: json['categorie'] as String,
      estLu: json['estLu'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dataPayload: json['dataPayload'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'corps': instance.corps,
      'categorie': instance.categorie,
      'estLu': instance.estLu,
      'createdAt': instance.createdAt.toIso8601String(),
      'dataPayload': instance.dataPayload,
    };

_NotificationPreference _$NotificationPreferenceFromJson(
  Map<String, dynamic> json,
) => _NotificationPreference(
  categorie: json['categorie'] as String,
  push: json['push'] as bool? ?? true,
  sms: json['sms'] as bool? ?? false,
  email: json['email'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationPreferenceToJson(
  _NotificationPreference instance,
) => <String, dynamic>{
  'categorie': instance.categorie,
  'push': instance.push,
  'sms': instance.sms,
  'email': instance.email,
};
