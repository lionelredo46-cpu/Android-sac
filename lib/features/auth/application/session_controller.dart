import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/providers.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

/// État de session global. `null` = déconnecté.
/// Au démarrage : si un jeton existe, on recharge le profil (/me) ; hors ligne,
/// on garde la session ouverte en mode lecture du cache.
class SessionController extends AsyncNotifier<AppUser?> {
  StreamSubscription<void>? _expiredSub;

  @override
  Future<AppUser?> build() async {
    _expiredSub?.cancel();
    _expiredSub = ref.watch(sessionExpiredProvider).stream.listen((_) => _onExpired());
    ref.onDispose(() => _expiredSub?.cancel());

    final repo = ref.read(authRepositoryProvider);
    if (!await repo.hasSession()) return null;
    try {
      return await repo.me();
    } on AppException catch (e) {
      if (e.isNetwork) {
        final cached = ref.read(cacheStoreProvider).read('me');
        if (cached?.data != null) return AppUser.fromJson(cached!.data! as Map<String, dynamic>);
      }
      return null;
    }
  }

  Future<void> _remember(AppUser user) => ref.read(cacheStoreProvider).put('me', user.toJson());

  Future<LoginResult> login(String identifier, String password, {String? totpCode}) async {
    final r = await ref.read(authRepositoryProvider).login(identifier, password, totpCode: totpCode);
    await _remember(r.user);
    state = AsyncData(r.user);
    return r;
  }

  Future<void> verifyOtp(String phone, String code) async {
    final r = await ref.read(authRepositoryProvider).verifyOtp(phone, code);
    await _remember(r.user);
    state = AsyncData(r.user);
  }

  Future<void> activate(String code, String otp, String password) async {
    final r = await ref.read(authRepositoryProvider).activate(code, otp, password);
    await _remember(r.user);
    state = AsyncData(r.user);
  }

  Future<void> refreshProfile() async {
    final user = await ref.read(authRepositoryProvider).me();
    await _remember(user);
    state = AsyncData(user);
  }

  Future<void> logout({bool allDevices = false}) async {
    try {
      await ref.read(authRepositoryProvider).logout(allDevices: allDevices);
    } catch (_) {
      // Hors ligne : les jetons locaux sont tout de même effacés.
    }
    await _clearLocal();
  }

  Future<void> _onExpired() async {
    await _clearLocal();
  }

  Future<void> _clearLocal() async {
    await ref.read(cacheStoreProvider).clear();
    await ref.read(secureStorageProvider).clearAuth();
    state = const AsyncData(null);
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, AppUser?>(SessionController.new);
