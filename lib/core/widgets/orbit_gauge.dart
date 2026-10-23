import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_animations.dart';
import '../theme/strato.dart';

/// Jauge orbitale : anneau qui se remplit en spirale jusqu'à [value] (0 → 1),
/// arc dégradé et point lumineux en tête, contenu libre au centre.
class OrbitGauge extends StatelessWidget {
  final double? value;
  final Color color;
  final double size;
  final double stroke;
  final Widget? center;
  final Duration duration;

  const OrbitGauge({
    super.key,
    required this.value,
    required this.color,
    this.size = 96,
    this.stroke = 8,
    this.center,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final target = (value ?? 0).clamp(0.0, 1.0);
    Widget ring(double v) => CustomPaint(
          size: Size.square(size),
          painter: _OrbitPainter(value: v, color: color, track: s.hairline, stroke: stroke, dark: s.isDark),
        );
    return SizedBox.square(
      dimension: size,
      child: Stack(alignment: Alignment.center, children: [
        RepaintBoundary(
          child: AppMotion.reduced(context)
              ? ring(target)
              : TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: target),
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => ring(v),
                ),
        ),
        if (center != null) Padding(padding: EdgeInsets.all(stroke + 6), child: FittedBox(fit: BoxFit.scaleDown, child: center)),
      ]),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color track;
  final double stroke;
  final bool dark;
  _OrbitPainter({required this.value, required this.color, required this.track, required this.stroke, required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = (size.shortestSide - stroke) / 2 - 2;
    final rect = Rect.fromCircle(center: c, radius: r);

    // Piste et graduations discrètes.
    canvas.drawCircle(c, r, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track);
    final tick = Paint()
      ..color = track
      ..strokeWidth = 1;
    for (var i = 0; i < 24; i++) {
      final a = i / 24 * 2 * math.pi;
      final inner = r - stroke / 2 - 5;
      canvas.drawLine(c + Offset(math.cos(a), math.sin(a)) * inner, c + Offset(math.cos(a), math.sin(a)) * (inner - (i % 6 == 0 ? 4 : 2)), tick);
    }
    if (value <= 0) return;

    final sweep = value * 2 * math.pi;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.max(sweep, 0.01),
        colors: [color.withValues(alpha: 0.25), color, Color.lerp(color, Colors.white, 0.35)!],
        stops: const [0, 0.7, 1],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect);
    if (dark) {
      canvas.drawArc(rect, -math.pi / 2, sweep, false, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke + 6
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    }
    canvas.drawArc(rect, -math.pi / 2, sweep, false, arc);

    // Tête lumineuse.
    final head = c + Offset(math.cos(sweep - math.pi / 2), math.sin(sweep - math.pi / 2)) * r;
    canvas.drawCircle(head, stroke * 0.9, Paint()
      ..color = color.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
    canvas.drawCircle(head, stroke * 0.38, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.value != value || old.color != color || old.track != track;
}
