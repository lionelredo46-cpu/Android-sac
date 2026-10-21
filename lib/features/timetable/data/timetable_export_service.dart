import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/timetable_models.dart';
import 'timetable_ics_generator.dart';
import 'timetable_pdf_generator.dart';

/// Façade des trois canaux d'export : PDF vectoriel, iCalendar et image.
class TimetableExportService {
  Future<TimetablePdfAssets>? _assets;

  Future<Uint8List> pdf(TimetableExportRequest request, List<TimetableSlot> slots, PdfLabels labels, {String locale = 'fr_FR'}) async {
    final TimetablePdfAssets assets;
    try {
      assets = await (_assets ??= TimetablePdfAssets.load());
    } catch (_) {
      _assets = null; // pas de mise en cache d'un échec : le prochain export réessaie
      rethrow;
    }
    return TimetablePdfGenerator(assets).build(request, slots, labels, locale: locale);
  }

  /// Fichier iCalendar couvrant [weeks] semaines à partir de la semaine demandée.
  String ics(TimetableExportRequest request, List<TimetableSlot> slots, IcsLabels labels, {required String calendarName, int weeks = 1}) {
    final start = request.weekStart;
    final end = DateTime(start.year, start.month, start.day + 7 * weeks);
    return const TimetableIcsGenerator().generate(
      slots: slots.where((s) => !s.debut.isBefore(start) && s.debut.isBefore(end)).toList(),
      calendarName: calendarName,
      labels: labels,
      alarmMinutes: request.alarmMinutes,
      includeCancelled: request.includeCancelled,
    );
  }

  /// Nom de fichier lisible : `AFRAM-EDT-Alexandre-OBIANG-2026-10-19.pdf`.
  static String fileName(TimetableExportRequest r, String extension) {
    final who = r.studentName.replaceAll(RegExp(r'[^A-Za-z0-9À-ÿ]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
    final week = r.weekStart.toIso8601String().substring(0, 10);
    return 'AFRAM-EDT-$who-$week.$extension';
  }

  Future<File> writeTemp(String name, List<int> bytes) async {
    final file = File('${(await getTemporaryDirectory()).path}/$name');
    return file.writeAsBytes(bytes, flush: true);
  }
}

final timetableExportServiceProvider = Provider<TimetableExportService>((_) => TimetableExportService());
