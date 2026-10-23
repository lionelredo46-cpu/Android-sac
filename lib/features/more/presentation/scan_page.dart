import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/widgets/ui.dart';
import '../../attendance/data/attendance_repository.dart';

/// Étudiant : scan du QR code de séance affiché par l'enseignant.
class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> with SingleTickerProviderStateMixin {
  final _controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  late final AnimationController _laser = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppMotion.reduced(context) ? _laser.stop() : _laser.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _laser.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || _busy) return;
    setState(() => _busy = true);
    HapticFeedback.mediumImpact();
    try {
      final res = await ref.read(attendanceRepositoryProvider).scan(code);
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: Icon(Icons.check_circle_rounded, color: ctx.strato.success, size: 64),
          title: Text(context.l10n.scanSuccess, textAlign: TextAlign.center),
          content: Text(res['statut'] == 'RETARD' ? context.l10n.lateMinutes((res['minutesRetard'] as num).toInt()) : context.l10n.present, textAlign: TextAlign.center),
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
    final s = context.strato;
    const box = 250.0;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(context.l10n.scanQr), foregroundColor: Colors.white),
      body: Stack(children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        // Voile sombre percé d'une fenêtre de visée.
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.6), BlendMode.srcOut),
          child: Stack(children: [
            Container(decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut)),
            Center(child: Container(width: box, height: box, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)))),
          ]),
        ),
        Center(
          child: SizedBox.square(
            dimension: box,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: s.gold, width: 3),
                  boxShadow: [BoxShadow(color: s.gold.withValues(alpha: 0.45), blurRadius: 30)],
                ),
              ),
              AnimatedBuilder(
                animation: _laser,
                builder: (_, __) => Positioned(
                  left: 18,
                  right: 18,
                  top: 18 + (box - 40) * Curves.easeInOut.transform(_laser.value),
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(colors: [s.gold.withValues(alpha: 0), s.gold, s.gold.withValues(alpha: 0)]),
                      boxShadow: [BoxShadow(color: s.gold, blurRadius: 14)],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 60,
          child: Text('Visez le QR code affiché par l’enseignant', textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        if (_busy) Center(child: CircularProgressIndicator(color: s.gold)),
      ]),
    );
  }
}
