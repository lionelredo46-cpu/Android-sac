import 'package:flutter/widgets.dart';

/// Motion design : durées, courbes et ressorts partagés (module « Obsidian »).
class AppMotion {
  AppMotion._();

  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 320);
  static const slow = Duration(milliseconds: 520);
  static const pulse = Duration(milliseconds: 1800);
  static const shimmer = Duration(milliseconds: 2600);
  static const radarSweep = Duration(milliseconds: 2400);

  static const emphasized = Curves.easeInOutCubicEmphasized;
  static const decelerate = Curves.easeOutCubic;

  /// Ressort des pressions (cartes, boutons du dock) : réponse vive, sans rebond excessif.
  static const pressSpring = SpringDescription(mass: 1, stiffness: 520, damping: 28);

  /// Ressort des déplacements (retour à la semaine courante, aimantation).
  static const softSpring = SpringDescription(mass: 1, stiffness: 170, damping: 22);

  /// Animations réduites si l'utilisateur les a désactivées (accessibilité).
  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}
