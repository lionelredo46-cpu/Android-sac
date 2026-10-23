import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'strato.dart';

/// Nuancier « Obsidian Sapphire & Imperial Gold » (emploi du temps immersif).
class ObsidianColors {
  ObsidianColors._();

  static const abyss = Color(0xFF070B14);
  static const abyssBlue = Color(0xFF0B132B);
  static const surface = Color(0xFF0F172A);
  static const surfaceHigh = Color(0xFF162036);
  static const sapphire = Color(0xFF2563EB);
  static const sapphireLight = Color(0xFF3B82F6);
  static const sapphireDeep = Color(0xFF1D4ED8);
  static const gold = AppColors.aframGold;
  static const goldLight = AppColors.aframGoldLight;
  static const emerald = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  static const ruby = Color(0xFFEF4444);
  static const text = Color(0xFFF1F5F9);
  static const textMuted = Color(0xFF94A3B8);
  static const textFaint = Color(0xFF64748B);
  static const hairline = Color(0x1F94A3B8);

  static const background = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [abyss, abyssBlue]);
  static const glassBorder = LinearGradient(colors: [Color(0x4D2563EB), Color(0x1A1D4ED8), Color(0x4D3B82F6)]);
  static const goldGradient = LinearGradient(colors: [gold, goldLight]);
  static const sapphireGradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [sapphireLight, sapphireDeep]);

  /// Teintes des matières : stables d'un lancement à l'autre (écran, PDF, image).
  static const coursePalette = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFF6366F1),
    Color(0xFFF6D38B),
    Color(0xFF22D3EE),
  ];

  /// En thème sombre, le ciel « Stratosphère » commun reste visible derrière le module ;
  /// en thème clair, le module garde son fond obsidienne opaque.
  static bool sharesSky(BuildContext context) => Theme.of(context).extension<Strato>()?.isDark ?? true;
  static Color scaffold(BuildContext context) => sharesSky(context) ? Colors.transparent : abyss;
  static BoxDecoration backdrop(BuildContext context) => BoxDecoration(gradient: sharesSky(context) ? null : background);

  static Color forCourse(String code) => coursePalette[code.codeUnits.fold<int>(7, (h, c) => (h * 31 + c) & 0x7fffffff) % coursePalette.length];

  /// Couleur sémantique d'un créneau : annulé (rubis), reporté (ambre), sinon la matière.
  static Color forStatus(String statut, String code) => switch (statut) {
    'ANNULE' => ruby,
    'REPORTE' => amber,
    _ => forCourse(code),
  };
}

/// Typographie du module : Outfit (titres, horaires géométriques) et Inter (métadonnées).
class ObsidianText {
  ObsidianText._();

  static TextStyle display({double size = 28, Color color = ObsidianColors.text}) =>
      TextStyle(fontFamily: 'Outfit', fontSize: size, fontWeight: FontWeight.w700, color: color, height: 1.15, letterSpacing: -0.4);
  static TextStyle title({double size = 17, Color color = ObsidianColors.text}) => TextStyle(fontFamily: 'Outfit', fontSize: size, fontWeight: FontWeight.w600, color: color, height: 1.2);
  static TextStyle time({double size = 13, Color color = ObsidianColors.text}) =>
      TextStyle(fontFamily: 'Outfit', fontSize: size, fontWeight: FontWeight.w600, color: color, fontFeatures: const [FontFeature.tabularFigures()]);
  static TextStyle body({double size = 14, Color color = ObsidianColors.textMuted}) => TextStyle(fontFamily: 'Inter', fontSize: size, fontWeight: FontWeight.w400, color: color, height: 1.35);
  static TextStyle label({double size = 12, Color color = ObsidianColors.textMuted}) =>
      TextStyle(fontFamily: 'Inter', fontSize: size, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.2);
}

/// Thème Material 3 sombre appliqué localement au module (le reste de l'application garde son thème).
class ObsidianTheme {
  ObsidianTheme._();

  static ThemeData of(ThemeData base) {
    const scheme = ColorScheme.dark(
      primary: ObsidianColors.sapphire,
      onPrimary: Colors.white,
      secondary: ObsidianColors.gold,
      onSecondary: ObsidianColors.abyss,
      surface: ObsidianColors.surface,
      onSurface: ObsidianColors.text,
      surfaceContainerHighest: ObsidianColors.surfaceHigh,
      error: ObsidianColors.ruby,
      outline: ObsidianColors.hairline,
    );
    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: ObsidianColors.abyss,
      canvasColor: ObsidianColors.surface,
      textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(fontFamily: 'Inter').apply(bodyColor: ObsidianColors.text, displayColor: ObsidianColors.text),
      iconTheme: const IconThemeData(color: ObsidianColors.text),
      appBarTheme: base.appBarTheme.copyWith(backgroundColor: Colors.transparent, foregroundColor: ObsidianColors.text, elevation: 0, scrolledUnderElevation: 0),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent, modalBackgroundColor: Colors.transparent, elevation: 0),
      dividerTheme: const DividerThemeData(color: ObsidianColors.hairline, thickness: 1),
      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: ObsidianColors.surfaceHigh,
        contentTextStyle: ObsidianText.body(color: ObsidianColors.text),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ObsidianColors.sapphire,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: ObsidianText.title(size: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ObsidianColors.text,
          minimumSize: const Size(48, 52),
          side: const BorderSide(color: ObsidianColors.hairline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: ObsidianText.title(size: 15),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: ObsidianColors.surface,
          foregroundColor: ObsidianColors.textMuted,
          selectedBackgroundColor: ObsidianColors.sapphire,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: ObsidianColors.hairline),
          textStyle: ObsidianText.label(size: 13),
        ),
      ),
    );
  }
}
