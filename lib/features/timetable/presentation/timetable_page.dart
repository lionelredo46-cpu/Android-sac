import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../../children/domain/child.dart';
import '../../children/presentation/child_scope.dart';
import '../data/timetable_repository.dart';
import '../domain/timetable_models.dart';

DateTime mondayOf(DateTime d) => DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));

class TimetablePage extends ConsumerStatefulWidget {
  const TimetablePage({super.key});

  @override
  ConsumerState<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends ConsumerState<TimetablePage> {
  DateTime _monday = mondayOf(DateTime.now());

  Future<void> _export(Child child) async {
    try {
      final ics = await ref.read(timetableRepositoryProvider).ics(child.id);
      final file = File('${(await getTemporaryDirectory()).path}/afram-emploi-du-temps.ics');
      await file.writeAsString(ics);
      await Share.shareXFiles([XFile(file.path, mimeType: 'text/calendar')], subject: 'AFRAM — Emploi du temps');
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChildScope(
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(l.timetableTitle),
          actions: [
            IconButton(tooltip: l.calendarTitle, icon: const Icon(Icons.event_rounded), onPressed: () => context.push(RoutePaths.calendar)),
            IconButton(tooltip: l.exportCalendar, icon: const Icon(Icons.ios_share_rounded), onPressed: () => _export(child)),
          ],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(children: [
              IconButton(tooltip: l.back, icon: const Icon(Icons.chevron_left_rounded), onPressed: () => setState(() => _monday = _monday.subtract(const Duration(days: 7)))),
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => _monday = mondayOf(DateTime.now())),
                  child: Text('${Fmt.dayMonth(_monday)} – ${Fmt.dayMonth(_monday.add(const Duration(days: 5)))}', style: AppTextStyles.h3),
                ),
              ),
              IconButton(tooltip: l.next, icon: const Icon(Icons.chevron_right_rounded), onPressed: () => setState(() => _monday = _monday.add(const Duration(days: 7)))),
            ]),
          ),
          Expanded(
            child: CachedAsyncView<Timetable>(
              value: ref.watch(timetableProvider((childId: child.id, monday: _monday))),
              onRetry: () => ref.invalidate(timetableProvider((childId: child.id, monday: _monday))),
              isEmpty: (t) => t.creneaux.isEmpty,
              emptyTitle: l.noClassToday,
              emptyIcon: Icons.event_busy_rounded,
              builder: (context, t) {
                final days = <DateTime, List<TimetableSlot>>{};
                for (final s in t.creneaux) {
                  final d = s.debut.toLocal();
                  days.putIfAbsent(DateTime(d.year, d.month, d.day), () => []).add(s);
                }
                final today = DateTime.now();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: days.entries.map((e) {
                    final isToday = e.key.year == today.year && e.key.month == today.month && e.key.day == today.day;
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 6),
                        child: Text('${Fmt.weekday(e.key)} ${Fmt.dayMonth(e.key)}',
                            style: AppTextStyles.h3.copyWith(color: isToday ? AppColors.aframGold : null)),
                      ),
                      ...e.value.map((s) => _SlotCard(s)),
                    ]);
                  }).toList(),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  final TimetableSlot s;
  const _SlotCard(this.s);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final color = s.cancelled ? AppColors.error : s.postponed ? AppColors.warning : AppColors.aframPrimary;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(width: 5, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('${Fmt.time(s.debut)} – ${Fmt.time(s.fin)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: color)),
                  const Spacer(),
                  if (s.cancelled) StatusChip.status('ANNULE', l.cancelledClass),
                  if (s.postponed) StatusChip.status('REPORTE', l.postponedClass),
                ]),
                const SizedBox(height: 4),
                Text(s.matiere, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700, decoration: s.cancelled ? TextDecoration.lineThrough : null)),
                Text('${s.enseignant} · ${l.room(s.salle)} · ${s.campus}', style: AppTextStyles.bodySmall),
                if (s.motif != null) Text(s.motif!, style: AppTextStyles.bodySmall.copyWith(color: color, fontStyle: FontStyle.italic)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
