import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/app_colors.dart';
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

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(attendanceStatsProvider(id));
            ref.invalidate(attendanceProvider(id));
            await ref.read(attendanceProvider(id).future);
          },
          child: ListView(padding: const EdgeInsets.all(16), children: [
            if (stats != null) _StatsHeader(stats),
            const SizedBox(height: 12),
            Card(
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
                headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false, titleTextStyle: AppTextStyles.h3),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isEmpty) return null;
                    final worst = events.any((e) => e.statut == 'ABSENT')
                        ? 'ABSENT'
                        : events.any((e) => e.statut == 'RETARD')
                            ? 'RETARD'
                            : 'PRESENT';
                    return Positioned(
                      bottom: 4,
                      child: Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: StatusStyle.of(worst).color)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(_selected == null ? l.recentAbsences : Fmt.date(_selected!), style: AppTextStyles.h3),
            const SizedBox(height: 8),
            if (visible.isEmpty) Padding(padding: const EdgeInsets.all(16), child: Text(l.noAbsence, textAlign: TextAlign.center)),
            ...visible.map((a) => _AttendanceTile(a)),
          ]),
        );
      },
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final AttendanceStats s;
  const _StatsHeader(this.s);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rate = s.tauxGlobal;
    final color = rate == null ? AppColors.info : rate >= 90 ? AppColors.success : rate >= 75 ? AppColors.warning : AppColors.error;
    return SectionCard(
      title: l.globalRate,
      icon: Icons.donut_large_rounded,
      iconColor: color,
      trailing: Text(Fmt.percent(rate), style: AppTextStyles.h2.copyWith(color: color)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _Counter(l.absent, s.totaux.absents, AppColors.error),
          _Counter(l.late, s.totaux.retards, AppColors.warning),
          _Counter(l.unjustifiedAbsences, s.totaux.absencesNonJustifiees, AppColors.error),
        ]),
        const Divider(height: 24),
        Align(alignment: Alignment.centerLeft, child: Text(l.byCourse, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700))),
        const SizedBox(height: 6),
        ...s.parMatiere.map((c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Expanded(flex: 3, child: Text(c.matiere, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                Expanded(flex: 2, child: ProgressBar((c.taux ?? 0) / 100, color: (c.taux ?? 0) >= 90 ? AppColors.success : AppColors.warning)),
                SizedBox(width: 52, child: Text(Fmt.percent(c.taux), textAlign: TextAlign.end, style: AppTextStyles.bodySmall)),
              ]),
            )),
      ]),
    );
  }
}

class _Counter extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Counter(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Flexible(
        child: Column(children: [
          Text('$value', style: AppTextStyles.h2.copyWith(color: color)),
          Text(label, textAlign: TextAlign.center, style: AppTextStyles.caption),
        ]),
      );
}

class _AttendanceTile extends StatelessWidget {
  final AttendanceItem a;
  const _AttendanceTile(this.a);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final j = a.justification;
    final style = StatusStyle.of(a.statut);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(style.icon, color: style.color, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(a.cours.nom, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700))),
            StatusChip(label: attendanceLabel(l, a.statut), color: style.color),
          ]),
          const SizedBox(height: 6),
          Text('${Fmt.weekday(a.date)} ${Fmt.date(a.date)} · ${Fmt.time(a.date)}–${Fmt.time(a.fin)} (${a.dureeMinutes} min)\n${a.enseignant} · ${l.room(a.salle)}',
              style: AppTextStyles.bodySmall),
          if (a.statut == 'RETARD') Text(l.lateMinutes(a.minutesRetard), style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning)),
          if (j != null) ...[
            const SizedBox(height: 6),
            StatusChip.status(
              j.statut,
              switch (j.statut) { 'VALIDE' => l.justified, 'REJETE' => l.justificationRejected, _ => l.justificationPending },
            ),
            if (j.commentaire != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(j.commentaire!, style: AppTextStyles.bodySmall)),
          ],
          if (a.justifiable)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.push('/tracking/justify', extra: a),
                icon: const Icon(Icons.upload_file_rounded),
                label: Text(l.justify),
              ),
            ),
        ]),
      ),
    );
  }
}
