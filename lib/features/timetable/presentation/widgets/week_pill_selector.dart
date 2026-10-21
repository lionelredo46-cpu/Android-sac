import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/spring_pressable.dart';
import '../../../../core/widgets/ui.dart';
import '../../domain/timetable_models.dart';

/// Pilule flottante de sélection : semaines en défilement infini (glisser), jours en un appui.
class WeekPillSelector extends StatefulWidget {
  final DateTime weekStart;
  final DateTime selectedDay;
  final DateTime today;
  final Set<DateTime> daysWithClasses;
  final ValueChanged<int> onWeekShift;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onToday;

  const WeekPillSelector({
    super.key,
    required this.weekStart,
    required this.selectedDay,
    required this.today,
    required this.daysWithClasses,
    required this.onWeekShift,
    required this.onDaySelected,
    required this.onToday,
  });

  @override
  State<WeekPillSelector> createState() => _WeekPillSelectorState();
}

class _WeekPillSelectorState extends State<WeekPillSelector> {
  /// Page d'origine d'une liste « infinie » : on peut reculer ou avancer de ~190 ans.
  static const _origin = 10000;
  late final DateTime _anchor = widget.weekStart;
  late final PageController _pages = PageController(initialPage: _origin);

  /// Vrai pendant un recalage programmatique : les pages traversées ne sont pas des choix.
  bool _syncing = false;

  // Arithmétique calendaire (et non Duration) : insensible aux changements d'heure.
  DateTime _weekOf(int page) => DateTime(_anchor.year, _anchor.month, _anchor.day + 7 * (page - _origin));
  int _pageOf(DateTime monday) => _origin + (monday.difference(_anchor).inHours / (24 * 7)).round();

  @override
  void didUpdateWidget(WeekPillSelector old) {
    super.didUpdateWidget(old);
    // Semaine changée depuis l'extérieur (bouton « Aujourd'hui », lien profond) : on suit.
    final target = _pageOf(widget.weekStart);
    if (!_pages.hasClients || (_pages.page?.round() ?? target) == target) return;
    if (AppMotion.reduced(context)) {
      _pages.jumpToPage(target);
      return;
    }
    _syncing = true;
    _pages.animateToPage(target, duration: AppMotion.slow, curve: AppMotion.emphasized).whenComplete(() => _syncing = false);
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isCurrentWeek = widget.weekStart == mondayOf(widget.today);
    final range = '${Fmt.dayMonth(widget.weekStart)} – ${Fmt.dayMonth(widget.weekStart.add(const Duration(days: 5)))}';
    return GlassContainer(
      blur: 18,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      borderRadius: BorderRadius.circular(28),
      shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10))],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l.ttPrevWeek,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.chevron_left_rounded, color: ObsidianColors.textMuted),
                onPressed: () => _pages.previousPage(duration: AppMotion.medium, curve: AppMotion.emphasized),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppMotion.medium,
                  transitionBuilder: (child, a) => FadeTransition(
                    opacity: a,
                    child: SlideTransition(
                      position: Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(a),
                      child: child,
                    ),
                  ),
                  child: Text(range, key: ValueKey(range), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: ObsidianText.title(size: 16)),
                ),
              ),
              AnimatedOpacity(
                opacity: isCurrentWeek ? 0 : 1,
                duration: AppMotion.fast,
                child: IgnorePointer(
                  ignoring: isCurrentWeek,
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onToday();
                    },
                    style: TextButton.styleFrom(foregroundColor: ObsidianColors.goldLight, visualDensity: VisualDensity.compact),
                    child: Text(l.ttToday, style: ObsidianText.label(size: 12, color: ObsidianColors.goldLight)),
                  ),
                ),
              ),
              IconButton(
                tooltip: l.ttNextWeek,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.chevron_right_rounded, color: ObsidianColors.textMuted),
                onPressed: () => _pages.nextPage(duration: AppMotion.medium, curve: AppMotion.emphasized),
              ),
            ],
          ),
          SizedBox(
            height: 62,
            child: PageView.builder(
              controller: _pages,
              physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
              onPageChanged: (page) {
                if (_syncing) return;
                final delta = page - _pageOf(widget.weekStart);
                if (delta != 0) {
                  HapticFeedback.selectionClick();
                  widget.onWeekShift(delta);
                }
              },
              itemBuilder: (_, page) {
                final monday = _weekOf(page);
                return Row(
                  children: [for (var i = 0; i < 6; i++) Expanded(child: _dayChip(context, DateTime(monday.year, monday.month, monday.day + i), monday == widget.weekStart))],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayChip(BuildContext context, DateTime day, bool displayedWeek) {
    final selected = displayedWeek && day == widget.selectedDay;
    final isToday = day == widget.today;
    final hasClasses = displayedWeek && widget.daysWithClasses.contains(day);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final letter = DateFormat.E(locale).format(day).replaceAll('.', '');
    return SpringPressable(
      onTap: () => widget.onDaySelected(day),
      semanticLabel: '${Fmt.weekday(day)} ${Fmt.dayMonth(day)}',
      child: AnimatedContainer(
        duration: AppMotion.medium,
        curve: AppMotion.emphasized,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          gradient: selected ? ObsidianColors.sapphireGradient : null,
          color: selected ? null : ObsidianColors.surfaceHigh.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isToday ? ObsidianColors.gold : Colors.transparent, width: 1.2),
          boxShadow: selected ? [BoxShadow(color: ObsidianColors.sapphire.withValues(alpha: 0.45), blurRadius: 14, spreadRadius: -4)] : null,
        ),
        child: ExcludeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(letter.toUpperCase(), maxLines: 1, style: ObsidianText.label(size: 10.5, color: selected ? Colors.white70 : ObsidianColors.textFaint)),
              const SizedBox(height: 2),
              Text(
                '${day.day}',
                style: ObsidianText.time(
                  size: 17,
                  color: selected
                      ? Colors.white
                      : isToday
                      ? ObsidianColors.goldLight
                      : ObsidianColors.text,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: AppMotion.fast,
                width: 5,
                height: 5,
                decoration: BoxDecoration(shape: BoxShape.circle, color: hasClasses ? (selected ? Colors.white : ObsidianColors.sapphireLight) : Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
