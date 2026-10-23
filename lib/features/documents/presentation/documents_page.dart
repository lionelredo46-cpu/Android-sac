import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pdf_viewer_page.dart';
import '../../../core/widgets/ui.dart';
import '../../attendance/presentation/justify_absence_page.dart';
import '../../children/domain/child.dart';
import '../../children/presentation/child_scope.dart';
import '../data/documents_repository.dart';
import '../domain/documents_models.dart';

const requestTypes = {
  'ATTESTATION_INSCRIPTION': "Attestation d'inscription",
  'CERTIFICAT_SCOLARITE': 'Certificat de scolarité',
  'RELEVE_NOTES_OFFICIEL': 'Relevé de notes officiel',
  'DUPLICATA_CARTE': "Duplicata de carte d'étudiant",
  'CHANGEMENT_FILIERE': 'Changement de filière',
  'CONGE_ACADEMIQUE': 'Congé académique',
};

/// Catégorie de document lisible (CERTIFICAT_MEDICAL → Certificat médical).
String documentCategoryLabel(String c) => switch (c) {
      'CONTRAT' => 'Contrat',
      'REGLEMENT' => 'Règlement',
      'IDENTITE' => "Pièce d'identité",
      'PHOTO' => "Photo d'identité",
      'DIPLOME' => 'Diplôme',
      'CERTIFICAT_MEDICAL' => 'Certificat médical',
      'ATTESTATION' => 'Attestation',
      'AUTRE' => 'Autre',
      _ => c.isEmpty ? c : c[0] + c.substring(1).toLowerCase().replaceAll('_', ' '),
    };

String requestStatusLabel(String s) => switch (s) {
      'SOUMISE' => 'Reçue',
      'EN_TRAITEMENT' => 'En traitement',
      'PRETE' => 'Prête',
      'LIVREE' => 'Retirée / envoyée',
      _ => 'Refusée',
    };

void openPdf(BuildContext context, String title, String filename, Future<dynamic> Function() loader) {
  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => PdfViewerPage(title: title, filename: filename, loader: () async => await loader())));
}

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.documentsTitle),
          bottom: StratoTabBar(tabs: [l.vault, l.requests]),
        ),
        body: ChildScope(builder: (context, child) => TabBarView(children: [_VaultTab(child), _RequestsTab(child)])),
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _DocTile({required this.icon, required this.color, required this.title, required this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      semanticLabel: title,
      child: Row(children: [
        GlowIcon(icon, color: color, size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
          ]),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ]),
    );
  }
}

class _VaultTab extends ConsumerWidget {
  final Child child;
  const _VaultTab(this.child);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = context.strato;
    final repo = ref.read(documentsRepositoryProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'upload',
        icon: const Icon(Icons.upload_file_rounded),
        label: Text(l.uploadDocument),
        onPressed: () => _upload(context, ref),
      ),
      body: CachedAsyncView<List<VaultDocument>>(
        value: ref.watch(vaultProvider(child.id)),
        onRetry: () => ref.invalidate(vaultProvider(child.id)),
        isEmpty: (d) => d.isEmpty,
        emptyTitle: l.noDocuments,
        emptyIcon: Icons.folder_off_outlined,
        builder: (context, docs) => ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 100 + context.bottomInset), children: [
          Reveal(
            child: GlassCard(
              gradient: s.heroGradient,
              glow: s.accentDeep,
              padding: const EdgeInsets.all(16),
              onTap: () => openPdf(context, l.enrollmentCertificate, 'attestation-${child.matricule}.pdf', () => repo.enrollmentCertificate(child.id)),
              semanticLabel: l.enrollmentCertificate,
              child: Row(children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(gradient: Strato.goldGradient, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: s.gold.withValues(alpha: 0.5), blurRadius: 16)]),
                  child: Icon(Icons.workspace_premium_rounded, color: s.onGold),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(l.enrollmentCertificate, style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16))),
                const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFFBE0A4)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < docs.length; i++)
            Reveal(
              index: i + 1,
              child: _DocTile(
                icon: docs[i].aSigner ? Icons.draw_rounded : Icons.description_rounded,
                color: docs[i].aSigner ? s.warning : s.accent,
                title: docs[i].titre,
                subtitle: '${documentCategoryLabel(docs[i].categorie)} · ${Fmt.date(docs[i].createdAt)}',
                onTap: () => openPdf(context, docs[i].titre, '${docs[i].titre}.pdf', () => repo.download(docs[i].id)),
                trailing: docs[i].aSigner
                    ? FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: s.gold, foregroundColor: s.onGold, minimumSize: const Size(0, 38)),
                        onPressed: () => _sign(context, ref, docs[i]),
                        child: Text(l.sign),
                      )
                    : docs[i].estSigne
                        ? StatusChip.status('VALIDE', l.signed)
                        : docs[i].validation != null
                            ? StatusChip.status(docs[i].validation!, docs[i].validation == 'EN_ATTENTE' ? 'En validation' : docs[i].validation == 'VALIDE' ? 'Validé' : 'Refusé')
                            : null,
              ),
            ),
        ]),
      ),
    );
  }

  Future<void> _sign(BuildContext context, WidgetRef ref, VaultDocument d) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.draw_rounded, color: ctx.strato.gold, size: 32),
        title: Text('${l.sign} — ${d.titre}'),
        content: Text(l.signConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.sign)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(documentsRepositoryProvider).sign(d.id);
      ref.invalidate(vaultProvider(child.id));
      if (context.mounted) context.showSnack(l.signed);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  Future<void> _upload(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final title = TextEditingController();
    var category = 'IDENTITE';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.uploadDocument),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: title, decoration: InputDecoration(labelText: l.documentTitle)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: InputDecoration(labelText: l.category),
              items: const {'IDENTITE': "Pièce d'identité", 'PHOTO': "Photo d'identité", 'DIPLOME': 'Diplôme', 'CERTIFICAT_MEDICAL': 'Certificat médical', 'AUTRE': 'Autre'}
                  .entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (v) => setState(() => category = v ?? 'AUTRE'),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, title.text.trim().isNotEmpty), child: Text(l.next)),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final file = await pickProof(context);
    if (file == null) return;
    try {
      await ref.read(documentsRepositoryProvider).upload(child.id, title.text.trim(), category, await file.toMultipart());
      ref.invalidate(vaultProvider(child.id));
      if (context.mounted) context.showSnack(l.requestSent);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }
}

class _RequestsTab extends ConsumerWidget {
  final Child child;
  const _RequestsTab(this.child);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(heroTag: 'request', icon: const Icon(Icons.add_rounded), label: Text(l.newRequest), onPressed: () => _create(context, ref)),
      body: CachedAsyncView<List<DocumentRequest>>(
        value: ref.watch(requestsProvider(child.id)),
        onRetry: () => ref.invalidate(requestsProvider(child.id)),
        isEmpty: (d) => d.isEmpty,
        emptyTitle: l.noRequests,
        emptyIcon: Icons.assignment_outlined,
        builder: (context, list) => ListView(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 100 + context.bottomInset),
          children: [
            for (var i = 0; i < list.length; i++)
              Reveal(
                index: i,
                child: _DocTile(
                  icon: list[i].documentDisponible ? Icons.file_download_done_rounded : Icons.assignment_rounded,
                  color: StatusStyle.of(list[i].statut).color,
                  title: list[i].libelle,
                  subtitle: '${Fmt.date(list[i].createdAt)}${list[i].motif != null ? ' · ${list[i].motif}' : ''}',
                  trailing: StatusChip.status(list[i].statut, requestStatusLabel(list[i].statut)),
                  onTap: list[i].documentDisponible
                      ? () => openPdf(context, list[i].libelle, '${list[i].type}.pdf', () => ref.read(documentsRepositoryProvider).requestDocument(list[i].id))
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    var type = requestTypes.keys.first;
    final motif = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.newRequest),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              initialValue: type,
              isExpanded: true,
              items: requestTypes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
              onChanged: (v) => setState(() => type = v ?? type),
            ),
            const SizedBox(height: 12),
            TextField(controller: motif, maxLines: 3, decoration: InputDecoration(labelText: l.reason)),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.send)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(documentsRepositoryProvider).createRequest(child.id, type, motif.text.trim());
      ref.invalidate(requestsProvider(child.id));
      if (context.mounted) context.showSnack(l.requestSent);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }
}
