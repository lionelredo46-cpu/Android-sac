import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/ui.dart';
import '../../attendance/data/attendance_repository.dart';

/// Étudiant : scan du QR code de séance affiché par l'enseignant.
class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  final _controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || _busy) return;
    setState(() => _busy = true);
    try {
      final res = await ref.read(attendanceRepositoryProvider).scan(code);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 56),
          title: Text(context.l10n.scanSuccess),
          content: Text(res['statut'] == 'RETARD' ? context.l10n.lateMinutes((res['minutesRetard'] as num).toInt()) : context.l10n.present),
          actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.ok))],
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) context.showError(e);
      await Future<void>.delayed(const Duration(seconds: 2));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanQr)),
      body: Stack(children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        Center(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(border: Border.all(color: AppColors.aframGold, width: 4), borderRadius: BorderRadius.circular(24)),
          ),
        ),
        if (_busy) const Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}
