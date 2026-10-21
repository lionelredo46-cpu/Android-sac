import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Couleurs de marque AFRAM
  static const Color aframPrimary = Color(0xFF0A3871);
  static const Color aframDark = Color(0xFF051D3B);
  static const Color aframLight = Color(0xFF1E5BB0);
  static const Color aframGold = Color(0xFFE5A93C);
  static const Color aframGoldLight = Color(0xFFF6D38B);

  // Couleurs sémantiques imposées par le cahier des charges
  static const Color success = Color(0xFF10B981); // Vert = Payé / Présent
  static const Color warning = Color(0xFFF59E0B); // Orange = En attente / Retard
  static const Color error = Color(0xFFEF4444);   // Rouge = Impayé / Absent
  static const Color info = Color(0xFF3B82F6);    // Bleu = Information

  // Neutres - Mode Clair
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);

  // Neutres - Mode Sombre
  static const Color backgroundDark = Color(0xFF0B132B);
  static const Color surfaceDark = Color(0xFF1C2541);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF1E293B);

  // Éléments spéciaux
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);
  static const Color offlineBanner = Color(0xFFD97706);
}
