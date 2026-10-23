import 'package:flutter/material.dart';

import '../theme/app_animations.dart';

/// Entrée en scène : fondu, montée et léger zoom, décalés selon [index]
/// (cascade des cartes d'une liste).
///
/// Un élément construit alors que la liste a déjà défilé apparaît sans
/// animation : rien ne « rejoue » quand on remonte une longue liste.
class Reveal extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final Duration stagger;
  final Duration delay;
  final double offset;

  const Reveal({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 620),
    this.stagger = const Duration(milliseconds: 70),
    this.delay = Duration.zero,
    this.offset = 28,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;
  bool _started = false;

  Duration get _wait => widget.delay + widget.stagger * widget.index.clamp(0, 10);

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: _wait + widget.duration);
    final total = _c.duration!.inMicroseconds;
    final start = total == 0 ? 0.0 : _wait.inMicroseconds / total;
    _t = CurvedAnimation(parent: _c, curve: Interval(start, 1, curve: Curves.easeOutQuart));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final position = Scrollable.maybeOf(context)?.position;
    final scrolled = position != null && position.hasPixels && position.pixels > 8;
    if (AppMotion.reduced(context) || scrolled || widget.index > 14) {
      _c.value = 1;
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (_, child) {
        final v = _t.value;
        if (v >= 1) return child!;
        return Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, widget.offset * (1 - v)),
            child: Transform.scale(scale: 0.97 + 0.03 * v, child: child),
          ),
        );
      },
    );
  }
}

/// Nombre animé : compte de la valeur précédente (0 au départ) vers [value].
class CountUp extends StatelessWidget {
  final double value;
  final String Function(double v) format;
  final TextStyle? style;
  final Duration duration;
  final TextAlign? textAlign;

  const CountUp({super.key, required this.value, required this.format, this.style, this.duration = const Duration(milliseconds: 1300), this.textAlign});

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return Text(format(value), style: style, textAlign: textAlign);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutExpo,
      builder: (_, v, __) => Text(format(v), style: style, textAlign: textAlign, maxLines: 1),
    );
  }
}
