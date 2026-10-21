import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../attendance/data/attendance_repository.dart';
import '../domain/timetable_models.dart';

enum TimetableMobileMode { day, week }

/// État d'affichage de l'emploi du temps (semaine, jour, cours sélectionné, vues).
@immutable
class TimetableViewState {
  final DateTime weekStart;
  final DateTime selectedDay;
  final String? selectedSlotId;
  final TimetableMobileMode mobileMode;
  final bool panelOpen;

  const TimetableViewState({required this.weekStart, required this.selectedDay, this.selectedSlotId, this.mobileMode = TimetableMobileMode.day, this.panelOpen = true});

  TimetableViewState copyWith({DateTime? weekStart, DateTime? selectedDay, String? Function()? selectedSlotId, TimetableMobileMode? mobileMode, bool? panelOpen}) =>
      TimetableViewState(
        weekStart: weekStart ?? this.weekStart,
        selectedDay: selectedDay ?? this.selectedDay,
        selectedSlotId: selectedSlotId != null ? selectedSlotId() : this.selectedSlotId,
        mobileMode: mobileMode ?? this.mobileMode,
        panelOpen: panelOpen ?? this.panelOpen,
      );
}

class TimetableController extends AutoDisposeNotifier<TimetableViewState> {
  @override
  TimetableViewState build() => _stateFor(DateTime.now());

  static DateTime _date(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Le dimanche, on présente la semaine suivante (pas de cours le week-end).
  TimetableViewState _stateFor(DateTime day) {
    var d = _date(day);
    if (d.weekday == DateTime.sunday) d = DateTime(d.year, d.month, d.day + 1);
    return TimetableViewState(weekStart: mondayOf(d), selectedDay: d);
  }

  /// Ouvre la semaine contenant [day] et sélectionne ce jour (lien profond, carte NFC…).
  void show(DateTime day) {
    final next = _stateFor(day);
    state = state.copyWith(weekStart: next.weekStart, selectedDay: next.selectedDay, selectedSlotId: () => null);
  }

  void goToToday() => show(DateTime.now());

  /// Change de semaine en conservant le jour de la semaine sélectionné.
  void shiftWeek(int weeks) {
    if (weeks == 0) return;
    DateTime shift(DateTime d) => DateTime(d.year, d.month, d.day + 7 * weeks);
    state = state.copyWith(weekStart: shift(state.weekStart), selectedDay: shift(state.selectedDay), selectedSlotId: () => null);
  }

  void selectDay(DateTime day) {
    final d = _date(day);
    state = state.copyWith(weekStart: mondayOf(d), selectedDay: d);
  }

  void selectSlot(String? id) => state = state.copyWith(selectedSlotId: () => id, panelOpen: id != null ? true : null);

  void togglePanel() => state = state.copyWith(panelOpen: !state.panelOpen);

  void toggleMobileMode() => state = state.copyWith(mobileMode: state.mobileMode == TimetableMobileMode.day ? TimetableMobileMode.week : TimetableMobileMode.day);
}

final timetableControllerProvider = NotifierProvider.autoDispose<TimetableController, TimetableViewState>(TimetableController.new);

/// Horloge du module : rafraîchit le repère « maintenant » et les cours en direct toutes les 30 s.
class ClockController extends AutoDisposeNotifier<DateTime> {
  @override
  DateTime build() {
    final timer = Timer.periodic(const Duration(seconds: 30), (_) => state = DateTime.now());
    ref.onDispose(timer.cancel);
    return DateTime.now();
  }
}

final clockProvider = NotifierProvider.autoDispose<ClockController, DateTime>(ClockController.new);

/// Statut de présence par créneau (`CODE@début UTC`) pour l'indicateur d'appel des cartes.
final attendanceBySlotProvider = Provider.autoDispose.family<Map<String, String>, String>((ref, childId) {
  final items = ref.watch(attendanceProvider(childId)).value?.data ?? const [];
  return {for (final a in items) attendanceKey(a.cours.code, a.date): a.statut};
});

String attendanceKey(String courseCode, DateTime debut) => '$courseCode@${debut.toUtc().toIso8601String()}';
