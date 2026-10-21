import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Mise en page commune aux écrans d'authentification.
class AuthScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool showBack;

  const AuthScaffold({super.key, required this.title, this.subtitle, required this.children, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBack ? AppBar(backgroundColor: Colors.transparent, foregroundColor: AppColors.aframPrimary, elevation: 0) : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Center(
                  child: Container(
                    width: 84,
                    height: 84,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: ClipOval(
                      child: Image.asset('Afram/assets/logo/logo-afram-officiel.png', fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 40, color: AppColors.aframPrimary)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2.copyWith(color: Theme.of(context).colorScheme.primary)),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(subtitle!, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight)),
                ],
                const SizedBox(height: 28),
                ...children,
              ]),
            ),
          ),
        ),
      ),
    );
  }
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
