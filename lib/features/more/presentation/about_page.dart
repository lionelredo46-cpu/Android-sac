import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/ui.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(l.about)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: Image.asset('Afram/assets/logo/logo-afram-officiel.png', height: 90, errorBuilder: (_, __, ___) => const SizedBox.shrink())),
        const SizedBox(height: 8),
        Center(child: Text('UniParent AFRAM', style: AppTextStyles.h2)),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (_, s) => Center(child: Text(s.hasData ? l.version('${s.data!.version} (${s.data!.buildNumber})') : '', style: AppTextStyles.caption)),
        ),
        const SizedBox(height: 20),
        Text(l.help, style: AppTextStyles.h3),
        ..._faq.map((q) => ExpansionTile(title: Text(q.$1), children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: Text(q.$2))])),
        const SizedBox(height: 16),
        Text(l.contactSchool, style: AppTextStyles.h3),
        ListTile(leading: const Icon(Icons.phone_rounded, color: AppColors.aframPrimary), title: const Text('+241 066 70 11 84'), onTap: () => launchUrl(Uri.parse('tel:+241066701184'))),
        ListTile(leading: const Icon(Icons.chat_rounded, color: AppColors.success), title: const Text('WhatsApp +241 074 00 00 43'), onTap: () => launchUrl(Uri.parse('https://wa.me/241074000043'), mode: LaunchMode.externalApplication)),
        ListTile(leading: const Icon(Icons.email_rounded, color: AppColors.aframPrimary), title: const Text('aframilesmail@aframgabon.com'), onTap: () => launchUrl(Uri.parse('mailto:aframilesmail@aframgabon.com'))),
        const ListTile(leading: Icon(Icons.schedule_rounded), title: Text('Lun–Ven 08:00–20:00 · Sam 08:00–14:00')),
        const SizedBox(height: 16),
        Text(l.privacy, style: AppTextStyles.h3),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Vos données (identité, scolarité, paiements) sont traitées par l’AFRAM uniquement pour le suivi de la scolarité. '
            'Elles sont chiffrées en transit, l’accès est limité aux personnes habilitées et chaque opération sensible est journalisée. '
            'Aucune donnée de carte bancaire n’est stockée. Vous pouvez demander l’accès, la rectification ou la suppression de vos données '
            'auprès de la scolarité via la messagerie.',
          ),
        ),
      ]),
    );
  }
}
