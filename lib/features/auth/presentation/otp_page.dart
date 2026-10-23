import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';
import '../application/session_controller.dart';
import '../data/auth_repository.dart';
import 'auth_scaffold.dart';
import 'otp_input.dart';

class OtpPage extends ConsumerStatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _code = TextEditingController();
  bool _loading = false;

  Future<void> _verify([String? value]) async {
    final code = value ?? _code.text;
    if (code.length != 6 || _loading) return;
    setState(() => _loading = true);
    try {
      await ref.read(sessionProvider.notifier).verifyOtp(widget.phone, code);
    } catch (e) {
      _code.clear();
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    try {
      final dev = await ref.read(authRepositoryProvider).sendOtp(widget.phone);
      if (dev != null && FlavorConfig.testTools && mounted) context.showSnack('Code (dev) : $dev');
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AuthScaffold(
      showBack: true,
      title: l.otpTitle,
      subtitle: l.otpSentTo(widget.phone),
      children: [
        OtpInput(controller: _code, onCompleted: _verify, onResend: _resend),
        const SizedBox(height: 24),
        AppButton(text: l.verify, isLoading: _loading, onPressed: _verify),
      ],
    );
  }
}
