// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimetableSlot _$TimetableSlotFromJson(Map<String, dynamic> json) =>
    _TimetableSlot(
      id: json['id'] as String,
      debut: DateTime.parse(json['debut'] as String),
      fin: DateTime.parse(json['fin'] as String),
      statut: json['statut'] as String,
      motif: json['motif'] as String?,
      matiere: json['matiere'] as String,
      code: json['code'] as String,
      enseignant: json['enseignant'] as String,
      salle: json['salle'] as String,
      campus: json['campus'] as String,
    );

Map<String, dynamic> _$TimetableSlotToJson(_TimetableSlot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debut': instance.debut.toIso8601String(),
      'fin': instance.fin.toIso8601String(),
      'statut': instance.statut,
      'motif': instance.motif,
      'matiere': instance.matiere,
      'code': instance.code,
      'enseignant': instance.enseignant,
      'salle': instance.salle,
      'campus': instance.campus,
    };

_Timetable _$TimetableFromJson(Map<String, dynamic> json) => _Timetable(
  creneaux:
      (json['creneaux'] as List<dynamic>?)
          ?.map((e) => TimetableSlot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TimetableToJson(_Timetable instance) =>
    <String, dynamic>{'creneaux': instance.creneaux};

_CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    _CalendarEvent(
      id: json['id'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      debut: DateTime.parse(json['debut'] as String),
      fin: DateTime.parse(json['fin'] as String),
    );

Map<String, dynamic> _$CalendarEventToJson(_CalendarEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
      'type': instance.type,
      'debut': instance.debut.toIso8601String(),
      'fin': instance.fin.toIso8601String(),
    };
