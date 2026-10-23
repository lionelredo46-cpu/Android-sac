class StorageKeys {
  StorageKeys._();

  // Clés sécurisées (FlutterSecureStorage)
  static const String accessToken = 'secure_access_token';
  static const String refreshToken = 'secure_refresh_token';
  static const String userRole = 'secure_user_role';
  static const String userId = 'secure_user_id';
  static const String biometricPin = 'secure_biometric_pin';

  // Clés préférences (SharedPreferences)
  static const String preferredLocale = 'pref_locale';
  static const String themeMode = 'pref_theme_mode';
  static const String activeChildId = 'pref_active_child_id';
  static const String biometricEnabled = 'pref_biometric_enabled';
  static const String notificationsEnabled = 'pref_notifications_enabled';
  static const String hasCompletedOnboarding = 'pref_has_completed_onboarding';
  static const String nfcCards = 'pref_nfc_cards';
  static const String apiBaseUrl = 'pref_api_base_url';
}
