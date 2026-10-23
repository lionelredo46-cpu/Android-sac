import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../errors/error_handler.dart';
import '../l10n/generated/app_localizations.dart';
import '../storage/cache_store.dart';
import '../theme/app_animations.dart';
import '../theme/strato.dart';
import '../utils/formatters.dart';
import 'empty_state_view.dart';
import 'error_state_view.dart';
import 'glass_card.dart';
import 'loading_skeleton.dart';

export '../theme/strato.dart';
export 'glass_card.dart';
export 'orbit_gauge.dart';
export 'reveal.dart';
export 'strato_tabs.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void showSnack(String message, {bool error = false}) {
    final s = strato;
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(children: [
          Icon(error ? Icons.error_rounded : Icons.check_circle_rounded, color: error ? const Color(0xFFFFA4A4) : s.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ]),
        backgroundColor: error ? const Color(0xFF5B1A24) : null,
        behavior: SnackBarBehavior.floating,
      ));
  }

  void showError(Object e) => showSnack(ErrorHandler.message(e), error: true);

  /// Marge basse d'une liste : barre système (affichage bord à bord) et dock flottant compris.
  double get bottomInset => MediaQuery.paddingOf(this).bottom;

  /// Hauteur du dock flottant seule (sans la barre système) : à ajouter sous un bouton flottant d'onglet.
  double get dockInset => (MediaQuery.paddingOf(this).bottom - MediaQuery.viewPaddingOf(this).bottom).clamp(0.0, double.infinity);
}

/// Couleurs sémantiques (cahier des charges §11) :
/// vert = payé/présent, orange = en attente/retard, rouge = impayé/absent, bleu = information.
class StatusStyle {
  final Color color;
  final IconData icon;
  const StatusStyle(this.color, this.icon);

  static StatusStyle of(String status) => switch (status) {
        'PAYE' || 'PRESENT' || 'VALIDE' || 'A_JOUR' || 'PRETE' || 'LIVREE' || 'RESOLU' || 'CLOTURE' || 'CONFIRME' || 'ACCEPTEE' || 'SUCCESS' =>
          const StatusStyle(AppColors.success, Icons.check_circle_rounded),
        'PARTIELLEMENT_PAYE' || 'RETARD' || 'EN_ATTENTE' || 'A_PAYER' || 'EN_COURS' || 'EN_TRAITEMENT' || 'SOUMISE' || 'DEMANDE' || 'OUVERT' || 'INITIALISE' || 'REPORTE' =>
          const StatusStyle(AppColors.warning, Icons.schedule_rounded),
        'EN_RETARD' || 'ABSENT' || 'ECHOUE' || 'REJETE' || 'REJETEE' || 'REFUSEE' || 'ANNULE' =>
          const StatusStyle(AppColors.error, Icons.error_rounded),
        _ => const StatusStyle(AppColors.info, Icons.info_rounded),
      };
}

/// Pastille de statut : point lumineux, teinte translucide et liseré.
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  const StatusChip({super.key, required this.label, required this.color, this.icon});

  factory StatusChip.status(String status, String label) {
    final s = StatusStyle.of(status);
    return StatusChip(label: label, color: s.color, icon: s.icon);
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.strato.isDark;
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: dark ? 0.14 : 0.10),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: color.withValues(alpha: dark ? 0.40 : 0.30)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 6)]),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: dark ? Color.lerp(color, Colors.white, 0.25) : Color.lerp(color, Colors.black, 0.2), fontWeight: FontWeight.w700, letterSpacing: 0.2),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Carte de section : pastille d'icône lumineuse, titre et contenu, en verre.
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget? trailing;
  final Widget child;
  final VoidCallback? onTap;
  const SectionCard({super.key, required this.title, required this.icon, required this.child, this.iconColor, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final color = iconColor ?? s.accent;
    return GlassCard(
      onTap: onTap,
      semanticLabel: onTap == null ? null : title,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GlowIcon(icon, color: color, size: 38, radius: 12),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTextStyles.h3.copyWith(color: s.text))),
          if (trailing != null) trailing!,
          if (onTap != null && trailing == null) Icon(Icons.arrow_forward_ios_rounded, size: 14, color: s.textFaint),
        ]),
        const SizedBox(height: 16),
        child,
      ]),
    );
  }
}

class KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  const KeyValueRow(this.label, this.value, {super.key, this.valueColor, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted))),
        const SizedBox(width: 12),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.end,
              style: (bold ? AppTextStyles.h3.copyWith(fontSize: 16) : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)).copyWith(color: valueColor ?? s.text)),
        ),
      ]),
    );
  }
}

/// Bandeau « données hors ligne » quand une ressource vient du cache.
class StaleBanner extends StatelessWidget {
  final DateTime updatedAt;
  const StaleBanner(this.updatedAt, {super.key});

  @override
  Widget build(BuildContext context) {
    const c = AppColors.offlineBanner;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Row(children: [
        const Icon(Icons.cloud_off_rounded, size: 17, color: Color(0xFFF7B955)),
        const SizedBox(width: 10),
        Expanded(child: Text(context.l10n.offlineBanner(Fmt.dateTime(updatedAt)), style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFF7B955), fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int count;
  final double height;
  const SkeletonList({super.key, this.count = 4, this.height = 96});

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => LoadingSkeleton(width: double.infinity, height: i == 0 ? height * 1.5 : height, borderRadius: 24),
      );
}

/// Affiche une ressource asynchrone mise en cache avec tous ses états :
/// chargement (skeleton), erreur (réessayer), vide, hors ligne (bandeau).
class CachedAsyncView<T> extends StatelessWidget {
  final AsyncValue<Cached<T>> value;
  final Widget Function(BuildContext context, T data) builder;
  final bool Function(T data)? isEmpty;
  final String? emptyTitle;
  final String? emptyMessage;
  final IconData emptyIcon;
  final VoidCallback onRetry;
  final Widget? loading;

  const CachedAsyncView({
    super.key,
    required this.value,
    required this.builder,
    required this.onRetry,
    this.isEmpty,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon = Icons.inbox_rounded,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final content = value.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      loading: () => KeyedSubtree(key: const ValueKey('loading'), child: loading ?? const SkeletonList()),
      error: (e, _) => KeyedSubtree(
        key: const ValueKey('error'),
        child: ErrorStateView(title: context.l10n.errorTitle, message: ErrorHandler.message(e), onRetry: onRetry),
      ),
      data: (cached) {
        if (isEmpty?.call(cached.data) ?? false) {
          return RefreshIndicator(
            key: const ValueKey('empty'),
            onRefresh: () async => onRetry(),
            child: ListView(children: [
              const SizedBox(height: 60),
              EmptyStateView(title: emptyTitle ?? context.l10n.emptyTitle, message: emptyMessage ?? '', icon: emptyIcon),
            ]),
          );
        }
        final child = builder(context, cached.data);
        if (!cached.fromCache) return KeyedSubtree(key: const ValueKey('data'), child: child);
        return Column(key: const ValueKey('stale'), children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: StaleBanner(cached.updatedAt)),
          Expanded(child: child),
        ]);
      },
    );
    return AnimatedSwitcher(
      duration: AppMotion.medium,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, previous) => Stack(fit: StackFit.expand, children: [...previous, if (current != null) current]),
      child: content,
    );
  }
}

/// Avatar à initiales cerclé d'un anneau or → saphir ; [spin] fait tourner l'anneau.
class Avatar extends StatelessWidget {
  final String initials;
  final double radius;
  final bool spin;
  const Avatar(this.initials, {super.key, this.radius = 22, this.spin = false});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final size = radius * 2;
    final ring = spin && !AppMotion.reduced(context) ? const _SpinningRing() : const _Ring(0);
    return SizedBox.square(
      dimension: size,
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(child: ring),
        Container(
          width: size - 5,
          height: size - 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: s.isDark ? const [Color(0xFF1B2C63), Color(0xFF0E1638)] : const [Color(0xFFFFFFFF), Color(0xFFE9EEFC)],
            ),
          ),
          child: Text(initials, style: AppTextStyles.h3.copyWith(color: s.gold, fontSize: radius * 0.72, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
      ]),
    );
  }
}

class _Ring extends StatelessWidget {
  final double turn;
  const _Ring(this.turn);

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: const [Color(0xFFFBE0A4), Color(0xFFE5A93C), Color(0xFF5B8CFF), Color(0xFF8B7BFF), Color(0xFFFBE0A4)],
            transform: GradientRotation(turn * 2 * math.pi),
          ),
        ),
      );
}

class _SpinningRing extends StatefulWidget {
  const _SpinningRing();

  @override
  State<_SpinningRing> createState() => _SpinningRingState();
}

class _SpinningRingState extends State<_SpinningRing> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  // Rotation pure (aucune reconstruction) : seul le compositeur travaille.
  Widget build(BuildContext context) => RepaintBoundary(child: RotationTransition(turns: _c, child: const _Ring(0)));
}

/// Barre de progression lumineuse : remplissage dégradé animé et tête brillante.
class ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;
  const ProgressBar(this.value, {super.key, this.color = AppColors.success, this.height = 8});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final target = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);
    Widget bar(double v) => LayoutBuilder(
          builder: (_, c) => Stack(children: [
            Container(height: height, decoration: BoxDecoration(color: s.hairline, borderRadius: BorderRadius.circular(height))),
            Container(
              height: height,
              width: c.maxWidth * v,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height),
                gradient: LinearGradient(colors: [color.withValues(alpha: 0.65), color, Color.lerp(color, Colors.white, 0.3)!]),
                boxShadow: s.isDark && v > 0 ? [BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 10, spreadRadius: -2)] : null,
              ),
            ),
          ]),
        );
    return Semantics(
      value: '${(target * 100).round()} %',
      child: AppMotion.reduced(context)
          ? bar(target)
          : TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: target),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => bar(v),
            ),
    );
  }
}
