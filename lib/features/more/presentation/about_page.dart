import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/ui.dart';
import '../../auth/presentation/auth_scaffold.dart';

/// À propos, aide (FAQ), confidentialité et contact AFRAM.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _faq = [
    ('Comment payer la scolarité ?', 'Onglet Finances → choisissez l’échéance → Payer. Mobile Money ou carte. Le reçu est disponible immédiatement après confirmation.'),
    ('Un versement au guichet apparaît-il dans l’application ?', 'Oui. Dès que la comptabilité l’enregistre, vous recevez une notification et le reçu numérique.'),
    ('Comment justifier une absence ?', 'Onglet Suivi → Présences → choisissez l’absence → Justifier, puis joignez une photo ou un PDF.'),
    ('Pourquoi je ne vois pas certaines notes ?', 'Seules les notes validées et publiées par la scolarité sont visibles.'),
    ('Mon enfant n’apparaît pas', 'Le rattachement est validé par la scolarité. Contactez-la via la messagerie (service Scolarité).'),
    ('L’application fonctionne-t-elle sans Internet ?', 'Oui en consultation : les dernières données chargées (notes, emploi du temps, reçus) restent accessibles et se synchronisent au retour du réseau.'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.strato;
    Widget contact(IconData icon, Color color, String label, VoidCallback? onTap) => GlassCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          radius: 20,
          onTap: onTap,
          semanticLabel: label,
          child: Row(children: [
            GlowIcon(icon, color: color, size: 40),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w600))),
            if (onTap != null) Icon(Icons.arrow_outward_rounded, size: 18, color: s.textFaint),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.about)),
      body: ListView(padding: EdgeInsets.fromLTRB(16, 0, 16, 32 + context.bottomInset), children: [
        const Reveal(offset: 0, child: Center(child: OrbitLogo(size: 130))),
        const SizedBox(height: 10),
        Center(child: Text('UniParent AFRAM', style: AppTextStyles.h1.copyWith(color: s.text, fontSize: 26))),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (_, snap) => Center(
            child: Text(snap.hasData ? l.version('${snap.data!.version} (${snap.data!.buildNumber})') : '', style: AppTextStyles.caption.copyWith(color: s.textFaint)),
          ),
        ),
        SectionLabel(l.help),
        Reveal(
          index: 1,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: [
              for (final q in _faq)
                ExpansionTile(
                  title: Text(q.$1, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                  expandedAlignment: Alignment.centerLeft,
                  children: [Text(q.$2, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted))],
                ),
            ]),
          ),
        ),
        SectionLabel(l.contactSchool),
        Reveal(index: 2, child: contact(Icons.phone_rounded, s.accent, '+241 066 70 11 84', () => launchUrl(Uri.parse('tel:+241066701184')))),
        Reveal(index: 3, child: contact(Icons.chat_rounded, s.success, 'WhatsApp +241 074 00 00 43', () => launchUrl(Uri.parse('https://wa.me/241074000043'), mode: LaunchMode.externalApplication))),
        Reveal(index: 4, child: contact(Icons.email_rounded, s.gold, 'aframilesmail@aframgabon.com', () => launchUrl(Uri.parse('mailto:aframilesmail@aframgabon.com')))),
        Reveal(index: 5, child: contact(Icons.schedule_rounded, s.textMuted, 'Lun–Ven 08:00–20:00 · Sam 08:00–14:00', null)),
        SectionLabel(l.privacy),
        Reveal(
          index: 6,
          child: GlassCard(
            child: Text(
              'Vos données (identité, scolarité, paiements) sont traitées par l’AFRAM uniquement pour le suivi de la scolarité. '
              'Elles sont chiffrées en transit, l’accès est limité aux personnes habilitées et chaque opération sensible est journalisée. '
              'Aucune donnée de carte bancaire n’est stockée. Vous pouvez demander l’accès, la rectification ou la suppression de vos données '
              'auprès de la scolarité via la messagerie.',
              style: AppTextStyles.bodySmall.copyWith(color: s.textMuted, height: 1.55),
            ),
          ),
        ),
      ]),
    );
  }
}
