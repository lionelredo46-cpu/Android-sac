import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Outfit (géométrique) pour les titres et les chiffres, Inter pour le texte courant.
/// Polices embarquées (pubspec.yaml) : aucun téléchargement ni changement de police au démarrage.
class AppTextStyles {
  AppTextStyles._();

  static const outfit = 'Outfit';
  static const inter = 'Inter';

  /// Grands chiffres (montants, moyennes, taux).
  static const display = TextStyle(
    fontFamily: outfit,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.4,
    height: 1.05,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const h1 = TextStyle(fontFamily: outfit, fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.1);

  static const h2 = TextStyle(fontFamily: outfit, fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: -0.4, height: 1.15);

  static const h3 = TextStyle(fontFamily: outfit, fontSize: 17.5, fontWeight: FontWeight.w600, letterSpacing: -0.1, height: 1.2);

  static const bodyLarge = TextStyle(fontFamily: inter, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);

  static const bodyMedium = TextStyle(fontFamily: inter, fontSize: 14, fontWeight: FontWeight.w400, height: 1.42);

  static const bodySmall = TextStyle(fontFamily: inter, fontSize: 12.5, fontWeight: FontWeight.w400, height: 1.38);

  static const caption = TextStyle(fontFamily: inter, fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.textMutedLight);

  /// Sur-titre en capitales espacées (sections, libellés de chiffres).
  static const overline = TextStyle(fontFamily: inter, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 1.6, height: 1.2);

  static const button = TextStyle(fontFamily: outfit, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.2);
}
