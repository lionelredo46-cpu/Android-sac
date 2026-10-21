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

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Future.wait([initializeDateFormatting('fr_FR'), initializeDateFormatting('en')]);

  final prefs = await SharedPrefsService.create();
  final cache = await CacheStore.open();

  final container = ProviderContainer(overrides: [
    sharedPrefsProvider.overrideWithValue(prefs),
    cacheStoreProvider.overrideWithValue(cache),
  ]);
  await container.read(pushServiceProvider).init();

  runApp(UncontrolledProviderScope(container: container, child: const UniParentApp()));
}
