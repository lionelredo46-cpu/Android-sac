import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/ui.dart';

/// Saisie OTP à 6 chiffres (pinput) avec compte à rebours de renvoi.
class OtpInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final Future<void> Function()? onResend;

  const OtpInput({super.key, required this.controller, required this.onCompleted, this.onResend});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  int _seconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _seconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) t.cancel();
      if (mounted) setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final base = PinTheme(
      width: 48,
      height: 58,
      textStyle: AppTextStyles.h2.copyWith(color: s.text),
      decoration: BoxDecoration(color: s.glass, border: Border.all(color: s.hairline), borderRadius: BorderRadius.circular(16)),
    );
    return Column(children: [
      Pinput(
        length: 6,
        controller: widget.controller,
        autofocus: true,
        defaultPinTheme: base,
        focusedPinTheme: base.copyDecorationWith(
          border: Border.all(color: s.gold, width: 1.6),
          boxShadow: [BoxShadow(color: s.gold.withValues(alpha: 0.30), blurRadius: 16)],
        ),
        submittedPinTheme: base.copyDecorationWith(color: s.gold.withValues(alpha: 0.10), border: Border.all(color: s.gold.withValues(alpha: 0.5))),
        cursor: Container(width: 2, height: 22, color: s.gold),
        keyboardType: TextInputType.number,
        onCompleted: widget.onCompleted,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
      ),
      if (widget.onResend != null) ...[
        const SizedBox(height: 16),
        TextButton.icon(
          icon: Icon(_seconds > 0 ? Icons.timer_outlined : Icons.refresh_rounded, size: 18),
          onPressed: _seconds > 0
              ? null
              : () async {
                  await widget.onResend!();
                  _start();
                },
          label: Text(_seconds > 0 ? context.l10n.resendIn(_seconds) : context.l10n.resendCode),
        ),
      ],
    ]);
  }
}
