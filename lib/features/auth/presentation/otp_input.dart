import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/app_colors.dart';
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
    final base = PinTheme(
      width: 50,
      height: 56,
      textStyle: AppTextStyles.h2,
      decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(12)),
    );
    return Column(children: [
      Pinput(
        length: 6,
        controller: widget.controller,
        autofocus: true,
        defaultPinTheme: base,
        focusedPinTheme: base.copyDecorationWith(border: Border.all(color: AppColors.aframPrimary, width: 2)),
        keyboardType: TextInputType.number,
        onCompleted: widget.onCompleted,
      ),
      if (widget.onResend != null) ...[
        const SizedBox(height: 16),
        TextButton(
          onPressed: _seconds > 0
              ? null
              : () async {
                  await widget.onResend!();
                  _start();
                },
          child: Text(_seconds > 0 ? context.l10n.resendIn(_seconds) : context.l10n.resendCode),
        ),
      ],
    ]);
  }
}
