import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/theme/obsidian_theme.dart';
import '../domain/timetable_models.dart';

/// Libellés traduits du document.
typedef PdfLabels = ({
  String title,
  String student,
  String matricule,
  String group,
  String generatedOn,
  String authentic,
  String verifyHint,
  String cancelled,
  String postponed,
  String teacher,
  String room,
  String time,
  String course,
  String status,
  String noClass,
  String page,
});

/// Polices et logo embarqués (aucun téléchargement : export possible hors ligne).
class TimetablePdfAssets {
  final pw.Font regular;
  final pw.Font semiBold;
  final pw.Font bold;
  final pw.Font display;
  final pw.MemoryImage logo;

  const TimetablePdfAssets({required this.regular, required this.semiBold, required this.bold, required this.display, required this.logo});

  static Future<TimetablePdfAssets> load([AssetBundle? bundle]) async {
    final b = bundle ?? rootBundle;
    Future<pw.Font> font(String file) async => pw.Font.ttf(await b.load('assets/google_fonts/$file'));
    return TimetablePdfAssets(
      regular: await font('Inter-Regular.ttf'),
      semiBold: await font('Inter-SemiBold.ttf'),
      bold: await font('Inter-Bold.ttf'),
      display: await font('Outfit-Bold.ttf'),
      logo: pw.MemoryImage((await b.load('Afram/assets/logo/logo-afram-officiel.png')).buffer.asUint8List()),
    );
  }
}

/// Rendu PDF vectoriel A4 (paysage : grille hebdomadaire proportionnelle ; portrait : liste par jour).
class TimetablePdfGenerator {
  final TimetablePdfAssets assets;
  const TimetablePdfGenerator(this.assets);

  static const _ink = PdfColor.fromInt(0xFF0F172A);
  static const _muted = PdfColor.fromInt(0xFF64748B);
  static const _line = PdfColor.fromInt(0xFFE2E8F0);
  static const _navy = PdfColor.fromInt(0xFF0A3871);
  static const _gold = PdfColor.fromInt(0xFFE5A93C);

  static String _ymd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  /// Empreinte du contenu : toute modification du planning change le QR code.
  static String fingerprint(TimetableExportRequest r, List<TimetableSlot> slots) {
    final content = [r.studentId, _ymd(r.weekStart), for (final s in slots) '${s.id}|${s.statut}|${s.debut.toUtc().toIso8601String()}|${s.salle}'];
    return sha256.convert(utf8.encode(content.join(';'))).toString().substring(0, 16);
  }

  static String verificationUrl(TimetableExportRequest r, List<TimetableSlot> slots) =>
      Uri.https('uniparent.aframgabon.com', '/verifier/edt', {'e': r.studentId, 's': _ymd(r.weekStart), 'h': fingerprint(r, slots)}).toString();

  /// Créneaux de la semaine demandée, triés.
  static List<TimetableSlot> weekSlots(TimetableExportRequest r, List<TimetableSlot> slots) {
    final end = DateTime(r.weekStart.year, r.weekStart.month, r.weekStart.day + 7);
    return slots.where((s) => !s.debut.isBefore(r.weekStart) && s.debut.isBefore(end) && (r.includeCancelled || !s.cancelled)).toList()..sort((a, b) => a.debut.compareTo(b.debut));
  }

  Future<Uint8List> build(TimetableExportRequest request, List<TimetableSlot> allSlots, PdfLabels l, {String locale = 'fr_FR', DateTime? now}) async {
    final slots = weekSlots(request, allSlots);
    final landscape = request.layout == PdfLayout.landscape;
    final format = landscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;
    final url = verificationUrl(request, slots);
    final hash = fingerprint(request, slots);
    final generated = now ?? DateTime.now();
    final weekEnd = request.weekStart.add(const Duration(days: 5));
    final range = '${DateFormat.MMMMd(locale).format(request.weekStart)} – ${DateFormat.yMMMMd(locale).format(weekEnd)}';

    final doc = pw.Document(title: '${l.title} — ${request.studentName}', author: 'AFRAM', creator: 'UniParent AFRAM', subject: range);
    final pageTheme = pw.PageTheme(
      pageFormat: format,
      margin: const pw.EdgeInsets.fromLTRB(28, 26, 28, 22),
      theme: pw.ThemeData.withFont(base: assets.regular, bold: assets.bold),
      buildBackground: (_) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Watermark.text(
          'AFRAM',
          style: pw.TextStyle(font: assets.display, fontSize: landscape ? 150 : 120, color: const PdfColor.fromInt(0x0D0A3871)),
        ),
      ),
    );
    final header = _header(request, l, range, url, hash);
    pw.Widget footer(pw.Context ctx) => pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text('${l.generatedOn} ${DateFormat.yMd(locale).add_Hm().format(generated)} · UniParent AFRAM · #$hash', style: const pw.TextStyle(fontSize: 7, color: _muted)),
        ),
        pw.Text('${l.page} ${ctx.pageNumber}/${ctx.pagesCount}', style: const pw.TextStyle(fontSize: 7, color: _muted)),
      ],
    );

    if (landscape) {
      doc.addPage(
        pw.Page(
          pageTheme: pageTheme,
          build: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              header,
              pw.SizedBox(height: 10),
              pw.Expanded(child: pw.LayoutBuilder(builder: (_, c) => _grid(request, slots, l, locale, c!.maxWidth, c.maxHeight))),
              pw.SizedBox(height: 6),
              footer(ctx),
            ],
          ),
        ),
      );
    } else {
      doc.addPage(
        pw.MultiPage(
          pageTheme: pageTheme,
          header: (ctx) => ctx.pageNumber == 1 ? pw.Padding(padding: const pw.EdgeInsets.only(bottom: 12), child: header) : pw.SizedBox(),
          footer: (ctx) => pw.Padding(padding: const pw.EdgeInsets.only(top: 8), child: footer(ctx)),
          build: (_) => slots.isEmpty ? [_empty(l)] : _dayLists(slots, l, locale),
        ),
      );
    }
    return doc.save();
  }

  pw.Widget _header(TimetableExportRequest r, PdfLabels l, String range, String url, String hash) {
    final identity = [
      if (r.matricule != null) '${l.matricule} ${r.matricule}',
      if (r.groupName != null) '${l.group} ${r.groupName}',
      if (r.programName != null) r.programName!,
    ].join('  ·  ');
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _gold, width: 1.5)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Image(assets.logo, height: 46),
          pw.SizedBox(width: 14),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ACADÉMIE FRANCO-AMÉRICAINE DE MANAGEMENT',
                  style: pw.TextStyle(font: assets.semiBold, fontSize: 7.5, color: _navy, letterSpacing: 0.8),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  '${l.title} · $range',
                  style: pw.TextStyle(font: assets.display, fontSize: 17, color: _ink),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  '${l.student} ${r.studentName}',
                  style: pw.TextStyle(font: assets.semiBold, fontSize: 9.5, color: _ink),
                ),
                if (identity.isNotEmpty) pw.Text(identity, style: const pw.TextStyle(fontSize: 8, color: _muted)),
              ],
            ),
          ),
          pw.SizedBox(width: 12),
          _seal(l, url, hash),
        ],
      ),
    );
  }

  /// Sceau d'authenticité vectoriel : QR de vérification et empreinte du contenu.
  pw.Widget _seal(PdfLabels l, String url, String hash) => pw.Container(
    padding: const pw.EdgeInsets.all(6),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _gold, width: 0.8),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Row(
      children: [
        pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: url, width: 52, height: 52, color: _navy, drawText: false),
        pw.SizedBox(width: 6),
        pw.SizedBox(
          width: 92,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                l.authentic,
                style: pw.TextStyle(font: assets.bold, fontSize: 7.5, color: _navy),
              ),
              pw.SizedBox(height: 2),
              pw.Text(l.verifyHint, style: const pw.TextStyle(fontSize: 6.5, color: _muted)),
              pw.SizedBox(height: 2),
              pw.Text(
                '#$hash',
                style: pw.TextStyle(font: assets.semiBold, fontSize: 6.5, color: _gold),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  pw.Widget _empty(PdfLabels l) => pw.Padding(
    padding: const pw.EdgeInsets.all(40),
    child: pw.Center(
      child: pw.Text(l.noClass, style: const pw.TextStyle(fontSize: 12, color: _muted)),
    ),
  );

  static PdfColor _color(TimetableSlot s) => PdfColor.fromInt(ObsidianColors.forStatus(s.statut, s.code).toARGB32());

  pw.Widget _grid(TimetableExportRequest r, List<TimetableSlot> slots, PdfLabels l, String locale, double width, double height) {
    if (slots.isEmpty) return _empty(l);
    final hasSunday = slots.any((s) => s.day.weekday == DateTime.sunday);
    final days = List.generate(hasSunday ? 7 : 6, (i) => DateTime(r.weekStart.year, r.weekStart.month, r.weekStart.day + i));
    final hours = hourRange(slots);
    const gutter = 34.0;
    const headerHeight = 20.0;
    final columnWidth = (width - gutter) / days.length;
    final hourHeight = (height - headerHeight) / (hours.end - hours.start);
    double y(DateTime t) {
      final local = t.toLocal();
      return headerHeight + ((local.hour - hours.start) + local.minute / 60) * hourHeight;
    }

    final children = <pw.Widget>[
      for (var h = hours.start; h <= hours.end; h++) ...[
        pw.Positioned(
          left: gutter,
          top: headerHeight + (h - hours.start) * hourHeight,
          child: pw.Container(width: width - gutter, height: 0.5, color: _line),
        ),
        pw.Positioned(
          left: 0,
          top: headerHeight + (h - hours.start) * hourHeight - 4,
          child: pw.SizedBox(
            width: gutter - 6,
            child: pw.Text(
              '${h.toString().padLeft(2, '0')}:00',
              textAlign: pw.TextAlign.right,
              style: const pw.TextStyle(fontSize: 7, color: _muted),
            ),
          ),
        ),
      ],
      for (var i = 0; i < days.length; i++) ...[
        pw.Positioned(
          left: gutter + i * columnWidth,
          top: 0,
          child: pw.Container(width: 0.5, height: height, color: _line),
        ),
        pw.Positioned(
          left: gutter + i * columnWidth,
          top: 2,
          child: pw.SizedBox(
            width: columnWidth,
            child: pw.Text(
              toBeginningOfSentenceCase(DateFormat('EEEE d', locale).format(days[i])),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: assets.semiBold, fontSize: 8.5, color: _navy),
            ),
          ),
        ),
        for (final p in placeDay(slots.where((s) => s.day == days[i]).toList())) _block(p, l, gutter + i * columnWidth, columnWidth, y),
      ],
    ];
    return pw.SizedBox(
      width: width,
      height: height,
      child: pw.Stack(overflow: pw.Overflow.clip, children: children),
    );
  }

  pw.Widget _block(PlacedSlot p, PdfLabels l, double left, double columnWidth, double Function(DateTime) y) {
    final s = p.slot;
    final color = _color(s);
    final laneWidth = columnWidth / p.lanes;
    final top = y(s.debut);
    final blockHeight = (y(s.fin) - top - 2).clamp(10.0, double.infinity);
    final time = '${DateFormat.Hm().format(s.debut.toLocal())}–${DateFormat.Hm().format(s.fin.toLocal())}';
    final status = s.cancelled
        ? l.cancelled
        : s.postponed
        ? l.postponed
        : null;
    return pw.Positioned(
      left: left + p.lane * laneWidth + 2,
      top: top + 1,
      // Barre de couleur dessinée à part : la bibliothèque pdf refuse un coin arrondi sur une bordure non uniforme.
      child: pw.Container(
        width: laneWidth - 4,
        height: blockHeight,
        decoration: pw.BoxDecoration(
          color: PdfColor(color.red, color.green, color.blue, 0.12),
          borderRadius: const pw.BorderRadius.horizontal(right: pw.Radius.circular(3)),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Container(width: 2.5, color: color),
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(4, 3, 4, 3),
                child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              s.matiere,
              maxLines: blockHeight > 40 ? 2 : 1,
              overflow: pw.TextOverflow.clip,
              style: pw.TextStyle(font: assets.bold, fontSize: 7.5, color: _ink, decoration: s.cancelled ? pw.TextDecoration.lineThrough : null),
            ),
            if (blockHeight > 26)
              pw.Text(
                '$time · ${s.salle}',
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                style: const pw.TextStyle(fontSize: 6.5, color: _muted),
              ),
            if (blockHeight > 46)
              pw.Text(
                s.enseignant,
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                style: const pw.TextStyle(fontSize: 6.5, color: _muted),
              ),
            if (status != null && blockHeight > 36)
              pw.Text(
                status.toUpperCase(),
                style: pw.TextStyle(font: assets.bold, fontSize: 6, color: color),
              ),
          ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<pw.Widget> _dayLists(List<TimetableSlot> slots, PdfLabels l, String locale) {
    final byDay = <DateTime, List<TimetableSlot>>{};
    for (final s in slots) {
      byDay.putIfAbsent(s.day, () => []).add(s);
    }
    pw.Widget cell(String text, {pw.Font? font, PdfColor color = _ink, double size = 8.5}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: size, color: color),
      ),
    );

    return [
      for (final e in byDay.entries) ...[
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 10, bottom: 4),
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: pw.BoxDecoration(color: _navy, borderRadius: pw.BorderRadius.circular(4)),
          child: pw.Text(
            toBeginningOfSentenceCase(DateFormat.yMMMMEEEEd(locale).format(e.key)),
            style: pw.TextStyle(font: assets.semiBold, fontSize: 9.5, color: PdfColors.white),
          ),
        ),
        pw.Table(
          columnWidths: const {0: pw.FixedColumnWidth(62), 1: pw.FlexColumnWidth(3), 2: pw.FlexColumnWidth(2), 3: pw.FlexColumnWidth(2), 4: pw.FixedColumnWidth(54)},
          border: const pw.TableBorder(horizontalInside: pw.BorderSide(color: _line, width: 0.5)),
          children: [
            pw.TableRow(
              children: [
                for (final h in [l.time, l.course, l.room, l.teacher, l.status]) cell(h, font: assets.semiBold, color: _muted, size: 7.5),
              ],
            ),
            for (final s in e.value)
              pw.TableRow(
                verticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  cell('${DateFormat.Hm().format(s.debut.toLocal())}–${DateFormat.Hm().format(s.fin.toLocal())}', font: assets.semiBold),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    child: pw.Row(
                      children: [
                        pw.Container(
                          width: 6,
                          height: 6,
                          decoration: pw.BoxDecoration(color: _color(s), shape: pw.BoxShape.circle),
                        ),
                        pw.SizedBox(width: 5),
                        pw.Expanded(
                          child: pw.Text(
                            '${s.matiere} (${s.code})',
                            style: pw.TextStyle(font: assets.semiBold, fontSize: 8.5, color: _ink, decoration: s.cancelled ? pw.TextDecoration.lineThrough : null),
                          ),
                        ),
                      ],
                    ),
                  ),
                  cell('${s.salle} — ${s.campus}'),
                  cell(s.enseignant),
                  cell(
                    s.cancelled
                        ? l.cancelled
                        : s.postponed
                        ? l.postponed
                        : '—',
                    font: assets.semiBold,
                    color: s.cancelled || s.postponed ? _color(s) : _muted,
                    size: 7.5,
                  ),
                ],
              ),
          ],
        ),
      ],
    ];
  }
}
