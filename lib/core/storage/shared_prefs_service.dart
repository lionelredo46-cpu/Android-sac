import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class SharedPrefsService {
  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  static Future<SharedPrefsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsService(prefs);
  }

  // Langue
  String get preferredLocale => _prefs.getString(StorageKeys.preferredLocale) ?? 'fr';
  Future<bool> setPreferredLocale(String locale) => _prefs.setString(StorageKeys.preferredLocale, locale);

  // Thème
  String get themeMode => _prefs.getString(StorageKeys.themeMode) ?? 'system';
  Future<bool> setThemeMode(String mode) => _prefs.setString(StorageKeys.themeMode, mode);

  // Enfant actif sélectionné
  String? get activeChildId => _prefs.getString(StorageKeys.activeChildId);
  Future<bool> setActiveChildId(String childId) => _prefs.setString(StorageKeys.activeChildId, childId);

  // Biométrie
  bool get isBiometricEnabled => _prefs.getBool(StorageKeys.biometricEnabled) ?? false;
  Future<bool> setBiometricEnabled(bool enabled) => _prefs.setBool(StorageKeys.biometricEnabled, enabled);

  // Onboarding
  bool get hasCompletedOnboarding => _prefs.getBool(StorageKeys.hasCompletedOnboarding) ?? false;
  Future<bool> setCompletedOnboarding(bool completed) => _prefs.setBool(StorageKeys.hasCompletedOnboarding, completed);
}
