import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pulsing_indicator.dart';
import '../../../../core/widgets/spring_pressable.dart';
import '../../../../core/widgets/ui.dart';
import '../../domain/timetable_models.dart';

/// Carte de cours : horaire, matière, salle, campus, enseignant, statut et appel.
///
/// S'adapte à la hauteur disponible (grille proportionnelle) : en dessous de
/// [compactHeight], seules les informations essentielles sont affichées.
class TimetableSlotCard extends StatelessWidget {
  final TimetableSlot slot;
  final DateTime now;

  /// Statut de présence relevé (PRESENT, ABSENT, RETARD, EXCUSE), pour un cours passé.
  final String? attendance;
  final bool selected;
  final bool hero;
  final VoidCallback? onTap;

  static const compactHeight = 116.0;

  const TimetableSlotCard({super.key, required this.slot, required this.now, this.attendance, this.selected = false, this.hero = true, this.onTap});

  static String heroTag(TimetableSlot s) => 'slot-${s.id}';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final live = slot.isLive(now);
    final accent = ObsidianColors.forStatus(slot.statut, slot.code);
    final radius = BorderRadius.circular(18);
    final time = '${Fmt.time(slot.debut)} – ${Fmt.time(slot.fin)}';

    final card = LayoutBuilder(
      builder: (context, c) {
        // Paliers de densité selon la hauteur (= durée du cours dans les vues proportionnelles).
        final h = c.hasBoundedHeight ? c.maxHeight : double.infinity;
        final tiny = h < 60;
        final compact = h < compactHeight;
        final content = tiny
            ? _line(slot.matiere, ObsidianText.title(size: 12.5), cancelled: slot.cancelled)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(child: _line(time, ObsidianText.time(size: 12, color: live ? ObsidianColors.goldLight : ObsidianColors.textMuted))),
                      const SizedBox(width: 6),
                      Flexible(
                        child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: _badge(l, live)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  _line(
                    slot.matiere,
                    ObsidianText.title(size: compact ? 14 : 16),
                    maxLines: h >= 140 ? 2 : 1,
                    cancelled: slot.cancelled,
                  ),
                  if (compact) ...[
                    if (h >= 88) _line('${slot.salle} · ${slot.enseignant}', ObsidianText.body(size: 11.5)),
                  ] else ...[
                    const SizedBox(height: 6),
                    _meta(Icons.meeting_room_outlined, '${l.room(slot.salle)} · ${slot.campus}'),
                    if (h >= 132) ...[const SizedBox(height: 2), _meta(Icons.person_outline_rounded, slot.enseignant)],
                    if (h >= 170 && slot.motif != null && slot.motif!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _line(slot.motif!, ObsidianText.body(size: 12, color: accent).copyWith(fontStyle: FontStyle.italic), maxLines: 2),
                    ],
                  ],
                ],
              );
        return Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: live ? 0.20 : 0.13),
                ObsidianColors.surfaceHigh.withValues(alpha: 0.96),
              ],
            ),
            border: Border.all(
              color: selected
                  ? ObsidianColors.sapphireLight
                  : live
                  ? ObsidianColors.gold.withValues(alpha: 0.7)
                  : accent.withValues(alpha: 0.28),
              width: selected || live ? 1.4 : 1,
            ),
            boxShadow: [
              if (live) BoxShadow(color: ObsidianColors.gold.withValues(alpha: 0.18), blurRadius: 18, spreadRadius: -4),
              if (selected) BoxShadow(color: ObsidianColors.sapphire.withValues(alpha: 0.35), blurRadius: 16, spreadRadius: -6),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: LiveShimmer(
              enabled: live,
              borderRadius: radius,
              child: _sizedRow(h.isFinite, [
                Container(width: 4, color: accent),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, tiny ? 4 : 8, 10, tiny ? 4 : 8),
                    // Hauteur imposée (grille) : contenu ancré en haut et rogné, jamais de débordement,
                    // même avec une très grande police système. Hauteur libre (liste) : taille naturelle.
                    child: h.isFinite
                        ? ClipRect(
                            child: OverflowBox(alignment: Alignment.topLeft, minHeight: 0, maxHeight: double.infinity, child: content),
                          )
                        : content,
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );

    return Semantics(
      label: '${slot.matiere}, $time, ${l.room(slot.salle)}, ${slot.enseignant}${live ? ', ${l.ttLiveNow}' : ''}${slot.cancelled ? ', ${l.cancelledClass}' : ''}',
      selected: selected,
      excludeSemantics: true,
      child: SpringPressable(
        onTap: onTap,
        child: hero
            ? Hero(
                tag: heroTag(slot),
                createRectTween: (a, b) => MaterialRectArcTween(begin: a, end: b),
                child: Material(type: MaterialType.transparency, child: card),
              )
            : card,
      ),
    );
  }

  /// Barre de couleur étirée sur toute la hauteur. Sans hauteur imposée (liste), la ligne
  /// prend la hauteur de son contenu : étirer vers une hauteur infinie est invalide.
  static Widget _sizedRow(bool boundedHeight, List<Widget> children) {
    final row = Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
    return boundedHeight ? row : IntrinsicHeight(child: row);
  }

  Widget _badge(AppLocalizations l, bool live) {
    if (live) return LiveBadge(label: l.ttLiveNow);
    if (slot.cancelled) return _chip(l.cancelledClass, ObsidianColors.ruby, Icons.block_rounded);
    if (slot.postponed) return _chip(l.postponedClass, ObsidianColors.amber, Icons.update_rounded);
    if (slot.isPast(now) && attendance != null) {
      return switch (attendance) {
        'PRESENT' => _chip(l.ttPresent, ObsidianColors.emerald, Icons.check_circle_rounded),
        'RETARD' => _chip(l.ttLate, ObsidianColors.amber, Icons.schedule_rounded),
        'ABSENT' => _chip(l.ttAbsent, ObsidianColors.ruby, Icons.cancel_rounded),
        'EXCUSE' => _chip(l.ttExcused, ObsidianColors.sapphireLight, Icons.verified_rounded),
        _ => const SizedBox.shrink(),
      };
    }
    return Text(slot.code, maxLines: 1, style: ObsidianText.label(size: 10.5, color: ObsidianColors.textFaint));
  }

  static Widget _chip(String label, Color color, IconData icon) => AnimatedContainer(
    duration: AppMotion.fast,
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: color.withValues(alpha: 0.45)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(label, maxLines: 1, style: ObsidianText.label(size: 10.5, color: color)),
      ],
    ),
  );

  static Widget _line(String text, TextStyle style, {int maxLines = 1, bool cancelled = false}) => Text(
    text,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: cancelled ? style.copyWith(decoration: TextDecoration.lineThrough, decorationColor: ObsidianColors.ruby) : style,
  );

  static Widget _meta(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 14, color: ObsidianColors.textFaint),
      const SizedBox(width: 5),
      Expanded(child: _line(text, ObsidianText.body(size: 12.5))),
    ],
  );
}
