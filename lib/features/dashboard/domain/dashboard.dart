import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard.freezed.dart';
part 'dashboard.g.dart';

@freezed
abstract class NextDue with _$NextDue {
  const factory NextDue({required String invoiceId, required DateTime date, required int montant}) = _NextDue;
  factory NextDue.fromJson(Map<String, dynamic> json) => _$NextDueFromJson(json);
}

@freezed
abstract class DashboardFinances with _$DashboardFinances {
  const factory DashboardFinances({
    @Default('XAF') String devise,
    @Default(0) int totalDu,
    @Default(0) int totalPaye,
    @Default(0) int resteAPayer,
    NextDue? prochaineEcheance,
    @Default('A_JOUR') String statut,
  }) = _DashboardFinances;
  factory DashboardFinances.fromJson(Map<String, dynamic> json) => _$DashboardFinancesFromJson(json);
}

@freezed
abstract class RecentAbsence with _$RecentAbsence {
  const factory RecentAbsence({
    required String id,
    required String statut,
    required DateTime date,
    required String cours,
    @Default(0) int minutesRetard,
    String? justification,
  }) = _RecentAbsence;
  factory RecentAbsence.fromJson(Map<String, dynamic> json) => _$RecentAbsenceFromJson(json);
}

@freezed
abstract class DashboardPresence with _$DashboardPresence {
  const factory DashboardPresence({
    double? tauxAssiduiteMois,
    @Default(0) int seancesMois,
    @Default(0) int absencesMois,
    @Default(0) int retardsMois,
    @Default([]) List<RecentAbsence> dernieresAbsences,
  }) = _DashboardPresence;
  factory DashboardPresence.fromJson(Map<String, dynamic> json) => _$DashboardPresenceFromJson(json);
}

@freezed
abstract class SemesterRef with _$SemesterRef {
  const factory SemesterRef({required String id, required String code, required String libelle}) = _SemesterRef;
  factory SemesterRef.fromJson(Map<String, dynamic> json) => _$SemesterRefFromJson(json);
}

@freezed
abstract class RecentGrade with _$RecentGrade {
  const factory RecentGrade({
    required String id,
    required String matiere,
    required String evaluation,
    required double valeur,
    @Default(20) double bareme,
    required DateTime date,
  }) = _RecentGrade;
  factory RecentGrade.fromJson(Map<String, dynamic> json) => _$RecentGradeFromJson(json);
}

@freezed
abstract class DashboardResults with _$DashboardResults {
  const factory DashboardResults({
    SemesterRef? semestre,
    double? moyenneGenerale,
    @Default(0) int creditsAcquis,
    @Default([]) List<RecentGrade> dernieresNotes,
  }) = _DashboardResults;
  factory DashboardResults.fromJson(Map<String, dynamic> json) => _$DashboardResultsFromJson(json);
}

@freezed
abstract class TodaySlot with _$TodaySlot {
  const factory TodaySlot({
    required String id,
    required DateTime debut,
    required DateTime fin,
    required String statut,
    required String matiere,
    required String salle,
    required String campus,
    required String enseignant,
  }) = _TodaySlot;
  factory TodaySlot.fromJson(Map<String, dynamic> json) => _$TodaySlotFromJson(json);
}

@freezed
abstract class DashboardAlert with _$DashboardAlert {
  const factory DashboardAlert({required String type, required String niveau, required String message, String? refId}) = _DashboardAlert;
  factory DashboardAlert.fromJson(Map<String, dynamic> json) => _$DashboardAlertFromJson(json);
}

@freezed
abstract class NewsItem with _$NewsItem {
  const factory NewsItem({required String id, required String titre, required String contenu, required DateTime datePublication}) = _NewsItem;
  factory NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);
}

@freezed
abstract class Dashboard with _$Dashboard {
  const factory Dashboard({
    required DashboardFinances finances,
    required DashboardPresence presence,
    required DashboardResults resultats,
    @Default([]) List<TodaySlot> aujourdhui,
    @Default([]) List<DashboardAlert> alertes,
    @Default([]) List<NewsItem> actualites,
  }) = _Dashboard;
  factory Dashboard.fromJson(Map<String, dynamic> json) => _$DashboardFromJson(json);
}
