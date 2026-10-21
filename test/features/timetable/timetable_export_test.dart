import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uniparent/core/l10n/generated/app_localizations.dart';
import 'package:uniparent/core/theme/obsidian_theme.dart';
import 'package:uniparent/features/timetable/data/timetable_ics_generator.dart';
import 'package:uniparent/features/timetable/data/timetable_pdf_generator.dart';
import 'package:uniparent/features/timetable/domain/timetable_models.dart';
import 'package:uniparent/features/timetable/presentation/widgets/export_bottom_sheet.dart';

TimetableSlot slot(String id, DateTime debut, {int hours = 2, String statut = 'PLANIFIE', String matiere = 'Génie logiciel', String salle = 'S104'}) => TimetableSlot(
  id: id,
  debut: debut,
  fin: debut.add(Duration(hours: hours)),
  statut: statut,
  matiere: matiere,
  code: 'INF304',
  enseignant: 'Patrick NDONG',
  salle: salle,
  campus: 'Batterie IV',
);

final monday = DateTime(2026, 10, 19);
final request = TimetableExportRequest(
  channel: ExportChannel.pdf,
  weekStart: monday,
  studentId: 'c5e8',
  studentName: 'Alexandre OBIANG',
  matricule: 'AFRAMSIL0102',
  groupName: 'L3 SIL',
);

const IcsLabels icsLabels = (teacher: 'Enseignant', room: 'Salle', reminder: 'Rappel', cancelled: 'Annulé');

const PdfLabels pdfLabels = (
  title: 'Emploi du temps',
  student: 'Étudiant :',
  matricule: 'Matricule',
  group: 'Groupe',
  generatedOn: 'Généré le',
  authentic: 'Document authentique',
  verifyHint: 'Scannez le QR code',
  cancelled: 'Annulé',
  postponed: 'Reporté',
  teacher: 'Enseignant',
  room: 'Salle',
  time: 'Horaire',
  course: 'Cours',
  status: 'Statut',
  noClass: 'Aucun cours',
  page: 'Page',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    Intl.defaultLocale = 'fr_FR';
  });

  final week = [
    slot('a', DateTime(2026, 10, 19, 8), matiere: 'Réseaux, sécurité; et cloud\\ avancé — module très long pour forcer le repli des lignes'),
    slot('b', DateTime(2026, 10, 20, 13), statut: 'ANNULE'),
    slot('c', DateTime(2026, 10, 22, 9), statut: 'REPORTE'),
    slot('hors-semaine', DateTime(2026, 10, 27, 8)),
  ];

  group('iCalendar (RFC 5545)', () {
    final ics = const TimetableIcsGenerator().generate(slots: TimetablePdfGenerator.weekSlots(request, week), calendarName: 'AFRAM — Alexandre', labels: icsLabels);

    test('lignes CRLF repliées à 75 octets au plus', () {
      expect(ics.endsWith('\r\n'), isTrue);
      expect(ics.replaceAll('\r\n', '').contains('\n'), isFalse, reason: 'aucun LF isolé');
      for (final line in ics.split('\r\n')) {
        expect(utf8.encode(line).length, lessThanOrEqualTo(75), reason: line);
      }
    });

    test('valeurs TEXT échappées et dépliables', () {
      final unfolded = ics.replaceAll('\r\n ', '');
      expect(unfolded, contains(r'SUMMARY:Réseaux\, sécurité\; et cloud\\ avancé'));
      expect(unfolded, contains(r'DESCRIPTION:Enseignant : Patrick NDONG\nSalle : S104 — Batterie IV'));
    });

    test('UID stables, statuts et rappel 15 min (sauf cours annulés)', () {
      final unfolded = ics.replaceAll('\r\n ', '');
      expect(unfolded, contains('UID:a@uniparent.aframgabon.com'));
      expect(unfolded, contains('DTSTART:${_utc(DateTime(2026, 10, 19, 8))}'));
      expect('BEGIN:VEVENT'.allMatches(unfolded).length, 3, reason: 'le cours hors semaine est exclu');
      expect(unfolded, contains('STATUS:CANCELLED'));
      expect(unfolded, contains('STATUS:TENTATIVE'));
      expect('TRIGGER:-PT15M'.allMatches(unfolded).length, 2, reason: 'pas de rappel pour le cours annulé');
    });

    test('repli sans couper un caractère multi-octets', () {
      final folded = TimetableIcsGenerator.fold('DESCRIPTION:${'é' * 80}');
      expect(folded.split('\r\n ').map((l) => utf8.encode(l).length).every((n) => n <= 75), isTrue);
      expect(folded.replaceAll('\r\n ', ''), 'DESCRIPTION:${'é' * 80}');
    });
  });

  group('PDF vectoriel', () {
    late TimetablePdfAssets assets;
    setUpAll(() async => assets = await TimetablePdfAssets.load());

    for (final layout in PdfLayout.values) {
      test('A4 ${layout.name} généré', () async {
        final bytes = await TimetablePdfGenerator(assets).build(request.copyWith(layout: layout), week, pdfLabels);
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
        expect(bytes.length, greaterThan(20000), reason: 'polices et logo embarqués');
      });
    }

    test('semaine vide : document valide', () async {
      final bytes = await TimetablePdfGenerator(assets).build(request, const [], pdfLabels);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('empreinte du QR : change si le planning change', () {
      final slots = TimetablePdfGenerator.weekSlots(request, week);
      final h1 = TimetablePdfGenerator.fingerprint(request, slots);
      final h2 = TimetablePdfGenerator.fingerprint(request, [slots.first.copyWith(statut: 'ANNULE'), ...slots.skip(1)]);
      expect(h1, hasLength(16));
      expect(h1, isNot(h2));
      final url = Uri.parse(TimetablePdfGenerator.verificationUrl(request, slots));
      expect(url.host, 'uniparent.aframgabon.com');
      expect(url.queryParameters, {'e': 'c5e8', 's': '2026-10-19', 'h': h1});
    });
  });

  test('couloirs : deux cours simultanés côte à côte, les autres pleine largeur', () {
    final placed = placeDay([slot('x', DateTime(2026, 10, 19, 8)), slot('y', DateTime(2026, 10, 19, 9)), slot('z', DateTime(2026, 10, 19, 13))]);
    final byId = {for (final p in placed) p.slot.id: p};
    expect((byId['x']!.lane, byId['x']!.lanes), (0, 2));
    expect((byId['y']!.lane, byId['y']!.lanes), (1, 2));
    expect((byId['z']!.lane, byId['z']!.lanes), (0, 1));
  });

  testWidgets('hub d’export : trois canaux, choix paysage / portrait et story / carte', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ObsidianTheme.of(ThemeData()),
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: ExportBottomSheet(request: request, slots: week),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('PDF éditorial'), findsOneWidget);
    expect(find.text('Agenda (.ics)'), findsOneWidget);
    expect(find.text('Image à partager'), findsOneWidget);

    await tester.tap(find.text('Portrait'));
    await tester.tap(find.text('Carte 1:1'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Ma semaine'), findsOneWidget, reason: 'aperçu de l’image');
  });
}

String _utc(DateTime d) => DateFormat("yyyyMMdd'T'HHmmss'Z'").format(d.toUtc());
