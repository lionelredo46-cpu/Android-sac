import 'package:flutter/material.dart';

import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/ui.dart';
import '../../domain/timetable_models.dart';
import 'slot_detail_view.dart';
import 'timetable_mobile_view.dart';
import 'timetable_slot_card.dart';

/// Vue tablette / bureau (≥ 600 px) : grille hebdomadaire proportionnelle et panneau latéral rétractable.
class TimetableDesktopView extends StatelessWidget {
  final String title;
  final String subtitle;
  final TimetableViewData data;
  final TimetableViewActions actions;
  final VoidCallback onSelectNone;
  final VoidCallback togglePanel;

  /// Aperçu de l'export de la semaine (rendu PDF), affiché dans le panneau.
  final Widget exportPreview;
  final ValueChanged<TimetableSlot> addToCalendar;
  final ValueChanged<TimetableSlot> checkRoom;

  const TimetableDesktopView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.data,
    required this.actions,
    required this.onSelectNone,
    required this.togglePanel,
    required this.exportPreview,
    required this.addToCalendar,
    required this.checkRoom,
  });

  static const panelWidth = 380.0;

  @override
  Widget build(BuildContext context) {
    final selected = data.slots?.where((s) => s.id == data.state.selectedSlotId).firstOrNull;
    final open = data.state.panelOpen;
    return DecoratedBox(
      decoration: ObsidianColors.backdrop(context),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Toolbar(title: title, subtitle: subtitle, data: data, actions: actions, panelOpen: open, togglePanel: togglePanel),
                  if (data.staleSince != null) Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: StaleBanner(data.staleSince!)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 8, 16),
                      child: GlassContainer(blur: 0, padding: const EdgeInsets.fromLTRB(4, 8, 12, 4), child: _body(context)),
                    ),
                  ),
                ],
              ),
            ),
            // Panneau rétractable : la largeur s'anime, le contenu garde sa taille (aucun débordement).
            AnimatedContainer(
              duration: AppMotion.slow,
              curve: AppMotion.emphasized,
              width: open ? panelWidth : 0,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  minWidth: panelWidth,
                  maxWidth: panelWidth,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
                    child: GlassContainer(
                      blur: 0,
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            child: AnimatedSwitcher(
                              duration: AppMotion.medium,
                              child: selected == null
                                  ? Padding(
                                      key: const ValueKey('hint'),
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.touch_app_rounded, color: ObsidianColors.sapphireLight),
                                          const SizedBox(width: 12),
                                          Expanded(child: Text(context.l10n.ttSelectSlotHint, style: ObsidianText.body())),
                                        ],
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      key: ValueKey(selected.id),
                                      padding: const EdgeInsets.all(16),
                                      child: SlotDetailView(
                                        slot: selected,
                                        now: data.now,
                                        attendance: data.attendanceOf(selected),
                                        onAddToCalendar: () => addToCalendar(selected),
                                        onCheckRoom: () => checkRoom(selected),
                                        onClose: onSelectNone,
                                      ),
                                    ),
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                            child: Text(context.l10n.ttExportPreview, style: ObsidianText.label(color: ObsidianColors.goldLight)),
                          ),
                          Expanded(child: exportPreview),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final l = context.l10n;
    if (data.slots == null) {
      return data.error != null
          ? Center(
              child: TextButton.icon(onPressed: actions.retry, icon: const Icon(Icons.refresh_rounded), label: Text(l.retry)),
            )
          : const Center(child: CircularProgressIndicator(color: ObsidianColors.sapphireLight));
    }
    return WeekGrid(data: data, onSlotTap: actions.openSlot);
  }
}

class _Toolbar extends StatelessWidget {
  final String title;
  final String subtitle;
  final TimetableViewData data;
  final TimetableViewActions actions;
  final bool panelOpen;
  final VoidCallback togglePanel;

  const _Toolbar({required this.title, required this.subtitle, required this.data, required this.actions, required this.panelOpen, required this.togglePanel});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final start = data.state.weekStart;
    final range = '${Fmt.dayMonth(start)} – ${Fmt.date(DateTime(start.year, start.month, start.day + 5))}';
    final isCurrent = start == mondayOf(data.now);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        children: [
          if (actions.back != null) IconButton(tooltip: l.back, onPressed: actions.back, icon: const Icon(Icons.arrow_back_rounded)),
          const SizedBox(width: 4),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: ObsidianText.display(size: 24)),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ObsidianText.label(color: ObsidianColors.goldLight),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(tooltip: l.ttPrevWeek, onPressed: () => actions.shiftWeek(-1), icon: const Icon(Icons.chevron_left_rounded)),
          Flexible(
            flex: 2,
            child: Text(range, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: ObsidianText.title(size: 15)),
          ),
          IconButton(tooltip: l.ttNextWeek, onPressed: () => actions.shiftWeek(1), icon: const Icon(Icons.chevron_right_rounded)),
          if (!isCurrent)
            TextButton(
              onPressed: actions.goToToday,
              child: Text(l.ttToday, style: ObsidianText.label(color: ObsidianColors.goldLight)),
            ),
          const SizedBox(width: 8),
          IconButton(key: const Key('toolbar-nfc'), tooltip: l.ttNfcTitle, onPressed: actions.openNfc, icon: const Icon(Icons.nfc_rounded)),
          const SizedBox(width: 4),
          FilledButton.icon(
            key: const Key('toolbar-export'),
            onPressed: actions.openExport,
            style: FilledButton.styleFrom(backgroundColor: ObsidianColors.gold, foregroundColor: ObsidianColors.abyss, minimumSize: const Size(48, 44)),
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: Text(l.ttExport),
          ),
          const SizedBox(width: 4),
          IconButton(tooltip: panelOpen ? l.ttHidePanel : l.ttShowPanel, onPressed: togglePanel, icon: Icon(panelOpen ? Icons.view_sidebar_rounded : Icons.view_sidebar_outlined)),
        ],
      ),
    );
  }
}

/// Grille matricielle lundi → samedi : colonne des heures et blocs proportionnels à la durée.
class WeekGrid extends StatelessWidget {
  final TimetableViewData data;
  final ValueChanged<TimetableSlot> onSlotTap;
  final double hourHeight;

  const WeekGrid({super.key, required this.data, required this.onSlotTap, this.hourHeight = 72});

  static const _gutter = 58.0;
  static const _header = 44.0;

  @override
  Widget build(BuildContext context) {
    final start = data.state.weekStart;
    final slots = data.slots ?? const <TimetableSlot>[];
    final hasSunday = slots.any((s) => s.day.weekday == DateTime.sunday);
    final days = [for (var i = 0; i < (hasSunday ? 7 : 6); i++) DateTime(start.year, start.month, start.day + i)];
    final hours = hourRange(slots);
    final height = (hours.end - hours.start) * hourHeight;
    double y(DateTime t) {
      final local = t.toLocal();
      return ((local.hour - hours.start) + local.minute / 60) * hourHeight;
    }

    return LayoutBuilder(
      builder: (context, c) {
        final column = (c.maxWidth - _gutter) / days.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: _header,
              child: Row(
                children: [
                  const SizedBox(width: _gutter),
                  for (final d in days)
                    SizedBox(
                      width: column,
                      child: _GridDayHeader(day: d, isToday: d == data.today, selected: d == data.state.selectedDay, count: data.slotsOn(d).length),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: SizedBox(
                  height: height + 8,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (var h = hours.start; h <= hours.end; h++) ...[
                        Positioned(
                          left: 0,
                          width: _gutter - 10,
                          top: (h - hours.start) * hourHeight - 7,
                          child: Text(
                            '${h.toString().padLeft(2, '0')}:00',
                            textAlign: TextAlign.right,
                            style: ObsidianText.time(size: 11.5, color: ObsidianColors.textFaint),
                          ),
                        ),
                        Positioned(left: _gutter, right: 0, top: (h - hours.start) * hourHeight, child: const Divider(height: 1)),
                      ],
                      for (var i = 0; i < days.length; i++) ...[
                        Positioned(
                          left: _gutter + i * column,
                          top: 0,
                          bottom: 0,
                          width: column,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: days[i] == data.today ? ObsidianColors.gold.withValues(alpha: 0.035) : null,
                              border: const Border(left: BorderSide(color: ObsidianColors.hairline)),
                            ),
                          ),
                        ),
                        for (final p in placeDay(data.slotsOn(days[i])))
                          Positioned(
                            left: _gutter + i * column + p.lane * column / p.lanes + 3,
                            top: y(p.slot.debut) + 2,
                            width: column / p.lanes - 6,
                            height: (y(p.slot.fin) - y(p.slot.debut) - 4).clamp(40.0, double.infinity),
                            child: TimetableSlotCard(
                              slot: p.slot,
                              now: data.now,
                              attendance: data.attendanceOf(p.slot),
                              selected: p.slot.id == data.state.selectedSlotId,
                              hero: false,
                              onTap: () => onSlotTap(p.slot),
                            ),
                          ),
                      ],
                      if (days.contains(data.today))
                        Builder(
                          builder: (_) {
                            final top = y(data.now);
                            if (top < 0 || top > height) return const SizedBox.shrink();
                            final i = days.indexOf(data.today);
                            return AnimatedPositioned(
                              duration: AppMotion.slow,
                              left: _gutter + i * column - 4,
                              width: column + 4,
                              top: top - 4,
                              child: IgnorePointer(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: ObsidianColors.gold),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        decoration: const BoxDecoration(gradient: LinearGradient(colors: [ObsidianColors.gold, ObsidianColors.ruby])),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GridDayHeader extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool selected;
  final int count;
  const _GridDayHeader({required this.day, required this.isToday, required this.selected, required this.count});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3),
    child: AnimatedContainer(
      duration: AppMotion.medium,
      decoration: BoxDecoration(
        color: isToday ? ObsidianColors.gold.withValues(alpha: 0.12) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isToday ? ObsidianColors.gold.withValues(alpha: 0.5) : Colors.transparent),
      ),
      child: Center(
        child: Text(
          '${Fmt.weekday(day)} ${day.day}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ObsidianText.title(size: 13.5, color: isToday ? ObsidianColors.goldLight : ObsidianColors.text),
        ),
      ),
    ),
  );
}
