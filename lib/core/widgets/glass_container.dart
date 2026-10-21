import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/obsidian_theme.dart';

/// Conteneur « verre dépoli » : flou d'arrière-plan et liseré lumineux dégradé.
///
/// Le flou (BackdropFilter) est coûteux : le réserver aux éléments flottants
/// (dock, pilule, feuilles). [blur] = 0 donne une surface pleine, idéale en liste.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blur;
  final Color? tint;
  final Gradient borderGradient;
  final double borderWidth;
  final List<BoxShadow>? shadows;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 16,
    this.tint,
    this.borderGradient = ObsidianColors.glassBorder,
    this.borderWidth = 1,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final fill = tint ?? ObsidianColors.surface.withValues(alpha: blur > 0 ? 0.72 : 0.96);
    Widget content = CustomPaint(
      foregroundPainter: _GradientBorderPainter(borderGradient, borderRadius, borderWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(color: fill, borderRadius: borderRadius),
        child: Padding(padding: padding, child: child),
      ),
    );
    if (blur > 0) {
      content = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: shadows),
      child: ClipRRect(borderRadius: borderRadius, child: content),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final BorderRadius radius;
  final double width;
  _GradientBorderPainter(this.gradient, this.radius, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(radius.toRRect(rect).deflate(width / 2), paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter old) => old.gradient != gradient || old.radius != radius || old.width != width;
}
