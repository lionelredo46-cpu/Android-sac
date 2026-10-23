import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../theme/app_animations.dart';
import '../theme/strato.dart';

/// État vide : l'icône flotte au centre d'orbites où gravitent deux satellites.
class EmptyStateView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;
  final Color? color;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final c = color ?? s.accent;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          OrbitEmblem(icon: icon, color: c),
          const SizedBox(height: 28),
          Text(title, style: AppTextStyles.h2.copyWith(color: s.text, fontSize: 21), textAlign: TextAlign.center),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted), textAlign: TextAlign.center),
          ],
          if (action != null) ...[const SizedBox(height: 24), action!],
        ]),
      ),
    );
  }
}

/// Emblème orbital animé (états vides, erreurs, attente).
class OrbitEmblem extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  const OrbitEmblem({super.key, required this.icon, required this.color, this.size = 132});

  @override
  State<OrbitEmblem> createState() => _OrbitEmblemState();
}

class _OrbitEmblemState extends State<OrbitEmblem> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 9));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppMotion.reduced(context) ? _c.stop() : _c.repeat();
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
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final t = _c.value;
            final float = math.sin(t * 2 * math.pi * 2) * 4;
            return Stack(alignment: Alignment.center, children: [
              CustomPaint(size: Size.square(widget.size), painter: _OrbitsPainter(t, widget.color, s.hairlineStrong)),
              Transform.translate(
                offset: Offset(0, float),
                child: Container(
                  width: widget.size * 0.46,
                  height: widget.size * 0.46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [widget.color.withValues(alpha: 0.35), widget.color.withValues(alpha: 0.08)]),
                    border: Border.all(color: widget.color.withValues(alpha: 0.45)),
                    boxShadow: [BoxShadow(color: widget.color.withValues(alpha: 0.35), blurRadius: 30, spreadRadius: -4)],
                  ),
                  child: Icon(widget.icon, size: widget.size * 0.22, color: Color.lerp(widget.color, s.text, 0.15)),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

class _OrbitsPainter extends CustomPainter {
  final double t;
  final Color color;
  final Color line;
  _OrbitsPainter(this.t, this.color, this.line);

  static const _orbits = [(0.48, 0.20, -0.35, 1.0, 0.0), (0.40, 0.30, 0.55, -1.6, 0.4)];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final orbit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = line;
    for (final (rx, ry, tilt, speed, phase) in _orbits) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(tilt);
      final rect = Rect.fromCenter(center: Offset.zero, width: size.width * rx * 2, height: size.height * ry * 2);
      canvas.drawOval(rect, orbit);
      final a = (t * speed + phase) * 2 * math.pi;
      final p = Offset(math.cos(a) * rect.width / 2, math.sin(a) * rect.height / 2);
      canvas.drawCircle(p, 6, Paint()
        ..color = color.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
      canvas.drawCircle(p, 3, Paint()..color = Color.lerp(color, Colors.white, 0.4)!);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_OrbitsPainter old) => old.t != t || old.color != color;
}
