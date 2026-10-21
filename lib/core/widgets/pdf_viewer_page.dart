import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../errors/error_handler.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return PdfPreview(
            build: (_) async => snap.data!,
            pdfFileName: widget.filename,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            allowSharing: true,
            allowPrinting: true,
          );
        },
      ),
    );
  }
}
