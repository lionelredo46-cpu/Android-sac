import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_animations.dart';
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
        if (devCode != null && FlavorConfig.testTools && mounted) context.showSnack('Code (dev) : $devCode');
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
        HapticFeedback.heavyImpact();
        context.showError(e);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    return AuthScaffold(
      title: 'UniParent AFRAM',
      subtitle: l.loginSubtitle,
      footer: [
        const SizedBox(height: 22),
        Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text('${l.firstLogin} ', style: AppTextStyles.bodyMedium.copyWith(color: s.textMuted)),
          TextButton(
            onPressed: () => context.push(RoutePaths.activate),
            child: Text(l.activateAccount, style: TextStyle(fontWeight: FontWeight.w800, color: s.gold)),
          ),
        ]),
        const DemoAccountsPanel(),
      ],
      children: [
        _ModeToggle(
          otp: _otpMode,
          passwordLabel: l.password,
          onChanged: (v) => setState(() => _otpMode = v),
        ),
        const SizedBox(height: 22),
        Form(
          key: _formKey,
          child: AnimatedSize(
            duration: AppMotion.medium,
            curve: AppMotion.emphasized,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: AppMotion.medium,
              transitionBuilder: (child, a) => FadeTransition(
                opacity: a,
                child: SlideTransition(position: Tween(begin: const Offset(0.04, 0), end: Offset.zero).animate(a), child: child),
              ),
              child: _otpMode
                  ? AppTextField(
                      key: const ValueKey('phone'),
                      controller: _phone,
                      label: l.phone,
                      hint: l.phoneHint,
                      prefixIcon: Icons.phone_iphone_rounded,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      validator: (v) => phoneRegex.hasMatch(normalizePhone(v ?? '')) ? null : l.invalidPhone,
                    )
                  : Column(key: const ValueKey('password'), children: [
                      AppTextField(
                        controller: _identifier,
                        label: l.identifier,
                        hint: l.identifierHint,
                        prefixIcon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username, AutofillHints.email],
                        validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        controller: _password,
                        label: l.password,
                        obscureText: _obscure,
                        prefixIcon: Icons.lock_outline_rounded,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: _needsTotp ? TextInputAction.next : TextInputAction.done,
                        onSubmitted: _needsTotp ? null : (_) => _submit(),
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
                    ]),
            ),
          ),
        ),
        SizedBox(height: _otpMode ? 24 : 6),
        AppButton(text: _otpMode ? l.sendCode : l.login, icon: _otpMode ? Icons.sms_rounded : Icons.arrow_forward_rounded, isLoading: _loading, onPressed: _submit),
      ],
    );
  }
}

/// Bascule mot de passe / SMS : une pastille dorée glisse sous l'option choisie.
class _ModeToggle extends StatelessWidget {
  final bool otp;
  final String passwordLabel;
  final ValueChanged<bool> onChanged;
  const _ModeToggle({required this.otp, required this.passwordLabel, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    Widget option(bool value, IconData icon, String label) {
      final selected = otp == value;
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!selected) HapticFeedback.selectionClick();
              onChanged(value);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 18, color: selected ? s.onGold : s.textMuted),
              const SizedBox(width: 8),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: AppMotion.fast,
                  style: AppTextStyles.button.copyWith(fontSize: 14.5, color: selected ? s.onGold : s.textMuted),
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
            ]),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: s.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: s.hairline)),
      child: Stack(children: [
        AnimatedAlign(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          alignment: otp ? Alignment.centerRight : Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: Strato.goldGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: s.gold.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 4))],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            option(false, Icons.lock_outline_rounded, passwordLabel),
            option(true, Icons.sms_outlined, 'SMS'),
          ]),
        ),
      ]),
    );
  }
}
