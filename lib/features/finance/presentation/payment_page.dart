import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/application/session_controller.dart';
import '../../auth/presentation/auth_scaffold.dart';
import '../data/finance_repository.dart';
import '../domain/finance_models.dart';

/// Parcours P2 : choix du montant (total/partiel), du moyen de paiement, puis
/// confirmation. Une clé d'idempotence unique protège contre le double paiement.
class PaymentPage extends ConsumerStatefulWidget {
  final String invoiceId;
  const PaymentPage({super.key, required this.invoiceId});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final _amount = TextEditingController();
  late final _phone = TextEditingController(text: ref.read(sessionProvider).value?.telephone ?? '');
  final _idempotencyKey = const Uuid().v4();
  bool _partial = false;
  String _canal = 'ONLINE_MOBILE_MONEY';
  bool _loading = false;

  int? _resolveAmount(Invoice inv) {
    if (!_partial) return inv.soldeRestant;
    final v = int.tryParse(_amount.text.replaceAll(RegExp(r'\D'), ''));
    return (v == null || v <= 0 || v > inv.soldeRestant) ? null : v;
  }

  Future<void> _pay(Invoice inv, List<ProviderOption> providers) async {
    final l = context.l10n;
    final amount = _resolveAmount(inv);
    if (amount == null) return context.showSnack('${l.amountToPay} : 1 – ${Fmt.money(inv.soldeRestant)}', error: true);
    final provider = providers.firstWhere((p) => p.canaux.contains(_canal) && p.parDefaut, orElse: () => providers.firstWhere((p) => p.canaux.contains(_canal)));
    if (_canal == 'ONLINE_MOBILE_MONEY' && !phoneRegex.hasMatch(normalizePhone(_phone.text))) {
      return context.showSnack(l.invalidPhone, error: true);
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.lock_rounded, color: ctx.strato.gold, size: 32),
        title: Text(l.confirmPayment(Fmt.money(amount, inv.devise)), textAlign: TextAlign.center),
        content: Text('${inv.title}\n${_canal == 'ONLINE_CARD' ? l.card : '${l.mobileMoney} · ${normalizePhone(_phone.text)}'}', textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.confirm)),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _loading = true);
    HapticFeedback.mediumImpact();
    try {
      final intent = await ref.read(financeRepositoryProvider).initiate(
            invoiceId: inv.id,
            montant: amount,
            canal: _canal,
            provider: provider.code,
            telephone: _canal == 'ONLINE_MOBILE_MONEY' ? normalizePhone(_phone.text) : null,
            idempotencyKey: _idempotencyKey,
          );
      if (!mounted) return;
      context.pushReplacement(RoutePaths.paymentStatus(intent.paymentId), extra: intent.paymentUrl);
    } on AppException catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    final invoice = ref.watch(invoiceProvider(widget.invoiceId));
    final providers = ref.watch(paymentProvidersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.paymentTitle)),
      body: CachedAsyncView<Invoice>(
        value: invoice,
        onRetry: () => ref.invalidate(invoiceProvider(widget.invoiceId)),
        builder: (context, inv) {
          final available = providers.value ?? const <ProviderOption>[];
          final canMobile = available.any((p) => p.canaux.contains('ONLINE_MOBILE_MONEY'));
          final canCard = available.any((p) => p.canaux.contains('ONLINE_CARD'));
          if (!canMobile && _canal == 'ONLINE_MOBILE_MONEY' && canCard) _canal = 'ONLINE_CARD';
          var i = 0;
          Widget r(Widget w) => Reveal(index: i++, child: w);

          return ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 28 + context.bottomInset), children: [
            r(GlassCard(
              gradient: s.heroGradient,
              glow: s.accentDeep,
              radius: 28,
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(inv.title, style: AppTextStyles.h3.copyWith(color: Colors.white)),
                Text('${inv.numeroFacture} · ${l.dueDate} ${Fmt.date(inv.dateEcheance)}', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xB3FFFFFF))),
                const SizedBox(height: 14),
                Text(l.amountToPay, style: AppTextStyles.caption.copyWith(color: const Color(0xB3FFFFFF))),
                AnimatedSwitcher(
                  duration: AppMotion.medium,
                  child: Text(
                    _partial ? (_resolveAmount(inv) == null ? '—' : Fmt.money(_resolveAmount(inv)!, inv.devise)) : Fmt.money(inv.soldeRestant, inv.devise),
                    key: ValueKey(_partial ? _amount.text : 'full'),
                    style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 32),
                  ),
                ),
              ]),
            )),
            SectionLabel(l.amountToPay),
            r(Row(children: [
              Expanded(child: _Choice(selected: !_partial, icon: Icons.all_inclusive_rounded, title: l.fullAmount, subtitle: Fmt.money(inv.soldeRestant, inv.devise), onTap: () => setState(() => _partial = false))),
              const SizedBox(width: 10),
              Expanded(child: _Choice(selected: _partial, icon: Icons.tune_rounded, title: l.partialAmount, subtitle: '1 – ${Fmt.money(inv.soldeRestant)}', onTap: () => setState(() => _partial = true))),
            ])),
            AnimatedSize(
              duration: AppMotion.medium,
              curve: AppMotion.emphasized,
              child: _partial
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: _amount,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setState(() {}),
                        style: AppTextStyles.h3.copyWith(color: s.text),
                        decoration: InputDecoration(labelText: l.amountToPay, suffixText: 'FCFA', helperText: '1 – ${Fmt.money(inv.soldeRestant)}'),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            SectionLabel(l.paymentMethod),
            if (providers.isLoading) const LinearProgressIndicator(),
            if (providers.hasError) Text(l.requiresNetwork, style: TextStyle(color: s.danger)),
            if (canMobile)
              r(_MethodTile(
                selected: _canal == 'ONLINE_MOBILE_MONEY',
                icon: Icons.phone_android_rounded,
                color: s.gold,
                title: l.mobileMoney,
                subtitle: l.mobileMoneyHint,
                onTap: () => setState(() => _canal = 'ONLINE_MOBILE_MONEY'),
              )),
            if (canCard)
              r(_MethodTile(
                selected: _canal == 'ONLINE_CARD',
                icon: Icons.credit_card_rounded,
                color: s.accent,
                title: l.card,
                subtitle: l.cardHint,
                onTap: () => setState(() => _canal = 'ONLINE_CARD'),
              )),
            AnimatedSize(
              duration: AppMotion.medium,
              curve: AppMotion.emphasized,
              child: _canal == 'ONLINE_MOBILE_MONEY'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: l.mobileMoneyNumber, prefixIcon: const Icon(Icons.phone_rounded)),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 26),
            r(AppButton(
              text: l.payNow,
              icon: Icons.lock_rounded,
              isLoading: _loading,
              onPressed: available.isEmpty ? null : () => _pay(inv, available),
            )),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.verified_user_rounded, size: 16, color: s.success),
              const SizedBox(width: 6),
              Flexible(
                child: Text('Paiement sécurisé — aucune donnée bancaire n’est stockée par l’AFRAM.',
                    style: AppTextStyles.caption.copyWith(color: s.textMuted), textAlign: TextAlign.center),
              ),
            ]),
          ]);
        },
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _Choice({required this.selected, required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      radius: 20,
      onTap: onTap,
      semanticLabel: title,
      borderColor: selected ? s.gold : null,
      tint: selected ? s.gold.withValues(alpha: s.isDark ? 0.12 : 0.08) : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: selected ? s.gold : s.textMuted, size: 20),
          const Spacer(),
          AnimatedContainer(
            duration: AppMotion.fast,
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected ? Strato.goldGradient : null,
              border: selected ? null : Border.all(color: s.hairlineStrong, width: 1.5),
            ),
            child: selected ? Icon(Icons.check_rounded, size: 13, color: s.onGold) : null,
          ),
        ]),
        const SizedBox(height: 10),
        Text(title, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w700)),
        Text(subtitle, style: AppTextStyles.caption.copyWith(color: s.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MethodTile({required this.selected, required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      semanticLabel: title,
      borderColor: selected ? s.gold : null,
      glow: selected ? s.gold : null,
      child: Row(children: [
        GlowIcon(icon, color: color, size: 46),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.bodyLarge.copyWith(color: s.text, fontWeight: FontWeight.w700)),
            Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
          ]),
        ),
        AnimatedSwitcher(
          duration: AppMotion.fast,
          child: Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, key: ValueKey(selected), color: selected ? s.gold : s.textFaint),
        ),
      ]),
    );
  }
}
