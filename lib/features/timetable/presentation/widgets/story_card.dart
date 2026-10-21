import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/theme/obsidian_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ui.dart';
import '../../domain/timetable_models.dart';

/// Visuel partageable de la semaine : story 9:16 (360 × 640) ou carte de poche 1:1 (360 × 360),
/// exporté en 1080 px de large ([captureBoundary] avec un ratio de 3).
class StoryCard extends StatelessWidget {
  final ImageFormat format;
  final String studentName;
  final String? groupName;
  final DateTime weekStart;
  final List<TimetableSlot> slots;

  const StoryCard({super.key, required this.format, required this.studentName, required this.weekStart, required this.slots, this.groupName});

  static Size sizeOf(ImageFormat f) => f == ImageFormat.story ? const Size(360, 640) : const Size(360, 360);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final size = sizeOf(format);
    final story = format == ImageFormat.story;
    final week = [...slots]..sort((a, b) => a.debut.compareTo(b.debut));
    final range = '${Fmt.dayMonth(weekStart)} – ${Fmt.dayMonth(DateTime(weekStart.year, weekStart.month, weekStart.day + 5))}';

    // Budget de lignes : au-delà, « +N autres cours » (aucun débordement possible).
    final budget = story ? 13 : 4;
    final shown = week.where((s) => !s.cancelled).take(budget).toList();
    final hidden = week.where((s) => !s.cancelled).length - shown.length;
    final byDay = <DateTime, List<TimetableSlot>>{};
    for (final s in shown) {
      byDay.putIfAbsent(s.day, () => []).add(s);
    }

    return SizedBox.fromSize(
      size: size,
      child: ClipRect(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ObsidianColors.abyss, ObsidianColors.abyssBlue, Color(0xFF10204A)]),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -80,
                right: -60,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [ObsidianColors.sapphire.withValues(alpha: 0.45), Colors.transparent]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22, story ? 34 : 20, 22, story ? 26 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: ClipOval(child: Image.asset('Afram/assets/logo/logo-afram-150x150.png', fit: BoxFit.contain)),
                        ),
                        const SizedBox(width: 8),
                        Text('AFRAM · UniParent', style: ObsidianText.label(size: 11, color: ObsidianColors.goldLight)),
                      ],
                    ),
                    SizedBox(height: story ? 26 : 12),
                    Text(l.ttStoryTitle, style: ObsidianText.display(size: story ? 34 : 24)),
                    const SizedBox(height: 4),
                    Text(
                      [studentName, if (groupName != null) groupName].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ObsidianText.title(size: story ? 15 : 13, color: ObsidianColors.goldLight),
                    ),
                    Text(range, style: ObsidianText.body(size: story ? 13 : 11.5)),
                    SizedBox(height: story ? 20 : 10),
                    Expanded(
                      child: shown.isEmpty
                          ? Center(
                              child: Text(l.ttNoClassWeek, style: ObsidianText.title(color: ObsidianColors.textMuted)),
                            )
                          // Défilement bloqué : si une police système agrandit le texte, la liste est rognée au lieu de déborder.
                          : SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final e in byDay.entries) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6, bottom: 3),
                                      child: Text('${Fmt.weekday(e.key)} ${e.key.day}'.toUpperCase(), style: ObsidianText.label(size: 10, color: ObsidianColors.textFaint)),
                                    ),
                                    for (final s in e.value) _row(s, story),
                                  ],
                                  if (hidden > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(l.ttStoryMore(hidden), style: ObsidianText.label(color: ObsidianColors.sapphireLight)),
                                    ),
                                ],
                              ),
                            ),
                    ),
                    Container(
                      height: 2,
                      width: 40,
                      decoration: BoxDecoration(gradient: ObsidianColors.goldGradient, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 6),
                    Text(l.ttStoryFooter, style: ObsidianText.label(size: 10, color: ObsidianColors.textFaint)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _row(TimetableSlot s, bool story) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.5),
    child: Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ObsidianColors.forStatus(s.statut, s.code)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 44,
          child: Text(
            Fmt.time(s.debut),
            style: ObsidianText.time(size: story ? 12.5 : 11, color: ObsidianColors.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            s.matiere,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ObsidianText.title(size: story ? 13.5 : 12),
          ),
        ),
        const SizedBox(width: 6),
        Text(s.salle, style: ObsidianText.label(size: 10.5, color: ObsidianColors.textFaint)),
      ],
    ),
  );
}

/// Rendu haute définition d'un [RepaintBoundary] en PNG.
Future<List<int>> captureBoundary(GlobalKey key, {double pixelRatio = 3}) async {
  final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}
