import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/obsidian_theme.dart';
import '../../../core/widgets/ui.dart';
import '../../children/application/children_providers.dart';
import '../domain/timetable_models.dart';
import 'timetable_controller.dart';
import 'widgets/export_bottom_sheet.dart';
import 'widgets/slot_detail_view.dart';
import 'widgets/timetable_slot_card.dart';

/// Action demandée depuis le détail et exécutée par la page Emploi du temps au retour.
enum SlotDetailAction { checkRoom }

/// Détail d'un cours (mobile) : la carte « s'ouvre » par une transition Hero.
class SlotDetailPage extends ConsumerWidget {
  final TimetableSlot slot;
  const SlotDetailPage({super.key, required this.slot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final now = ref.watch(clockProvider);
    final child = ref.watch(activeChildProvider);
    final attendance = child == null ? null : ref.watch(attendanceBySlotProvider(child.id))[attendanceKey(slot.code, slot.debut)];

    return Theme(
      data: ObsidianTheme.of(Theme.of(context)),
      child: Scaffold(
        backgroundColor: ObsidianColors.abyss,
        appBar: AppBar(title: Text(l.ttSlotDetail, style: ObsidianText.title())),
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: ObsidianColors.background),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              SlotDetailView(
                slot: slot,
                now: now,
                attendance: attendance,
                leading: SizedBox(
                  height: 168,
                  child: TimetableSlotCard(slot: slot, now: now, attendance: attendance),
                ),
                onAddToCalendar: () {
                  if (child == null) return;
                  final request = TimetableExportRequest(
                    channel: ExportChannel.ics,
                    weekStart: mondayOf(slot.debut.toLocal()),
                    studentId: child.id,
                    studentName: '${child.prenom} ${child.nom}',
                  );
                  shareIcs(context, ref, request, [slot]).catchError((Object e) {
                    if (context.mounted) context.showError(e);
                  });
                },
                onCheckRoom: () => context.pop(SlotDetailAction.checkRoom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
