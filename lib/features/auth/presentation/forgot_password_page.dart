import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/ui.dart';
import '../data/auth_repository.dart';
import 'auth_scaffold.dart';
import 'otp_input.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  Future<void> _send() async {
    if (_identifier.text.trim().isEmpty || _loading) return;
    setState(() => _loading = true);
    try {
      final dev = await ref.read(authRepositoryProvider).forgotPassword(_identifier.text);
      if (dev != null && FlavorConfig.testTools && mounted) context.showSnack('Code (dev) : $dev');
      setState(() => _sent = true);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate() || _code.text.length != 6 || _loading) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(_identifier.text, _code.text, _password.text);
      if (!mounted) return;
      context.showSnack(context.l10n.resetDone);
      context.pop();
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AuthScaffold(
      showBack: true,
      title: l.resetPassword,
      children: !_sent
          ? [
              AppTextField(controller: _identifier, label: l.identifier, hint: l.identifierHint, prefixIcon: Icons.person_outline_rounded),
              const SizedBox(height: 24),
              AppButton(text: l.sendCode, isLoading: _loading, onPressed: _send),
            ]
          : [
              OtpInput(controller: _code, onCompleted: (_) {}, onResend: _send),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: AppTextField(
                  controller: _password,
                  label: l.newPassword,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) => passwordRegex.hasMatch(v ?? '') ? null : l.passwordRules,
                ),
              ),
              const SizedBox(height: 24),
              AppButton(text: l.resetPassword, isLoading: _loading, onPressed: _reset),
            ],
    );
  }
}
