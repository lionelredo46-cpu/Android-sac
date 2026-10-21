// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NextDue _$NextDueFromJson(Map<String, dynamic> json) => _NextDue(
  invoiceId: json['invoiceId'] as String,
  date: DateTime.parse(json['date'] as String),
  montant: (json['montant'] as num).toInt(),
);

Map<String, dynamic> _$NextDueToJson(_NextDue instance) => <String, dynamic>{
  'invoiceId': instance.invoiceId,
  'date': instance.date.toIso8601String(),
  'montant': instance.montant,
};

_DashboardFinances _$DashboardFinancesFromJson(Map<String, dynamic> json) =>
    _DashboardFinances(
      devise: json['devise'] as String? ?? 'XAF',
      totalDu: (json['totalDu'] as num?)?.toInt() ?? 0,
      totalPaye: (json['totalPaye'] as num?)?.toInt() ?? 0,
      resteAPayer: (json['resteAPayer'] as num?)?.toInt() ?? 0,
      prochaineEcheance: json['prochaineEcheance'] == null
          ? null
          : NextDue.fromJson(json['prochaineEcheance'] as Map<String, dynamic>),
      statut: json['statut'] as String? ?? 'A_JOUR',
    );

Map<String, dynamic> _$DashboardFinancesToJson(_DashboardFinances instance) =>
    <String, dynamic>{
      'devise': instance.devise,
      'totalDu': instance.totalDu,
      'totalPaye': instance.totalPaye,
      'resteAPayer': instance.resteAPayer,
      'prochaineEcheance': instance.prochaineEcheance,
      'statut': instance.statut,
    };

_RecentAbsence _$RecentAbsenceFromJson(Map<String, dynamic> json) =>
    _RecentAbsence(
      id: json['id'] as String,
      statut: json['statut'] as String,
      date: DateTime.parse(json['date'] as String),
      cours: json['cours'] as String,
      minutesRetard: (json['minutesRetard'] as num?)?.toInt() ?? 0,
      justification: json['justification'] as String?,
    );

Map<String, dynamic> _$RecentAbsenceToJson(_RecentAbsence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statut': instance.statut,
      'date': instance.date.toIso8601String(),
      'cours': instance.cours,
      'minutesRetard': instance.minutesRetard,
      'justification': instance.justification,
    };

_DashboardPresence _$DashboardPresenceFromJson(Map<String, dynamic> json) =>
    _DashboardPresence(
      tauxAssiduiteMois: (json['tauxAssiduiteMois'] as num?)?.toDouble(),
      seancesMois: (json['seancesMois'] as num?)?.toInt() ?? 0,
      absencesMois: (json['absencesMois'] as num?)?.toInt() ?? 0,
      retardsMois: (json['retardsMois'] as num?)?.toInt() ?? 0,
      dernieresAbsences:
          (json['dernieresAbsences'] as List<dynamic>?)
              ?.map((e) => RecentAbsence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DashboardPresenceToJson(_DashboardPresence instance) =>
    <String, dynamic>{
      'tauxAssiduiteMois': instance.tauxAssiduiteMois,
      'seancesMois': instance.seancesMois,
      'absencesMois': instance.absencesMois,
      'retardsMois': instance.retardsMois,
      'dernieresAbsences': instance.dernieresAbsences,
    };

_SemesterRef _$SemesterRefFromJson(Map<String, dynamic> json) => _SemesterRef(
  id: json['id'] as String,
  code: json['code'] as String,
  libelle: json['libelle'] as String,
);

Map<String, dynamic> _$SemesterRefToJson(_SemesterRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'libelle': instance.libelle,
    };

_RecentGrade _$RecentGradeFromJson(Map<String, dynamic> json) => _RecentGrade(
  id: json['id'] as String,
  matiere: json['matiere'] as String,
  evaluation: json['evaluation'] as String,
  valeur: (json['valeur'] as num).toDouble(),
  bareme: (json['bareme'] as num?)?.toDouble() ?? 20,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$RecentGradeToJson(_RecentGrade instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matiere': instance.matiere,
      'evaluation': instance.evaluation,
      'valeur': instance.valeur,
      'bareme': instance.bareme,
      'date': instance.date.toIso8601String(),
    };

_DashboardResults _$DashboardResultsFromJson(Map<String, dynamic> json) =>
    _DashboardResults(
      semestre: json['semestre'] == null
          ? null
          : SemesterRef.fromJson(json['semestre'] as Map<String, dynamic>),
      moyenneGenerale: (json['moyenneGenerale'] as num?)?.toDouble(),
      creditsAcquis: (json['creditsAcquis'] as num?)?.toInt() ?? 0,
      dernieresNotes:
          (json['dernieresNotes'] as List<dynamic>?)
              ?.map((e) => RecentGrade.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DashboardResultsToJson(_DashboardResults instance) =>
    <String, dynamic>{
      'semestre': instance.semestre,
      'moyenneGenerale': instance.moyenneGenerale,
      'creditsAcquis': instance.creditsAcquis,
      'dernieresNotes': instance.dernieresNotes,
    };

_TodaySlot _$TodaySlotFromJson(Map<String, dynamic> json) => _TodaySlot(
  id: json['id'] as String,
  debut: DateTime.parse(json['debut'] as String),
  fin: DateTime.parse(json['fin'] as String),
  statut: json['statut'] as String,
  matiere: json['matiere'] as String,
  salle: json['salle'] as String,
  campus: json['campus'] as String,
  enseignant: json['enseignant'] as String,
);

Map<String, dynamic> _$TodaySlotToJson(_TodaySlot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debut': instance.debut.toIso8601String(),
      'fin': instance.fin.toIso8601String(),
      'statut': instance.statut,
      'matiere': instance.matiere,
      'salle': instance.salle,
      'campus': instance.campus,
      'enseignant': instance.enseignant,
    };

_DashboardAlert _$DashboardAlertFromJson(Map<String, dynamic> json) =>
    _DashboardAlert(
      type: json['type'] as String,
      niveau: json['niveau'] as String,
      message: json['message'] as String,
      refId: json['refId'] as String?,
    );

Map<String, dynamic> _$DashboardAlertToJson(_DashboardAlert instance) =>
    <String, dynamic>{
      'type': instance.type,
      'niveau': instance.niveau,
      'message': instance.message,
      'refId': instance.refId,
    };

_NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => _NewsItem(
  id: json['id'] as String,
  titre: json['titre'] as String,
  contenu: json['contenu'] as String,
  datePublication: DateTime.parse(json['datePublication'] as String),
);

Map<String, dynamic> _$NewsItemToJson(_NewsItem instance) => <String, dynamic>{
  'id': instance.id,
  'titre': instance.titre,
  'contenu': instance.contenu,
  'datePublication': instance.datePublication.toIso8601String(),
};

_Dashboard _$DashboardFromJson(Map<String, dynamic> json) => _Dashboard(
  finances: DashboardFinances.fromJson(
    json['finances'] as Map<String, dynamic>,
  ),
  presence: DashboardPresence.fromJson(
    json['presence'] as Map<String, dynamic>,
  ),
  resultats: DashboardResults.fromJson(
    json['resultats'] as Map<String, dynamic>,
  ),
  aujourdhui:
      (json['aujourdhui'] as List<dynamic>?)
          ?.map((e) => TodaySlot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  alertes:
      (json['alertes'] as List<dynamic>?)
          ?.map((e) => DashboardAlert.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  actualites:
      (json['actualites'] as List<dynamic>?)
          ?.map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DashboardToJson(_Dashboard instance) =>
    <String, dynamic>{
      'finances': instance.finances,
      'presence': instance.presence,
      'resultats': instance.resultats,
      'aujourdhui': instance.aujourdhui,
      'alertes': instance.alertes,
      'actualites': instance.actualites,
    };
