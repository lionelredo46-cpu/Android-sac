import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndef/ndef.dart' as ndef;

import '../domain/nfc_payload.dart';

enum NfcStatus { available, disabled, unsupported }

enum NfcFailure { timeout, cancelled, unsupported, unreadable, tooLarge }

class NfcException implements Exception {
  final NfcFailure failure;
  final String? detail;
  const NfcException(this.failure, [this.detail]);

  @override
  String toString() => 'NfcException($failure${detail == null ? '' : ': $detail'})';
}

/// Format des échanges NFC du module (NDEF) :
/// - Tap-to-Sync : enregistrement MIME `application/vnd.afram.timetable` (JSON compressé gzip) ;
/// - salle : URI `https://uniparent.aframgabon.com/salle/<code>` ou texte `AFRAM:SALLE:<code>` ;
/// - émargement : URI `…/presence/<code>` ou texte `AFRAM:PRESENCE:<code>` ;
/// - tout autre support (carte étudiante sans NDEF reconnu) : identifiant matériel.
class NfcPayloadCodec {
  NfcPayloadCodec._();

  static const mimeType = 'application/vnd.afram.timetable';
  static const host = 'uniparent.aframgabon.com';

  /// Taille maximale d'un message NDEF de tag de type 4 (fichier NDEF de 0x7FFF octets, longueur comprise).
  static const maxNdefBytes = 0x7FFD;

  /// Plafond de décompression : une semaine pèse quelques Ko, au-delà le contenu est suspect.
  static const _maxJsonBytes = 256 * 1024;

  static Uint8List encodeShare(NfcTimetableShare share) {
    final json = utf8.encode(jsonEncode(share.toJson()));
    final record = ndef.MimeRecord(decodedType: mimeType, payload: Uint8List.fromList(gzip.encode(json)));
    final message = ndef.encodeNdefMessage([record]);
    if (message.length > maxNdefBytes) throw const NfcException(NfcFailure.tooLarge);
    return message;
  }

  static NfcPayload decode({required List<ndef.NDEFRecord> records, required String uid, required String technology}) {
    for (final r in records) {
      if (r is ndef.MimeRecord && r.decodedType == mimeType && r.payload != null) {
        // Contenu venu d'un tag ou d'un téléphone inconnu : taille bornée, toute anomalie = illisible.
        try {
          if (r.payload!.length > maxNdefBytes) throw const FormatException('Message NDEF trop long');
          final json = jsonDecode(utf8.decode(_gunzip(r.payload!))) as Map<String, dynamic>;
          return NfcPayload.fromJson(json);
        } on Object catch (e) {
          throw NfcException(NfcFailure.unreadable, '$e');
        }
      }
      final text = switch (r) {
        ndef.UriRecord(:final uriString) => uriString,
        ndef.TextRecord(:final text) => text,
        _ => null,
      };
      final parsed = text == null ? null : parseText(text);
      if (parsed != null) return parsed;
    }
    return NfcPayload.studentCard(uid: uid, technology: technology);
  }

  /// Décompression par blocs, interrompue dès que le plafond est dépassé (protection « gzip bomb »).
  static List<int> _gunzip(List<int> data) {
    final out = _CappedSink(_maxJsonBytes);
    final input = gzip.decoder.startChunkedConversion(out);
    for (var i = 0; i < data.length; i += 512) {
      input.add(data.sublist(i, i + 512 > data.length ? data.length : i + 512));
    }
    input.close();
    return out.bytes.takeBytes();
  }

  /// Reconnaît un tag de salle ou d'émargement (URI ou texte).
  static NfcPayload? parseText(String value) {
    final v = value.trim();
    final uri = Uri.tryParse(v);
    if (uri != null && uri.host == host && uri.pathSegments.length >= 2) {
      final code = Uri.decodeComponent(uri.pathSegments[1]);
      if (code.isEmpty) return null;
      return switch (uri.pathSegments.first) {
        'salle' => NfcPayload.room(roomCode: code),
        'presence' => NfcPayload.attendance(code: code),
        _ => null,
      };
    }
    final m = RegExp(r'^AFRAM:(SALLE|PRESENCE):(.+)$', caseSensitive: false).firstMatch(v);
    if (m == null) return null;
    final code = m.group(2)!.trim();
    return m.group(1)!.toUpperCase() == 'SALLE' ? NfcPayload.room(roomCode: code) : NfcPayload.attendance(code: code);
  }
}

class _CappedSink implements Sink<List<int>> {
  final int max;
  final bytes = BytesBuilder(copy: false);
  _CappedSink(this.max);

  @override
  void add(List<int> chunk) {
    bytes.add(chunk);
    if (bytes.length > max) throw const FormatException('Contenu NFC décompressé trop volumineux');
  }

  @override
  void close() {}
}

/// Abstraction NFC du module Emploi du temps (lecture de tags, échange entre téléphones).
abstract class NfcTimetableService {
  Future<NfcStatus> status();

  /// Attend un tag, une carte ou un téléphone en émulation, puis décode son contenu.
  Future<NfcPayload> read({required String iosPrompt, required String iosSuccess, Duration timeout = const Duration(seconds: 30)});

  Future<void> cancel();

  /// Émulation de tag (Host Card Emulation) : disponible sur Android uniquement.
  Future<bool> canShare();

  /// Expose la semaine comme un tag NFC jusqu'à [stopSharing] : l'autre téléphone n'a qu'à la lire.
  Future<void> startSharing(NfcTimetableShare share);

  Future<void> stopSharing();
}

/// Implémentation matérielle : flutter_nfc_kit (lecture) et service HCE natif Android (partage).
class DeviceNfcTimetableService implements NfcTimetableService {
  static const _hce = MethodChannel('ga.afram.uniparent/hce');

  @override
  Future<NfcStatus> status() async {
    try {
      return switch (await FlutterNfcKit.nfcAvailability) {
        NFCAvailability.available => NfcStatus.available,
        NFCAvailability.disabled => NfcStatus.disabled,
        NFCAvailability.not_supported => NfcStatus.unsupported,
      };
    } on PlatformException {
      return NfcStatus.unsupported;
    } on MissingPluginException {
      return NfcStatus.unsupported;
    }
  }

  @override
  Future<NfcPayload> read({required String iosPrompt, required String iosSuccess, Duration timeout = const Duration(seconds: 30)}) async {
    try {
      final tag = await FlutterNfcKit.poll(timeout: timeout, iosAlertMessage: iosPrompt);
      var records = <ndef.NDEFRecord>[];
      if (tag.ndefAvailable == true) {
        try {
          records = await FlutterNfcKit.readNDEFRecords(cached: false);
        } on PlatformException {
          // Carte sans NDEF exploitable (DESFire chiffrée…) : on garde l'identifiant.
        }
      }
      await FlutterNfcKit.finish(iosAlertMessage: iosSuccess);
      return NfcPayloadCodec.decode(records: records, uid: tag.id, technology: tag.type.name);
    } on PlatformException catch (e) {
      await FlutterNfcKit.finish().catchError((_) {});
      throw NfcException(switch (e.code) {
        '408' => NfcFailure.timeout,
        '409' => NfcFailure.cancelled,
        '404' => NfcFailure.unsupported,
        _ => NfcFailure.unreadable,
      }, e.message);
    } on FormatException catch (e) {
      throw NfcException(NfcFailure.unreadable, e.message);
    }
  }

  @override
  Future<void> cancel() => FlutterNfcKit.finish().catchError((_) {});

  @override
  Future<bool> canShare() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _hce.invokeMethod<bool>('isSupported') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<void> startSharing(NfcTimetableShare share) async {
    try {
      await _hce.invokeMethod('start', {'ndef': NfcPayloadCodec.encodeShare(share)});
    } on PlatformException catch (e) {
      throw NfcException(e.code == '413' ? NfcFailure.tooLarge : NfcFailure.unsupported, e.message);
    }
  }

  @override
  Future<void> stopSharing() async {
    try {
      await _hce.invokeMethod('stop');
    } on MissingPluginException {
      // Plateforme sans émulation : rien à arrêter.
    }
  }
}

/// Lecteur simulé : démonstration sur un appareil sans puce NFC (émulateur) et tests.
class SimulatedNfcTimetableService implements NfcTimetableService {
  final NfcPayload Function() next;
  final Duration delay;
  bool _sharing = false;

  SimulatedNfcTimetableService(this.next, {this.delay = const Duration(milliseconds: 1600)});

  bool get isSharing => _sharing;

  @override
  Future<NfcStatus> status() async => NfcStatus.available;

  @override
  Future<NfcPayload> read({required String iosPrompt, required String iosSuccess, Duration timeout = const Duration(seconds: 30)}) async {
    await Future<void>.delayed(delay);
    return next();
  }

  @override
  Future<void> cancel() async {}

  @override
  Future<bool> canShare() async => true;

  @override
  Future<void> startSharing(NfcTimetableShare share) async => _sharing = true;

  @override
  Future<void> stopSharing() async => _sharing = false;
}

final nfcServiceProvider = Provider<NfcTimetableService>((_) => DeviceNfcTimetableService());
