import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/security/app_lock.dart';
import '../../../core/widgets/ui.dart';
import '../application/session_controller.dart';

/// Écran de déverrouillage biométrique (empreinte / Face ID).
class LockPage extends ConsumerStatefulWidget {
  const LockPage({super.key});

  @override
  ConsumerState<LockPage> createState() => _LockPageState();
}

class _LockPageState extends ConsumerState<LockPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    final ok = await ref.read(biometricServiceProvider).authenticate(context.l10n.biometricReason);
    if (ok) ref.read(appLockProvider.notifier).unlock();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(sessionProvider).value;
    return Scaffold(
      backgroundColor: AppColors.aframPrimary,
      body: SafeArea(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.fingerprint_rounded, size: 96, color: Colors.white),
            const SizedBox(height: 24),
            Text(l.hello(user?.firstName ?? ''), style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.aframGold, minimumSize: const Size(260, 52)),
              onPressed: _unlock,
              icon: const Icon(Icons.lock_open_rounded),
              label: Text(l.biometricUnlock),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.read(sessionProvider.notifier).logout(),
              child: Text(l.logout, style: const TextStyle(color: Colors.white70)),
            ),
          ]),
        ),
      ),
    );
  }
}
