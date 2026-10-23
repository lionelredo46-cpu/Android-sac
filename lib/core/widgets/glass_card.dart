import 'package:flutter/material.dart';

import '../theme/strato.dart';
import 'spring_pressable.dart';

/// Surface de verre « Stratosphère » : remplissage translucide, reflet sur le
/// bord supérieur gauche et liseré dégradé. Sans flou (peu coûteux en liste).
///
/// [gradient] remplace le verre par une surface héroïque (montant dû, moyenne) ;
/// [glow] ajoute un halo coloré sous la carte.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Gradient? gradient;
  final Color? tint;
  final Color? glow;
  final Color? borderColor;
  final String? semanticLabel;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.radius = 24,
    this.onTap,
    this.onLongPress,
    this.gradient,
    this.tint,
    this.glow,
    this.borderColor,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final r = BorderRadius.circular(radius);
    final hero = gradient != null;

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: [
          if (glow != null) BoxShadow(color: glow!.withValues(alpha: s.isDark ? 0.32 : 0.22), blurRadius: 36, spreadRadius: -6, offset: const Offset(0, 14)),
          if (!s.isDark && glow == null) BoxShadow(color: s.shadow, blurRadius: 24, spreadRadius: -8, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: CustomPaint(
          foregroundPainter: _SheenBorderPainter(
            radius: r,
            gradient: borderColor != null
                ? LinearGradient(colors: [borderColor!, borderColor!.withValues(alpha: borderColor!.a * 0.5)])
                : hero
                    ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: 0.45), Colors.white.withValues(alpha: 0.06)])
                    : s.glassBorder,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.alphaBlend(s.sheen.withValues(alpha: s.isDark ? 0.05 : 0.0), tint ?? s.glass),
                      tint ?? s.glass,
                    ],
                  ),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );

    if (hero) {
      // Reflet diagonal sur les surfaces héroïques.
      // passthrough : la carte garde la largeur imposée par son parent (pas de rétrécissement au contenu).
      card = Stack(fit: StackFit.passthrough, children: [
        card,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: r,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1, -1),
                    end: Alignment(0.4, 0.6),
                    colors: [Color(0x26FFFFFF), Color(0x00FFFFFF)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]);
    }

    if (onTap != null || onLongPress != null) {
      card = SpringPressable(onTap: onTap, onLongPress: onLongPress, pressedScale: 0.975, semanticLabel: semanticLabel, child: card);
    }
    return margin == null ? card : Padding(padding: margin!, child: card);
  }
}

class _SheenBorderPainter extends CustomPainter {
  final BorderRadius radius;
  final Gradient gradient;
  _SheenBorderPainter({required this.radius, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      radius.toRRect(rect).deflate(0.6),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_SheenBorderPainter old) => old.gradient != gradient || old.radius != radius;
}

/// Pastille d'icône lumineuse (teinte translucide + liseré), utilisée en tête de carte.
class GlowIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double radius;
  const GlowIcon(this.icon, {super.key, required this.color, this.size = 44, this.radius = 14});

  @override
  Widget build(BuildContext context) {
    final dark = context.strato.isDark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: dark ? 0.32 : 0.20), color.withValues(alpha: dark ? 0.10 : 0.06)],
        ),
        border: Border.all(color: color.withValues(alpha: dark ? 0.38 : 0.25)),
        boxShadow: dark ? [BoxShadow(color: color.withValues(alpha: 0.28), blurRadius: 18, spreadRadius: -4)] : null,
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

/// Texte peint d'un dégradé (titres héroïques).
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;
  final int? maxLines;
  const GradientText(this.text, {super.key, required this.style, required this.gradient, this.textAlign, this.maxLines});

  @override
  Widget build(BuildContext context) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (b) => gradient.createShader(Offset.zero & b.size),
        child: Text(text, style: style, textAlign: textAlign, maxLines: maxLines, overflow: maxLines == null ? null : TextOverflow.ellipsis),
      );
}

/// Titre de section : sur-titre espacé et action facultative.
class SectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  const SectionLabel(this.text, {super.key, this.trailing, this.padding = const EdgeInsets.fromLTRB(4, 20, 4, 10)});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Padding(
      padding: padding,
      child: Row(children: [
        Container(width: 14, height: 2, decoration: BoxDecoration(gradient: Strato.goldGradient, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: s.textMuted, fontWeight: FontWeight.w700, letterSpacing: 1.6, fontSize: 11),
          ),
        ),
        if (trailing != null) trailing!,
      ]),
    );
  }
}
