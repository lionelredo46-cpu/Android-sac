import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../domain/app_user.dart';

class LoginResult {
  final AppUser user;
  final bool twoFactorSetupRequired;
  const LoginResult(this.user, this.twoFactorSetupRequired);
}

class ActivationStart {
  final String? maskedPhone;
  final String? prenom;
  final String? devCode;
  const ActivationStart({this.maskedPhone, this.prenom, this.devCode});
}

class AuthRepository {
  final ApiClient _api;
  final SecureStorageService _storage;
  AuthRepository(this._api, this._storage);

  Future<LoginResult> _persist(Map<String, dynamic> res) async {
    await _storage.saveTokens(accessToken: res['accessToken'] as String, refreshToken: res['refreshToken'] as String);
    final user = AppUser.fromJson(res['user'] as Map<String, dynamic>);
    await _storage.saveUserId(user.id);
    await _storage.saveUserRole(user.role);
    return LoginResult(user, res['twoFactorSetupRequired'] == true);
  }

  Future<LoginResult> login(String identifier, String password, {String? totpCode}) async =>
      _persist(await _api.post<Map<String, dynamic>>(ApiEndpoints.login, data: {
        'identifier': identifier.trim(),
        'password': password,
        if (totpCode != null && totpCode.isNotEmpty) 'totpCode': totpCode,
      }));

  /// Renvoie le code en mode développement uniquement (OTP_DEV_ECHO côté API).
  Future<String?> sendOtp(String phone) async {
    final res = await _api.post<Map<String, dynamic>>(ApiEndpoints.otpSend, data: {'phone': phone});
    return res['devCode'] as String?;
  }

  Future<LoginResult> verifyOtp(String phone, String code) async =>
      _persist(await _api.post<Map<String, dynamic>>(ApiEndpoints.otpVerify, data: {'phone': phone, 'code': code}));

  Future<ActivationStart> startActivation(String code) async {
    final res = await _api.post<Map<String, dynamic>>(ApiEndpoints.activateStart, data: {'activationCode': code.trim()});
    return ActivationStart(maskedPhone: res['maskedPhone'] as String?, prenom: res['prenom'] as String?, devCode: res['devCode'] as String?);
  }

  Future<LoginResult> activate(String code, String otp, String password) async =>
      _persist(await _api.post<Map<String, dynamic>>(ApiEndpoints.activate, data: {'activationCode': code.trim(), 'otpCode': otp, 'newPassword': password}));

  Future<String?> forgotPassword(String identifier) async {
    final res = await _api.post<Map<String, dynamic>>(ApiEndpoints.forgotPassword, data: {'identifier': identifier.trim()});
    return res['devCode'] as String?;
  }

  Future<void> resetPassword(String identifier, String code, String password) =>
      _api.post(ApiEndpoints.resetPassword, data: {'identifier': identifier.trim(), 'code': code, 'newPassword': password});

  Future<void> changePassword(String current, String next) =>
      _api.post(ApiEndpoints.changePassword, data: {'currentPassword': current, 'newPassword': next});

  Future<AppUser> me() async => AppUser.fromJson(await _api.get<Map<String, dynamic>>(ApiEndpoints.me));

  Future<void> updateLocale(String locale) => _api.patch(ApiEndpoints.me, data: {'preferredLocale': locale});

  Future<void> registerDevice(String token, String platform) =>
      _api.post(ApiEndpoints.devices, data: {'token': token, 'platform': platform});

  Future<void> logout({bool allDevices = false}) async {
    try {
      await _api.post(allDevices ? ApiEndpoints.logoutAll : ApiEndpoints.logout);
    } finally {
      await _storage.clearAuth();
    }
  }

  Future<bool> hasSession() async => (await _storage.getAccessToken())?.isNotEmpty == true;
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider), ref.watch(secureStorageProvider)),
);
