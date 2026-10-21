import 'package:flutter/material.dart';

import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/spring_pressable.dart';

/// Action du dock flottant ; [prestige] = accent or impérial (action phare).
class DockAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool prestige;
  final Key? key;
  const DockAction({required this.icon, required this.label, required this.onTap, this.prestige = false, this.key});
}

/// Dock en verre dépoli posé au-dessus du contenu (actions rapides de l'emploi du temps).
class GlassDock extends StatelessWidget {
  final List<DockAction> actions;
  const GlassDock({super.key, required this.actions});

  static const height = 68.0;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 420),
    child: GlassContainer(
      blur: 18,
      padding: const EdgeInsets.all(6),
      borderRadius: BorderRadius.circular(26),
      shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 30, offset: const Offset(0, 12))],
      child: SizedBox(
        height: height - 12,
        child: Row(
          children: [for (final a in actions) Expanded(child: _DockButton(action: a))],
        ),
      ),
    ),
  );
}

class _DockButton extends StatelessWidget {
  final DockAction action;
  const _DockButton({required this.action});

  @override
  Widget build(BuildContext context) {
    final color = action.prestige ? ObsidianColors.abyss : ObsidianColors.text;
    return SpringPressable(
      key: action.key,
      onTap: action.onTap,
      semanticLabel: action.label,
      child: AnimatedContainer(
        duration: AppMotion.medium,
        curve: AppMotion.emphasized,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(gradient: action.prestige ? ObsidianColors.goldGradient : null, borderRadius: BorderRadius.circular(20)),
        child: ExcludeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: AppMotion.fast,
                child: Icon(action.icon, key: ValueKey(action.icon), size: 21, color: color),
              ),
              const SizedBox(height: 3),
              Text(
                action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ObsidianText.label(size: 11, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
