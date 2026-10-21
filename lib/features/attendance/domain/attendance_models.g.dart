// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseRef _$CourseRefFromJson(Map<String, dynamic> json) => _CourseRef(
  id: json['id'] as String,
  code: json['code'] as String,
  nom: json['nom'] as String,
);

Map<String, dynamic> _$CourseRefToJson(_CourseRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'nom': instance.nom,
    };

_Justification _$JustificationFromJson(Map<String, dynamic> json) =>
    _Justification(
      id: json['id'] as String,
      motif: json['motif'] as String,
      statut: json['statut'] as String,
      commentaire: json['commentaire'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$JustificationToJson(_Justification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'motif': instance.motif,
      'statut': instance.statut,
      'commentaire': instance.commentaire,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_AttendanceItem _$AttendanceItemFromJson(Map<String, dynamic> json) =>
    _AttendanceItem(
      id: json['id'] as String,
      statut: json['statut'] as String,
      minutesRetard: (json['minutesRetard'] as num?)?.toInt() ?? 0,
      date: DateTime.parse(json['date'] as String),
      fin: DateTime.parse(json['fin'] as String),
      dureeMinutes: (json['dureeMinutes'] as num?)?.toInt() ?? 0,
      cours: CourseRef.fromJson(json['cours'] as Map<String, dynamic>),
      enseignant: json['enseignant'] as String,
      salle: json['salle'] as String,
      justification: json['justification'] == null
          ? null
          : Justification.fromJson(
              json['justification'] as Map<String, dynamic>,
            ),
      justifiable: json['justifiable'] as bool? ?? false,
    );

Map<String, dynamic> _$AttendanceItemToJson(_AttendanceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statut': instance.statut,
      'minutesRetard': instance.minutesRetard,
      'date': instance.date.toIso8601String(),
      'fin': instance.fin.toIso8601String(),
      'dureeMinutes': instance.dureeMinutes,
      'cours': instance.cours,
      'enseignant': instance.enseignant,
      'salle': instance.salle,
      'justification': instance.justification,
      'justifiable': instance.justifiable,
    };

_AttendanceTotals _$AttendanceTotalsFromJson(Map<String, dynamic> json) =>
    _AttendanceTotals(
      seances: (json['seances'] as num?)?.toInt() ?? 0,
      presents: (json['PRESENT'] as num?)?.toInt() ?? 0,
      absents: (json['ABSENT'] as num?)?.toInt() ?? 0,
      retards: (json['RETARD'] as num?)?.toInt() ?? 0,
      excuses: (json['EXCUSE'] as num?)?.toInt() ?? 0,
      absencesNonJustifiees:
          (json['absencesNonJustifiees'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AttendanceTotalsToJson(_AttendanceTotals instance) =>
    <String, dynamic>{
      'seances': instance.seances,
      'PRESENT': instance.presents,
      'ABSENT': instance.absents,
      'RETARD': instance.retards,
      'EXCUSE': instance.excuses,
      'absencesNonJustifiees': instance.absencesNonJustifiees,
    };

_CourseAttendance _$CourseAttendanceFromJson(Map<String, dynamic> json) =>
    _CourseAttendance(
      courseId: json['courseId'] as String,
      matiere: json['matiere'] as String,
      taux: (json['taux'] as num?)?.toDouble(),
      absences: (json['absences'] as num?)?.toInt() ?? 0,
      retards: (json['retards'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CourseAttendanceToJson(_CourseAttendance instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'matiere': instance.matiere,
      'taux': instance.taux,
      'absences': instance.absences,
      'retards': instance.retards,
    };

_WeekAttendance _$WeekAttendanceFromJson(Map<String, dynamic> json) =>
    _WeekAttendance(
      semaine: json['semaine'] as String,
      absences: (json['absences'] as num?)?.toInt() ?? 0,
      retards: (json['retards'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WeekAttendanceToJson(_WeekAttendance instance) =>
    <String, dynamic>{
      'semaine': instance.semaine,
      'absences': instance.absences,
      'retards': instance.retards,
    };

_AttendanceStats _$AttendanceStatsFromJson(Map<String, dynamic> json) =>
    _AttendanceStats(
      tauxGlobal: (json['tauxGlobal'] as num?)?.toDouble(),
      totaux: AttendanceTotals.fromJson(json['totaux'] as Map<String, dynamic>),
      parMatiere:
          (json['parMatiere'] as List<dynamic>?)
              ?.map((e) => CourseAttendance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      parSemaine:
          (json['parSemaine'] as List<dynamic>?)
              ?.map((e) => WeekAttendance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AttendanceStatsToJson(_AttendanceStats instance) =>
    <String, dynamic>{
      'tauxGlobal': instance.tauxGlobal,
      'totaux': instance.totaux,
      'parMatiere': instance.parMatiere,
      'parSemaine': instance.parSemaine,
    };
