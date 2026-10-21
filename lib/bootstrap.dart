import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/config/flavor_config.dart';
import 'core/demo/local_backend.dart';
import 'core/demo/local_database.dart';
import 'core/notifications/push_service.dart';
import 'core/providers.dart';
import 'core/storage/cache_store.dart';
import 'core/storage/shared_prefs_service.dart';

/// Point d'entrée commun aux trois flavors.
Future<void> bootstrap({required Flavor flavor, required String appName, required String apiBaseUrl, bool localBackend = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize(flavor: flavor, appName: appName, apiBaseUrl: apiBaseUrl, enableLogging: flavor == Flavor.dev, localBackend: localBackend);

  // Polices Inter et Outfit embarquées (assets/google_fonts) : licence SIL OFL à afficher.
  LicenseRegistry.addLicense(() async* {
    for (final family in const ['Inter', 'Outfit']) {
      yield LicenseEntryWithLineBreaks(['google_fonts ($family)'], await rootBundle.loadString('assets/google_fonts/$family-OFL.txt'));
    }
  });

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Future.wait([initializeDateFormatting('fr_FR'), initializeDateFormatting('en')]);

  final prefs = await SharedPrefsService.create();
  final cache = await CacheStore.open();
  final local = localBackend ? LocalBackend(await LocalDatabase.open()) : null;

  final container = ProviderContainer(overrides: [
    sharedPrefsProvider.overrideWithValue(prefs),
    cacheStoreProvider.overrideWithValue(cache),
    localBackendProvider.overrideWithValue(local),
  ]);
  await container.read(pushServiceProvider).init();

  runApp(UncontrolledProviderScope(container: container, child: const UniParentApp()));
}
