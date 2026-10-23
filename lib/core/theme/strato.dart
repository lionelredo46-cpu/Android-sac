import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Système de design « Stratosphère » : ciel profond, verre lumineux et or impérial AFRAM.
///
/// Jetons lus par les widgets via `context.strato` ; une variante sombre (nuit
/// stratosphérique, étoiles) et une claire (aube). Les couleurs sémantiques du
/// cahier des charges (vert, orange, rouge, bleu) restent celles d'[AppColors].
@immutable
class Strato extends ThemeExtension<Strato> {
  final Brightness brightness;

  /// Couleur pleine sous le ciel (barres système, repli).
  final Color base;

  /// Surface opaque des dialogues, feuilles et menus.
  final Color elevated;

  /// Dégradé vertical du ciel (haut → horizon).
  final List<Color> sky;

  /// Voiles d'aurore qui dérivent lentement derrière le contenu.
  final List<Color> aurora;
  final double auroraStrength;
  final bool stars;

  /// Lueur dorée de l'horizon (bas de l'écran).
  final Color horizon;

  final Color glass;
  final Color glassStrong;
  final Color hairline;
  final Color hairlineStrong;

  /// Reflet du bord supérieur des surfaces de verre.
  final Color sheen;

  final Color text;
  final Color textMuted;
  final Color textFaint;

  final Color accent;
  final Color accentDeep;
  final Color gold;
  final Color onGold;
  final Color shadow;

  const Strato({
    required this.brightness,
    required this.base,
    required this.elevated,
    required this.sky,
    required this.aurora,
    required this.auroraStrength,
    required this.stars,
    required this.horizon,
    required this.glass,
    required this.glassStrong,
    required this.hairline,
    required this.hairlineStrong,
    required this.sheen,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.accent,
    required this.accentDeep,
    required this.gold,
    required this.onGold,
    required this.shadow,
  });

  bool get isDark => brightness == Brightness.dark;

  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get danger => AppColors.error;
  Color get info => AppColors.info;

  static const night = Strato(
    brightness: Brightness.dark,
    base: Color(0xFF050916),
    elevated: Color(0xFF0D1733),
    sky: [Color(0xFF03050D), Color(0xFF060D24), Color(0xFF0A1740)],
    aurora: [Color(0xFF2F6BFF), Color(0xFF7B4DFF), Color(0xFF12B5DE), Color(0xFFE5A93C)],
    auroraStrength: 0.30,
    stars: true,
    horizon: Color(0xFFE5A93C),
    glass: Color(0x12FFFFFF),
    glassStrong: Color(0x1FFFFFFF),
    hairline: Color(0x1CFFFFFF),
    hairlineStrong: Color(0x3DFFFFFF),
    sheen: Color(0x40FFFFFF),
    text: Color(0xFFF2F5FF),
    textMuted: Color(0xFFA6B1CF),
    textFaint: Color(0xFF6E7A9C),
    accent: Color(0xFF7AA8FF),
    accentDeep: Color(0xFF3A6DF0),
    gold: Color(0xFFF2C063),
    onGold: Color(0xFF1C1405),
    shadow: Color(0x66000000),
  );

  static const dawn = Strato(
    brightness: Brightness.light,
    base: Color(0xFFF3F6FD),
    elevated: Color(0xFFFFFFFF),
    sky: [Color(0xFFF9FBFF), Color(0xFFEEF2FE), Color(0xFFE4EAFB)],
    aurora: [Color(0xFF8FB0FF), Color(0xFFC3AEFF), Color(0xFF8EE3F2), Color(0xFFF5CF8A)],
    auroraStrength: 0.38,
    stars: false,
    horizon: Color(0xFFF2C063),
    glass: Color(0xB8FFFFFF),
    glassStrong: Color(0xE8FFFFFF),
    hairline: Color(0x1A0A1F44),
    hairlineStrong: Color(0x330A1F44),
    sheen: Color(0xFFFFFFFF),
    text: Color(0xFF0B1533),
    textMuted: Color(0xFF55607D),
    textFaint: Color(0xFF8992AD),
    accent: Color(0xFF1E5BB0),
    accentDeep: Color(0xFF0A3871),
    gold: Color(0xFFC08316),
    onGold: Color(0xFF1C1405),
    shadow: Color(0x1F0A1F44),
  );

  /// Or impérial des actions principales.
  static const goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBE0A4), Color(0xFFEDB451), Color(0xFFD68F22)],
  );

  /// Saphir → indigo : surfaces héroïques, bulles envoyées.
  static const sapphireGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3E7BFF), Color(0xFF5B4BF0)],
  );

  /// Carte héroïque (montant dû, moyenne) : nuit bleue traversée d'une aurore.
  LinearGradient get heroGradient => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C3C9A), Color(0xFF2A1F78), Color(0xFF0D1844)],
          stops: [0, 0.55, 1],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A3871), Color(0xFF1E5BB0), Color(0xFF4B49C8)],
          stops: [0, 0.6, 1],
        );

  /// Liseré du verre : lumière en haut à gauche, presque rien en bas à droite.
  LinearGradient get glassBorder => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [sheen, hairline, hairline.withValues(alpha: hairline.a * 0.4)],
        stops: const [0, 0.45, 1],
      );

  /// Teinte d'une valeur sur une échelle (taux d'assiduité, moyenne) : vert, orange, rouge.
  Color scale(double? ratio, {double good = 0.9, double fair = 0.75}) {
    if (ratio == null) return info;
    if (ratio >= good) return success;
    if (ratio >= fair) return warning;
    return danger;
  }

  @override
  Strato copyWith({Color? accent, Color? gold}) => Strato(
        brightness: brightness,
        base: base,
        elevated: elevated,
        sky: sky,
        aurora: aurora,
        auroraStrength: auroraStrength,
        stars: stars,
        horizon: horizon,
        glass: glass,
        glassStrong: glassStrong,
        hairline: hairline,
        hairlineStrong: hairlineStrong,
        sheen: sheen,
        text: text,
        textMuted: textMuted,
        textFaint: textFaint,
        accent: accent ?? this.accent,
        accentDeep: accentDeep,
        gold: gold ?? this.gold,
        onGold: onGold,
        shadow: shadow,
      );

  @override
  Strato lerp(Strato? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    List<Color> l(List<Color> a, List<Color> b) => [for (var i = 0; i < a.length; i++) c(a[i], b[i])];
    return Strato(
      brightness: t < 0.5 ? brightness : other.brightness,
      base: c(base, other.base),
      elevated: c(elevated, other.elevated),
      sky: l(sky, other.sky),
      aurora: l(aurora, other.aurora),
      auroraStrength: auroraStrength + (other.auroraStrength - auroraStrength) * t,
      stars: t < 0.5 ? stars : other.stars,
      horizon: c(horizon, other.horizon),
      glass: c(glass, other.glass),
      glassStrong: c(glassStrong, other.glassStrong),
      hairline: c(hairline, other.hairline),
      hairlineStrong: c(hairlineStrong, other.hairlineStrong),
      sheen: c(sheen, other.sheen),
      text: c(text, other.text),
      textMuted: c(textMuted, other.textMuted),
      textFaint: c(textFaint, other.textFaint),
      accent: c(accent, other.accent),
      accentDeep: c(accentDeep, other.accentDeep),
      gold: c(gold, other.gold),
      onGold: c(onGold, other.onGold),
      shadow: c(shadow, other.shadow),
    );
  }
}

extension StratoContext on BuildContext {
  Strato get strato => Theme.of(this).extension<Strato>() ?? Strato.night;
}
