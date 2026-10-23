import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../theme/strato.dart';
import 'app_button.dart';
import 'empty_state_view.dart';

class ErrorStateView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStateView({
    super.key,
    this.title = 'Une erreur est survenue',
    required this.message,
    this.onRetry,
    this.icon = Icons.cloud_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          OrbitEmblem(icon: icon, color: s.danger),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.h2.copyWith(color: s.text, fontSize: 21), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(message, style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted), textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            SizedBox(width: 220, child: AppButton(text: 'Réessayer', icon: Icons.refresh_rounded, onPressed: onRetry, isOutlined: true)),
          ],
        ]),
      ),
    );
  }
}
