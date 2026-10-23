import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/flavor_config.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/spring_pressable.dart';
import '../../../../core/widgets/ui.dart';
import '../../../children/domain/child.dart';
import '../../data/nfc_service.dart';
import '../../domain/nfc_payload.dart';
import '../../domain/timetable_models.dart';
import '../nfc_controller.dart';

/// Données nécessaires au hub NFC (fournies par la page Emploi du temps).
class NfcRadarArgs {
  final Child child;
  final List<Child> children;
  final List<TimetableSlot> todaySlots;
  final List<TimetableSlot> weekSlots;
  final DateTime weekStart;
  final ValueChanged<Child> openChildAgenda;
  final ValueChanged<NfcTimetableShare> openShared;

  const NfcRadarArgs({
    required this.child,
    required this.children,
    required this.todaySlots,
    required this.weekSlots,
    required this.weekStart,
    required this.openChildAgenda,
    required this.openShared,
  });

  NfcScanContext get scanContext => (child: child, children: children, todaySlots: todaySlots);

  NfcTimetableShare share(DateTime now) =>
      NfcPayload.timetableShare(
            owner: '${child.prenom} ${child.nom}',
            group: child.group.nom,
            weekStart: weekStart,
            sharedAt: now,
            slots: weekSlots.map(SharedSlot.fromSlot).toList(),
          )
          as NfcTimetableShare;
}

Future<void> showNfcRadar(BuildContext context, NfcRadarArgs args, {NfcMode initialMode = NfcMode.room}) {
  HapticFeedback.mediumImpact();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (_) => Theme(
      data: ObsidianTheme.of(Theme.of(context)),
      child: NfcRadarSheet(args: args, initialMode: initialMode),
    ),
  );
}

/// Hub NFC : radar orbital, quatre usages (Tap-to-Sync, salle, émargement, carte étudiant).
class NfcRadarSheet extends ConsumerStatefulWidget {
  final NfcRadarArgs args;
  final NfcMode initialMode;
  const NfcRadarSheet({super.key, required this.args, this.initialMode = NfcMode.room});

  @override
  ConsumerState<NfcRadarSheet> createState() => _NfcRadarSheetState();
}

class _NfcRadarSheetState extends ConsumerState<NfcRadarSheet> {
  late NfcMode _mode = widget.initialMode;
  bool _sending = false;
  NfcStatus? _status;
  bool _canShare = false;

  NfcScanController get _controller => ref.read(nfcScanControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _probe();
  }

  Future<void> _probe() async {
    final status = await _controller.status();
    final canShare = await _controller.canShare();
    if (!mounted) return;
    setState(() {
      _status = status;
      _canShare = canShare;
    });
  }

  /// Démonstration sans puce NFC : un tag cohérent avec le mode choisi est « lu ».
  void _simulate() {
    final a = widget.args;
    _controller.simulate(
      SimulatedNfcTimetableService(
        () => switch (_mode) {
          NfcMode.sync => NfcPayload.timetableShare(
            owner: 'Lucie MBA',
            group: a.child.group.nom,
            weekStart: a.weekStart,
            sharedAt: DateTime.now(),
            slots: a.weekSlots.map(SharedSlot.fromSlot).toList(),
          ),
          // Salle du cours en cours ou à venir, sinon d'un cours du jour : la démo montre un cas parlant.
          NfcMode.room => NfcPayload.room(
            roomCode: checkRoom('', a.todaySlots, DateTime.now()).reference?.salle ?? a.todaySlots.firstOrNull?.salle ?? a.weekSlots.firstOrNull?.salle ?? 'S104',
          ),
          NfcMode.attendance => NfcPayload.attendance(code: 'DEMO-${DateTime.now().millisecondsSinceEpoch}'),
          NfcMode.card => const NfcPayload.studentCard(uid: '04:A2:19:6B:3C:5E:80', technology: 'mifare_desfire'),
        },
      ),
    );
    setState(() => _status = NfcStatus.available);
    _primary();
  }

  void _primary() {
    final l = context.l10n;
    final state = ref.read(nfcScanControllerProvider);
    if (state is NfcScanning || state is NfcSharing) {
      _controller.reset();
      return;
    }
    if (_mode == NfcMode.sync && _sending) {
      _controller.startSharing(widget.args.share(DateTime.now()));
      return;
    }
    _controller.scan(widget.args.scanContext, iosPrompt: l.ttNfcIosPrompt, iosSuccess: l.ttNfcIosSuccess);
  }

  void _setMode(NfcMode mode) {
    if (mode == _mode) return;
    HapticFeedback.selectionClick();
    _controller.reset();
    setState(() => _mode = mode);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(nfcScanControllerProvider);
    ref.listen(nfcScanControllerProvider, (_, next) {
      switch (next) {
        case NfcAttendanceResult():
          HapticFeedback.heavyImpact(); // émargement confirmé
        case NfcRoomResult() || NfcCardResult() || NfcShareReceived():
          HapticFeedback.mediumImpact();
        case NfcFailed():
          HapticFeedback.lightImpact();
        default:
      }
    });
    final unavailable = _status != null && _status != NfcStatus.available;
    final demo = FlavorConfig.testTools;
    final busy = state is NfcScanning || state is NfcSharing;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.94),
      child: GlassContainer(
        blur: 22,
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
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.nfc_rounded, color: ObsidianColors.sapphireLight),
                  const SizedBox(width: 8),
                  Expanded(child: Text(l.ttNfcTitle, style: ObsidianText.display(size: 22))),
                  IconButton(
                    tooltip: l.close,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: ObsidianColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Hauteur commune : un libellé sur deux lignes (« Carte étudiant ») n'agrandit pas une seule puce.
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final m in NfcMode.values)
                      Expanded(
                        child: _ModeChip(mode: m, selected: m == _mode, label: _modeLabel(l, m), icon: _modeIcon(m), onTap: () => _setMode(m)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: LayoutBuilder(
                  builder: (_, c) => NfcRadar(size: math.min(c.maxWidth - 40, 240), tone: _tone(state), active: busy || state is NfcIdle),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: AppMotion.medium,
                child: Text(
                  _instruction(l, state),
                  key: ValueKey('${_mode.name}-${state.runtimeType}-$_sending'),
                  textAlign: TextAlign.center,
                  style: ObsidianText.body(size: 14, color: ObsidianColors.text),
                ),
              ),
              if (_mode == NfcMode.sync && state is! NfcShareReceived) ...[
                const SizedBox(height: 14),
                SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: false, label: Text(l.ttNfcReceive), icon: const Icon(Icons.download_rounded)),
                    ButtonSegment(value: true, label: Text(l.ttNfcShare), icon: const Icon(Icons.upload_rounded), enabled: _canShare),
                  ],
                  selected: {_sending},
                  onSelectionChanged: busy
                      ? null
                      : (v) {
                          HapticFeedback.selectionClick();
                          setState(() => _sending = v.first);
                        },
                ),
                if (!_canShare && _status != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(l.ttNfcShareUnavailable, textAlign: TextAlign.center, style: ObsidianText.body(size: 12)),
                  ),
              ],
              AnimatedSize(
                duration: AppMotion.medium,
                curve: AppMotion.emphasized,
                child: AnimatedSwitcher(
                  duration: AppMotion.medium,
                  transitionBuilder: (c, a) => FadeTransition(
                    opacity: a,
                    child: SlideTransition(
                      position: Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(a),
                      child: c,
                    ),
                  ),
                  child: KeyedSubtree(key: ValueKey(state), child: _result(l, state)),
                ),
              ),
              const SizedBox(height: 16),
              if (unavailable && !_controller.simulating) ...[
                _Notice(icon: Icons.portable_wifi_off_rounded, text: _status == NfcStatus.disabled ? l.ttNfcDisabled : l.ttNfcUnavailable),
                if (demo) ...[
                  const SizedBox(height: 12),
                  FilledButton.icon(key: const Key('nfc-simulate'), onPressed: _simulate, icon: const Icon(Icons.science_rounded), label: Text(l.ttNfcSimulate)),
                ],
              ] else
                FilledButton.icon(
                  key: const Key('nfc-primary'),
                  onPressed: _status == null ? null : _primary,
                  style: _mode == NfcMode.sync && _sending ? FilledButton.styleFrom(backgroundColor: ObsidianColors.gold, foregroundColor: ObsidianColors.abyss) : null,
                  icon: Icon(busy ? Icons.stop_rounded : (state is NfcIdle ? Icons.sensors_rounded : Icons.refresh_rounded)),
                  label: Text(
                    busy
                        ? (state is NfcSharing ? l.ttNfcStopSharing : l.cancel)
                        : state is NfcIdle
                        ? (_mode == NfcMode.sync && _sending ? l.ttNfcShare : l.ttNfcScan)
                        : l.ttNfcRetry,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _modeLabel(AppLocalizations l, NfcMode m) => switch (m) {
    NfcMode.sync => l.ttNfcSync,
    NfcMode.room => l.ttNfcRoom,
    NfcMode.attendance => l.ttNfcAttendance,
    NfcMode.card => l.ttNfcCard,
  };

  static IconData _modeIcon(NfcMode m) => switch (m) {
    NfcMode.sync => Icons.swap_horiz_rounded,
    NfcMode.room => Icons.meeting_room_rounded,
    NfcMode.attendance => Icons.how_to_reg_rounded,
    NfcMode.card => Icons.badge_rounded,
  };

  static Color _tone(NfcScanState s) => switch (s) {
    NfcSharing() => ObsidianColors.gold,
    NfcFailed() => ObsidianColors.ruby,
    NfcRoomResult(:final check) => check.isMine ? ObsidianColors.emerald : ObsidianColors.amber,
    NfcAttendanceResult() || NfcCardResult() || NfcShareReceived() => ObsidianColors.emerald,
    _ => ObsidianColors.sapphireLight,
  };

  String _instruction(AppLocalizations l, NfcScanState s) => switch (s) {
    NfcScanning() => l.ttNfcScanning,
    NfcSharing() => l.ttNfcSharing,
    NfcFailed(:final failure, :final message) =>
      message ??
          switch (failure) {
            NfcFailure.timeout => l.ttNfcTimeout,
            NfcFailure.cancelled => l.ttNfcCancelled,
            NfcFailure.unsupported => l.ttNfcUnavailable,
            NfcFailure.tooLarge => l.ttNfcTooLarge,
            _ => l.ttNfcUnreadable,
          },
    NfcIdle() => switch (_mode) {
      NfcMode.sync => l.ttNfcSyncHint,
      NfcMode.room => l.ttNfcRoomHint,
      NfcMode.attendance => l.ttNfcAttendanceHint,
      NfcMode.card => l.ttNfcCardHint,
    },
    _ => '',
  };

  Widget _result(AppLocalizations l, NfcScanState s) => switch (s) {
    NfcRoomResult(:final check) => _ResultCard(
      key: const Key('nfc-result-room'),
      icon: check.isMine ? Icons.check_circle_rounded : Icons.wrong_location_rounded,
      color: check.isMine ? ObsidianColors.emerald : ObsidianColors.amber,
      title: check.isMine ? l.ttRoomYes : l.ttRoomNo,
      subtitle: l.room(check.roomCode),
      children: [
        if (!check.isMine)
          Text(
            check.reference == null ? l.ttRoomNoCourse : l.ttRoomExpected(check.reference!.matiere, check.reference!.salle, check.reference!.campus),
            style: ObsidianText.body(color: ObsidianColors.text),
          ),
        const SizedBox(height: 10),
        Text(check.inRoomToday.isEmpty ? l.ttRoomNone : l.ttRoomToday(check.roomCode), style: ObsidianText.label(color: ObsidianColors.goldLight)),
        for (final slot in check.inRoomToday)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Text('${Fmt.time(slot.debut)}–${Fmt.time(slot.fin)}', style: ObsidianText.time(size: 12.5, color: ObsidianColors.textMuted)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(slot.matiere, maxLines: 1, overflow: TextOverflow.ellipsis, style: ObsidianText.title(size: 13.5)),
                ),
              ],
            ),
          ),
      ],
    ),
    NfcAttendanceResult(:final statut, :final minutesRetard, :final course) => _ResultCard(
      key: const Key('nfc-result-attendance'),
      icon: Icons.verified_rounded,
      color: statut == 'RETARD' ? ObsidianColors.amber : ObsidianColors.emerald,
      title: l.ttAttendanceOk,
      subtitle: [if (course != null) course, if (statut == 'RETARD') l.ttAttendanceLate(minutesRetard) else l.ttPresent].join(' · '),
    ),
    NfcCardResult(:final card, :final child) => _ResultCard(
      key: const Key('nfc-result-card'),
      icon: child != null ? Icons.badge_rounded : Icons.help_outline_rounded,
      color: child != null ? ObsidianColors.emerald : ObsidianColors.sapphireLight,
      title: child != null ? l.ttCardLinked('${child.prenom} ${child.nom}') : l.ttCardUnknown,
      subtitle: l.ttCardUid(card.uid, card.technology),
      children: [
        if (child != null)
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              widget.args.openChildAgenda(child);
            },
            icon: const Icon(Icons.calendar_month_rounded, size: 18),
            label: Text(l.ttCardOpen),
          )
        else ...[
          Text(l.ttCardLinkHint, style: ObsidianText.body(size: 12.5)),
          const SizedBox(height: 8),
          for (final c in widget.args.children)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: OutlinedButton.icon(
                onPressed: () => _controller.linkCard(card, c),
                icon: const Icon(Icons.link_rounded, size: 18),
                label: Text(l.ttCardLinkTo('${c.prenom} ${c.nom}'), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
        ],
      ],
    ),
    NfcShareReceived(:final share) => _ResultCard(
      key: const Key('nfc-result-share'),
      icon: Icons.mark_email_read_rounded,
      color: ObsidianColors.emerald,
      title: l.ttShareReceived(share.owner),
      subtitle: '${l.ttClassesCount(share.slots.length)} · ${l.ttExportSubtitle(Fmt.dayMonth(share.weekStart))}',
      children: [
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            widget.args.openShared(share);
          },
          icon: const Icon(Icons.visibility_rounded, size: 18),
          label: Text(l.ttShareView),
        ),
      ],
    ),
    _ => const SizedBox(width: double.infinity),
  };
}

class _ModeChip extends StatelessWidget {
  final NfcMode mode;
  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ModeChip({required this.mode, required this.selected, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: SpringPressable(
      key: Key('nfc-mode-${mode.name}'),
      onTap: onTap,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: AppMotion.medium,
        curve: AppMotion.emphasized,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          gradient: selected ? ObsidianColors.sapphireGradient : null,
          color: selected ? null : ObsidianColors.surfaceHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? ObsidianColors.sapphireLight : ObsidianColors.hairline),
        ),
        child: ExcludeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: selected ? Colors.white : ObsidianColors.textMuted),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: ObsidianText.label(size: 11, color: selected ? Colors.white : ObsidianColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ResultCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final List<Widget> children;
  const _ResultCard({super.key, required this.icon, required this.color, required this.title, required this.subtitle, this.children = const []});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: GlassContainer(
      blur: 0,
      padding: const EdgeInsets.all(16),
      borderGradient: LinearGradient(colors: [color.withValues(alpha: 0.6), color.withValues(alpha: 0.1)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1),
                duration: AppMotion.slow,
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.16),
                    boxShadow: [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 18)],
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: ObsidianText.title(size: 17)),
                    if (subtitle.isNotEmpty) Text(subtitle, style: ObsidianText.body(size: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          if (children.isNotEmpty) ...[const SizedBox(height: 12), ...children],
        ],
      ),
    ),
  );
}

class _Notice extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Notice({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ObsidianColors.amber.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ObsidianColors.amber.withValues(alpha: 0.4)),
    ),
    child: Row(
      children: [
        Icon(icon, color: ObsidianColors.amber),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: ObsidianText.body(size: 13, color: ObsidianColors.text)),
        ),
      ],
    ),
  );
}

/// Radar orbital : anneaux concentriques, balayage rotatif, ondes et satellites.
class NfcRadar extends StatefulWidget {
  final double size;
  final Color tone;
  final bool active;
  const NfcRadar({super.key, required this.size, this.tone = ObsidianColors.sapphireLight, this.active = true});

  @override
  State<NfcRadar> createState() => _NfcRadarState();
}

class _NfcRadarState extends State<NfcRadar> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: AppMotion.radarSweep);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(NfcRadar old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() => widget.active && !AppMotion.reduced(context) ? _c.repeat() : _c.stop();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Color?>(
    tween: ColorTween(end: widget.tone),
    duration: AppMotion.slow,
    builder: (_, tone, __) => RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(
          painter: _RadarPainter(_c, tone ?? widget.tone, widget.active),
          child: Center(
            child: Container(
              width: widget.size * 0.26,
              height: widget.size * 0.26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [(tone ?? widget.tone).withValues(alpha: 0.9), (tone ?? widget.tone).withValues(alpha: 0.35)]),
                boxShadow: [BoxShadow(color: (tone ?? widget.tone).withValues(alpha: 0.55), blurRadius: 30)],
              ),
              child: Icon(Icons.nfc_rounded, color: Colors.white, size: widget.size * 0.12),
            ),
          ),
        ),
      ),
    ),
  );
}

class _RadarPainter extends CustomPainter {
  final Animation<double> t;
  final Color tone;
  final bool active;
  _RadarPainter(this.t, this.tone, this.active) : super(repaint: t);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = tone.withValues(alpha: 0.22);
    for (final f in const [0.45, 0.7, 0.95]) {
      canvas.drawCircle(c, r * f, ring);
    }

    // Balayage : secteur dégradé qui tourne.
    final angle = t.value * 2 * math.pi;
    final sweep = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi / 2,
        colors: [
          tone.withValues(alpha: 0),
          tone.withValues(alpha: active ? 0.35 : 0.12),
        ],
        transform: GradientRotation(angle - math.pi / 2),
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r * 0.95, sweep);

    // Ondes concentriques qui s'éloignent.
    if (active) {
      for (var i = 0; i < 3; i++) {
        final p = (t.value * 1.5 + i / 3) % 1;
        canvas.drawCircle(
          c,
          r * (0.15 + 0.8 * p),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = tone.withValues(alpha: (1 - p) * 0.5),
        );
      }
    }

    // Satellites en orbite.
    for (var i = 0; i < 3; i++) {
      final orbit = r * (0.45 + 0.25 * i);
      final a = angle * (i.isEven ? 1 : -0.7) + i * 2.1;
      canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * orbit, 3.2 - i * 0.6, Paint()..color = (i == 1 ? ObsidianColors.goldLight : tone).withValues(alpha: 0.9));
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) => old.tone != tone || old.active != active;
}
