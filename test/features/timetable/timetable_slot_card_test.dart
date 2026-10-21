import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uniparent/core/l10n/generated/app_localizations.dart';
import 'package:uniparent/core/theme/obsidian_theme.dart';
import 'package:uniparent/features/timetable/domain/timetable_models.dart';
import 'package:uniparent/features/timetable/presentation/widgets/glass_dock.dart';
import 'package:uniparent/features/timetable/presentation/widgets/timetable_slot_card.dart';

TimetableSlot slot({String statut = 'PLANIFIE', String? motif}) => TimetableSlot(
  id: 's1',
  debut: DateTime(2026, 10, 21, 8),
  fin: DateTime(2026, 10, 21, 11),
  statut: statut,
  motif: motif,
  matiere: 'Génie logiciel',
  code: 'INF304',
  enseignant: 'Patrick NDONG',
  salle: 'S104',
  campus: 'Batterie IV',
);

Widget host(Widget child, {double height = 170, double width = 360}) => MaterialApp(
  theme: ObsidianTheme.of(ThemeData()),
  locale: const Locale('fr'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, height: height, child: child),
    ),
  ),
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    Intl.defaultLocale = 'fr_FR';
  });

  final before = DateTime(2026, 10, 20, 9);
  final during = DateTime(2026, 10, 21, 9, 30);
  final after = DateTime(2026, 10, 21, 12);

  testWidgets('affiche horaire, matière, salle, campus et enseignant', (tester) async {
    await tester.pumpWidget(host(TimetableSlotCard(slot: slot(), now: before)));
    expect(find.text('08:00 – 11:00'), findsOneWidget);
    expect(find.text('Génie logiciel'), findsOneWidget);
    expect(find.text('Salle S104 · Batterie IV'), findsOneWidget);
    expect(find.text('Patrick NDONG'), findsOneWidget);
    expect(find.text('INF304'), findsOneWidget);
  });

  testWidgets('cours en direct : badge doré « EN DIRECT »', (tester) async {
    await tester.pumpWidget(host(TimetableSlotCard(slot: slot(), now: during)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('EN DIRECT'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('EN DIRECT')), findsOneWidget);
  });

  testWidgets('cours annulé : libellé, motif et titre barré', (tester) async {
    await tester.pumpWidget(
      host(
        TimetableSlotCard(
          slot: slot(statut: 'ANNULE', motif: 'Enseignant en mission'),
          now: before,
        ),
      ),
    );
    expect(find.text('Annulé'), findsOneWidget);
    expect(find.text('Enseignant en mission'), findsOneWidget);
    final title = tester.widget<Text>(find.text('Génie logiciel'));
    expect(title.style?.decoration, TextDecoration.lineThrough);
    expect(find.text('EN DIRECT'), findsNothing, reason: 'un cours annulé n’est jamais en direct');
  });

  testWidgets('cours passé : indicateur d’appel (présent / absent)', (tester) async {
    await tester.pumpWidget(host(TimetableSlotCard(slot: slot(), now: after, attendance: 'PRESENT')));
    expect(find.text('Présent'), findsOneWidget);
    await tester.pumpWidget(host(TimetableSlotCard(slot: slot(), now: after, attendance: 'ABSENT')));
    expect(find.text('Absent'), findsOneWidget);
  });

  testWidgets('le toucher déclenche l’action', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(TimetableSlotCard(slot: slot(), now: before, onTap: () => taps++)));
    await tester.tap(find.byType(TimetableSlotCard));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  for (final height in [44.0, 56.0, 72.0, 92.0, 130.0, 240.0]) {
    testWidgets('aucun débordement à $height px de haut (grille proportionnelle)', (tester) async {
      await tester.pumpWidget(
        host(
          TimetableSlotCard(
            slot: slot(statut: 'ANNULE', motif: 'Motif très long ' * 6),
            now: before,
          ),
          height: height,
          width: 150,
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('hauteur libre (agenda de la semaine, liste) : taille naturelle, sans erreur', (tester) async {
    await tester.pumpWidget(
      host(
        ListView(
          children: [
            TimetableSlotCard(
              slot: slot(statut: 'ANNULE', motif: 'Enseignant en mission'),
              now: before,
            ),
            TimetableSlotCard(slot: slot(), now: during),
          ],
        ),
        height: 600,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(TimetableSlotCard).first).height, inInclusiveRange(90, 220));
    expect(find.text('Enseignant en mission'), findsOneWidget, reason: 'tout le contenu est affiché en liste');
  });

  testWidgets('dock : trois actions, l’export en accent doré', (tester) async {
    final tapped = <String>[];
    await tester.pumpWidget(
      host(
        GlassDock(
          actions: [
            DockAction(icon: Icons.view_agenda_rounded, label: 'Semaine', onTap: () => tapped.add('vue')),
            DockAction(icon: Icons.nfc_rounded, label: 'NFC', onTap: () => tapped.add('nfc')),
            DockAction(icon: Icons.ios_share_rounded, label: 'Exporter', onTap: () => tapped.add('export'), prestige: true),
          ],
        ),
        height: 80,
      ),
    );
    await tester.tap(find.text('NFC'));
    await tester.tap(find.text('Exporter'));
    await tester.pumpAndSettle();
    expect(tapped, ['nfc', 'export']);
    expect(tester.takeException(), isNull);
  });
}
