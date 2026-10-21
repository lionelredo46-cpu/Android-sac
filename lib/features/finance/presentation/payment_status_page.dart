import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/ui.dart';
import '../../children/application/children_providers.dart';
import '../../dashboard/application/dashboard_providers.dart';
import '../data/finance_repository.dart';
import '../domain/finance_models.dart';
import 'finance_widgets.dart';

/// Attente de confirmation : la vérité vient du serveur (webhook signé),
/// l'application se contente d'interroger régulièrement le statut.
class PaymentStatusPage extends ConsumerStatefulWidget {
  final String paymentId;
  final String? initialUrl;
  const PaymentStatusPage({super.key, required this.paymentId, this.initialUrl});

  @override
  ConsumerState<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends ConsumerState<PaymentStatusPage> {
  static const _pollEvery = Duration(seconds: 4);
  static const _maxWait = Duration(minutes: 5);

  PaymentIntent? _intent;
  Timer? _timer;
  final _started = DateTime.now();
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) _openUrl(widget.initialUrl!);
    _poll();
    _timer = Timer.periodic(_pollEvery, (_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _done => _intent != null && (_intent!.statut == 'VALIDE' || _intent!.statut == 'ECHOUE');

  Future<void> _poll() async {
    if (_done) return;
    if (DateTime.now().difference(_started) > _maxWait) {
      _timer?.cancel();
      setState(() => _timedOut = true);
      return;
    }
    try {
      final s = await ref.read(financeRepositoryProvider).status(widget.paymentId);
      if (!mounted) return;
      setState(() => _intent = s);
      if (_done) _onFinished();
    } catch (_) {
      // Réseau instable : on réessaie au prochain cycle.
    }
  }

  void _onFinished() {
    _timer?.cancel();
    final child = ref.read(activeChildProvider);
    if (child != null) {
      ref.invalidate(invoicesProvider(child.id));
      ref.invalidate(paymentsProvider(child.id));
      ref.invalidate(dashboardProvider(child.id));
      ref.invalidate(financeSummaryProvider(child.id));
    }
  }

  Future<void> _openUrl(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  Future<void> _simulate(bool success) async {
    try {
      final s = await ref.read(financeRepositoryProvider).sandboxConfirm(widget.paymentId, success);
      setState(() => _intent = s);
      _onFinished();
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final i = _intent;
    final status = i?.statut ?? 'EN_ATTENTE';
    final (icon, color, title, body) = switch (status) {
      'VALIDE' => (Icons.check_circle_rounded, AppColors.success, l.paymentSuccess, i != null ? Fmt.money(i.montant, i.devise) : ''),
      'ECHOUE' => (Icons.cancel_rounded, AppColors.error, l.paymentFailed, l.paymentFailedBody),
      _ => (Icons.hourglass_top_rounded, AppColors.warning, l.paymentPending, l.paymentPendingBody),
    };

    return PopScope(
      canPop: _done || _timedOut,
      child: Scaffold(
        appBar: AppBar(title: Text(l.paymentTitle), automaticallyImplyLeading: _done || _timedOut),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Semantics(liveRegion: true, child: Icon(icon, size: 96, color: color)),
              const SizedBox(height: 20),
              Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center, style: AppTextStyles.bodyLarge),
              if (i != null) ...[
                const SizedBox(height: 8),
                Text('Réf. ${i.reference}', textAlign: TextAlign.center, style: AppTextStyles.caption),
              ],
              if (!_done && !_timedOut) ...[const SizedBox(height: 24), const Center(child: CircularProgressIndicator())],
              if (_timedOut && !_done) ...[
                const SizedBox(height: 16),
                Text('La confirmation prend plus de temps que prévu. Vous serez notifié dès réception ; aucun double débit n’est possible.',
                    textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
              ],
              const SizedBox(height: 32),
              if (!_done && widget.initialUrl != null)
                OutlinedButton.icon(onPressed: () => _openUrl(widget.initialUrl!), icon: const Icon(Icons.open_in_new_rounded), label: Text(l.openPaymentPage)),
              if (!_done && FlavorConfig.isDev) ...[
                const SizedBox(height: 8),
                OutlinedButton(onPressed: () => _simulate(true), child: Text(l.simulateSuccess)),
                TextButton(onPressed: () => _simulate(false), child: Text(l.simulateFailure)),
              ],
              if (status == 'VALIDE' && i?.receipt != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: Text(l.viewReceipt),
                  onPressed: () => openReceipt(context, i!.receipt!, () => ref.read(financeRepositoryProvider).receiptPdf(i.receipt!.id)),
                ),
              if (_done || _timedOut) ...[
                const SizedBox(height: 8),
                TextButton(onPressed: () => context.go(RoutePaths.finances), child: Text(l.close)),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
