import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/ui.dart';
import '../../children/application/children_providers.dart';
import '../../dashboard/application/dashboard_providers.dart';
import '../data/finance_repository.dart';
import '../domain/finance_models.dart';
import 'finance_widgets.dart';

/// Attente de confirmation : la vérité vient du serveur (webhook signé),
/// l'application se contente d'interroger régulièrement le statut.
class PaymentStatusPage extends ConsumerStatefulWidget {
  final String paymentId;
  final String? initialUrl;
  const PaymentStatusPage({super.key, required this.paymentId, this.initialUrl});

  @override
  ConsumerState<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends ConsumerState<PaymentStatusPage> {
  static const _pollEvery = Duration(seconds: 4);
  static const _maxWait = Duration(minutes: 5);

  PaymentIntent? _intent;
  Timer? _timer;
  final _started = DateTime.now();
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) _openUrl(widget.initialUrl!);
    _poll();
    _timer = Timer.periodic(_pollEvery, (_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _done => _intent != null && (_intent!.statut == 'VALIDE' || _intent!.statut == 'ECHOUE');

  Future<void> _poll() async {
    if (_done) return;
    if (DateTime.now().difference(_started) > _maxWait) {
      _timer?.cancel();
      setState(() => _timedOut = true);
      return;
    }
    try {
      final s = await ref.read(financeRepositoryProvider).status(widget.paymentId);
      if (!mounted) return;
      setState(() => _intent = s);
      if (_done) _onFinished();
    } catch (_) {
      // Réseau instable : on réessaie au prochain cycle.
    }
  }

  void _onFinished() {
    _timer?.cancel();
    _intent?.statut == 'VALIDE' ? HapticFeedback.heavyImpact() : HapticFeedback.vibrate();
    final child = ref.read(activeChildProvider);
    if (child != null) {
      ref.invalidate(invoicesProvider(child.id));
      ref.invalidate(paymentsProvider(child.id));
      ref.invalidate(dashboardProvider(child.id));
      ref.invalidate(financeSummaryProvider(child.id));
    }
  }

  Future<void> _openUrl(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  Future<void> _simulate(bool success) async {
    try {
      final s = await ref.read(financeRepositoryProvider).sandboxConfirm(widget.paymentId, success);
      setState(() => _intent = s);
      _onFinished();
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final i = _intent;
    final status = i?.statut ?? 'EN_ATTENTE';
    final (title, body) = switch (status) {
      'VALIDE' => (l.paymentSuccess, i != null ? Fmt.money(i.montant, i.devise) : ''),
      'ECHOUE' => (l.paymentFailed, l.paymentFailedBody),
      _ => (l.paymentPending, l.paymentPendingBody),
    };

    return PopScope(
      canPop: _done || _timedOut,
      child: Scaffold(
        appBar: AppBar(title: Text(l.paymentTitle), automaticallyImplyLeading: _done || _timedOut),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                label: title,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (c, a) => ScaleTransition(scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack), child: FadeTransition(opacity: a, child: c)),
                    child: switch (status) {
                      'VALIDE' => const _SuccessBurst(key: ValueKey('ok')),
                      'ECHOUE' => _Shake(key: const ValueKey('ko'), child: OrbitEmblem(icon: Icons.close_rounded, color: s.danger, size: 170)),
                      _ => OrbitEmblem(key: const ValueKey('wait'), icon: Icons.hourglass_top_rounded, color: s.gold, size: 170),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(title, textAlign: TextAlign.center, style: AppTextStyles.h1.copyWith(color: s.text, fontSize: 26)),
              const SizedBox(height: 8),
              Text(body,
                  textAlign: TextAlign.center,
                  style: status == 'VALIDE' ? AppTextStyles.display.copyWith(color: s.success, fontSize: 30) : AppTextStyles.bodyLarge.copyWith(color: s.textMuted)),
              if (i != null) ...[
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: s.glass, borderRadius: BorderRadius.circular(12), border: Border.all(color: s.hairline)),
                    child: Text('Réf. ${i.reference}', style: AppTextStyles.caption.copyWith(color: s.textMuted, letterSpacing: 0.5)),
                  ),
                ),
              ],
              if (_timedOut && !_done) ...[
                const SizedBox(height: 16),
                Text('La confirmation prend plus de temps que prévu. Vous serez notifié dès réception ; aucun double débit n’est possible.',
                    textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted)),
              ],
              const SizedBox(height: 32),
              if (!_done && widget.initialUrl != null) ...[
                AppButton(text: l.openPaymentPage, icon: Icons.open_in_new_rounded, isOutlined: true, onPressed: () => _openUrl(widget.initialUrl!)),
                const SizedBox(height: 10),
              ],
              if (!_done && FlavorConfig.testTools) ...[
                AppButton(text: l.simulateSuccess, icon: Icons.science_rounded, onPressed: () => _simulate(true)),
                TextButton(onPressed: () => _simulate(false), child: Text(l.simulateFailure, style: TextStyle(color: s.danger))),
              ],
              if (status == 'VALIDE' && i?.receipt != null)
                AppButton(
                  icon: Icons.receipt_long_rounded,
                  text: l.viewReceipt,
                  onPressed: () => openReceipt(context, i!.receipt!, () => ref.read(financeRepositoryProvider).receiptPdf(i.receipt!.id)),
                ),
              if (_done || _timedOut) ...[
                const SizedBox(height: 8),
                TextButton(onPressed: () => context.go(RoutePaths.finances), child: Text(l.close)),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

/// Paiement confirmé : le cercle se trace, la coche se dessine, des éclats jaillissent.
class _SuccessBurst extends StatefulWidget {
  const _SuccessBurst({super.key});

  @override
  State<_SuccessBurst> createState() => _SuccessBurstState();
}

class _SuccessBurstState extends State<_SuccessBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppMotion.reduced(context) ? _c.value = 1 : _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(size: const Size.square(170), painter: _BurstPainter(_c.value, s.success, s.gold)),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  final double t;
  final Color color;
  final Color gold;
  _BurstPainter(this.t, this.color, this.gold);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width * 0.3;
    double seg(double a, double b) => ((t - a) / (b - a)).clamp(0.0, 1.0);

    // Éclats.
    final burst = Curves.easeOutCubic.transform(seg(0.35, 1));
    if (burst > 0 && burst < 1) {
      for (var i = 0; i < 14; i++) {
        final a = i / 14 * 2 * math.pi;
        final d = r + 10 + burst * size.width * 0.22;
        final p = c + Offset(math.cos(a), math.sin(a)) * d;
        canvas.drawCircle(p, (i.isEven ? 3.2 : 2.2) * (1 - burst), Paint()..color = (i.isEven ? gold : color).withValues(alpha: 1 - burst));
      }
    }

    // Halo et disque.
    final disc = Curves.easeOutBack.transform(seg(0, 0.4));
    canvas.drawCircle(c, r * 1.25 * disc, Paint()
      ..color = color.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18));
    canvas.drawCircle(c, r * disc, Paint()..shader = RadialGradient(colors: [Color.lerp(color, Colors.white, 0.3)!, color]).createShader(Rect.fromCircle(center: c, radius: r)));

    // Anneau tracé.
    final ring = seg(0.05, 0.5);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r + 9), -math.pi / 2, ring * 2 * math.pi, false, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = gold);

    // Coche.
    final check = Curves.easeOut.transform(seg(0.35, 0.75));
    if (check > 0) {
      final p1 = c + Offset(-r * 0.42, 0);
      final p2 = c + Offset(-r * 0.1, r * 0.32);
      final p3 = c + Offset(r * 0.45, -r * 0.3);
      final path = Path()..moveTo(p1.dx, p1.dy);
      if (check < 0.4) {
        final k = check / 0.4;
        path.lineTo(p1.dx + (p2.dx - p1.dx) * k, p1.dy + (p2.dy - p1.dy) * k);
      } else {
        final k = (check - 0.4) / 0.6;
        path
          ..lineTo(p2.dx, p2.dy)
          ..lineTo(p2.dx + (p3.dx - p2.dx) * k, p2.dy + (p3.dy - p2.dy) * k);
      }
      canvas.drawPath(path, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}

/// Secousse horizontale (refus).
class _Shake extends StatelessWidget {
  final Widget child;
  const _Shake({super.key, required this.child});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (_, t, c) => Transform.translate(offset: Offset(math.sin(t * math.pi * 6) * 10 * (1 - t), 0), child: c),
        child: child,
      );
}
