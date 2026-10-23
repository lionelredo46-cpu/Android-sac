import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(sharedPrefsProvider).setCompletedOnboarding(true);
    if (mounted) context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final pages = [
      (Icons.visibility_rounded, l.onboardingTitle1, l.onboardingBody1, [AppColors.aframGold, const Color(0xFF5B8CFF)], [Icons.payments_rounded, Icons.grade_rounded, Icons.event_rounded]),
      (Icons.verified_user_rounded, l.onboardingTitle2, l.onboardingBody2, [const Color(0xFF34D399), const Color(0xFF5B8CFF)], [Icons.lock_rounded, Icons.fingerprint_rounded, Icons.shield_moon_rounded]),
      (Icons.notifications_active_rounded, l.onboardingTitle3, l.onboardingBody3, [const Color(0xFF8B7BFF), AppColors.aframGold], [Icons.chat_rounded, Icons.campaign_rounded, Icons.sms_rounded]),
    ];
    final last = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
            child: Row(children: [
              Text('UniParent', style: AppTextStyles.h3.copyWith(color: s.text)),
              const Spacer(),
              AnimatedOpacity(
                opacity: last ? 0 : 1,
                duration: AppMotion.medium,
                child: TextButton(onPressed: last ? null : _finish, child: Text(l.start, style: TextStyle(color: s.textMuted))),
              ),
            ]),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) {
                HapticFeedback.selectionClick();
                setState(() => _index = i);
              },
              itemBuilder: (_, i) {
                final p = pages[i];
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final page = _controller.hasClients && _controller.position.haveDimensions ? _controller.page ?? 0 : 0.0;
                    final delta = (i - page).clamp(-1.0, 1.0);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        // Parallaxe : l'illustration glisse plus vite que le texte.
                        Transform.translate(
                          offset: Offset(delta * 120, 0),
                          child: Transform.scale(
                            scale: 1 - delta.abs() * 0.25,
                            child: Opacity(opacity: (1 - delta.abs()).clamp(0.0, 1.0), child: _Planet(icon: p.$1, colors: p.$4, satellites: p.$5)),
                          ),
                        ),
                        const SizedBox(height: 44),
                        Transform.translate(
                          offset: Offset(delta * 40, 0),
                          child: Opacity(
                            opacity: (1 - delta.abs() * 1.4).clamp(0.0, 1.0),
                            child: Column(children: [
                              Text(p.$2, textAlign: TextAlign.center, style: AppTextStyles.h1.copyWith(color: s.text, fontSize: 28)),
                              const SizedBox(height: 14),
                              Text(p.$3, textAlign: TextAlign.center, style: AppTextStyles.bodyLarge.copyWith(color: s.textMuted)),
                            ]),
                          ),
                        ),
                      ]),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutBack,
                margin: const EdgeInsets.all(4),
                width: i == _index ? 30 : 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: i == _index ? Strato.goldGradient : null,
                  color: i == _index ? null : s.hairlineStrong,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
            child: AppButton(
              text: last ? l.start : l.next,
              icon: last ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
              onPressed: last ? _finish : () => _controller.nextPage(duration: const Duration(milliseconds: 520), curve: AppMotion.emphasized),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Planète lumineuse et ses satellites (illustration d'introduction).
class _Planet extends StatefulWidget {
  final IconData icon;
  final List<Color> colors;
  final List<IconData> satellites;
  const _Planet({required this.icon, required this.colors, required this.satellites});

  @override
  State<_Planet> createState() => _PlanetState();
}

class _PlanetState extends State<_Planet> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 14));

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
    const size = 260.0;
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final t = _c.value * 2 * math.pi;
            final satellites = [for (var i = 0; i < widget.satellites.length; i++) _satellite(s, t, i)];
            return Stack(alignment: Alignment.center, children: [
              CustomPaint(size: const Size.square(size), painter: _RingsPainter(s.hairlineStrong, widget.colors.first)),
              // Satellites derrière la planète, puis la planète, puis ceux de devant.
              for (final (front, w) in satellites)
                if (!front) w,
              Transform.translate(
                offset: Offset(0, math.sin(t * 2) * 5),
                child: Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.35, -0.45),
                      radius: 0.95,
                      colors: [Color.lerp(widget.colors.first, Colors.white, 0.55)!, widget.colors.first, Color.lerp(widget.colors.first, const Color(0xFF0A0F2C), 0.55)!],
                      stops: const [0, 0.42, 1],
                    ),
                    boxShadow: [
                      BoxShadow(color: widget.colors.first.withValues(alpha: 0.55), blurRadius: 50, spreadRadius: 2),
                      BoxShadow(color: widget.colors.last.withValues(alpha: 0.35), blurRadius: 90, spreadRadius: 16),
                    ],
                  ),
                  child: Icon(widget.icon, size: 52, color: Colors.white),
                ),
              ),
              for (final (front, w) in satellites)
                if (front) w,
            ]);
          },
        ),
      ),
    );
  }
}

extension on _PlanetState {
  /// Satellite n° [i] sur son orbite elliptique : (devant la planète ?, widget).
  (bool, Widget) _satellite(Strato s, double t, int i) {
    final a = t * (i.isEven ? 1 : -1.3) + i * 2.1;
    final rx = 112.0 - i * 10;
    final ry = 54.0 + i * 16;
    final depth = math.sin(a); // > 0 : devant
    final color = widget.colors[i % 2];
    return (
      depth > 0,
      Transform.translate(
        offset: Offset(math.cos(a) * rx, depth * ry),
        child: Transform.scale(
          scale: 0.82 + 0.18 * (depth + 1) / 2,
          child: Opacity(
            opacity: 0.55 + 0.45 * (depth + 1) / 2,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: s.isDark ? const Color(0xFF1A3B7D) : Colors.white,
                border: Border.all(color: color.withValues(alpha: 0.6)),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 16)],
              ),
              child: Icon(widget.satellites[i], size: 19, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final Color line;
  final Color glow;
  _RingsPainter(this.line, this.glow);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = line;
    for (var i = 0; i < 3; i++) {
      canvas.drawOval(Rect.fromCenter(center: c, width: (112.0 - i * 10) * 2, height: (54.0 + i * 16) * 2), p);
    }
    canvas.drawCircle(c, size.width * 0.48, Paint()
      ..shader = RadialGradient(colors: [glow.withValues(alpha: 0.12), glow.withValues(alpha: 0)]).createShader(Rect.fromCircle(center: c, radius: size.width * 0.48)));
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.line != line || old.glow != glow;
}
