import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:printing/printing.dart';
import 'package:uniparent/bootstrap.dart';
import 'package:uniparent/core/config/flavor_config.dart';
import 'package:uniparent/features/timetable/presentation/widgets/nfc_radar_sheet.dart';
import 'package:uniparent/main_staging.dart' show stagingApiBaseUrl;
import 'package:uniparent/features/timetable/presentation/widgets/timetable_slot_card.dart';

/// Parcours complet sur appareil, connecté à l'API de recette (Railway, comptes de démonstration) :
/// sélection de semaine → affichage des cours → détail → export PDF → déclenchement NFC.
///
/// flutter test integration_test/timetable_flow_test.dart --flavor staging -d <appareil>
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Les animations continues (cours en direct, radar) empêchent pumpAndSettle : on attend un élément.
  Future<void> pumpUntil(WidgetTester tester, Finder finder, {Duration timeout = const Duration(seconds: 20)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) return;
    }
    throw TestFailure('Introuvable après $timeout : $finder');
  }

  Future<void> pumpUntilTrue(WidgetTester tester, bool Function() condition, String what, {Duration timeout = const Duration(seconds: 10)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (condition()) return;
    }
    throw TestFailure('Condition non atteinte après $timeout : $what');
  }

  Future<void> tapWhenVisible(WidgetTester tester, Finder finder) async {
    await pumpUntil(tester, finder);
    await tester.ensureVisible(finder.first);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(finder.first);
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('emploi du temps : semaine, cours, export PDF et NFC', (tester) async {
    await bootstrap(flavor: Flavor.staging, appName: 'UniParent Recette', apiBaseUrl: stagingApiBaseUrl);
    expect(FlavorConfig.testTools, isTrue);

    // Premier lancement : introduction puis connexion par un compte de démonstration.
    await pumpUntil(tester, find.byWidgetPredicate((w) => w is Text && ['Commencer', 'Se connecter', 'Bonjour Jean-Marc'].any((t) => w.data?.startsWith(t) ?? false)));
    if (find.text('Commencer').evaluate().isNotEmpty) await tapWhenVisible(tester, find.text('Commencer'));
    if (find.text('Se connecter').evaluate().isNotEmpty) await tapWhenVisible(tester, find.text('Parent — Jean-Marc OBIANG'));

    // Accueil → Emploi du temps.
    await tapWhenVisible(tester, find.text('Emploi du temps'));
    await pumpUntil(tester, find.byType(TimetableSlotCard));

    // Sélection de semaine : suivante puis retour à aujourd'hui.
    // Libellé de semaine (« 19 oct. – 24 oct. ») ; pendant la transition, le dernier est l'entrant.
    final week = find.byWidgetPredicate((w) => w is Text && (w.data?.contains(' – ') ?? false) && !(w.data?.contains(':') ?? true));
    String range() => (tester.widget(week.last) as Text).data!;
    final before = range();
    await tester.tap(find.byTooltip('Semaine suivante'));
    await pumpUntilTrue(tester, () => range() != before, 'passage à la semaine suivante');
    await tapWhenVisible(tester, find.text("Aujourd'hui"));
    await pumpUntilTrue(tester, () => range() == before, "retour à la semaine d'aujourd'hui");

    // Vue semaine : tous les cours, puis détail d'un cours (transition Hero).
    await tapWhenVisible(tester, find.byKey(const Key('dock-view')));
    await pumpUntil(tester, find.byType(TimetableSlotCard));
    await tester.tap(find.byType(TimetableSlotCard).first);
    await pumpUntil(tester, find.text('Détail du cours'));
    expect(find.text('Ajouter à mon agenda'), findsOneWidget);
    await tapWhenVisible(tester, find.byType(BackButton)); // pageBack() cherche l’infobulle anglaise « Back »
    await pumpUntil(tester, find.byKey(const Key('dock-export')));

    // Export PDF : aperçu rendu par le moteur vectoriel.
    await tapWhenVisible(tester, find.byKey(const Key('dock-export')));
    await pumpUntil(tester, find.text('PDF éditorial'));
    await tapWhenVisible(tester, find.text('Portrait'));
    await tapWhenVisible(tester, find.text('Aperçu, impression et partage'));
    await pumpUntil(tester, find.byType(PdfPreview));
    await pumpUntil(
      tester,
      find.descendant(of: find.byType(PdfPreview), matching: find.byType(Image)),
      timeout: const Duration(seconds: 30),
    );
    await tapWhenVisible(tester, find.byType(BackButton)); // pageBack() cherche l’infobulle anglaise « Back »
    await tester.pump(const Duration(seconds: 1));
    Navigator.of(tester.element(find.text('PDF éditorial'))).pop();
    await tester.pump(const Duration(seconds: 1));

    // NFC : hub, puis scan (simulé si l'appareil n'a pas de puce NFC).
    await tapWhenVisible(tester, find.byKey(const Key('dock-nfc')));
    await pumpUntil(tester, find.byType(NfcRadar));
    await pumpUntil(tester, find.byWidgetPredicate((w) => w.key == const Key('nfc-simulate') || w.key == const Key('nfc-primary')));
    final simulate = find.byKey(const Key('nfc-simulate'));
    if (simulate.evaluate().isNotEmpty) {
      await tapWhenVisible(tester, simulate);
      await pumpUntil(tester, find.byKey(const Key('nfc-result-room')));
      expect(find.textContaining('salle'), findsWidgets);
    } else {
      // Appareil équipé : le scan démarre et attend un tag réel.
      await tapWhenVisible(tester, find.byKey(const Key('nfc-primary')));
      await pumpUntil(tester, find.text('Recherche en cours…'));
    }
  });
}
