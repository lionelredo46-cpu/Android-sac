import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/config/flavor_config.dart';
import 'core/notifications/push_service.dart';
import 'core/providers.dart';
import 'core/storage/cache_store.dart';
import 'core/storage/shared_prefs_service.dart';

/// Point d'entrée commun aux trois flavors.
Future<void> bootstrap({required Flavor flavor, required String appName, required String apiBaseUrl}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize(flavor: flavor, appName: appName, apiBaseUrl: apiBaseUrl, enableLogging: flavor == Flavor.dev);

  // Polices Inter et Outfit embarquées (assets/fonts, déclarées dans pubspec.yaml) : licence SIL OFL à afficher.
  LicenseRegistry.addLicense(() async* {
    for (final family in const ['Inter', 'Outfit']) {
      yield LicenseEntryWithLineBreaks([family], await rootBundle.loadString('assets/fonts/$family-OFL.txt'));
    }
  });

  // Ciel visible jusque sous les barres système (bord à bord).
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Démarrage : toutes les initialisations indépendantes en parallèle.
  final (prefs, cache) = await (
    SharedPrefsService.create(),
    CacheStore.open(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]),
    initializeDateFormatting('fr_FR'),
    initializeDateFormatting('en'),
  ).wait.then((r) => (r.$1, r.$2));
  if (FlavorConfig.testTools && prefs.apiBaseUrl != null) FlavorConfig.overrideApiBaseUrl(prefs.apiBaseUrl);

  final container = ProviderContainer(overrides: [
    sharedPrefsProvider.overrideWithValue(prefs),
    cacheStoreProvider.overrideWithValue(cache),
  ]);

  runApp(UncontrolledProviderScope(container: container, child: const UniParentApp()));
  // Notifications push initialisées après le premier affichage : elles ne retardent jamais l'ouverture.
  unawaited(container.read(pushServiceProvider).init());
}
