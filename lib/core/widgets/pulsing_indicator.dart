import 'package:flutter/material.dart';

import '../theme/app_animations.dart';
import '../theme/obsidian_theme.dart';

/// Point lumineux entouré d'ondes concentriques (cours en direct, scan NFC actif).
class PulsingIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final int rings;
  final Duration period;

  const PulsingIndicator({super.key, this.color = ObsidianColors.gold, this.size = 10, this.rings = 2, this.period = AppMotion.pulse});

  @override
  State<PulsingIndicator> createState() => _PulsingIndicatorState();
}

class _PulsingIndicatorState extends State<PulsingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.period);

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
    final extent = widget.size * 3;
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: extent,
        child: CustomPaint(painter: _RipplePainter(_c, widget.color, widget.size / 2, widget.rings)),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> t;
  final Color color;
  final double core;
  final int rings;
  _RipplePainter(this.t, this.color, this.core, this.rings) : super(repaint: t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;
    for (var i = 0; i < rings; i++) {
      final p = (t.value + i / rings) % 1;
      canvas.drawCircle(center, core + (maxRadius - core) * p, Paint()..color = color.withValues(alpha: (1 - p) * 0.45));
    }
    canvas.drawCircle(center, core, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.color != color || old.core != core || old.rings != rings;
}

/// Badge « EN DIRECT » doré (accent VIP réservé au cours en cours).
class LiveBadge extends StatelessWidget {
  final String label;
  const LiveBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(4, 2, 10, 2),
    decoration: BoxDecoration(
      color: ObsidianColors.gold.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: ObsidianColors.gold.withValues(alpha: 0.55)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PulsingIndicator(size: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ObsidianText.label(size: 10.5, color: ObsidianColors.goldLight),
          ),
        ),
      ],
    ),
  );
}

/// Reflet doux qui balaie l'enfant en continu (shimmer du créneau en direct).
class LiveShimmer extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final BorderRadius borderRadius;
  const LiveShimmer({super.key, required this.child, this.enabled = true, this.borderRadius = BorderRadius.zero});

  @override
  State<LiveShimmer> createState() => _LiveShimmerState();
}

class _LiveShimmerState extends State<LiveShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: AppMotion.shimmer);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(LiveShimmer old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() => widget.enabled && !AppMotion.reduced(context) ? _c.repeat() : _c.stop();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: RepaintBoundary(child: CustomPaint(painter: _ShimmerPainter(_c))),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final Animation<double> t;
  _ShimmerPainter(this.t) : super(repaint: t);

  @override
  void paint(Canvas canvas, Size size) {
    final x = -size.width + (size.width * 3) * AppMotion.emphasized.transform(t.value);
    final rect = Rect.fromLTWH(x, 0, size.width, size.height);
    final shader = LinearGradient(
      colors: [Colors.transparent, ObsidianColors.goldLight.withValues(alpha: 0.10), Colors.transparent],
      stops: const [0.2, 0.5, 0.8],
      transform: const GradientRotation(0.35),
    ).createShader(rect);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => false;
}
