import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// PDF générés sur l'appareil en mode démo (reçus, attestations, pièces déposées).
/// Polices standard PDF : n'utiliser que des caractères Latin-1 (pas d'espace fine).
class DemoPdf {
  DemoPdf._();

  static final _blue = PdfColor.fromHex('#0B3D91');

  /// Remplace la typographie hors Latin-1 (apostrophe courbe, tirets…) que les polices standard ne savent pas dessiner.
  static String _latin(String s) => s
      .replaceAll(RegExp('[’‘]'), "'")
      .replaceAll(RegExp('[“”]'), '"')
      .replaceAll(RegExp('[—–]'), '-')
      .replaceAll('…', '...')
      .replaceAll(RegExp('[  ]'), ' ');

  static Future<List<int>> build({required String title, String? reference, required List<String> paragraphs, List<List<String>> table = const []}) async {
    title = _latin(title);
    reference = reference == null ? null : _latin(reference);
    paragraphs = paragraphs.map(_latin).toList();
    table = [for (final row in table) row.map(_latin).toList()];
    final doc = pw.Document(title: title, author: 'AFRAM - UniParent');
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(48),
      build: (_) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('ACADÉMIE FRANCO-AMÉRICAINE DE MANAGEMENT', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: _blue)),
        pw.Text('AFRAM - Libreville, Gabon', style: const pw.TextStyle(fontSize: 9)),
        pw.Divider(color: _blue),
        pw.SizedBox(height: 24),
        pw.Text(title, style: const pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        if (reference != null) pw.Padding(padding: const pw.EdgeInsets.only(top: 4), child: pw.Text(reference, style: const pw.TextStyle(fontSize: 10))),
        pw.SizedBox(height: 20),
        for (final p in paragraphs) pw.Padding(padding: const pw.EdgeInsets.only(bottom: 10), child: pw.Text(p, style: const pw.TextStyle(fontSize: 11))),
        if (table.isNotEmpty)
          pw.TableHelper.fromTextArray(
            data: table,
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerCount: 0,
            columnWidths: {0: const pw.FlexColumnWidth(2), 1: const pw.FlexColumnWidth(3)},
          ),
        pw.Spacer(),
        pw.Text('Document généré en mode démonstration, sans valeur officielle.', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
      ]),
    ));
    return doc.save();
  }
}
