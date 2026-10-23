import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/ui.dart';
import '../application/session_controller.dart';
import '../data/auth_repository.dart';
import 'auth_scaffold.dart';
import 'otp_input.dart';

/// Parcours P1 : code d'invitation (SMS) → OTP sur le téléphone enregistré
/// → création du mot de passe → accès aux enfants rattachés.
class ActivationPage extends ConsumerStatefulWidget {
  final String? initialCode;
  const ActivationPage({super.key, this.initialCode});

  @override
  ConsumerState<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends ConsumerState<ActivationPage> {
  final _formKey = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.initialCode ?? '');
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  ActivationStart? _started;
  bool _loading = false;

  Future<void> _start() async {
    if (_code.text.trim().isEmpty || _loading) return;
    setState(() => _loading = true);
    try {
      final s = await ref.read(authRepositoryProvider).startActivation(_code.text);
      if (s.devCode != null && FlavorConfig.testTools && mounted) context.showSnack('Code (dev) : ${s.devCode}');
      setState(() => _started = s);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _activate() async {
    if (!_formKey.currentState!.validate() || _otp.text.length != 6 || _loading) return;
    setState(() => _loading = true);
    try {
      await ref.read(sessionProvider.notifier).activate(_code.text, _otp.text, _password.text);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = _started;
    return AuthScaffold(
      showBack: true,
      title: s?.prenom != null ? l.activationHello(s!.prenom!) : l.activationTitle,
      subtitle: s == null ? l.activationCodeHint : l.otpSentTo(s.maskedPhone ?? ''),
      children: s == null
          ? [
              AppTextField(controller: _code, label: l.activationCode, hint: 'AFR-XXXXXXXX', prefixIcon: Icons.vpn_key_outlined),
              const SizedBox(height: 24),
              AppButton(text: l.next, isLoading: _loading, onPressed: _start),
            ]
          : [
              OtpInput(controller: _otp, onCompleted: (_) {}, onResend: _start),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(children: [
                  AppTextField(
                    controller: _password,
                    label: l.newPassword,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (v) => passwordRegex.hasMatch(v ?? '') ? null : l.passwordRules,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _confirm,
                    label: l.confirmPassword,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (v) => v == _password.text ? null : l.passwordsDontMatch,
                  ),
                  const SizedBox(height: 8),
                  Text(l.passwordRules, style: Theme.of(context).textTheme.bodySmall),
                ]),
              ),
              const SizedBox(height: 24),
              AppButton(text: l.activateAccount, isLoading: _loading, onPressed: _activate),
            ],
    );
  }
}
