import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/ui.dart';
import '../../domain/timetable_models.dart';
import '../timetable_controller.dart';
import 'glass_dock.dart';
import 'timetable_slot_card.dart';
import 'week_pill_selector.dart';

/// Données affichées par les vues de l'emploi du temps (indépendantes de Riverpod : testables et prévisualisables).
class TimetableViewData {
  final TimetableViewState state;
  final DateTime now;

  /// null = chargement en cours.
  final List<TimetableSlot>? slots;
  final Object? error;
  final DateTime? staleSince;
  final Map<String, String> attendance;

  const TimetableViewData({required this.state, required this.now, required this.slots, this.error, this.staleSince, this.attendance = const {}});

  List<TimetableSlot> slotsOn(DateTime day) => (slots ?? const <TimetableSlot>[]).where((s) => s.day == day).toList()..sort((a, b) => a.debut.compareTo(b.debut));

  Set<DateTime> get daysWithClasses => {for (final s in slots ?? const <TimetableSlot>[]) s.day};

  String? attendanceOf(TimetableSlot s) => attendance[attendanceKey(s.code, s.debut)];

  DateTime get today => DateTime(now.year, now.month, now.day);
}

/// Actions déclenchées par les vues (branchées sur le contrôleur par la page).
class TimetableViewActions {
  final ValueChanged<TimetableSlot> openSlot;
  final ValueChanged<int> shiftWeek;
  final ValueChanged<DateTime> selectDay;
  final VoidCallback goToToday;
  final VoidCallback toggleMode;
  final VoidCallback openNfc;
  final VoidCallback openExport;
  final VoidCallback retry;
  final VoidCallback? back;

  const TimetableViewActions({
    required this.openSlot,
    required this.shiftWeek,
    required this.selectDay,
    required this.goToToday,
    required this.toggleMode,
    required this.openNfc,
    required this.openExport,
    required this.retry,
    this.back,
  });
}

/// Vue mobile (< 600 px) : pilule de semaine flottante, timeline du jour ou agenda de la semaine, dock en verre.
class TimetableMobileView extends StatelessWidget {
  final String title;
  final String subtitle;
  final TimetableViewData data;
  final TimetableViewActions actions;

  const TimetableMobileView({super.key, required this.title, required this.subtitle, required this.data, required this.actions});

  static const _headerHeight = 56.0;
  static const _pillHeight = 132.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final padding = MediaQuery.paddingOf(context);
    final top = padding.top + _headerHeight + _pillHeight + 8;
    final bottom = padding.bottom + GlassDock.height + 28;
    final dayMode = data.state.mobileMode == TimetableMobileMode.day;

    return DecoratedBox(
      decoration: ObsidianColors.backdrop(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: _body(context, EdgeInsets.only(top: top, bottom: bottom)),
          ),
          // Voile dégradé derrière l'en-tête : le contenu qui défile dessous s'efface au lieu de se superposer au titre.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: padding.top + _headerHeight + _pillHeight * 0.6,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ObsidianColors.abyss, ObsidianColors.abyss.withValues(alpha: 0.9), ObsidianColors.abyss.withValues(alpha: 0)],
                    stops: const [0, 0.55, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, padding.top, 12, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: _headerHeight,
                    child: Row(
                      children: [
                        if (actions.back != null)
                          IconButton(
                            tooltip: l.back,
                            onPressed: actions.back,
                            icon: const Icon(Icons.arrow_back_rounded, color: ObsidianColors.text),
                          ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: ObsidianText.display(size: 22)),
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ObsidianText.label(size: 12, color: ObsidianColors.goldLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  WeekPillSelector(
                    weekStart: data.state.weekStart,
                    selectedDay: data.state.selectedDay,
                    today: data.today,
                    daysWithClasses: data.daysWithClasses,
                    onWeekShift: actions.shiftWeek,
                    onDaySelected: actions.selectDay,
                    onToday: actions.goToToday,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: padding.bottom + 14,
            child: Center(
              child: GlassDock(
                actions: [
                  DockAction(
                    key: const Key('dock-view'),
                    icon: dayMode ? Icons.view_agenda_rounded : Icons.view_day_rounded,
                    label: dayMode ? l.ttViewWeek : l.ttViewDay,
                    onTap: actions.toggleMode,
                  ),
                  DockAction(key: const Key('dock-nfc'), icon: Icons.nfc_rounded, label: l.ttNfc, onTap: actions.openNfc),
                  DockAction(key: const Key('dock-export'), icon: Icons.ios_share_rounded, label: l.ttExport, onTap: actions.openExport, prestige: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, EdgeInsets insets) {
    final l = context.l10n;
    if (data.error != null && data.slots == null) {
      return Padding(
        padding: insets,
        child: _Message(
          icon: Icons.cloud_off_rounded,
          title: l.errorTitle,
          action: TextButton(onPressed: actions.retry, child: Text(l.retry)),
        ),
      );
    }
    if (data.slots == null) {
      return Padding(
        padding: insets,
        child: const Center(child: CircularProgressIndicator(color: ObsidianColors.sapphireLight)),
      );
    }
    final stale = data.staleSince == null ? null : Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: StaleBanner(data.staleSince!));
    final child = data.state.mobileMode == TimetableMobileMode.day
        ? _DaySwipe(
            key: ValueKey('day-${data.state.selectedDay}'),
            onSwipe: (next) {
              final d = data.state.selectedDay;
              var target = DateTime(d.year, d.month, d.day + (next ? 1 : -1));
              if (target.weekday == DateTime.sunday) target = DateTime(target.year, target.month, target.day + (next ? 1 : -1));
              HapticFeedback.selectionClick();
              actions.selectDay(target);
            },
            child: DayTimeline(
              day: data.state.selectedDay,
              slots: data.slotsOn(data.state.selectedDay),
              now: data.now,
              attendanceOf: data.attendanceOf,
              selectedId: data.state.selectedSlotId,
              onSlotTap: actions.openSlot,
              padding: insets,
              header: stale,
            ),
          )
        : WeekAgenda(key: ValueKey('week-${data.state.weekStart}'), data: data, onSlotTap: actions.openSlot, padding: insets, header: stale);
    return AnimatedSwitcher(
      duration: AppMotion.medium,
      switchInCurve: AppMotion.decelerate,
      transitionBuilder: (c, a) => FadeTransition(
        opacity: a,
        child: ScaleTransition(scale: Tween(begin: 0.985, end: 1.0).animate(a), child: c),
      ),
      child: child,
    );
  }
}

/// Glisser horizontalement change de jour (vélocité suffisante pour ne pas gêner le défilement).
class _DaySwipe extends StatelessWidget {
  final Widget child;
  final ValueChanged<bool> onSwipe;
  const _DaySwipe({super.key, required this.child, required this.onSwipe});

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onHorizontalDragEnd: (d) {
      final v = d.primaryVelocity ?? 0;
      if (v.abs() > 320) onSwipe(v < 0);
    },
    child: child,
  );
}

/// Timeline proportionnelle d'une journée : la hauteur des cartes suit la durée réelle des cours.
class DayTimeline extends StatefulWidget {
  final DateTime day;
  final List<TimetableSlot> slots;
  final DateTime now;
  final String? Function(TimetableSlot) attendanceOf;
  final String? selectedId;
  final ValueChanged<TimetableSlot> onSlotTap;
  final EdgeInsets padding;
  final Widget? header;
  final double hourHeight;

  const DayTimeline({
    super.key,
    required this.day,
    required this.slots,
    required this.now,
    required this.attendanceOf,
    required this.onSlotTap,
    this.selectedId,
    this.padding = EdgeInsets.zero,
    this.header,
    this.hourHeight = 84,
  });

  @override
  State<DayTimeline> createState() => _DayTimelineState();
}

class _DayTimelineState extends State<DayTimeline> {
  final _scroll = ScrollController();
  static const _gutter = 54.0;

  ({int start, int end}) get _hours => hourRange(widget.slots);
  bool get _isToday => widget.day == DateTime(widget.now.year, widget.now.month, widget.now.day);

  double _y(DateTime t) {
    final local = t.toLocal();
    return ((local.hour - _hours.start) + local.minute / 60) * widget.hourHeight;
  }

  @override
  void initState() {
    super.initState();
    // Positionne la vue sur ce qui compte : le cours en direct, sinon le prochain (repère « maintenant »
    // compris), sinon le premier cours du jour (journée terminée ou autre jour).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients || widget.slots.isEmpty) return;
      final now = widget.now;
      final live = _isToday ? widget.slots.where((s) => s.isLive(now)).firstOrNull : null;
      final next = _isToday ? widget.slots.where((s) => s.debut.isAfter(now)).firstOrNull : null;
      // Environ 7 h de journée tiennent à l'écran : « maintenant − 30 min » montre le repère et le prochain cours.
      final anchor = live != null
          ? live.debut.subtract(const Duration(minutes: 15))
          : next != null
          ? now.subtract(const Duration(minutes: 30))
          : widget.slots.first.debut.subtract(const Duration(minutes: 30));
      final target = _y(anchor).clamp(0.0, _scroll.position.maxScrollExtent);
      _scroll.jumpTo(target);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (widget.slots.isEmpty) {
      return ListView(
        padding: widget.padding,
        children: [
          if (widget.header != null) widget.header!,
          const SizedBox(height: 48),
          _Message(icon: Icons.self_improvement_rounded, title: l.ttNoClassDay, body: l.ttNoClassDayBody),
        ],
      );
    }
    final hours = _hours;
    final height = (hours.end - hours.start) * widget.hourHeight;
    final nowY = _y(widget.now);
    final showNow = _isToday && nowY >= 0 && nowY <= height;

    return SingleChildScrollView(
      controller: _scroll,
      padding: widget.padding,
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
            child: LayoutBuilder(
              builder: (context, c) {
                final trackWidth = c.maxWidth - _gutter;
                return SizedBox(
                  height: height + 12,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (var h = hours.start; h <= hours.end; h++) ...[
                        Positioned(
                          left: 0,
                          top: (h - hours.start) * widget.hourHeight - 7,
                          width: _gutter - 10,
                          child: Text(
                            '${h.toString().padLeft(2, '0')}:00',
                            textAlign: TextAlign.right,
                            style: ObsidianText.time(size: 11.5, color: ObsidianColors.textFaint),
                          ),
                        ),
                        Positioned(left: _gutter, right: 0, top: (h - hours.start) * widget.hourHeight, child: const Divider(height: 1)),
                      ],
                      for (final p in placeDay(widget.slots))
                        Positioned(
                          left: _gutter + p.lane * trackWidth / p.lanes + 2,
                          top: _y(p.slot.debut) + 2,
                          width: trackWidth / p.lanes - 6,
                          height: (_y(p.slot.fin) - _y(p.slot.debut) - 4).clamp(44.0, double.infinity),
                          child: TimetableSlotCard(
                            slot: p.slot,
                            now: widget.now,
                            attendance: widget.attendanceOf(p.slot),
                            selected: p.slot.id == widget.selectedId,
                            onTap: () => widget.onSlotTap(p.slot),
                          ),
                        ),
                      if (showNow)
                        AnimatedPositioned(
                          duration: AppMotion.slow,
                          curve: AppMotion.emphasized,
                          left: 0,
                          right: 0,
                          top: nowY - 11,
                          child: IgnorePointer(
                            child: _NowLine(label: Fmt.time(widget.now), gutter: _gutter),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Repère de l'heure courante : étiquette dorée et ligne or → rubis.
class _NowLine extends StatelessWidget {
  final String label;
  final double gutter;
  const _NowLine({required this.label, required this.gutter});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 22,
    child: Row(
      children: [
        SizedBox(
          width: gutter - 4,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(gradient: ObsidianColors.goldGradient, borderRadius: BorderRadius.circular(8)),
              child: Text(label, style: ObsidianText.time(size: 11, color: ObsidianColors.abyss)),
            ),
          ),
        ),
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ObsidianColors.gold,
            boxShadow: [BoxShadow(color: ObsidianColors.gold.withValues(alpha: 0.7), blurRadius: 10)],
          ),
        ),
        Expanded(
          child: Container(
            height: 2,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [ObsidianColors.gold, ObsidianColors.ruby])),
          ),
        ),
      ],
    ),
  );
}

/// Agenda de la semaine : une section par jour, cartes en pleine hauteur.
class WeekAgenda extends StatelessWidget {
  final TimetableViewData data;
  final ValueChanged<TimetableSlot> onSlotTap;
  final EdgeInsets padding;
  final Widget? header;

  const WeekAgenda({super.key, required this.data, required this.onSlotTap, this.padding = EdgeInsets.zero, this.header});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final start = data.state.weekStart;
    final days = [for (var i = 0; i < 6; i++) DateTime(start.year, start.month, start.day + i)];
    if (data.slots!.isEmpty) {
      return ListView(
        padding: padding,
        children: [
          if (header != null) header!,
          const SizedBox(height: 48),
          _Message(icon: Icons.event_busy_rounded, title: l.ttNoClassWeek),
        ],
      );
    }
    return ListView(
      padding: padding.add(const EdgeInsets.symmetric(horizontal: 16)),
      children: [
        if (header != null) header!,
        for (final day in days) ...[
          _DayHeader(day: day, isToday: day == data.today, count: data.slotsOn(day).length),
          for (final s in data.slotsOn(day))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TimetableSlotCard(slot: s, now: data.now, attendance: data.attendanceOf(s), selected: s.id == data.state.selectedSlotId, onTap: () => onSlotTap(s)),
            ),
        ],
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final int count;
  const _DayHeader({required this.day, required this.isToday, required this.count});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 8),
    child: Row(
      children: [
        Flexible(
          child: Text(
            '${Fmt.weekday(day)} ${Fmt.dayMonth(day)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ObsidianText.title(size: 16, color: isToday ? ObsidianColors.goldLight : ObsidianColors.text),
          ),
        ),
        const SizedBox(width: 8),
        Text(context.l10n.ttClassesCount(count), style: ObsidianText.label(color: ObsidianColors.textFaint)),
      ],
    ),
  );
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;
  const _Message({required this.icon, required this.title, this.body, this.action});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassContainer(
        blur: 0,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: ObsidianColors.sapphireLight),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: ObsidianText.title()),
            if (body != null) ...[const SizedBox(height: 6), Text(body!, textAlign: TextAlign.center, style: ObsidianText.body())],
            if (action != null) ...[const SizedBox(height: 8), action!],
          ],
        ),
      ),
    ),
  );
}
