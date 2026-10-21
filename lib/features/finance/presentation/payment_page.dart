import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/router/route_paths.dart';
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
        title: Text(l.confirmPayment(Fmt.money(amount, inv.devise))),
        content: Text('${inv.title}\n${_canal == 'ONLINE_CARD' ? l.card : '${l.mobileMoney} · ${normalizePhone(_phone.text)}'}'),
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

          return ListView(padding: const EdgeInsets.all(16), children: [
            Card(
              child: ListTile(
                title: Text(inv.title, style: AppTextStyles.h3),
                subtitle: Text('${inv.numeroFacture} · ${l.dueDate} ${Fmt.date(inv.dateEcheance)}'),
                trailing: Text(Fmt.money(inv.soldeRestant, inv.devise), style: AppTextStyles.h3.copyWith(color: AppColors.error)),
              ),
            ),
            const SizedBox(height: 16),
            Text(l.amountToPay, style: AppTextStyles.h3),
            RadioGroup<bool>(
              groupValue: _partial,
              onChanged: (v) => setState(() => _partial = v ?? false),
              child: Column(children: [
                RadioListTile<bool>(value: false, title: Text('${l.fullAmount} — ${Fmt.money(inv.soldeRestant, inv.devise)}')),
                RadioListTile<bool>(value: true, title: Text(l.partialAmount)),
              ]),
            ),
            if (_partial)
              TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l.amountToPay, suffixText: 'FCFA', helperText: '1 – ${Fmt.money(inv.soldeRestant)}'),
              ),
            const SizedBox(height: 16),
            Text(l.paymentMethod, style: AppTextStyles.h3),
            const SizedBox(height: 8),
            if (providers.isLoading) const LinearProgressIndicator(),
            if (providers.hasError) Text(l.requiresNetwork, style: const TextStyle(color: AppColors.error)),
            if (canMobile)
              _MethodTile(
                selected: _canal == 'ONLINE_MOBILE_MONEY',
                icon: Icons.phone_android_rounded,
                title: l.mobileMoney,
                subtitle: l.mobileMoneyHint,
                onTap: () => setState(() => _canal = 'ONLINE_MOBILE_MONEY'),
              ),
            if (canCard)
              _MethodTile(
                selected: _canal == 'ONLINE_CARD',
                icon: Icons.credit_card_rounded,
                title: l.card,
                subtitle: l.cardHint,
                onTap: () => setState(() => _canal = 'ONLINE_CARD'),
              ),
            if (_canal == 'ONLINE_MOBILE_MONEY') ...[
              const SizedBox(height: 12),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l.mobileMoneyNumber, prefixIcon: const Icon(Icons.phone_rounded)),
              ),
            ],
            const SizedBox(height: 24),
            AppButton(
              text: l.payNow,
              icon: Icons.lock_rounded,
              isLoading: _loading,
              onPressed: available.isEmpty ? null : () => _pay(inv, available),
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.verified_user_rounded, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              Flexible(child: Text('Paiement sécurisé — aucune donnée bancaire n’est stockée par l’AFRAM.', style: AppTextStyles.caption, textAlign: TextAlign.center)),
            ]),
          ]);
        },
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MethodTile({required this.selected, required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: selected ? AppColors.aframPrimary : AppColors.borderLight, width: selected ? 2 : 1),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.aframPrimary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.aframPrimary),
        ),
      );
}
