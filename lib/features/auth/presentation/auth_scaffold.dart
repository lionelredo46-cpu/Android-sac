import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/widgets/ui.dart';

/// Mise en page commune aux écrans d'authentification : logo en orbite,
/// titre lumineux et formulaire posé sur un panneau de verre.
class AuthScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final List<Widget> footer;
  final bool showBack;

  const AuthScaffold({super.key, required this.title, this.subtitle, required this.children, this.footer = const [], this.showBack = false});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: showBack ? AppBar(toolbarHeight: 52) : null,
      // Défilement sur toute la hauteur (sous la barre d'état) : le halo du logo n'est jamais coupé net.
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 12, 20, 24 + MediaQuery.paddingOf(context).bottom),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Reveal(
                        offset: 0,
                        child: Center(child: OrbitLogo(size: showBack ? 96 : 128)),
                      ),
                      const SizedBox(height: 22),
                      Reveal(
                        index: 1,
                        child: GradientText(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1.copyWith(fontSize: showBack ? 27 : 32),
                          gradient: LinearGradient(colors: [s.text, Color.lerp(s.text, s.gold, 0.7)!]),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 8),
                        Reveal(
                          index: 2,
                          child: Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted),
                          ),
                        ),
                      ],
                      const SizedBox(height: 26),
                      Reveal(
                        index: 3,
                        child: GlassCard(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                          radius: 30,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
                        ),
                      ),
                      for (var i = 0; i < footer.length; i++) Reveal(index: 4 + i, child: footer[i]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Voile sous la barre d'état : le contenu qui défile s'y fond au lieu de passer sous les icônes.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.paddingOf(context).top + 18,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [s.base.withValues(alpha: 0.94), s.base.withValues(alpha: 0)]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo AFRAM au centre d'un anneau doré, avec deux satellites en orbite.
class OrbitLogo extends StatefulWidget {
  final double size;
  const OrbitLogo({super.key, this.size = 128});

  @override
  State<OrbitLogo> createState() => _OrbitLogoState();
}

class _OrbitLogoState extends State<OrbitLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 12));

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
    final inner = widget.size * 0.6;
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _c,
              builder: (_, __) => CustomPaint(size: Size.square(widget.size), painter: _LogoOrbitPainter(_c.value, s.gold, s.accent, s.hairlineStrong)),
            ),
            Container(
              width: inner,
              height: inner,
              padding: EdgeInsets.all(inner * 0.16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: s.gold.withValues(alpha: s.isDark ? 0.45 : 0.30), blurRadius: 40, spreadRadius: 2),
                  BoxShadow(color: s.accent.withValues(alpha: 0.25), blurRadius: 70, spreadRadius: 10),
                ],
              ),
              // Le logo rectangulaire tient entier dans le disque (pas de rognage).
              child: Image.asset(
                'assets/brand/logo-afram.png',
                fit: BoxFit.contain,
                cacheWidth: (inner * 3).round(),
                errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 40, color: AppColors.aframPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoOrbitPainter extends CustomPainter {
  final double t;
  final Color gold;
  final Color accent;
  final Color line;
  _LogoOrbitPainter(this.t, this.gold, this.accent, this.line);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 4;
    final rect = Rect.fromCircle(center: c, radius: r);

    // Anneau doré en rotation (arc dégradé) et orbite fine.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = line,
    );
    canvas.drawArc(
      rect,
      t * 2 * math.pi,
      math.pi * 1.2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: [gold.withValues(alpha: 0), gold, Colors.white],
          stops: const [0, 0.85, 1],
          transform: GradientRotation(t * 2 * math.pi),
          endAngle: math.pi * 1.2,
        ).createShader(rect),
    );

    void satellite(double angle, double radius, Color color, double dot) {
      final p = c + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawCircle(
        p,
        dot * 2.4,
        Paint()
          ..color = color.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(p, dot, Paint()..color = Color.lerp(color, Colors.white, 0.5)!);
    }

    satellite(t * 2 * math.pi + math.pi * 1.2, r, gold, 3.2);
    satellite(-t * 4 * math.pi, r * 0.82, accent, 2.4);
  }

  @override
  bool shouldRepaint(_LogoOrbitPainter old) => old.t != t || old.gold != gold;
}

final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,128}$');

/// Normalise un numéro saisi (espaces, tirets) au format international.
String normalizePhone(String raw) {
  var p = raw.replaceAll(RegExp(r'[\s\-.]'), '');
  if (p.startsWith('00')) p = '+${p.substring(2)}';
  if (!p.startsWith('+') && p.length <= 9) p = '+241${p.startsWith('0') ? p : '0$p'}';
  return p;
}
