import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_models.freezed.dart';
part 'timetable_models.g.dart';

@freezed
abstract class TimetableSlot with _$TimetableSlot {
  const TimetableSlot._();

  const factory TimetableSlot({
    required String id,
    required DateTime debut,
    required DateTime fin,
    required String statut,
    String? motif,
    required String matiere,
    required String code,
    required String enseignant,
    required String salle,
    required String campus,
  }) = _TimetableSlot;
  factory TimetableSlot.fromJson(Map<String, dynamic> json) => _$TimetableSlotFromJson(json);

  bool get cancelled => statut == 'ANNULE';
  bool get postponed => statut == 'REPORTE';

  /// Cours en train de se dérouler à [now] (hors annulation).
  bool isLive(DateTime now) => !cancelled && !now.isBefore(debut) && now.isBefore(fin);
  bool isPast(DateTime now) => !fin.isAfter(now);
  int get minutes => fin.difference(debut).inMinutes;

  /// Jour local du créneau (minuit), clé de regroupement par journée.
  DateTime get day {
    final d = debut.toLocal();
    return DateTime(d.year, d.month, d.day);
  }
}

/// Lundi (minuit, heure locale) de la semaine contenant [d].
DateTime mondayOf(DateTime d) => DateTime(d.year, d.month, d.day - (d.weekday - 1));

/// Créneau placé dans une journée : couloir [lane] parmi [lanes] couloirs parallèles.
typedef PlacedSlot = ({TimetableSlot slot, int lane, int lanes});

/// Répartit les créneaux d'une journée en couloirs pour que deux cours
/// simultanés s'affichent côte à côte au lieu de se recouvrir.
List<PlacedSlot> placeDay(List<TimetableSlot> slots) {
  final sorted = [...slots]..sort((a, b) => a.debut.compareTo(b.debut));
  final placed = <PlacedSlot>[];
  var cluster = <({TimetableSlot slot, int lane})>[];
  final laneEnds = <DateTime>[];
  DateTime? clusterEnd;

  void flush() {
    final lanes = laneEnds.length;
    placed.addAll(cluster.map((c) => (slot: c.slot, lane: c.lane, lanes: lanes)));
    cluster = [];
    laneEnds.clear();
  }

  for (final s in sorted) {
    if (clusterEnd != null && !s.debut.isBefore(clusterEnd)) {
      flush();
      clusterEnd = null;
    }
    var lane = laneEnds.indexWhere((end) => !s.debut.isBefore(end));
    if (lane == -1) {
      lane = laneEnds.length;
      laneEnds.add(s.fin);
    } else {
      laneEnds[lane] = s.fin;
    }
    cluster.add((slot: s, lane: lane));
    clusterEnd = clusterEnd == null || s.fin.isAfter(clusterEnd) ? s.fin : clusterEnd;
  }
  flush();
  return placed;
}

/// Amplitude horaire affichée (heures entières) couvrant tous les créneaux.
({int start, int end}) hourRange(Iterable<TimetableSlot> slots, {int minStart = 8, int minEnd = 18}) {
  var start = minStart;
  var end = minEnd;
  for (final s in slots) {
    final d = s.debut.toLocal();
    final f = s.fin.toLocal();
    start = d.hour < start ? d.hour : start;
    final endHour = f.minute > 0 ? f.hour + 1 : f.hour;
    end = endHour > end ? endHour : end;
  }
  return (start: start, end: end.clamp(start + 1, 24));
}

enum ExportChannel { pdf, ics, image }

enum PdfLayout { landscape, portrait }

enum ImageFormat { story, square }

/// Métadonnées d'un export (PDF, iCalendar ou image) d'une semaine d'emploi du temps.
@freezed
abstract class TimetableExportRequest with _$TimetableExportRequest {
  const factory TimetableExportRequest({
    required ExportChannel channel,
    required DateTime weekStart,
    required String studentId,
    required String studentName,
    String? matricule,
    String? groupName,
    String? programName,
    @Default(PdfLayout.landscape) PdfLayout layout,
    @Default(ImageFormat.story) ImageFormat imageFormat,
    @Default(true) bool includeCancelled,
    @Default(15) int alarmMinutes,
  }) = _TimetableExportRequest;
  factory TimetableExportRequest.fromJson(Map<String, dynamic> json) => _$TimetableExportRequestFromJson(json);
}

@freezed
abstract class Timetable with _$Timetable {
  const factory Timetable({@Default([]) List<TimetableSlot> creneaux}) = _Timetable;
  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
}

@freezed
abstract class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({required String id, required String titre, String? description, required String type, required DateTime debut, required DateTime fin}) =
      _CalendarEvent;
  factory CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);
}
