import 'package:freezed_annotation/freezed_annotation.dart';

import '../../dashboard/domain/dashboard.dart';

part 'grades_models.freezed.dart';
part 'grades_models.g.dart';

@freezed
abstract class GradeEntry with _$GradeEntry {
  const factory GradeEntry({
    required String id,
    required String evaluation,
    required String type,
    required double valeur,
    @Default(20) double bareme,
    @Default(1) double coefficient,
    required DateTime date,
  }) = _GradeEntry;
  factory GradeEntry.fromJson(Map<String, dynamic> json) => _$GradeEntryFromJson(json);
}

@freezed
abstract class CourseResult with _$CourseResult {
  const factory CourseResult({
    required String courseId,
    required String code,
    required String nom,
    @Default(1) double coefficient,
    @Default(0) int credits,
    required double moyenne,
    @Default(0) int creditsAcquis,
    @Default(0) int nombreNotes,
    double? moyenneClasse,
    @Default([]) List<GradeEntry> notes,
  }) = _CourseResult;
  factory CourseResult.fromJson(Map<String, dynamic> json) => _$CourseResultFromJson(json);
}

@freezed
abstract class SemesterResults with _$SemesterResults {
  const factory SemesterResults({
    required SemesterRef semestre,
    double? moyenneGenerale,
    double? moyenneClasse,
    int? rang,
    int? effectif,
    @Default(0) int creditsAcquis,
    @Default(0) int creditsTotal,
    String? mention,
    String? decision,
    @Default([]) List<CourseResult> matieres,
  }) = _SemesterResults;
  factory SemesterResults.fromJson(Map<String, dynamic> json) => _$SemesterResultsFromJson(json);
}

@freezed
abstract class SemesterAverage with _$SemesterAverage {
  const factory SemesterAverage({
    required String semesterId,
    required String code,
    required String libelle,
    required String annee,
    double? moyenne,
    @Default(0) int creditsAcquis,
    @Default(false) bool estActif,
  }) = _SemesterAverage;
  factory SemesterAverage.fromJson(Map<String, dynamic> json) => _$SemesterAverageFromJson(json);
}
