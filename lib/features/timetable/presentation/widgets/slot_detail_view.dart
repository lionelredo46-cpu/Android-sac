import 'package:flutter/material.dart';

import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pulsing_indicator.dart';
import '../../../../core/widgets/ui.dart';
import '../../domain/timetable_models.dart';

/// Détail complet d'un cours (panneau latéral sur tablette, page dédiée sur mobile).
class SlotDetailView extends StatelessWidget {
  final TimetableSlot slot;
  final DateTime now;
  final String? attendance;
  final VoidCallback onAddToCalendar;
  final VoidCallback onCheckRoom;
  final VoidCallback? onClose;

  /// Carte d'en-tête (la carte du cours en mobile, pour la transition Hero).
  final Widget? leading;

  const SlotDetailView({super.key, required this.slot, required this.now, required this.onAddToCalendar, required this.onCheckRoom, this.attendance, this.onClose, this.leading});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final accent = ObsidianColors.forStatus(slot.statut, slot.code);
    final live = slot.isLive(now);
    final attendanceLabel = switch (attendance) {
      'PRESENT' => (l.ttPresent, ObsidianColors.emerald),
      'RETARD' => (l.ttLate, ObsidianColors.amber),
      'ABSENT' => (l.ttAbsent, ObsidianColors.ruby),
      'EXCUSE' => (l.ttExcused, ObsidianColors.sapphireLight),
      _ => (l.ttAttendancePending, ObsidianColors.textMuted),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) leading!,
        if (leading == null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 5,
                height: 46,
                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (live)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: LiveBadge(label: l.ttLiveNow),
                      ),
                    Text(slot.matiere, style: ObsidianText.title(size: 19)),
                    Text(slot.code, style: ObsidianText.label(color: ObsidianColors.textFaint)),
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  tooltip: l.close,
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded, color: ObsidianColors.textMuted),
                ),
            ],
          ),
        const SizedBox(height: 16),
        _row(Icons.event_rounded, Fmt.weekday(slot.debut), Fmt.date(slot.debut)),
        _row(Icons.schedule_rounded, '${Fmt.time(slot.debut)} – ${Fmt.time(slot.fin)}', '${l.ttDuration} : ${l.ttMinutes(slot.minutes)}'),
        _row(Icons.meeting_room_rounded, l.room(slot.salle), '${l.ttCampus} ${slot.campus}'),
        _row(Icons.person_rounded, slot.enseignant, l.ttTeacher),
        _row(Icons.how_to_reg_rounded, attendanceLabel.$1, l.ttAttendanceLabel, color: attendanceLabel.$2),
        if (slot.cancelled || slot.postponed)
          _row(slot.cancelled ? Icons.block_rounded : Icons.update_rounded, slot.cancelled ? l.cancelledClass : l.postponedClass, slot.motif ?? '', color: accent),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(onPressed: onAddToCalendar, icon: const Icon(Icons.event_available_rounded, size: 18), label: Text(l.ttAddToCalendar)),
            OutlinedButton.icon(onPressed: onCheckRoom, icon: const Icon(Icons.nfc_rounded, size: 18), label: Text(l.ttCheckRoom)),
          ],
        ),
      ],
    );
  }

  static Widget _row(IconData icon, String title, String subtitle, {Color color = ObsidianColors.sapphireLight}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 19, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: ObsidianText.title(size: 14.5)),
              if (subtitle.isNotEmpty) Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: ObsidianText.body(size: 12.5)),
            ],
          ),
        ),
      ],
    ),
  );
}
