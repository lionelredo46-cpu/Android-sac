import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_models.freezed.dart';
part 'attendance_models.g.dart';

@freezed
abstract class CourseRef with _$CourseRef {
  const factory CourseRef({required String id, required String code, required String nom}) = _CourseRef;
  factory CourseRef.fromJson(Map<String, dynamic> json) => _$CourseRefFromJson(json);
}

@freezed
abstract class Justification with _$Justification {
  const factory Justification({required String id, required String motif, required String statut, String? commentaire, required DateTime createdAt}) = _Justification;
  factory Justification.fromJson(Map<String, dynamic> json) => _$JustificationFromJson(json);
}

@freezed
abstract class AttendanceItem with _$AttendanceItem {
  const factory AttendanceItem({
    required String id,
    required String statut,
    @Default(0) int minutesRetard,
    required DateTime date,
    required DateTime fin,
    @Default(0) int dureeMinutes,
    required CourseRef cours,
    required String enseignant,
    required String salle,
    Justification? justification,
    @Default(false) bool justifiable,
  }) = _AttendanceItem;
  factory AttendanceItem.fromJson(Map<String, dynamic> json) => _$AttendanceItemFromJson(json);
}

@freezed
abstract class AttendanceTotals with _$AttendanceTotals {
  const factory AttendanceTotals({
    @Default(0) int seances,
    @JsonKey(name: 'PRESENT') @Default(0) int presents,
    @JsonKey(name: 'ABSENT') @Default(0) int absents,
    @JsonKey(name: 'RETARD') @Default(0) int retards,
    @JsonKey(name: 'EXCUSE') @Default(0) int excuses,
    @Default(0) int absencesNonJustifiees,
  }) = _AttendanceTotals;
  factory AttendanceTotals.fromJson(Map<String, dynamic> json) => _$AttendanceTotalsFromJson(json);
}

@freezed
abstract class CourseAttendance with _$CourseAttendance {
  const factory CourseAttendance({required String courseId, required String matiere, double? taux, @Default(0) int absences, @Default(0) int retards}) = _CourseAttendance;
  factory CourseAttendance.fromJson(Map<String, dynamic> json) => _$CourseAttendanceFromJson(json);
}

@freezed
abstract class WeekAttendance with _$WeekAttendance {
  const factory WeekAttendance({required String semaine, @Default(0) int absences, @Default(0) int retards}) = _WeekAttendance;
  factory WeekAttendance.fromJson(Map<String, dynamic> json) => _$WeekAttendanceFromJson(json);
}

@freezed
abstract class AttendanceStats with _$AttendanceStats {
  const factory AttendanceStats({
    double? tauxGlobal,
    required AttendanceTotals totaux,
    @Default([]) List<CourseAttendance> parMatiere,
    @Default([]) List<WeekAttendance> parSemaine,
  }) = _AttendanceStats;
  factory AttendanceStats.fromJson(Map<String, dynamic> json) => _$AttendanceStatsFromJson(json);
}
