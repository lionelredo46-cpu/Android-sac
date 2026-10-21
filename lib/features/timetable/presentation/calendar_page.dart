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
        'REUNION_PARENTS' => (Icons.groups_rounded, AppColors.aframPrimary),
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
        builder: (context, events) {
          final now = DateTime.now();
          final upcoming = events.where((e) => e.fin.isAfter(now)).toList();
          final past = events.where((e) => !e.fin.isAfter(now)).toList().reversed;
          return ListView(padding: const EdgeInsets.all(16), children: [
            ...upcoming.map((e) => _EventTile(e)),
            if (past.isNotEmpty) ...[
              const Divider(height: 32),
              ...past.map((e) => Opacity(opacity: 0.55, child: _EventTile(e))),
            ],
          ]);
        },
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final CalendarEvent e;
  const _EventTile(this.e);

  @override
  Widget build(BuildContext context) {
    final (icon, color) = CalendarPage.styleOf(e.type);
    final sameDay = e.debut.toLocal().day == e.fin.toLocal().day && e.fin.difference(e.debut).inHours < 24;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.14), child: Icon(icon, color: color)),
        title: Text(e.titre, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
        subtitle: Text(sameDay ? Fmt.date(e.debut) : '${Fmt.date(e.debut)} → ${Fmt.date(e.fin)}'),
      ),
    );
  }
}
