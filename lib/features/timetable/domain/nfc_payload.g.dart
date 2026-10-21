// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SharedSlot _$SharedSlotFromJson(Map<String, dynamic> json) => _SharedSlot(
  debut: DateTime.parse(json['d'] as String),
  fin: DateTime.parse(json['f'] as String),
  matiere: json['m'] as String,
  code: json['c'] as String,
  salle: json['s'] as String,
  campus: json['p'] as String,
  enseignant: json['e'] as String,
  statut: json['t'] as String? ?? 'PLANIFIE',
);

Map<String, dynamic> _$SharedSlotToJson(_SharedSlot instance) =>
    <String, dynamic>{
      'd': instance.debut.toIso8601String(),
      'f': instance.fin.toIso8601String(),
      'm': instance.matiere,
      'c': instance.code,
      's': instance.salle,
      'p': instance.campus,
      'e': instance.enseignant,
      't': instance.statut,
    };

NfcTimetableShare _$NfcTimetableShareFromJson(Map<String, dynamic> json) =>
    NfcTimetableShare(
      v: (json['v'] as num?)?.toInt() ?? 1,
      owner: json['owner'] as String,
      group: json['group'] as String?,
      weekStart: DateTime.parse(json['weekStart'] as String),
      sharedAt: DateTime.parse(json['sharedAt'] as String),
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => SharedSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      $type: json['k'] as String?,
    );

Map<String, dynamic> _$NfcTimetableShareToJson(NfcTimetableShare instance) =>
    <String, dynamic>{
      'v': instance.v,
      'owner': instance.owner,
      'group': instance.group,
      'weekStart': instance.weekStart.toIso8601String(),
      'sharedAt': instance.sharedAt.toIso8601String(),
      'slots': instance.slots,
      'k': instance.$type,
    };

NfcRoomTag _$NfcRoomTagFromJson(Map<String, dynamic> json) => NfcRoomTag(
  roomCode: json['roomCode'] as String,
  $type: json['k'] as String?,
);

Map<String, dynamic> _$NfcRoomTagToJson(NfcRoomTag instance) =>
    <String, dynamic>{'roomCode': instance.roomCode, 'k': instance.$type};

NfcAttendanceTag _$NfcAttendanceTagFromJson(Map<String, dynamic> json) =>
    NfcAttendanceTag(code: json['code'] as String, $type: json['k'] as String?);

Map<String, dynamic> _$NfcAttendanceTagToJson(NfcAttendanceTag instance) =>
    <String, dynamic>{'code': instance.code, 'k': instance.$type};

NfcStudentCard _$NfcStudentCardFromJson(Map<String, dynamic> json) =>
    NfcStudentCard(
      uid: json['uid'] as String,
      technology: json['technology'] as String,
      $type: json['k'] as String?,
    );

Map<String, dynamic> _$NfcStudentCardToJson(NfcStudentCard instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'technology': instance.technology,
      'k': instance.$type,
    };
