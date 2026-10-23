import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniparent/core/config/flavor_config.dart';
import 'package:uniparent/core/l10n/generated/app_localizations.dart';
import 'package:uniparent/core/providers.dart';
import 'package:uniparent/core/storage/cache_store.dart';
import 'package:uniparent/core/storage/shared_prefs_service.dart';
import 'package:uniparent/core/theme/app_theme.dart';
import 'package:uniparent/core/widgets/ui.dart';
import 'package:uniparent/features/auth/application/session_controller.dart';
import 'package:uniparent/features/auth/domain/app_user.dart';
import 'package:uniparent/features/auth/presentation/login_page.dart';
import 'package:uniparent/features/children/application/children_providers.dart';
import 'package:uniparent/features/children/domain/child.dart';
import 'package:uniparent/features/dashboard/application/dashboard_providers.dart';
import 'package:uniparent/features/dashboard/domain/dashboard.dart';
import 'package:uniparent/features/dashboard/presentation/dashboard_page.dart';
import 'package:uniparent/features/notifications/data/notifications_repository.dart';

class _FakeSession extends SessionController {
  @override
  Future<AppUser?> build() async => const AppUser(
        id: 'u1',
        role: 'PARENT',
        email: 'parent@aframgabon.com',
        parentProfile: PersonProfile(id: 'p1', nom: 'OBIANG', prenom: 'Jean-Marc'),
      );
}

const _child = Child(
  id: 'c1',
  matricule: 'AFRAMSIL0102',
  nom: 'OBIANG',
  prenom: 'Alexandre',
  estPayeur: true,
  relation: 'PERE',
  group: StudentGroup(id: 'g1', nom: 'L3 SIL', program: Program(id: 'p', code: 'SIL', nom: 'Systèmes Informatiques et Logiciels')),
);

Future<Widget> _app(Widget home, {List<Override> overrides = const []}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPrefsService.create();
  return ProviderScope(
    overrides: [sharedPrefsProvider.overrideWithValue(prefs), ...overrides],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      // Animations continues (ciel, reflets, anneaux) coupées : pumpAndSettle doit pouvoir se stabiliser.
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!),
      locale: const Locale('fr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      home: home,
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    Intl.defaultLocale = 'fr_FR'; // comme UniParentApp pour la langue française
    FlavorConfig.initialize(flavor: Flavor.dev, appName: 'Test', apiBaseUrl: 'http://localhost:3000');
  });

  testWidgets('Connexion : validation des champs et bascule vers la connexion par SMS', (tester) async {
    await tester.pumpWidget(await _app(const LoginPage()));
    await tester.pumpAndSettle();

    expect(find.text('Email ou téléphone'), findsOneWidget);
    // Formulaire plus haut que l'écran de test (800 × 600) : on fait défiler jusqu'au bouton.
    await tester.ensureVisible(find.text('Se connecter'));
    await tester.tap(find.text('Se connecter'));
    await tester.pump();
    expect(find.text('Champ obligatoire'), findsNWidgets(2));

    await tester.ensureVisible(find.text('SMS'));
    await tester.tap(find.text('SMS'));
    await tester.pumpAndSettle();
    expect(find.text('Numéro de téléphone'), findsOneWidget);
    expect(find.text('Recevoir un code'), findsOneWidget);
  });

  testWidgets('Tableau de bord : situation financière, alertes et enfant actif', (tester) async {
    final dashboard = Dashboard.fromJson({
      'finances': {'devise': 'XAF', 'totalDu': 1110000, 'totalPaye': 295000, 'resteAPayer': 815000, 'statut': 'EN_RETARD'},
      'presence': {'tauxAssiduiteMois': 91.3, 'seancesMois': 23, 'absencesMois': 2, 'retardsMois': 1, 'dernieresAbsences': []},
      'resultats': {'moyenneGenerale': 14.54, 'creditsAcquis': 12, 'dernieresNotes': []},
      'aujourdhui': [],
      'alertes': [{'type': 'IMPAYE', 'niveau': 'danger', 'message': '1 échéance(s) en retard : 130000 FCFA à régler'}],
      'actualites': [],
    });
    await tester.pumpWidget(await _app(
      const DashboardPage(),
      overrides: [
        sessionProvider.overrideWith(_FakeSession.new),
        childrenProvider.overrideWith((ref) async => Cached(const [_child], fromCache: false, updatedAt: DateTime.now())),
        dashboardProvider.overrideWith((ref, id) async => Cached(dashboard, fromCache: true, updatedAt: DateTime(2026, 10, 20, 9))),
        unreadCountProvider.overrideWith((ref) async => 3),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Bonjour Jean-Marc'), findsOneWidget);
    expect(find.text('Alexandre OBIANG'), findsOneWidget);
    expect(find.text('815 000 FCFA'), findsOneWidget);
    expect(find.textContaining('130000 FCFA à régler'), findsOneWidget);
    expect(find.text('En retard'), findsOneWidget);
    // Données issues du cache : le bandeau hors ligne est affiché.
    expect(find.byType(StaleBanner), findsOneWidget);
  });
}
