import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../providers.dart';

/// Verrouillage biométrique (empreinte / Face ID) après la première connexion.
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, options: const AuthenticationOptions(stickyAuth: true));
    } on PlatformException {
      return false;
    }
  }
}

final biometricServiceProvider = Provider<BiometricService>((_) => BiometricService());

/// true tant que l'utilisateur n'a pas déverrouillé l'app (si la biométrie est activée).
class AppLockController extends Notifier<bool> {
  @override
  bool build() => ref.read(sharedPrefsProvider).isBiometricEnabled;

  void unlock() => state = false;
  void lock() {
    if (ref.read(sharedPrefsProvider).isBiometricEnabled) state = true;
  }
}

final appLockProvider = NotifierProvider<AppLockController, bool>(AppLockController.new);
