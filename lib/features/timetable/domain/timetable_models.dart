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
}

@freezed
abstract class Timetable with _$Timetable {
  const factory Timetable({@Default([]) List<TimetableSlot> creneaux}) = _Timetable;
  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
}

@freezed
abstract class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String id,
    required String titre,
    String? description,
    required String type,
    required DateTime debut,
    required DateTime fin,
  }) = _CalendarEvent;
  factory CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);
}
