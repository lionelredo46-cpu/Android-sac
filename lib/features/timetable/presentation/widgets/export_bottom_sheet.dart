import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/ui.dart';
import '../../data/timetable_export_service.dart';
import '../../data/timetable_ics_generator.dart';
import '../../data/timetable_pdf_generator.dart';
import '../../data/timetable_repository.dart';
import '../../domain/timetable_models.dart';
import 'story_card.dart';

PdfLabels pdfLabelsOf(AppLocalizations l) => (
  title: l.ttPdfDocTitle,
  student: l.ttPdfStudent,
  matricule: l.ttPdfMatricule,
  group: l.ttPdfGroup,
  generatedOn: l.ttPdfGenerated,
  authentic: l.ttPdfAuthentic,
  verifyHint: l.ttPdfVerifyHint,
  cancelled: l.cancelledClass,
  postponed: l.postponedClass,
  teacher: l.ttTeacher,
  room: l.ttRoomLabel,
  time: l.ttPdfTime,
  course: l.ttPdfCourse,
  status: l.ttPdfStatus,
  noClass: l.ttNoClassWeek,
  page: l.ttPdfPage,
);

IcsLabels icsLabelsOf(AppLocalizations l) => (teacher: l.ttTeacher, room: l.ttRoomLabel, reminder: l.ttReminder, cancelled: l.cancelledClass);

/// Locale `intl` des documents générés.
String exportLocaleOf(BuildContext context) => Localizations.localeOf(context).languageCode == 'en' ? 'en' : 'fr_FR';

/// Partage un fichier (feuille de partage système ; ancrée sur l'élément touché sur tablette).
Future<void> shareExportFile(BuildContext context, File file, {required String mimeType, String? subject}) async {
  final box = context.findRenderObject() as RenderBox?;
  await Share.shareXFiles(
    [XFile(file.path, mimeType: mimeType)],
    subject: subject,
    sharePositionOrigin: box == null || !box.hasSize ? null : box.localToGlobal(Offset.zero) & box.size,
  );
}

/// Exporte des créneaux au format iCalendar et ouvre la feuille de partage (agendas).
Future<void> shareIcs(BuildContext context, WidgetRef ref, TimetableExportRequest request, List<TimetableSlot> slots, {int weeks = 1}) async {
  final l = context.l10n;
  final service = ref.read(timetableExportServiceProvider);
  final ics = service.ics(request, slots, icsLabelsOf(l), calendarName: l.ttCalendarName(request.studentName), weeks: weeks);
  // RFC 5545 §3.1.4 : le flux iCalendar est encodé en UTF-8.
  final file = await service.writeTemp(TimetableExportService.fileName(request, 'ics'), utf8.encode(ics));
  if (context.mounted) await shareExportFile(context, file, mimeType: 'text/calendar', subject: l.ttCalendarName(request.studentName));
}

/// Ouvre le hub d'export (feuille modale ; largeur bornée sur tablette et bureau).
Future<void> showExportHub(BuildContext context, {required TimetableExportRequest request, required List<TimetableSlot> slots}) {
  HapticFeedback.mediumImpact();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (sheetContext) => Theme(
      data: ObsidianTheme.of(Theme.of(context)),
      child: ExportBottomSheet(request: request, slots: slots),
    ),
  );
}

/// Hub d'exportation : PDF vectoriel, fichier iCalendar, image story / carte.
class ExportBottomSheet extends ConsumerStatefulWidget {
  final TimetableExportRequest request;
  final List<TimetableSlot> slots;
  const ExportBottomSheet({super.key, required this.request, required this.slots});

  @override
  ConsumerState<ExportBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends ConsumerState<ExportBottomSheet> {
  PdfLayout _layout = PdfLayout.landscape;
  ImageFormat _format = ImageFormat.story;

  /// Portée de l'export agenda : la semaine affichée ou les 8 prochaines (limite de 2 mois de l'API).
  int _icsWeeks = 1;
  ExportChannel? _busy;
  final _storyKey = GlobalKey();

  List<TimetableSlot> get _week => TimetablePdfGenerator.weekSlots(widget.request, widget.slots);

  Future<void> _run(ExportChannel channel, Future<void> Function() job) async {
    if (_busy != null) return;
    setState(() => _busy = channel);
    try {
      await job();
      HapticFeedback.mediumImpact();
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _openPdf() => _run(ExportChannel.pdf, () async {
    final request = widget.request.copyWith(channel: ExportChannel.pdf, layout: _layout);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Theme(
          data: ObsidianTheme.of(Theme.of(context)),
          child: TimetablePdfPreviewPage(request: request, slots: widget.slots),
        ),
      ),
    );
  });

  Future<void> _shareIcs(BuildContext buttonContext) => _run(ExportChannel.ics, () async {
    final r = widget.request.copyWith(channel: ExportChannel.ics);
    final start = r.weekStart;
    final slots = _icsWeeks == 1
        ? widget.slots
        : await ref.read(timetableRepositoryProvider).between(r.studentId, start, DateTime(start.year, start.month, start.day + 7 * _icsWeeks));
    if (buttonContext.mounted) await shareIcs(buttonContext, ref, r, slots, weeks: _icsWeeks);
  });

  Future<void> _shareImage(BuildContext buttonContext) => _run(ExportChannel.image, () async {
    final l = context.l10n;
    final service = ref.read(timetableExportServiceProvider);
    final png = await captureBoundary(_storyKey, pixelRatio: 1080 / StoryCard.sizeOf(_format).width);
    final request = widget.request.copyWith(channel: ExportChannel.image, imageFormat: _format);
    final file = await service.writeTemp(TimetableExportService.fileName(request, 'png'), png);
    if (buttonContext.mounted) await shareExportFile(buttonContext, file, mimeType: 'image/png', subject: l.ttStoryTitle);
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = widget.request;
    final range = '${Fmt.dayMonth(r.weekStart)} – ${Fmt.dayMonth(DateTime(r.weekStart.year, r.weekStart.month, r.weekStart.day + 5))}';
    final maxHeight = MediaQuery.sizeOf(context).height * 0.92;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: GlassContainer(
        blur: 20,
        padding: EdgeInsets.zero,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + MediaQuery.paddingOf(context).bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: ObsidianColors.textFaint, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.ttExportTitle, style: ObsidianText.display(size: 22)),
                        Text('${l.ttExportSubtitle(range)} · ${r.studentName}', maxLines: 2, overflow: TextOverflow.ellipsis, style: ObsidianText.body(size: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l.close,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: ObsidianColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ChannelCard(
                key: const Key('export-pdf'),
                icon: Icons.picture_as_pdf_rounded,
                title: l.ttPdfTitle,
                body: l.ttPdfBody,
                accent: ObsidianColors.sapphireLight,
                options: SegmentedButton<PdfLayout>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: PdfLayout.landscape, label: Text(l.ttLandscape), icon: const Icon(Icons.crop_landscape_rounded)),
                    ButtonSegment(value: PdfLayout.portrait, label: Text(l.ttPortrait), icon: const Icon(Icons.crop_portrait_rounded)),
                  ],
                  selected: {_layout},
                  onSelectionChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _layout = v.first);
                  },
                ),
                action: l.ttPreviewPdf,
                busy: _busy == ExportChannel.pdf,
                onAction: (_) => _openPdf(),
              ),
              _ChannelCard(
                key: const Key('export-ics'),
                icon: Icons.event_available_rounded,
                title: l.ttIcsTitle,
                body: l.ttIcsBody(r.alarmMinutes),
                accent: ObsidianColors.emerald,
                options: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: 1, label: Text(l.ttIcsScopeWeek)),
                    ButtonSegment(value: 8, label: Text(l.ttIcsScopeTerm)),
                  ],
                  selected: {_icsWeeks},
                  onSelectionChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _icsWeeks = v.first);
                  },
                ),
                action: l.ttIcsAction,
                busy: _busy == ExportChannel.ics,
                onAction: _shareIcs,
              ),
              _ChannelCard(
                key: const Key('export-image'),
                icon: Icons.auto_awesome_rounded,
                title: l.ttImageTitle,
                body: l.ttImageBody,
                accent: ObsidianColors.gold,
                prestige: true,
                options: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<ImageFormat>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(value: ImageFormat.story, label: Text(l.ttStory)),
                        ButtonSegment(value: ImageFormat.square, label: Text(l.ttSquare)),
                      ],
                      selected: {_format},
                      onSelectionChanged: (v) {
                        HapticFeedback.selectionClick();
                        setState(() => _format = v.first);
                      },
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: AnimatedSize(
                        duration: AppMotion.medium,
                        curve: AppMotion.emphasized,
                        child: SizedBox(
                          height: _format == ImageFormat.story ? 300 : 180,
                          child: FittedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: RepaintBoundary(
                                key: _storyKey,
                                child: StoryCard(format: _format, studentName: r.studentName, groupName: r.groupName, weekStart: r.weekStart, slots: _week),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                action: l.ttShareImage,
                busy: _busy == ExportChannel.image,
                onAction: _shareImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final Widget? options;
  final String action;
  final bool busy;
  final bool prestige;
  final void Function(BuildContext buttonContext) onAction;

  const _ChannelCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
    required this.action,
    required this.busy,
    required this.onAction,
    this.options,
    this.prestige = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: GlassContainer(
      blur: 0,
      padding: const EdgeInsets.all(16),
      borderGradient: LinearGradient(colors: [accent.withValues(alpha: 0.45), accent.withValues(alpha: 0.08)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: ObsidianText.title(size: 16)),
                    const SizedBox(height: 2),
                    Text(body, style: ObsidianText.body(size: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          if (options != null) ...[const SizedBox(height: 14), options!],
          const SizedBox(height: 14),
          Builder(
            builder: (buttonContext) => FilledButton(
              onPressed: busy ? null : () => onAction(buttonContext),
              style: prestige ? FilledButton.styleFrom(backgroundColor: ObsidianColors.gold, foregroundColor: ObsidianColors.abyss) : null,
              child: AnimatedSwitcher(
                duration: AppMotion.fast,
                child: busy
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                    : Text(action, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Aperçu plein écran du PDF : zoom, impression physique et partage (package printing).
class TimetablePdfPreviewPage extends ConsumerStatefulWidget {
  final TimetableExportRequest request;
  final List<TimetableSlot> slots;
  const TimetablePdfPreviewPage({super.key, required this.request, required this.slots});

  @override
  ConsumerState<TimetablePdfPreviewPage> createState() => _TimetablePdfPreviewPageState();
}

class _TimetablePdfPreviewPageState extends ConsumerState<TimetablePdfPreviewPage> {
  Future<Uint8List>? _pdf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pdf ??= ref.read(timetableExportServiceProvider).pdf(widget.request, widget.slots, pdfLabelsOf(context.l10n), locale: exportLocaleOf(context));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ObsidianColors.abyss,
    appBar: AppBar(title: Text(context.l10n.ttPdfTitle, style: ObsidianText.title())),
    body: PdfPreview(
      build: (_) => _pdf!,
      pdfFileName: TimetableExportService.fileName(widget.request, 'pdf'),
      canChangeOrientation: false,
      canChangePageFormat: false,
      canDebug: false,
      scrollViewDecoration: const BoxDecoration(color: ObsidianColors.abyss),
      loadingWidget: const CircularProgressIndicator(color: ObsidianColors.sapphireLight),
    ),
  );
}

/// Aperçu PDF en direct (panneau latéral) : rendu uniquement quand la semaine ou le contenu change.
class LivePdfPreview extends ConsumerStatefulWidget {
  final TimetableExportRequest request;
  final List<TimetableSlot> slots;
  const LivePdfPreview({super.key, required this.request, required this.slots});

  @override
  ConsumerState<LivePdfPreview> createState() => _LivePdfPreviewState();
}

class _LivePdfPreviewState extends ConsumerState<LivePdfPreview> {
  String? _signature;
  late LayoutCallback _build;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  @override
  void didUpdateWidget(LivePdfPreview old) {
    super.didUpdateWidget(old);
    _refresh();
  }

  void _refresh() {
    final week = TimetablePdfGenerator.weekSlots(widget.request, widget.slots);
    final signature = '${widget.request.hashCode}:${TimetablePdfGenerator.fingerprint(widget.request, week)}';
    if (signature == _signature) return;
    _signature = signature;
    final future = ref.read(timetableExportServiceProvider).pdf(widget.request, widget.slots, pdfLabelsOf(context.l10n), locale: exportLocaleOf(context));
    _build = (_) => future;
  }

  @override
  Widget build(BuildContext context) => PdfPreview(
    build: _build,
    useActions: false,
    maxPageWidth: 340,
    previewPageMargin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
    scrollViewDecoration: const BoxDecoration(color: Colors.transparent),
    loadingWidget: const CircularProgressIndicator(color: ObsidianColors.sapphireLight),
  );
}
