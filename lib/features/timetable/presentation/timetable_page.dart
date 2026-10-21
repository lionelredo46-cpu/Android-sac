import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/obsidian_theme.dart';
import '../../../core/widgets/ui.dart';
import '../../children/application/children_providers.dart';
import '../../children/domain/child.dart';
import '../../children/presentation/child_scope.dart';
import '../data/timetable_repository.dart';
import '../domain/nfc_payload.dart';
import '../domain/timetable_models.dart';
import 'nfc_controller.dart';
import 'slot_detail_page.dart';
import 'timetable_controller.dart';
import 'widgets/export_bottom_sheet.dart';
import 'widgets/nfc_radar_sheet.dart';
import 'widgets/timetable_desktop_view.dart';
import 'widgets/timetable_mobile_view.dart';

/// Emploi du temps « Obsidian » : timeline mobile (< 600 px), grille hebdomadaire au-delà.
///
/// Liens profonds : `/timetable?week=2026-10-19&sheet=export|nfc&nfc=room|sync|attendance|card`,
/// et `/salle/<code>` (tag NFC de salle lu application fermée).
class TimetablePage extends ConsumerStatefulWidget {
  final String? initialWeek;
  final String? sheet;
  final String? nfcMode;
  final String? roomCode;

  const TimetablePage({super.key, this.initialWeek, this.sheet, this.nfcMode, this.roomCode});

  static const breakpoint = 600.0;

  @override
  ConsumerState<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends ConsumerState<TimetablePage> {
  bool _deepLinkHandled = false;

  TimetableController get _controller => ref.read(timetableControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    final week = DateTime.tryParse(widget.initialWeek ?? '');
    if (week != null) WidgetsBinding.instance.addPostFrameCallback((_) => _controller.show(week));
  }

  TimetableExportRequest _request(Child child, DateTime weekStart) => TimetableExportRequest(
    channel: ExportChannel.pdf,
    weekStart: weekStart,
    studentId: child.id,
    studentName: '${child.prenom} ${child.nom}',
    matricule: child.matricule,
    groupName: child.group.nom,
    programName: child.group.program.nom,
  );

  /// Cours du jour, même si une autre semaine est affichée. Lecture directe (cache hors ligne compris) :
  /// le provider autoDispose de la semaine courante ne serait écouté par personne et serait libéré en cours de chargement.
  Future<List<TimetableSlot>> _todaySlots(Child child) async {
    final now = DateTime.now();
    final timetable = await ref.read(timetableRepositoryProvider).week(child.id, mondayOf(now));
    return timetable.data.creneaux.where((s) => s.day == DateTime(now.year, now.month, now.day)).toList();
  }

  Future<void> _openNfc(Child child, List<TimetableSlot> weekSlots, {NfcMode mode = NfcMode.room}) async {
    final state = ref.read(timetableControllerProvider);
    List<TimetableSlot> today = const [];
    try {
      today = await _todaySlots(child);
    } catch (_) {
      // Hors ligne sans cache : la vérification de salle indiquera « aucun cours ».
    }
    if (!mounted) return;
    await showNfcRadar(
      context,
      NfcRadarArgs(
        child: child,
        children: ref.read(childrenProvider).value?.data ?? [child],
        todaySlots: today,
        weekSlots: weekSlots,
        weekStart: state.weekStart,
        openChildAgenda: (c) async {
          await ref.read(activeChildIdProvider.notifier).select(c.id);
          _controller.goToToday();
        },
        openShared: (share) => context.push(RoutePaths.timetableShared, extra: share),
      ),
      initialMode: mode,
    );
  }

  /// Tag de salle lu hors application : résultat immédiat, sans nouveau scan.
  Future<void> _openRoomCheck(Child child, String roomCode) async {
    final today = await _todaySlots(child).catchError((Object _) => <TimetableSlot>[]);
    if (!mounted) return;
    final check = checkRoom(roomCode, today, DateTime.now());
    HapticFeedback.mediumImpact();
    final l = context.l10n;
    context.showSnack(
      check.isMine
          ? '${l.ttRoomYes} — ${l.room(roomCode)}'
          : check.reference == null
          ? '${l.ttRoomNo} — ${l.ttRoomNoCourse}'
          : '${l.ttRoomNo} — ${l.ttRoomExpected(check.reference!.matiere, check.reference!.salle, check.reference!.campus)}',
    );
  }

  /// Ouvre une seule fois la cible d'un lien profond. La vérification de salle charge elle-même les cours
  /// du jour ; les feuilles attendent la semaine (ou son échec, hors ligne sans cache).
  void _handleDeepLink(Child child, AsyncValue<Object?> week, List<TimetableSlot>? slots, DateTime weekStart) {
    final room = widget.roomCode;
    if (_deepLinkHandled || (room == null && widget.sheet == null)) return;
    if (room == null && slots == null && !week.hasError) return;
    _deepLinkHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (room != null) {
        _openRoomCheck(child, room);
      } else if (widget.sheet == 'export') {
        showExportHub(context, request: _request(child, weekStart), slots: slots ?? const []);
      } else if (widget.sheet == 'nfc') {
        _openNfc(child, slots ?? const [], mode: NfcMode.values.asNameMap()[widget.nfcMode] ?? NfcMode.room);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChildScope(
      builder: (context, child) {
        final state = ref.watch(timetableControllerProvider);
        final async = ref.watch(timetableProvider((childId: child.id, monday: state.weekStart)));
        final cached = async.value;
        final slots = cached?.data.creneaux;
        _handleDeepLink(child, async, slots, state.weekStart);

        final data = TimetableViewData(
          state: state,
          now: ref.watch(clockProvider),
          slots: slots,
          error: async.error,
          staleSince: cached != null && cached.fromCache ? cached.updatedAt : null,
          attendance: ref.watch(attendanceBySlotProvider(child.id)),
        );
        final request = _request(child, state.weekStart);
        final title = l.timetableTitle;
        final subtitle = '${child.prenom} ${child.nom} · ${child.group.nom}';

        return Theme(
          data: ObsidianTheme.of(Theme.of(context)),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(
              backgroundColor: ObsidianColors.abyss,
              body: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= TimetablePage.breakpoint;
                  final actions = TimetableViewActions(
                    openSlot: (slot) async {
                      _controller.selectSlot(slot.id);
                      if (wide) return;
                      final action = await context.push<SlotDetailAction>(RoutePaths.timetableSlot(slot.id), extra: slot);
                      if (action == SlotDetailAction.checkRoom && context.mounted) await _openNfc(child, slots ?? const []);
                    },
                    shiftWeek: _controller.shiftWeek,
                    selectDay: (d) {
                      HapticFeedback.selectionClick();
                      _controller.selectDay(d);
                    },
                    goToToday: _controller.goToToday,
                    toggleMode: _controller.toggleMobileMode,
                    openNfc: () => _openNfc(child, slots ?? const []),
                    openExport: () => showExportHub(context, request: request, slots: slots ?? const []),
                    retry: () => ref.invalidate(timetableProvider((childId: child.id, monday: state.weekStart))),
                    back: context.canPop() ? () => context.pop() : null,
                  );
                  if (!wide) return TimetableMobileView(title: title, subtitle: subtitle, data: data, actions: actions);
                  return TimetableDesktopView(
                    title: title,
                    subtitle: subtitle,
                    data: data,
                    actions: actions,
                    onSelectNone: () => _controller.selectSlot(null),
                    togglePanel: _controller.togglePanel,
                    exportPreview: slots == null ? const SizedBox.shrink() : LivePdfPreview(request: request, slots: slots),
                    addToCalendar: (slot) => shareIcs(context, ref, request.copyWith(channel: ExportChannel.ics), [slot]).catchError((Object e) {
                      if (context.mounted) context.showError(e);
                    }),
                    checkRoom: (_) => _openNfc(child, slots ?? const []),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
