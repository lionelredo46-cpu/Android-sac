import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/ui.dart';
import '../application/session_controller.dart';

/// Comptes créés par le seed de démonstration (backend/prisma/seed.ts).
const demoPassword = 'Afram2026!';

class DemoAccount {
  final String label;
  final String identifier;
  final String detail;
  final IconData icon;
  final Color color;
  const DemoAccount(this.label, this.identifier, this.detail, this.icon, this.color);
}

const demoAccounts = [
  DemoAccount('Parent — Jean-Marc OBIANG', 'parent@aframgabon.com', '2 enfants · tranche en retard', Icons.family_restroom_rounded, AppColors.aframGold),
  DemoAccount('Étudiant — Alexandre OBIANG', 'alexandre.obiang@etudiant.afram.ga', 'L3 SIL · scan QR de présence', Icons.school_rounded, AppColors.success),
  DemoAccount('Étudiante — Grâce OBIANG', 'grace.obiang@etudiant.afram.ga', 'L1 MGO · dossier incomplet', Icons.school_outlined, AppColors.info),
  DemoAccount('Camarade — Lucie MBA', 'etudiant1@etudiant.afram.ga', 'Test anti-IDOR (autre famille)', Icons.person_outline_rounded, Color(0xFF8B7BFF)),
];

/// Connexion en un appui (développement et recette — jamais affiché en production).
class DemoAccountsPanel extends ConsumerStatefulWidget {
  const DemoAccountsPanel({super.key});

  @override
  ConsumerState<DemoAccountsPanel> createState() => _DemoAccountsPanelState();
}

class _DemoAccountsPanelState extends ConsumerState<DemoAccountsPanel> {
  String? _loading;

  Future<void> _login(DemoAccount a) async {
    setState(() => _loading = a.identifier);
    try {
      await ref.read(sessionProvider.notifier).login(a.identifier, demoPassword);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = null);
    }
  }

  /// Pointe l'application vers un autre serveur (ex. domaine Railway) sans la recompiler.
  Future<void> _changeServer() async {
    final config = FlavorConfig.instance;
    final url = TextEditingController(text: config.apiBaseUrl);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.dns_rounded, color: ctx.strato.gold, size: 30),
        title: const Text('Serveur de l’API'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(
            controller: url,
            keyboardType: TextInputType.url,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Adresse', hintText: 'https://….up.railway.app'),
          ),
          const SizedBox(height: 8),
          Text('Par défaut : ${config.defaultApiBaseUrl}', style: AppTextStyles.caption.copyWith(color: ctx.strato.textMuted)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, ''), child: const Text('Par défaut')),
          FilledButton(onPressed: () => Navigator.pop(ctx, url.text.trim()), child: Text(ctx.l10n.save)),
        ],
      ),
    );
    if (result == null || !mounted) return;
    final value = result.replaceAll(RegExp(r'/+$'), '');
    if (value.isNotEmpty && Uri.tryParse(value)?.hasScheme != true) return context.showSnack('Adresse invalide (http:// ou https://)', error: true);
    final next = value.isEmpty || value == config.defaultApiBaseUrl ? null : value;
    await ref.read(sharedPrefsProvider).setApiBaseUrl(next);
    FlavorConfig.overrideApiBaseUrl(next);
    ref.invalidate(apiClientProvider);
    setState(() {});
    if (mounted) context.showSnack('Serveur : ${FlavorConfig.instance.apiBaseUrl}');
  }

  @override
  Widget build(BuildContext context) {
    if (!FlavorConfig.testTools) return const SizedBox.shrink();
    final s = context.strato;
    Widget tile({required IconData icon, required Color color, required String title, required String subtitle, required Widget trailing, VoidCallback? onTap}) => GlassCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          radius: 20,
          onTap: onTap,
          child: Row(children: [
            GlowIcon(icon, color: color, size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: s.text)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
              ]),
            ),
            trailing,
          ]),
        );

    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SectionLabel('Comptes de démonstration', trailing: Icon(Icons.science_rounded, color: s.gold, size: 18)),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text('Touchez un compte pour vous connecter (mot de passe $demoPassword)', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
        ),
        for (final a in demoAccounts)
          tile(
            icon: a.icon,
            color: a.color,
            title: a.label,
            subtitle: '${a.identifier}\n${a.detail}',
            onTap: _loading == null ? () => _login(a) : null,
            trailing: _loading == a.identifier
                ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: s.gold))
                : Icon(Icons.login_rounded, color: s.gold),
          ),
        tile(
          icon: Icons.vpn_key_rounded,
          color: AppColors.warning,
          title: 'Mère à activer — Clarisse OBIANG',
          subtitle: 'Parcours d’activation P1 · code AFRAM-2026-ACTIVATE',
          onTap: () => context.push('${RoutePaths.activate}?code=AFRAM-2026-ACTIVATE'),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: s.textFaint),
        ),
        tile(
          icon: Icons.dns_rounded,
          color: const Color(0xFF22D3EE),
          title: 'Serveur de l’API',
          subtitle: FlavorConfig.instance.apiBaseUrl,
          onTap: _changeServer,
          trailing: Icon(Icons.edit_rounded, size: 18, color: s.textFaint),
        ),
      ]),
    );
  }
}
