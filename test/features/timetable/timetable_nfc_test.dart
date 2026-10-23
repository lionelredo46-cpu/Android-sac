import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniparent/core/config/flavor_config.dart';
import 'package:uniparent/core/l10n/generated/app_localizations.dart';
import 'package:uniparent/core/providers.dart';
import 'package:uniparent/core/storage/shared_prefs_service.dart';
import 'package:uniparent/core/theme/obsidian_theme.dart';
import 'package:uniparent/features/children/domain/child.dart';
import 'package:uniparent/features/timetable/data/nfc_service.dart';
import 'package:uniparent/features/timetable/domain/nfc_payload.dart';
import 'package:uniparent/features/timetable/domain/timetable_models.dart';
import 'package:uniparent/features/timetable/presentation/nfc_controller.dart';
import 'package:uniparent/features/timetable/presentation/widgets/nfc_radar_sheet.dart';

const alexandre = Child(
  id: 'c1',
  matricule: 'AFRAMSIL0102',
  nom: 'OBIANG',
  prenom: 'Alexandre',
  estPayeur: true,
  relation: 'PERE',
  group: StudentGroup(
    id: 'g1',
    nom: 'L3 SIL',
    program: Program(id: 'p', code: 'SIL', nom: 'Systèmes Informatiques et Logiciels'),
  ),
);

TimetableSlot slot(String id, DateTime debut, String salle) => TimetableSlot(
  id: id,
  debut: debut,
  fin: debut.add(const Duration(hours: 2)),
  statut: 'PLANIFIE',
  matiere: 'Cours $id',
  code: 'C$id',
  enseignant: 'Patrick NDONG',
  salle: salle,
  campus: 'Batterie IV',
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    Intl.defaultLocale = 'fr_FR';
    FlavorConfig.initialize(flavor: Flavor.dev, appName: 'Test', apiBaseUrl: 'http://localhost');
  });

  group('Format NFC (NDEF)', () {
    test('Tap-to-Sync : aller-retour compressé de la semaine', () {
      final share =
          NfcPayload.timetableShare(
                owner: 'Alexandre OBIANG',
                group: 'L3 SIL',
                weekStart: DateTime.utc(2026, 10, 19),
                sharedAt: DateTime.utc(2026, 10, 21, 9),
                slots: [for (var i = 0; i < 12; i++) SharedSlot.fromSlot(slot('$i', DateTime.utc(2026, 10, 19 + i % 6, 8 + i % 3), 'S10$i'))],
              )
              as NfcTimetableShare;
      final bytes = NfcPayloadCodec.encodeShare(share);
      expect(bytes.length, lessThan(1500), reason: 'compression gzip : tient dans un tag de type 4');
      final decoded = NfcPayloadCodec.decode(records: ndef.decodeRawNdefMessage(bytes), uid: 'hce', technology: 'iso7816');
      expect(decoded, share);
    });

    test('tags de salle et d’émargement : URI ou texte', () {
      expect(NfcPayloadCodec.parseText('https://uniparent.aframgabon.com/salle/S104'), const NfcPayload.room(roomCode: 'S104'));
      expect(NfcPayloadCodec.parseText('https://uniparent.aframgabon.com/presence/AB12CD'), const NfcPayload.attendance(code: 'AB12CD'));
      expect(NfcPayloadCodec.parseText('afram:salle:LABO-INFO'), const NfcPayload.room(roomCode: 'LABO-INFO'));
      expect(NfcPayloadCodec.parseText('AFRAM:PRESENCE:XYZ789'), const NfcPayload.attendance(code: 'XYZ789'));
      expect(NfcPayloadCodec.parseText('https://exemple.com/salle/S104'), isNull, reason: 'domaine étranger ignoré');
      final records = [ndef.UriRecord.fromString('https://uniparent.aframgabon.com/salle/AMPHI%20A')];
      expect(NfcPayloadCodec.decode(records: records, uid: '04AA', technology: 'mifare_ultralight'), const NfcPayload.room(roomCode: 'AMPHI A'));
    });

    test('support sans contenu reconnu : carte étudiante (identifiant matériel)', () {
      expect(NfcPayloadCodec.decode(records: const [], uid: '04:A2:19', technology: 'mifare_desfire'), const NfcPayload.studentCard(uid: '04:A2:19', technology: 'mifare_desfire'));
    });
  });

  group('Vérification de salle', () {
    final now = DateTime(2026, 10, 21, 9);
    final today = [slot('1', DateTime(2026, 10, 21, 8), 'S104'), slot('2', DateTime(2026, 10, 21, 13), 'LABO-INFO')];

    test('cours en cours dans la salle scannée', () {
      final check = checkRoom('s-104', today, now);
      expect(check.isMine, isTrue);
      expect(check.inRoomToday.map((s) => s.id), ['1']);
    });

    test('mauvaise salle : le cours attendu est indiqué', () {
      final check = checkRoom('AMPHI A', today, now);
      expect(check.isMine, isFalse);
      expect(check.reference?.salle, 'S104');
      expect(check.inRoomToday, isEmpty);
    });

    test('après le dernier cours : aucune référence', () {
      expect(checkRoom('S104', today, DateTime(2026, 10, 21, 18)).reference, isNull);
    });
  });

  test('un scan abandonné (annulation, changement de mode) ne remplace pas l’état courant', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPrefsService.create();
    final reader = SimulatedNfcTimetableService(() => const NfcPayload.room(roomCode: 'S104'), delay: const Duration(milliseconds: 50));
    final container = ProviderContainer(overrides: [sharedPrefsProvider.overrideWithValue(prefs), nfcServiceProvider.overrideWithValue(reader)]);
    addTearDown(container.dispose);
    container.listen(nfcScanControllerProvider, (_, __) {});
    final controller = container.read(nfcScanControllerProvider.notifier);

    final scan = controller.scan((child: alexandre, children: const [alexandre], todaySlots: const []), iosPrompt: '', iosSuccess: '');
    expect(container.read(nfcScanControllerProvider), isA<NfcScanning>());
    await controller.reset();
    await scan;
    expect(container.read(nfcScanControllerProvider), isA<NfcIdle>());
  });

  testWidgets('hub NFC : scan simulé d’une salle puis association d’une carte', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPrefsService.create();
    final now = DateTime.now();
    final today = [slot('1', DateTime(now.year, now.month, now.day, now.hour), 'S104')];
    var next = const NfcPayload.room(roomCode: 'S104');
    final reader = SimulatedNfcTimetableService(() => next, delay: const Duration(milliseconds: 300));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPrefsProvider.overrideWithValue(prefs), nfcServiceProvider.overrideWithValue(reader)],
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
            body: NfcRadarSheet(
              args: NfcRadarArgs(
                child: alexandre,
                children: const [alexandre],
                todaySlots: today,
                weekSlots: today,
                weekStart: mondayOf(now),
                openChildAgenda: (_) {},
                openShared: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Ma salle'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nfc-primary')));
    await tester.pump();
    expect(find.text('Recherche en cours…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byKey(const Key('nfc-result-room')), findsOneWidget);
    expect(find.text("Oui, c'est votre salle"), findsOneWidget);

    // Mode carte : carte inconnue, puis association au dossier.
    next = const NfcPayload.studentCard(uid: '04:A2:19', technology: 'mifare_desfire');
    await tester.tap(find.byKey(const Key('nfc-mode-card')));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const Key('nfc-primary')));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Carte non associée'), findsOneWidget);
    await tester.tap(find.text('Associer à Alexandre OBIANG'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Carte de Alexandre OBIANG'), findsOneWidget);
    expect(prefs.nfcCards, {'04:A2:19': 'c1'});
    expect(tester.takeException(), isNull);

    // Fermeture : arrêt propre des animations et du lecteur.
    await tester.pumpWidget(const SizedBox());
    expect(find.byType(NfcRadar), findsNothing);
  });
}
