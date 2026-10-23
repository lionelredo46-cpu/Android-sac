import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../theme/app_animations.dart';
import '../theme/strato.dart';
import 'spring_pressable.dart';

/// Bouton principal « or impérial » : dégradé, halo, reflet qui balaie la
/// surface et pression à ressort. [isOutlined] donne la variante en verre.
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late final AnimationController _sheen = AnimationController(vsync: this, duration: const Duration(milliseconds: 3600));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(AppButton old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final shine = !widget.isOutlined && widget.onPressed != null && !widget.isLoading && !AppMotion.reduced(context);
    if (shine && !_sheen.isAnimating) _sheen.repeat();
    if (!shine) _sheen.stop();
  }

  @override
  void dispose() {
    _sheen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final enabled = widget.onPressed != null && !widget.isLoading;
    final outlined = widget.isOutlined;
    final fg = widget.textColor ?? (outlined ? s.text : s.onGold);
    final r = BorderRadius.circular(18);

    final decoration = outlined
        ? BoxDecoration(color: s.glass, borderRadius: r, border: Border.all(color: widget.backgroundColor ?? s.hairlineStrong, width: 1.2))
        : BoxDecoration(
            borderRadius: r,
            color: widget.backgroundColor,
            gradient: widget.backgroundColor == null ? Strato.goldGradient : null,
            boxShadow: enabled
                ? [BoxShadow(color: (widget.backgroundColor ?? s.gold).withValues(alpha: s.isDark ? 0.42 : 0.32), blurRadius: 26, spreadRadius: -6, offset: const Offset(0, 12))]
                : null,
          );

    final label = widget.isLoading
        ? _Dots(color: fg)
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (widget.icon != null) ...[Icon(widget.icon, size: 20, color: fg), const SizedBox(width: 10)],
            Flexible(child: Text(widget.text, style: AppTextStyles.button.copyWith(color: fg), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]);

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.text,
      child: ExcludeSemantics(
        child: SpringPressable(
          onTap: enabled ? widget.onPressed : null,
          pressedScale: 0.965,
          child: AnimatedOpacity(
            duration: AppMotion.fast,
            opacity: widget.onPressed == null ? 0.45 : 1,
            child: Container(
              height: 56,
              decoration: decoration,
              child: ClipRRect(
                borderRadius: r,
                child: Stack(fit: StackFit.expand, children: [
                  if (!outlined)
                    AnimatedBuilder(
                      animation: _sheen,
                      builder: (_, __) {
                        // Le reflet traverse en 30 % du cycle puis se repose.
                        final p = (_sheen.value / 0.3).clamp(0.0, 1.0);
                        if (p <= 0 || p >= 1) return const SizedBox.shrink();
                        return FractionalTranslation(
                          translation: Offset(-1.2 + 2.4 * Curves.easeInOut.transform(p), 0),
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0x00FFFFFF), Color(0x66FFFFFF), Color(0x00FFFFFF)],
                                stops: [0.3, 0.5, 0.7],
                                transform: GradientRotation(0.5),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Center(child: label)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Trois points qui rebondissent (chargement dans un bouton).
class _Dots extends StatefulWidget {
  final Color color;
  const _Dots({required this.color});

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = ((_c.value - i * 0.16) % 1 + 1) % 1;
            final lift = t < 0.5 ? Curves.easeOut.transform(t * 2) : Curves.easeIn.transform(2 - t * 2);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.5),
              width: 8,
              height: 8,
              transform: Matrix4.translationValues(0, -6 * lift, 0),
              decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.55 + 0.45 * lift), shape: BoxShape.circle),
            );
          }),
        ),
      );
}
