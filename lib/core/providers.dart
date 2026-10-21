import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'demo/local_backend.dart';
import 'network/api_client.dart';
import 'network/dio_client.dart';
import 'storage/cache_store.dart';
import 'storage/secure_storage_service.dart';
import 'storage/shared_prefs_service.dart';

/// Initialisés dans bootstrap() puis injectés via ProviderScope.overrides.
final sharedPrefsProvider = Provider<SharedPrefsService>((_) => throw UnimplementedError('sharedPrefsProvider'));
final cacheStoreProvider = Provider<CacheStore>((_) => throw UnimplementedError('cacheStoreProvider'));

/// Serveur simulé du mode démo autonome (null : API réelle).
final localBackendProvider = Provider<LocalBackend?>((_) => null);

final secureStorageProvider = Provider<SecureStorageService>((_) => SecureStorageService());

/// Émis quand la session est révoquée côté serveur (refresh refusé).
final sessionExpiredProvider = Provider<StreamController<void>>((ref) {
  final c = StreamController<void>.broadcast();
  ref.onDispose(c.close);
  return c;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final expired = ref.watch(sessionExpiredProvider);
  final client = DioClient(
    storageService: ref.watch(secureStorageProvider),
    onSessionExpired: () => expired.add(null),
    adapter: switch (ref.watch(localBackendProvider)) {
      final local? => LocalHttpAdapter(local),
      null => null,
    },
  );
  return ApiClient(client.dio);
});

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => switch (ref.watch(sharedPrefsProvider).themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPrefsProvider).setThemeMode(mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => Locale(ref.watch(sharedPrefsProvider).preferredLocale);

  Future<void> set(Locale locale) async {
    state = locale;
    await ref.read(sharedPrefsProvider).setPreferredLocale(locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);
