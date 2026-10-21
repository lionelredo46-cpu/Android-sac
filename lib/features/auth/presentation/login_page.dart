import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/ui.dart';
import '../application/session_controller.dart';
import '../data/auth_repository.dart';
import 'auth_scaffold.dart';
import 'demo_accounts.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _totp = TextEditingController();
  final _phone = TextEditingController();
  bool _otpMode = false;
  bool _obscure = true;
  bool _needsTotp = false;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_identifier, _password, _totp, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() => _loading = true);
    try {
      if (_otpMode) {
        final phone = normalizePhone(_phone.text);
        final devCode = await ref.read(authRepositoryProvider).sendOtp(phone);
        if (devCode != null && FlavorConfig.isDev && mounted) context.showSnack('Code (dev) : $devCode');
        if (mounted) context.push(RoutePaths.otp, extra: phone);
      } else {
        final r = await ref.read(sessionProvider.notifier).login(_identifier.text, _password.text, totpCode: _totp.text);
        if (r.twoFactorSetupRequired && mounted) {
          context.showSnack('Activez la double authentification depuis le back-office.');
        }
      }
    } on AppException catch (e) {
      if (e.code == 'TWO_FACTOR_REQUIRED') {
        setState(() => _needsTotp = true);
      } else if (mounted) {
        context.showError(e);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AuthScaffold(
      title: 'UniParent AFRAM',
      subtitle: l.loginSubtitle,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(l.password), icon: const Icon(Icons.lock_outline_rounded)),
            const ButtonSegment(value: true, label: Text('SMS'), icon: Icon(Icons.sms_outlined)),
          ],
          selected: {_otpMode},
          onSelectionChanged: (s) => setState(() => _otpMode = s.first),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(children: [
            if (_otpMode)
              AppTextField(
                controller: _phone,
                label: l.phone,
                hint: l.phoneHint,
                prefixIcon: Icons.phone_iphone_rounded,
                keyboardType: TextInputType.phone,
                validator: (v) => phoneRegex.hasMatch(normalizePhone(v ?? '')) ? null : l.invalidPhone,
              )
            else ...[
              AppTextField(
                controller: _identifier,
                label: l.identifier,
                hint: l.identifierHint,
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _password,
                label: l.password,
                obscureText: _obscure,
                prefixIcon: Icons.lock_outline_rounded,
                textInputAction: _needsTotp ? TextInputAction.next : TextInputAction.done,
                validator: (v) => (v == null || v.isEmpty) ? l.fieldRequired : null,
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Afficher' : 'Masquer',
                  icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              if (_needsTotp) ...[
                const SizedBox(height: 18),
                AppTextField(
                  controller: _totp,
                  label: l.totpCode,
                  prefixIcon: Icons.verified_user_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) => RegExp(r'^\d{6}$').hasMatch(v ?? '') ? null : l.fieldRequired,
                ),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => context.push(RoutePaths.forgotPassword), child: Text(l.forgotPassword)),
              ),
            ],
          ]),
        ),
        const SizedBox(height: 12),
        AppButton(text: _otpMode ? l.sendCode : l.login, isLoading: _loading, onPressed: _submit),
        const SizedBox(height: 24),
        Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text('${l.firstLogin} '),
          TextButton(
            onPressed: () => context.push(RoutePaths.activate),
            child: Text(l.activateAccount, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.aframPrimary)),
          ),
        ]),
        const DemoAccountsPanel(),
      ],
    );
  }
}
