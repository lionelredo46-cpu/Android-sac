import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../../children/domain/child.dart';
import '../data/attendance_repository.dart';
import '../domain/attendance_models.dart';

String attendanceLabel(AppLocalizations l, String s) => switch (s) {
      'PRESENT' => l.present,
      'ABSENT' => l.absent,
      'RETARD' => l.late,
      'EXCUSE' => l.excused,
      _ => s,
    };

class AttendanceTab extends ConsumerStatefulWidget {
  final Child child;
  const AttendanceTab({super.key, required this.child});

  @override
  ConsumerState<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<AttendanceTab> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final id = widget.child.id;
    final stats = ref.watch(attendanceStatsProvider(id)).value?.data;

    return CachedAsyncView<List<AttendanceItem>>(
      value: ref.watch(attendanceProvider(id)),
      onRetry: () {
        ref.invalidate(attendanceProvider(id));
        ref.invalidate(attendanceStatsProvider(id));
      },
      builder: (context, items) {
        final byDay = <DateTime, List<AttendanceItem>>{};
        for (final a in items) {
          final d = DateTime(a.date.toLocal().year, a.date.toLocal().month, a.date.toLocal().day);
          byDay.putIfAbsent(d, () => []).add(a);
        }
        final visible = _selected == null
            ? items.where((a) => a.statut != 'PRESENT').toList()
            : (byDay[DateTime(_selected!.year, _selected!.month, _selected!.day)] ?? const []);

        Widget dayCell(DateTime d, {Color? fill, Color? ring, Color? text, List<BoxShadow>? glow}) => Center(
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: fill == null ? null : Strato.goldGradient,
                  border: ring == null ? null : Border.all(color: ring, width: 1.5),
                  boxShadow: glow,
                ),
                child: Text('${d.day}', style: AppTextStyles.bodyMedium.copyWith(color: text ?? s.text, fontWeight: FontWeight.w600)),
              ),
            );

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(attendanceStatsProvider(id));
            ref.invalidate(attendanceProvider(id));
            await ref.read(attendanceProvider(id).future);
          },
          child: ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 24 + context.bottomInset), children: [
            if (stats != null) Reveal(child: _StatsHeader(stats)),
            const SizedBox(height: 12),
            Reveal(
              index: 1,
              child: GlassCard(
                padding: const EdgeInsets.fromLTRB(6, 8, 6, 10),
                child: TableCalendar<AttendanceItem>(
                  locale: Localizations.localeOf(context).languageCode,
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: _focused,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableCalendarFormats: const {CalendarFormat.month: 'Mois'},
                  selectedDayPredicate: (d) => _selected != null && isSameDay(d, _selected),
                  eventLoader: (d) => byDay[DateTime(d.year, d.month, d.day)] ?? const [],
                  onDaySelected: (sel, foc) => setState(() {
                    _selected = isSameDay(sel, _selected) ? null : sel;
                    _focused = foc;
                  }),
                  onPageChanged: (f) => _focused = f,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: AppTextStyles.caption.copyWith(color: s.textMuted, fontWeight: FontWeight.w700),
                    weekendStyle: AppTextStyles.caption.copyWith(color: s.textFaint, fontWeight: FontWeight.w700),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: AppTextStyles.h3.copyWith(color: s.text),
                    leftChevronIcon: Icon(Icons.chevron_left_rounded, color: s.gold),
                    rightChevronIcon: Icon(Icons.chevron_right_rounded, color: s.gold),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: AppTextStyles.bodyMedium.copyWith(color: s.text),
                    weekendTextStyle: AppTextStyles.bodyMedium.copyWith(color: s.textMuted),
                    disabledTextStyle: AppTextStyles.bodyMedium.copyWith(color: s.textFaint.withValues(alpha: 0.5)),
                  ),
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (_, d, __) => dayCell(d, ring: s.accent, text: s.accent),
                    selectedBuilder: (_, d, __) => dayCell(d, fill: s.gold, text: s.onGold, glow: [BoxShadow(color: s.gold.withValues(alpha: 0.5), blurRadius: 14)]),
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return null;
                      final worst = events.any((e) => e.statut == 'ABSENT')
                          ? 'ABSENT'
                          : events.any((e) => e.statut == 'RETARD')
                              ? 'RETARD'
                              : 'PRESENT';
                      final c = StatusStyle.of(worst).color;
                      return Positioned(
                        bottom: 3,
                        child: Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: c, boxShadow: [BoxShadow(color: c, blurRadius: 6)])),
                      );
                    },
                  ),
                ),
              ),
            ),
            SectionLabel(_selected == null ? l.recentAbsences : Fmt.date(_selected!)),
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.verified_rounded, color: s.success),
                  const SizedBox(width: 8),
                  Text(l.noAbsence, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted)),
                ]),
              ),
            for (var i = 0; i < visible.length; i++) Reveal(key: ValueKey('${_selected}_${visible[i].id}'), index: i + 2, child: _AttendanceTile(visible[i])),
          ]),
        );
      },
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final AttendanceStats st;
  const _StatsHeader(this.st);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final rate = st.tauxGlobal;
    final color = s.scale(rate == null ? null : rate / 100);
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(children: [
        Row(children: [
          OrbitGauge(
            value: rate == null ? null : rate / 100,
            color: color,
            size: 112,
            stroke: 9,
            center: Column(mainAxisSize: MainAxisSize.min, children: [
              rate == null
                  ? Text('—', style: AppTextStyles.h1.copyWith(color: s.text))
                  : CountUp(value: rate, format: (v) => '${v.toStringAsFixed(0)}%', style: AppTextStyles.h1.copyWith(color: s.text, fontSize: 26)),
              Text(l.globalRate, style: AppTextStyles.caption.copyWith(color: s.textMuted, fontSize: 9.5)),
            ]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(children: [
              _Counter(l.absent, st.totaux.absents, s.danger, Icons.event_busy_rounded),
              const SizedBox(height: 8),
              _Counter(l.late, st.totaux.retards, s.warning, Icons.timer_outlined),
              const SizedBox(height: 8),
              _Counter(l.unjustifiedAbsences, st.totaux.absencesNonJustifiees, s.danger, Icons.report_gmailerrorred_rounded),
            ]),
          ),
        ]),
        if (st.parMatiere.isNotEmpty) ...[
          const SizedBox(height: 16),
          Divider(color: s.hairline, height: 1),
          const SizedBox(height: 14),
          Align(alignment: Alignment.centerLeft, child: Text(l.byCourse.toUpperCase(), style: AppTextStyles.overline.copyWith(color: s.textMuted))),
          const SizedBox(height: 10),
          for (final c in st.parMatiere)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                Expanded(flex: 3, child: Text(c.matiere, style: AppTextStyles.bodySmall.copyWith(color: s.text), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: ProgressBar((c.taux ?? 0) / 100, color: s.scale((c.taux ?? 0) / 100), height: 6)),
                SizedBox(width: 52, child: Text(Fmt.percent(c.taux), textAlign: TextAlign.end, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted, fontWeight: FontWeight.w700))),
              ]),
            ),
        ],
      ]),
    );
  }
}

class _Counter extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _Counter(this.label, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withValues(alpha: s.isDark ? 0.09 : 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.22))),
      child: Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: AppTextStyles.caption.copyWith(color: s.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis)),
        Text('$value', style: AppTextStyles.h3.copyWith(color: color, fontSize: 17)),
      ]),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final AttendanceItem a;
  const _AttendanceTile(this.a);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final j = a.justification;
    final style = StatusStyle.of(a.statut);
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            width: 4,
            decoration: BoxDecoration(color: style.color, boxShadow: [BoxShadow(color: style.color.withValues(alpha: 0.7), blurRadius: 10)]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(a.cours.nom, style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: FontWeight.w700))),
                  StatusChip(label: attendanceLabel(l, a.statut), color: style.color),
                ]),
                const SizedBox(height: 6),
                Text('${Fmt.weekday(a.date)} ${Fmt.date(a.date)} · ${Fmt.time(a.date)}–${Fmt.time(a.fin)} (${a.dureeMinutes} min)',
                    style: AppTextStyles.bodySmall.copyWith(color: s.text)),
                Text('${a.enseignant} · ${l.room(a.salle)}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
                if (a.statut == 'RETARD') Text(l.lateMinutes(a.minutesRetard), style: AppTextStyles.bodySmall.copyWith(color: s.warning, fontWeight: FontWeight.w700)),
                if (j != null) ...[
                  const SizedBox(height: 8),
                  StatusChip.status(
                    j.statut,
                    switch (j.statut) { 'VALIDE' => l.justified, 'REJETE' => l.justificationRejected, _ => l.justificationPending },
                  ),
                  if (j.commentaire != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(j.commentaire!, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted))),
                ],
                if (a.justifiable)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push('/tracking/justify', extra: a),
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: Text(l.justify),
                      style: TextButton.styleFrom(foregroundColor: s.gold),
                    ),
                  ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
