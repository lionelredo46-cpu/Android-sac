import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/security/app_lock.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/pulsing_indicator.dart';
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
    final s = context.strato;
    final user = ref.watch(sessionProvider).value;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Reveal(
                offset: 0,
                child: SizedBox.square(
                  dimension: 190,
                  child: Stack(alignment: Alignment.center, children: [
                    PulsingIndicator(color: s.gold.withValues(alpha: 0.6), size: 64, rings: 3, period: const Duration(milliseconds: 2600)),
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: Strato.goldGradient,
                        boxShadow: [BoxShadow(color: s.gold.withValues(alpha: 0.5), blurRadius: 40)],
                      ),
                      child: Icon(Icons.fingerprint_rounded, size: 56, color: s.onGold),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 18),
              Reveal(index: 1, child: Text(l.hello(user?.firstName ?? ''), style: AppTextStyles.h1.copyWith(color: s.text), textAlign: TextAlign.center)),
              const SizedBox(height: 8),
              Reveal(index: 2, child: Text(l.biometricReason, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted), textAlign: TextAlign.center)),
              const SizedBox(height: 36),
              Reveal(index: 3, child: AppButton(text: l.biometricUnlock, icon: Icons.lock_open_rounded, onPressed: _unlock)),
              const SizedBox(height: 10),
              Reveal(
                index: 4,
                child: TextButton(
                  onPressed: () => ref.read(sessionProvider.notifier).logout(),
                  child: Text(l.logout, style: TextStyle(color: s.textMuted)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
