import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_animations.dart';
import '../theme/strato.dart';

/// Ciel « Stratosphère » peint derrière toutes les pages : dégradé profond,
/// voiles d'aurore qui dérivent lentement, champ d'étoiles scintillant (nuit)
/// et lueur dorée de l'horizon. Un seul painter, isolé dans sa propre couche.
class StratoBackground extends StatefulWidget {
  final Widget child;
  const StratoBackground({super.key, required this.child});

  @override
  State<StratoBackground> createState() => _StratoBackgroundState();
}

class _StratoBackgroundState extends State<StratoBackground> with TickerProviderStateMixin {
  // Cycle long : le mouvement doit se sentir plus qu'il ne se voit.
  static const _cycle = Duration(seconds: 48);

  /// Le ciel n'est repeint qu'environ 15 fois par seconde : la dérive est si lente que
  /// l'œil ne voit aucune différence, et le GPU reste libre pour le défilement.
  static const _frame = Duration(milliseconds: 66);
  static const _start = 0.18;

  final _t = ValueNotifier<double>(_start);

  /// Au lancement, le ciel s'allume doucement depuis la couleur unie de l'écran de démarrage système.
  late final AnimationController _intro = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..forward();
  late final Animation<double> _light = CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic);
  late final Ticker _ticker = createTicker(_onTick);
  Duration _last = Duration.zero;

  void _onTick(Duration elapsed) {
    if (elapsed - _last < _frame) return;
    _last = elapsed;
    _t.value = (elapsed.inMicroseconds / _cycle.inMicroseconds + _start) % 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _intro.value = 1;
      if (_ticker.isActive) _ticker.stop();
    } else if (!_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _intro.dispose();
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(child: CustomPaint(painter: _SkyPainter(_t, _light, s), isComplex: true, willChange: true)),
        RepaintBoundary(child: widget.child),
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double r;
  final double phase;
  final double speed;
  final double base;
  const _Star(this.x, this.y, this.r, this.phase, this.speed, this.base);
}

final List<_Star> _stars = () {
  final rnd = math.Random(20261022);
  return List.generate(90, (_) {
    final big = rnd.nextDouble() < 0.12;
    return _Star(
      rnd.nextDouble(),
      math.pow(rnd.nextDouble(), 1.6).toDouble(), // plus denses vers le haut du ciel
      big ? 1.1 + rnd.nextDouble() * 0.7 : 0.45 + rnd.nextDouble() * 0.55,
      rnd.nextDouble(),
      1 + rnd.nextInt(3).toDouble(),
      0.25 + rnd.nextDouble() * 0.6,
    );
  });
}();

class _SkyPainter extends CustomPainter {
  final ValueListenable<double> t;
  final Animation<double> intro;
  final Strato s;
  _SkyPainter(this.t, this.intro, this.s) : super(repaint: Listenable.merge([t, intro]));

  // Trajectoires des voiles : centre (x, y), amplitude, fréquence, déphasage, rayon relatif.
  static const _veils = [
    (0.15, 0.12, 0.18, 1.0, 0.0, 0.95),
    (0.92, 0.30, 0.16, 1.0, 0.33, 0.85),
    (0.30, 0.62, 0.20, 2.0, 0.6, 0.80),
    (0.80, 0.95, 0.14, 1.0, 0.15, 0.75),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final light = intro.value;
    canvas.drawRect(rect, Paint()..color = s.base);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [for (final c in s.sky) c.withValues(alpha: light)]).createShader(rect),
    );

    final phase = t.value * 2 * math.pi;
    final span = size.longestSide;
    for (var i = 0; i < _veils.length; i++) {
      final (cx, cy, amp, freq, shift, radius) = _veils[i];
      final a = phase * freq + shift * 2 * math.pi;
      final center = Offset(
        size.width * (cx + amp * math.sin(a)),
        size.height * (cy + amp * 0.6 * math.cos(a * 0.8)),
      );
      final r = span * radius * (0.92 + 0.08 * math.sin(a * 1.3));
      final color = s.aurora[i % s.aurora.length];
      final strength = s.auroraStrength * (i == 3 ? 0.55 : 1) * light;
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(colors: [
            color.withValues(alpha: strength),
            color.withValues(alpha: strength * 0.35),
            color.withValues(alpha: 0),
          ], stops: const [0, 0.45, 1])
              .createShader(Rect.fromCircle(center: center, radius: r)),
      );
    }

    // Horizon : lueur dorée très basse, comme l'aube vue depuis la stratosphère.
    final h = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 1.08), width: size.width * 1.8, height: size.height * 0.55);
    canvas.drawOval(
      h,
      Paint()
        ..shader = RadialGradient(colors: [
          s.horizon.withValues(alpha: (s.isDark ? 0.16 : 0.22) * light),
          s.horizon.withValues(alpha: 0),
        ]).createShader(h),
    );

    if (s.stars) {
      final paint = Paint();
      for (final star in _stars) {
        final twinkle = 0.55 + 0.45 * math.sin(phase * star.speed * 6 + star.phase * 2 * math.pi);
        paint.color = Colors.white.withValues(alpha: (star.base * twinkle * (1 - star.y * 0.55) * light).clamp(0.0, 1.0));
        canvas.drawCircle(Offset(star.x * size.width, star.y * size.height * 0.85), star.r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.s != s || old.t != t || old.intro != intro;
}
