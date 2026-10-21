import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'timetable_models.dart';

part 'nfc_payload.freezed.dart';
part 'nfc_payload.g.dart';

/// Créneau compact échangé par NFC (clés courtes : la capacité d'un tag est limitée).
@freezed
abstract class SharedSlot with _$SharedSlot {
  const SharedSlot._();

  const factory SharedSlot({
    @JsonKey(name: 'd') required DateTime debut,
    @JsonKey(name: 'f') required DateTime fin,
    @JsonKey(name: 'm') required String matiere,
    @JsonKey(name: 'c') required String code,
    @JsonKey(name: 's') required String salle,
    @JsonKey(name: 'p') required String campus,
    @JsonKey(name: 'e') required String enseignant,
    @JsonKey(name: 't') @Default('PLANIFIE') String statut,
  }) = _SharedSlot;
  factory SharedSlot.fromJson(Map<String, dynamic> json) => _$SharedSlotFromJson(json);

  factory SharedSlot.fromSlot(TimetableSlot s) =>
      SharedSlot(debut: s.debut, fin: s.fin, matiere: s.matiere, code: s.code, salle: s.salle, campus: s.campus, enseignant: s.enseignant, statut: s.statut);

  /// Identifiant stable et propre au propriétaire : deux emplois du temps reçus (ou un
  /// nouvel envoi réordonné) ne se télescopent pas dans l'agenda (UID iCalendar).
  TimetableSlot toSlot(String owner) => TimetableSlot(
    id: 'nfc-${sha1.convert(utf8.encode(owner)).toString().substring(0, 10)}-$code-${debut.toUtc().millisecondsSinceEpoch}',
    debut: debut,
    fin: fin,
    statut: statut,
    matiere: matiere,
    code: code,
    enseignant: enseignant,
    salle: salle,
    campus: campus,
  );
}

/// Contenu d'un échange NFC, selon les quatre usages du module.
@Freezed(unionKey: 'k')
sealed class NfcPayload with _$NfcPayload {
  /// Tap-to-Sync : semaine d'emploi du temps transmise de téléphone à téléphone.
  const factory NfcPayload.timetableShare({
    @Default(1) int v,
    required String owner,
    String? group,
    required DateTime weekStart,
    required DateTime sharedAt,
    @Default([]) List<SharedSlot> slots,
  }) = NfcTimetableShare;

  /// Tag posé à l'entrée d'une salle ou d'un amphithéâtre.
  const factory NfcPayload.room({required String roomCode}) = NfcRoomTag;

  /// Borne ou badge d'émargement : même code de séance que le QR de présence.
  const factory NfcPayload.attendance({required String code}) = NfcAttendanceTag;

  /// Carte étudiante physique (MIFARE, DESFire, NFC standard) : seul l'identifiant est lu.
  const factory NfcPayload.studentCard({required String uid, required String technology}) = NfcStudentCard;

  factory NfcPayload.fromJson(Map<String, dynamic> json) => _$NfcPayloadFromJson(json);
}

/// Résultat d'un scan de salle : est-ce la salle du cours en cours (ou du prochain) ?
typedef RoomCheck = ({String roomCode, bool isMine, TimetableSlot? reference, List<TimetableSlot> inRoomToday});

String _roomKey(String code) => code.toUpperCase().replaceAll(RegExp(r'[\s_-]'), '');

RoomCheck checkRoom(String roomCode, List<TimetableSlot> todaySlots, DateTime now) {
  final active = todaySlots.where((s) => !s.cancelled).toList()..sort((a, b) => a.debut.compareTo(b.debut));
  final reference = active.where((s) => s.isLive(now)).firstOrNull ?? active.where((s) => s.debut.isAfter(now)).firstOrNull;
  return (
    roomCode: roomCode,
    isMine: reference != null && _roomKey(reference.salle) == _roomKey(roomCode),
    reference: reference,
    inRoomToday: active.where((s) => _roomKey(s.salle) == _roomKey(roomCode)).toList(),
  );
}
