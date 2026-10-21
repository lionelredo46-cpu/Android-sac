import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../errors/error_handler.dart';
import '../l10n/generated/app_localizations.dart';
import '../storage/cache_store.dart';
import '../utils/formatters.dart';
import 'empty_state_view.dart';
import 'error_state_view.dart';
import 'loading_skeleton.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: error ? AppColors.error : null,
        behavior: SnackBarBehavior.floating,
      ));
  }

  void showError(Object e) => showSnack(ErrorHandler.message(e), error: true);
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
    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Flexible(child: Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}

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
    final color = iconColor ?? context.colors.primary;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTextStyles.h3)),
              if (trailing != null) trailing!,
              if (onTap != null && trailing == null) Icon(Icons.chevron_right_rounded, color: context.colors.outline),
            ]),
            const SizedBox(height: 14),
            child,
          ]),
        ),
      ),
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: valueColor)),
          ),
        ]),
      );
}

/// Bandeau « données hors ligne » quand une ressource vient du cache.
class StaleBanner extends StatelessWidget {
  final DateTime updatedAt;
  const StaleBanner(this.updatedAt, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: AppColors.offlineBanner.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          const Icon(Icons.cloud_off_rounded, size: 16, color: AppColors.offlineBanner),
          const SizedBox(width: 8),
          Expanded(child: Text(context.l10n.offlineBanner(Fmt.dateTime(updatedAt)), style: AppTextStyles.bodySmall.copyWith(color: AppColors.offlineBanner))),
        ]),
      );
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
        itemBuilder: (_, __) => LoadingSkeleton(width: double.infinity, height: height, borderRadius: 16),
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
    return value.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      loading: () => loading ?? const SkeletonList(),
      error: (e, _) => ErrorStateView(title: context.l10n.errorTitle, message: ErrorHandler.message(e), onRetry: onRetry),
      data: (cached) {
        if (isEmpty?.call(cached.data) ?? false) {
          return RefreshIndicator(
            onRefresh: () async => onRetry(),
            child: ListView(children: [
              const SizedBox(height: 60),
              EmptyStateView(title: emptyTitle ?? context.l10n.emptyTitle, message: emptyMessage ?? '', icon: emptyIcon),
            ]),
          );
        }
        final child = builder(context, cached.data);
        if (!cached.fromCache) return child;
        return Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: StaleBanner(cached.updatedAt)),
          Expanded(child: child),
        ]);
      },
    );
  }
}

class Avatar extends StatelessWidget {
  final String initials;
  final double radius;
  const Avatar(this.initials, {super.key, this.radius = 22});

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.aframGold.withValues(alpha: 0.25),
        child: Text(initials, style: AppTextStyles.h3.copyWith(color: AppColors.aframPrimary, fontSize: radius * 0.75)),
      );
}

class ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  const ProgressBar(this.value, {super.key, this.color = AppColors.success});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          minHeight: 8,
          color: color,
          backgroundColor: color.withValues(alpha: 0.15),
        ),
      );
}
