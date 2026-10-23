enum Flavor { dev, staging, prod }

/// Configuration par environnement (flavor). L'URL de l'API peut être
/// surchargée au lancement : `--dart-define=API_BASE_URL=https://...`
/// (utile pour tester sur un téléphone physique en réseau local).
class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;

  /// URL compilée dans l'application (avant tout changement de serveur en recette).
  final String defaultApiBaseUrl;
  final bool enableLogging;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.defaultApiBaseUrl,
    required this.enableLogging,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  static void initialize({
    required Flavor flavor,
    required String appName,
    required String apiBaseUrl,
    bool enableLogging = false,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 30),
  }) {
    const override = String.fromEnvironment('API_BASE_URL');
    _instance = FlavorConfig._internal(
      flavor: flavor,
      appName: appName,
      apiBaseUrl: override.isNotEmpty ? override : apiBaseUrl,
      defaultApiBaseUrl: override.isNotEmpty ? override : apiBaseUrl,
      enableLogging: enableLogging,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
  }

  /// Change de serveur sans recompiler (recette) ; null revient à l'URL compilée.
  static void overrideApiBaseUrl(String? url) {
    final i = instance;
    _instance = FlavorConfig._internal(
      flavor: i.flavor,
      appName: i.appName,
      apiBaseUrl: url ?? i.defaultApiBaseUrl,
      defaultApiBaseUrl: i.defaultApiBaseUrl,
      enableLogging: i.enableLogging,
      connectTimeout: i.connectTimeout,
      receiveTimeout: i.receiveTimeout,
    );
  }

  static FlavorConfig get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('FlavorConfig must be initialized before access.');
    }
    return i;
  }

  static bool get isDev => instance.flavor == Flavor.dev;
  static bool get isStaging => instance.flavor == Flavor.staging;
  static bool get isProd => instance.flavor == Flavor.prod;

  /// Outils de recette (comptes de démonstration, simulation de paiement, NFC simulé) :
  /// développement et recette uniquement, jamais en production.
  static bool get testTools => !isProd;
}
