import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/providers.dart';
import '../../attendance/data/attendance_repository.dart';
import '../../children/domain/child.dart';
import '../data/nfc_service.dart';
import '../domain/nfc_payload.dart';
import '../domain/timetable_models.dart';

enum NfcMode { sync, room, attendance, card }

sealed class NfcScanState {
  const NfcScanState();
}

class NfcIdle extends NfcScanState {
  const NfcIdle();
}

class NfcScanning extends NfcScanState {
  const NfcScanning();
}

class NfcSharing extends NfcScanState {
  const NfcSharing();
}

class NfcRoomResult extends NfcScanState {
  final RoomCheck check;
  const NfcRoomResult(this.check);
}

class NfcAttendanceResult extends NfcScanState {
  final String statut;
  final int minutesRetard;
  final String? course;
  const NfcAttendanceResult(this.statut, this.minutesRetard, this.course);
}

class NfcCardResult extends NfcScanState {
  final NfcStudentCard card;
  final Child? child;
  const NfcCardResult(this.card, this.child);
}

class NfcShareReceived extends NfcScanState {
  final NfcTimetableShare share;
  const NfcShareReceived(this.share);
}

class NfcFailed extends NfcScanState {
  final NfcFailure? failure;
  final String? message;
  const NfcFailed({this.failure, this.message});
}

/// Contexte d'interprétation d'un scan : dossier actif, dossiers suivis, cours du jour.
typedef NfcScanContext = ({Child child, List<Child> children, List<TimetableSlot> todaySlots});

/// Machine d'état du hub NFC : un scan, puis un résultat selon le contenu lu
/// (le contenu prime sur le mode choisi : un tag de salle lu en mode « carte » reste une salle).
class NfcScanController extends AutoDisposeNotifier<NfcScanState> {
  late NfcTimetableService _device;
  NfcTimetableService? _simulation;
  bool _sharing = false;

  /// Incrémenté à chaque scan, annulation ou fermeture : la réponse tardive
  /// d'un scan abandonné (changement de mode, « Annuler ») est ignorée.
  int _generation = 0;

  @override
  NfcScanState build() {
    // Lu ici : un provider ne peut plus être lu pendant la destruction (onDispose).
    _device = ref.read(nfcServiceProvider);
    ref.onDispose(() {
      _generation++;
      final service = _service;
      if (_sharing) service.stopSharing();
      service.cancel();
    });
    return const NfcIdle();
  }

  NfcTimetableService get _service => _simulation ?? _device;

  /// Démo sur un appareil sans NFC : les lectures suivantes renverront des tags simulés.
  void simulate(NfcTimetableService simulation) => _simulation = simulation;

  bool get simulating => _simulation != null;

  Future<NfcStatus> status() => _service.status();

  Future<bool> canShare() => _service.canShare();

  Future<void> scan(NfcScanContext context, {required String iosPrompt, required String iosSuccess}) async {
    if (state is NfcScanning) return;
    final generation = ++_generation;
    state = const NfcScanning();
    NfcScanState next;
    try {
      next = await _handle(await _service.read(iosPrompt: iosPrompt, iosSuccess: iosSuccess), context);
    } on NfcException catch (e) {
      next = NfcFailed(failure: e.failure);
    } on AppException catch (e) {
      next = NfcFailed(message: e.message);
    } catch (_) {
      // Toute autre erreur (contenu inattendu, plateforme) : jamais de radar bloqué en « recherche ».
      next = const NfcFailed(failure: NfcFailure.unreadable);
    }
    if (generation == _generation) state = next;
  }

  Future<NfcScanState> _handle(NfcPayload payload, NfcScanContext context) async {
    switch (payload) {
      case NfcTimetableShare():
        return NfcShareReceived(payload);
      case NfcRoomTag(:final roomCode):
        return NfcRoomResult(checkRoom(roomCode, context.todaySlots, DateTime.now()));
      case NfcAttendanceTag(:final code):
        final res = await ref.read(attendanceRepositoryProvider).scan(code);
        ref.invalidate(attendanceProvider(context.child.id));
        return NfcAttendanceResult('${res['statut'] ?? 'PRESENT'}', (res['minutesRetard'] as num?)?.toInt() ?? 0, res['cours'] as String?);
      case NfcStudentCard():
        final childId = ref.read(sharedPrefsProvider).nfcCards[payload.uid];
        return NfcCardResult(payload, context.children.where((c) => c.id == childId).firstOrNull);
    }
  }

  /// Associe la carte lue à un dossier : les prochains scans ouvriront directement son agenda.
  Future<void> linkCard(NfcStudentCard card, Child child) async {
    await ref.read(sharedPrefsProvider).setNfcCard(card.uid, child.id);
    state = NfcCardResult(card, child);
  }

  Future<void> startSharing(NfcTimetableShare share) async {
    try {
      await _service.startSharing(share);
      _sharing = true;
      state = const NfcSharing();
    } on NfcException catch (e) {
      state = NfcFailed(failure: e.failure);
    } on Exception {
      state = const NfcFailed(failure: NfcFailure.unsupported);
    }
  }

  Future<void> stopSharing() async {
    if (_sharing) await _service.stopSharing();
    _sharing = false;
    state = const NfcIdle();
  }

  Future<void> reset() async {
    _generation++;
    if (state is NfcScanning) await _service.cancel();
    if (_sharing) await stopSharing();
    state = const NfcIdle();
  }
}

final nfcScanControllerProvider = NotifierProvider.autoDispose<NfcScanController, NfcScanState>(NfcScanController.new);
