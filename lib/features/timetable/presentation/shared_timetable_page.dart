import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/obsidian_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../domain/nfc_payload.dart';
import '../domain/timetable_models.dart';
import 'timetable_controller.dart';
import 'widgets/export_bottom_sheet.dart';
import 'widgets/timetable_mobile_view.dart';

/// Emploi du temps reçu par Tap-to-Sync : consultation et ajout à l'agenda.
class SharedTimetablePage extends ConsumerWidget {
  final NfcTimetableShare share;
  const SharedTimetablePage({super.key, required this.share});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final slots = [for (final s in share.slots) s.toSlot(share.owner)];
    final data = TimetableViewData(
      state: TimetableViewState(weekStart: share.weekStart, selectedDay: share.weekStart),
      now: ref.watch(clockProvider),
      slots: slots,
    );
    final request = TimetableExportRequest(channel: ExportChannel.ics, weekStart: share.weekStart, studentId: 'nfc', studentName: share.owner, groupName: share.group);

    return Theme(
      data: ObsidianTheme.of(Theme.of(context)),
      child: Scaffold(
        backgroundColor: ObsidianColors.scaffold(context),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.ttSharedTitle, style: ObsidianText.title()),
              Text(
                l.ttSharedBy(share.owner, Fmt.dateTime(share.sharedAt)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ObsidianText.label(color: ObsidianColors.goldLight),
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (buttonContext) => IconButton(
                tooltip: l.ttAddToCalendar,
                icon: const Icon(Icons.event_available_rounded),
                onPressed: () => shareIcs(buttonContext, ref, request, slots).catchError((Object e) {
                  if (context.mounted) context.showError(e);
                }),
              ),
            ),
          ],
        ),
        body: DecoratedBox(
          decoration: ObsidianColors.backdrop(context),
          child: WeekAgenda(data: data, onSlotTap: (_) {}, padding: const EdgeInsets.only(bottom: 32)),
        ),
      ),
    );
  }
}
