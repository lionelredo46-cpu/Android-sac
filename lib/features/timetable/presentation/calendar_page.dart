import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../data/timetable_repository.dart';
import '../domain/timetable_models.dart';

/// Calendrier académique : rentrée, examens, vacances, échéances, réunions parents.
class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  static (IconData, Color) styleOf(String type) => switch (type) {
        'EXAMEN' => (Icons.edit_document, AppColors.error),
        'VACANCES' => (Icons.beach_access_rounded, AppColors.success),
        'FERIE' => (Icons.flag_rounded, AppColors.info),
        'ECHEANCE_PAIEMENT' => (Icons.payments_rounded, AppColors.warning),
        'REUNION_PARENTS' => (Icons.groups_rounded, const Color(0xFF8B7BFF)),
        'RENTREE' => (Icons.school_rounded, AppColors.aframGold),
        _ => (Icons.event_rounded, AppColors.info),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.calendarTitle)),
      body: CachedAsyncView<List<CalendarEvent>>(
        value: ref.watch(calendarEventsProvider),
        onRetry: () => ref.invalidate(calendarEventsProvider),
        isEmpty: (e) => e.isEmpty,
        emptyIcon: Icons.event_busy_rounded,
        builder: (context, events) {
          final now = DateTime.now();
          final upcoming = events.where((e) => e.fin.isAfter(now)).toList();
          final past = events.where((e) => !e.fin.isAfter(now)).toList().reversed.toList();
          return ListView(padding: const EdgeInsets.fromLTRB(16, 6, 16, 28), children: [
            for (var i = 0; i < upcoming.length; i++) Reveal(index: i, child: _EventTile(upcoming[i], first: i == 0)),
            if (past.isNotEmpty) ...[
              const SectionLabel('Passé'),
              for (final e in past) Opacity(opacity: 0.55, child: _EventTile(e)),
            ],
          ]);
        },
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final CalendarEvent e;
  final bool first;
  const _EventTile(this.e, {this.first = false});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final (icon, color) = CalendarPage.styleOf(e.type);
    final d = e.debut.toLocal();
    final sameDay = d.day == e.fin.toLocal().day && e.fin.difference(e.debut).inHours < 24;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      borderColor: first ? s.gold.withValues(alpha: 0.55) : null,
      glow: first ? s.gold : null,
      child: Row(children: [
        Container(
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0.06)]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.45)),
          ),
          child: Column(children: [
            Text('${d.day}', style: AppTextStyles.h2.copyWith(color: s.text, fontSize: 22)),
            Text(Fmt.dayMonth(d).replaceAll(RegExp(r'[0-9.\s]'), '').toUpperCase(), maxLines: 1, style: AppTextStyles.overline.copyWith(color: color, fontSize: 9.5, letterSpacing: 1)),
          ]),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(child: Text(e.titre, style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: FontWeight.w700))),
            ]),
            const SizedBox(height: 3),
            Text(sameDay ? Fmt.date(e.debut) : '${Fmt.date(e.debut)} → ${Fmt.date(e.fin)}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
          ]),
        ),
      ]),
    );
  }
}
