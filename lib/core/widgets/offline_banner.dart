import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_text_styles.dart';
import '../network/connectivity_service.dart';
import '../theme/app_animations.dart';

/// Bandeau hors ligne : se déploie depuis le haut quand le réseau disparaît.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(connectivityProvider) == NetworkStatus.offline;
    return AnimatedSize(
      duration: AppMotion.medium,
      curve: AppMotion.emphasized,
      child: !offline
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFB45309), Color(0xFFD97706), Color(0xFFB45309)]),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Mode hors ligne — Données en cache affichées',
                        style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
