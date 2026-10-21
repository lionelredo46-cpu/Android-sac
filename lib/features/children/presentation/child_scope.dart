import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/ui.dart';
import '../application/children_providers.dart';
import '../domain/child.dart';

/// Fournit l'enfant actif aux écrans qui en dépendent, avec les états
/// chargement / erreur / aucun enfant rattaché.
class ChildScope extends ConsumerWidget {
  final Widget Function(BuildContext context, Child child) builder;
  const ChildScope({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider);
    final active = ref.watch(activeChildProvider);
    return children.when(
      loading: () => const SkeletonList(),
      error: (e, _) => ErrorStateView(title: context.l10n.errorTitle, message: ErrorHandler.message(e), onRetry: () => ref.invalidate(childrenProvider)),
      data: (_) => active == null
          ? EmptyStateView(title: context.l10n.noChildren, message: context.l10n.noChildrenBody, icon: Icons.family_restroom_rounded)
          : builder(context, active),
    );
  }
}

/// Sélecteur d'enfant (avatar + nom) affiché en haut de l'accueil.
class ChildSelector extends ConsumerWidget {
  final bool onDark;
  const ChildSelector({super.key, this.onDark = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeChildProvider);
    final all = ref.watch(childrenProvider).value?.data ?? const [];
    if (active == null) return const SizedBox.shrink();
    final color = onDark ? Colors.white : Theme.of(context).colorScheme.onSurface;

    return Semantics(
      button: all.length > 1,
      label: '${context.l10n.selectChild} : ${active.fullName}',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: all.length > 1 ? () => _pick(context, ref, all, active) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Avatar(active.initials),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(active.fullName, style: AppTextStyles.h3.copyWith(color: color), overflow: TextOverflow.ellipsis),
                Text(active.subtitle, style: AppTextStyles.bodySmall.copyWith(color: color.withValues(alpha: 0.75)), overflow: TextOverflow.ellipsis),
              ]),
            ),
            if (all.length > 1) Icon(Icons.unfold_more_rounded, color: color),
          ]),
        ),
      ),
    );
  }

  void _pick(BuildContext context, WidgetRef ref, List<Child> all, Child active) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(context.l10n.selectChild, style: AppTextStyles.h3)),
          for (final c in all)
            ListTile(
              leading: Avatar(c.initials, radius: 20),
              title: Text(c.fullName),
              subtitle: Text('${c.matricule} · ${c.group.nom}'),
              trailing: c.id == active.id ? const Icon(Icons.check_circle_rounded, color: Colors.green) : null,
              onTap: () {
                ref.read(activeChildIdProvider.notifier).select(c.id);
                Navigator.pop(ctx);
              },
            ),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }
}
