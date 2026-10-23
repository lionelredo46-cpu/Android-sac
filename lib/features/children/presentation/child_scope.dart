import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Carte d'identité de l'enfant actif (avatar à anneau tournant, filière) ;
/// touchée, elle ouvre le choix de l'enfant quand plusieurs sont rattachés.
class ChildSelector extends ConsumerWidget {
  const ChildSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = context.strato;
    final active = ref.watch(activeChildProvider);
    final all = ref.watch(childrenProvider).value?.data ?? const [];
    if (active == null) return const SizedBox.shrink();
    final many = all.length > 1;

    return Semantics(
      button: many,
      label: '${context.l10n.selectChild} : ${active.fullName}',
      excludeSemantics: true,
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
        onTap: many ? () => _pick(context, ref, all, active) : null,
        child: Row(children: [
          Avatar(active.initials, radius: 27, spin: true),
          const SizedBox(width: 14),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 380),
              transitionBuilder: (c, a) => FadeTransition(
                opacity: a,
                child: SlideTransition(position: Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(a), child: c),
              ),
              child: Column(
                key: ValueKey(active.id),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(active.fullName, style: AppTextStyles.h3.copyWith(color: s.text, fontSize: 18), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(active.subtitle, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(active.matricule, style: AppTextStyles.overline.copyWith(color: s.gold, letterSpacing: 1.2)),
                ],
              ),
            ),
          ),
          if (many)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: s.glassStrong, border: Border.all(color: s.hairline)),
              child: Icon(Icons.swap_horiz_rounded, color: s.gold, size: 20),
            ),
        ]),
      ),
    );
  }

  void _pick(BuildContext context, WidgetRef ref, List<Child> all, Child active) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final s = ctx.strato;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Padding(padding: const EdgeInsets.only(bottom: 14, left: 4), child: Text(context.l10n.selectChild, style: AppTextStyles.h2.copyWith(color: s.text, fontSize: 21))),
              for (var i = 0; i < all.length; i++)
                Reveal(
                  index: i,
                  child: GlassCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    borderColor: all[i].id == active.id ? s.gold.withValues(alpha: 0.6) : null,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(activeChildIdProvider.notifier).select(all[i].id);
                      Navigator.pop(ctx);
                    },
                    child: Row(children: [
                      Avatar(all[i].initials, radius: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(all[i].fullName, style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: FontWeight.w700)),
                          Text('${all[i].matricule} · ${all[i].group.nom}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
                        ]),
                      ),
                      if (all[i].id == active.id) Icon(Icons.check_circle_rounded, color: s.gold),
                    ]),
                  ),
                ),
            ]),
          ),
        );
      },
    );
  }
}
