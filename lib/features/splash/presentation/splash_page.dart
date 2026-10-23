import 'package:flutter/material.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/presentation/auth_scaffold.dart';

/// Affiché pendant la restauration de la session (le routeur redirige ensuite).
///
/// Le logo est exactement au centre de l'écran, comme l'icône de l'écran de
/// démarrage Android : le passage du système à Flutter ne fait aucun saut.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const _logo = 192.0; // disque de ~115 dp, comme l'icône de démarrage Android 12+

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final center = MediaQuery.sizeOf(context).height / 2;
    return Scaffold(
      body: Stack(children: [
        const Center(child: OrbitLogo(size: _logo)),
        Positioned(
          top: center + _logo / 2 + 26,
          left: 24,
          right: 24,
          child: Column(children: [
            Reveal(
              delay: const Duration(milliseconds: 120),
              child: GradientText(
                'UniParent',
                style: AppTextStyles.display.copyWith(fontSize: 46, letterSpacing: -1.6),
                gradient: LinearGradient(colors: [s.text, s.gold, s.text], stops: const [0, 0.55, 1]),
              ),
            ),
            const SizedBox(height: 8),
            Reveal(
              delay: const Duration(milliseconds: 260),
              child: Text('AFRAM BUSINESS SCHOOL', style: AppTextStyles.overline.copyWith(color: s.gold, letterSpacing: 4)),
            ),
            const SizedBox(height: 40),
            Reveal(
              delay: const Duration(milliseconds: 400),
              child: SizedBox(
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(minHeight: 3, color: s.gold, backgroundColor: s.hairline),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Reveal(
              delay: const Duration(milliseconds: 480),
              child: Text(context.l10n.tagline, textAlign: TextAlign.center, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
            ),
          ]),
        ),
      ]),
    );
  }
}
