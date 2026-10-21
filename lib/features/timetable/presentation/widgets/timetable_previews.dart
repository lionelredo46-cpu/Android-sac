import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/obsidian_theme.dart';
import '../../domain/timetable_models.dart';
import 'glass_dock.dart';
import 'nfc_radar_sheet.dart';
import 'story_card.dart';
import 'timetable_slot_card.dart';
import 'week_pill_selector.dart';

/// Aperçus des composants du module (`flutter widget-preview start`).

final _now = DateTime(2026, 10, 21, 9, 30);

TimetableSlot _slot({String statut = 'PLANIFIE', int startHour = 8, int hours = 3, String id = 'p1'}) => TimetableSlot(
  id: id,
  debut: DateTime(2026, 10, 21, startHour),
  fin: DateTime(2026, 10, 21, startHour + hours),
  statut: statut,
  matiere: 'Développement mobile (Flutter)',
  code: 'INF301',
  enseignant: 'Patrick NDONG',
  salle: 'LABO-INFO',
  campus: 'Batterie IV',
  motif: statut == 'ANNULE' ? 'Enseignant en mission' : null,
);

/// Enveloppe commune : thème Obsidian, traductions françaises et formats de date initialisés.
Widget obsidianPreview(Widget child) => _PreviewHost(child: child);

class _PreviewHost extends StatefulWidget {
  final Widget child;
  const _PreviewHost({required this.child});

  @override
  State<_PreviewHost> createState() => _PreviewHostState();
}

class _PreviewHostState extends State<_PreviewHost> {
  late final Future<void> _ready = initializeDateFormatting('fr_FR').then((_) => Intl.defaultLocale = 'fr_FR');

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _ready,
    builder: (context, snapshot) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ObsidianTheme.of(ThemeData()),
      locale: const Locale('fr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      home: Scaffold(
        backgroundColor: ObsidianColors.abyss,
        body: snapshot.connectionState == ConnectionState.done
            ? Center(
                child: Padding(padding: const EdgeInsets.all(16), child: widget.child),
              )
            : const SizedBox.shrink(),
      ),
    ),
  );
}

@Preview(group: 'Emploi du temps', name: 'Carte — cours en direct', size: Size(380, 200), wrapper: obsidianPreview)
Widget slotCardLive() => SizedBox(
  height: 160,
  child: TimetableSlotCard(slot: _slot(), now: _now),
);

@Preview(group: 'Emploi du temps', name: 'Carte — annulée', size: Size(380, 200), wrapper: obsidianPreview)
Widget slotCardCancelled() => SizedBox(
  height: 160,
  child: TimetableSlotCard(
    slot: _slot(statut: 'ANNULE'),
    now: _now,
  ),
);

@Preview(group: 'Emploi du temps', name: 'Carte — compacte, présent', size: Size(380, 110), wrapper: obsidianPreview)
Widget slotCardCompact() => SizedBox(
  height: 72,
  child: TimetableSlotCard(slot: _slot(startHour: 7, hours: 1), now: _now, attendance: 'PRESENT'),
);

@Preview(group: 'Emploi du temps', name: 'Dock en verre', size: Size(400, 120), wrapper: obsidianPreview)
Widget glassDock() => GlassDock(
  actions: [
    DockAction(icon: Icons.view_agenda_rounded, label: 'Semaine', onTap: () {}),
    DockAction(icon: Icons.nfc_rounded, label: 'NFC', onTap: () {}),
    DockAction(icon: Icons.ios_share_rounded, label: 'Exporter', onTap: () {}, prestige: true),
  ],
);

@Preview(group: 'Emploi du temps', name: 'Pilule de semaine', size: Size(400, 180), wrapper: obsidianPreview)
Widget weekPill() => WeekPillSelector(
  weekStart: DateTime(2026, 10, 19),
  selectedDay: DateTime(2026, 10, 21),
  today: DateTime(2026, 10, 21),
  daysWithClasses: {DateTime(2026, 10, 19), DateTime(2026, 10, 21), DateTime(2026, 10, 22)},
  onWeekShift: (_) {},
  onDaySelected: (_) {},
  onToday: () {},
);

@Preview(group: 'NFC', name: 'Radar orbital', size: Size(320, 320), wrapper: obsidianPreview)
Widget nfcRadar() => const NfcRadar(size: 260);

@Preview(group: 'Export', name: 'Story 9:16', size: Size(400, 680), wrapper: obsidianPreview)
Widget storyCard() => StoryCard(
  format: ImageFormat.story,
  studentName: 'Alexandre OBIANG',
  groupName: 'L3 SIL',
  weekStart: DateTime(2026, 10, 19),
  slots: [
    _slot(),
    _slot(id: 'p2', startHour: 13, hours: 2),
  ],
);
