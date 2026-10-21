import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/flavor_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
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
  DemoAccount('Parent — Jean-Marc OBIANG', 'parent@aframgabon.com', '2 enfants · tranche en retard', Icons.family_restroom_rounded, AppColors.aframPrimary),
  DemoAccount('Étudiant — Alexandre OBIANG', 'alexandre.obiang@etudiant.afram.ga', 'L3 SIL · scan QR de présence', Icons.school_rounded, AppColors.success),
  DemoAccount('Étudiante — Grâce OBIANG', 'grace.obiang@etudiant.afram.ga', 'L1 MGO · dossier incomplet', Icons.school_outlined, AppColors.info),
  DemoAccount('Camarade — Lucie MBA', 'etudiant1@etudiant.afram.ga', 'Test anti-IDOR (autre famille)', Icons.person_outline_rounded, AppColors.textSecondaryLight),
];

/// Connexion en un appui (flavor dev uniquement — jamais affiché en recette ni en production).
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

  @override
  Widget build(BuildContext context) {
    if (!FlavorConfig.isDev) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.aframGold.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.aframGold.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.science_rounded, color: AppColors.aframGold, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text('Comptes de démonstration', style: AppTextStyles.h3)),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 8),
          child: Text(
            FlavorConfig.instance.localBackend
                ? 'Démo autonome : données stockées sur ce téléphone, aucune connexion requise. Touchez un compte (mot de passe $demoPassword).'
                : 'Touchez un compte pour vous connecter (mot de passe $demoPassword)',
            style: AppTextStyles.bodySmall,
          ),
        ),
        for (final a in demoAccounts)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(backgroundColor: a.color.withValues(alpha: 0.12), child: Icon(a.icon, color: a.color)),
              title: Text(a.label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text('${a.identifier}\n${a.detail}', style: AppTextStyles.bodySmall),
              isThreeLine: true,
              trailing: _loading == a.identifier
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.login_rounded, color: AppColors.aframPrimary),
              onTap: _loading == null ? () => _login(a) : null,
            ),
          ),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            dense: true,
            leading: CircleAvatar(backgroundColor: AppColors.warning.withValues(alpha: 0.12), child: const Icon(Icons.vpn_key_rounded, color: AppColors.warning)),
            title: Text('Mère à activer — Clarisse OBIANG', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
            subtitle: Text('Parcours d’activation P1 · code AFRAM-2026-ACTIVATE', style: AppTextStyles.bodySmall),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('${RoutePaths.activate}?code=AFRAM-2026-ACTIVATE'),
          ),
        ),
      ]),
    );
  }
}
