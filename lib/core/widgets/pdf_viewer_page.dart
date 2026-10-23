import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../constants/app_text_styles.dart';
import '../errors/error_handler.dart';
import 'empty_state_view.dart';
import 'error_state_view.dart';
import 'ui.dart';

/// Visionneuse PDF (reçus, bulletins, attestations) : affichage, partage
/// (WhatsApp, email…) et impression. Le chargement passe par l'API authentifiée.
class PdfViewerPage extends StatefulWidget {
  final String title;
  final String filename;
  final Future<Uint8List> Function() loader;

  const PdfViewerPage({super.key, required this.title, required this.filename, required this.loader});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late Future<Uint8List> _future = widget.loader();

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.h3.copyWith(color: s.text, fontSize: 18))),
      body: FutureBuilder<Uint8List>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            return ErrorStateView(
              title: context.l10n.errorTitle,
              message: ErrorHandler.message(snap.error!),
              onRetry: () => setState(() => _future = widget.loader()),
            );
          }
          if (!snap.hasData) return Center(child: OrbitEmblem(icon: Icons.picture_as_pdf_rounded, color: s.gold));
          return PdfPreview(
            build: (_) async => snap.data!,
            pdfFileName: widget.filename,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            allowSharing: true,
            allowPrinting: true,
            scrollViewDecoration: const BoxDecoration(color: Colors.transparent),
            pdfPreviewPageDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [BoxShadow(color: s.shadow, blurRadius: 24, offset: const Offset(0, 10))],
            ),
            actionBarTheme: PdfActionBarTheme(backgroundColor: s.elevated, iconColor: s.gold),
            loadingWidget: Center(child: CircularProgressIndicator(color: s.gold)),
          );
        },
      ),
    );
  }
}
