import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'core/config/flavor_config.dart';
import 'core/l10n/generated/app_localizations.dart';
import 'core/network/connectivity_service.dart';
import 'core/notifications/push_service.dart';
import 'core/providers.dart';
import 'core/router/app_router.dart';
import 'core/security/app_lock.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/application/session_controller.dart';
import 'features/children/application/children_providers.dart';
import 'features/notifications/data/notifications_repository.dart';

class UniParentApp extends ConsumerStatefulWidget {
  const UniParentApp({super.key});

  @override
  ConsumerState<UniParentApp> createState() => _UniParentAppState();
}

class _UniParentAppState extends ConsumerState<UniParentApp> with WidgetsBindingObserver {
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final push = ref.read(pushServiceProvider);
    push.pendingRoute.addListener(() {
      final route = push.pendingRoute.value;
      if (route != null && ref.read(sessionProvider).value != null) {
        ref.read(routerProvider).push(route);
        push.pendingRoute.value = null;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _pausedAt = DateTime.now();
    if (state == AppLifecycleState.resumed) {
      // Reverrouillage biométrique après 2 minutes en arrière-plan.
      if (_pausedAt != null && DateTime.now().difference(_pausedAt!) > const Duration(minutes: 2)) {
        ref.read(appLockProvider.notifier).lock();
      }
      ref.invalidate(unreadCountProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Connexion : enregistrement du jeton push et chargement des enfants.
    ref.listen(sessionProvider, (prev, next) {
      if (prev?.value == null && next.value != null) ref.read(pushServiceProvider).registerDevice();
    });
    // Retour du réseau : synchronisation automatique des données affichées.
    ref.listen(connectivityProvider, (prev, next) {
      if (prev == NetworkStatus.offline && next == NetworkStatus.online) {
        ref.invalidate(childrenProvider);
        ref.invalidate(unreadCountProvider);
      }
    });

    final locale = ref.watch(localeProvider);
    // Formats des nombres et des dates alignés sur la langue choisie (1 085 000 FCFA, 13 octobre 2026).
    Intl.defaultLocale = locale.languageCode == 'fr' ? 'fr_FR' : 'en';

    return MaterialApp.router(
      title: FlavorConfig.instance.appName,
      debugShowCheckedModeBanner: FlavorConfig.isDev,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),
      locale: locale,
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

/// Raccourci pour naviguer depuis un contexte sans BuildContext.
extension RouterRefX on WidgetRef {
  GoRouter get router => read(routerProvider);
}
