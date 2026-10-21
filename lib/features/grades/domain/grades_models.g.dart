// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grades_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GradeEntry _$GradeEntryFromJson(Map<String, dynamic> json) => _GradeEntry(
  id: json['id'] as String,
  evaluation: json['evaluation'] as String,
  type: json['type'] as String,
  valeur: (json['valeur'] as num).toDouble(),
  bareme: (json['bareme'] as num?)?.toDouble() ?? 20,
  coefficient: (json['coefficient'] as num?)?.toDouble() ?? 1,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$GradeEntryToJson(_GradeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'evaluation': instance.evaluation,
      'type': instance.type,
      'valeur': instance.valeur,
      'bareme': instance.bareme,
      'coefficient': instance.coefficient,
      'date': instance.date.toIso8601String(),
    };

_CourseResult _$CourseResultFromJson(Map<String, dynamic> json) =>
    _CourseResult(
      courseId: json['courseId'] as String,
      code: json['code'] as String,
      nom: json['nom'] as String,
      coefficient: (json['coefficient'] as num?)?.toDouble() ?? 1,
      credits: (json['credits'] as num?)?.toInt() ?? 0,
      moyenne: (json['moyenne'] as num).toDouble(),
      creditsAcquis: (json['creditsAcquis'] as num?)?.toInt() ?? 0,
      nombreNotes: (json['nombreNotes'] as num?)?.toInt() ?? 0,
      moyenneClasse: (json['moyenneClasse'] as num?)?.toDouble(),
      notes:
          (json['notes'] as List<dynamic>?)
              ?.map((e) => GradeEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CourseResultToJson(_CourseResult instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'code': instance.code,
      'nom': instance.nom,
      'coefficient': instance.coefficient,
      'credits': instance.credits,
      'moyenne': instance.moyenne,
      'creditsAcquis': instance.creditsAcquis,
      'nombreNotes': instance.nombreNotes,
      'moyenneClasse': instance.moyenneClasse,
      'notes': instance.notes,
    };

_SemesterResults _$SemesterResultsFromJson(Map<String, dynamic> json) =>
    _SemesterResults(
      semestre: SemesterRef.fromJson(json['semestre'] as Map<String, dynamic>),
      moyenneGenerale: (json['moyenneGenerale'] as num?)?.toDouble(),
      moyenneClasse: (json['moyenneClasse'] as num?)?.toDouble(),
      rang: (json['rang'] as num?)?.toInt(),
      effectif: (json['effectif'] as num?)?.toInt(),
      creditsAcquis: (json['creditsAcquis'] as num?)?.toInt() ?? 0,
      creditsTotal: (json['creditsTotal'] as num?)?.toInt() ?? 0,
      mention: json['mention'] as String?,
      decision: json['decision'] as String?,
      matieres:
          (json['matieres'] as List<dynamic>?)
              ?.map((e) => CourseResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SemesterResultsToJson(_SemesterResults instance) =>
    <String, dynamic>{
      'semestre': instance.semestre,
      'moyenneGenerale': instance.moyenneGenerale,
      'moyenneClasse': instance.moyenneClasse,
      'rang': instance.rang,
      'effectif': instance.effectif,
      'creditsAcquis': instance.creditsAcquis,
      'creditsTotal': instance.creditsTotal,
      'mention': instance.mention,
      'decision': instance.decision,
      'matieres': instance.matieres,
    };

_SemesterAverage _$SemesterAverageFromJson(Map<String, dynamic> json) =>
    _SemesterAverage(
      semesterId: json['semesterId'] as String,
      code: json['code'] as String,
      libelle: json['libelle'] as String,
      annee: json['annee'] as String,
      moyenne: (json['moyenne'] as num?)?.toDouble(),
      creditsAcquis: (json['creditsAcquis'] as num?)?.toInt() ?? 0,
      estActif: json['estActif'] as bool? ?? false,
    );

Map<String, dynamic> _$SemesterAverageToJson(_SemesterAverage instance) =>
    <String, dynamic>{
      'semesterId': instance.semesterId,
      'code': instance.code,
      'libelle': instance.libelle,
      'annee': instance.annee,
      'moyenne': instance.moyenne,
      'creditsAcquis': instance.creditsAcquis,
      'estActif': instance.estActif,
    };
