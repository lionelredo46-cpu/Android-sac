import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/ui.dart';

/// Affiché pendant la restauration de la session (le routeur redirige ensuite).
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.aframPrimary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutBack,
          builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 110,
              height: 110,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset('Afram/assets/logo/logo-afram-officiel.png', fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 48, color: AppColors.aframPrimary)),
              ),
            ),
            const SizedBox(height: 24),
            Text('UniParent', style: AppTextStyles.h1.copyWith(color: Colors.white)),
            const SizedBox(height: 6),
            Text('AFRAM Business School', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.aframGoldLight)),
            const SizedBox(height: 40),
            const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.aframGold)),
            const SizedBox(height: 12),
            Text(context.l10n.tagline, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
          ]),
        ),
      ),
    );
  }
}
