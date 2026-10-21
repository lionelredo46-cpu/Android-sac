import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
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
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColors.aframGold,
            tabs: [Tab(text: l.vault), Tab(text: l.requests)],
          ),
        ),
        body: ChildScope(builder: (context, child) => TabBarView(children: [_VaultTab(child), _RequestsTab(child)])),
      ),
    );
  }
}

class _VaultTab extends ConsumerWidget {
  final Child child;
  const _VaultTab(this.child);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
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
        builder: (context, docs) => ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 96), children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.workspace_premium_outlined, color: AppColors.aframGold),
              title: Text(l.enrollmentCertificate),
              trailing: const Icon(Icons.picture_as_pdf_rounded),
              onTap: () => openPdf(context, l.enrollmentCertificate, 'attestation-${child.matricule}.pdf', () => repo.enrollmentCertificate(child.id)),
            ),
          ),
          const SizedBox(height: 8),
          ...docs.map((d) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(d.aSigner ? Icons.draw_rounded : Icons.description_outlined, color: d.aSigner ? AppColors.warning : AppColors.aframPrimary),
                  title: Text(d.titre),
                  subtitle: Text('${d.categorie} · ${Fmt.date(d.createdAt)}'),
                  trailing: d.aSigner
                      ? FilledButton.tonal(onPressed: () => _sign(context, ref, d), child: Text(l.sign))
                      : d.estSigne
                          ? StatusChip.status('VALIDE', l.signed)
                          : d.validation != null
                              ? StatusChip.status(d.validation!, d.validation == 'EN_ATTENTE' ? 'En validation' : d.validation == 'VALIDE' ? 'Validé' : 'Refusé')
                              : null,
                  onTap: () => openPdf(context, d.titre, '${d.titre}.pdf', () => repo.download(d.id)),
                ),
              )),
        ]),
      ),
    );
  }

  Future<void> _sign(BuildContext context, WidgetRef ref, VaultDocument d) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: list
              .map((r) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(r.libelle, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      subtitle: Text('${Fmt.date(r.createdAt)}${r.motif != null ? ' · ${r.motif}' : ''}'),
                      trailing: StatusChip.status(r.statut, requestStatusLabel(r.statut)),
                      onTap: r.documentDisponible
                          ? () => openPdf(context, r.libelle, '${r.type}.pdf', () => ref.read(documentsRepositoryProvider).requestDocument(r.id))
                          : null,
                    ),
                  ))
              .toList(),
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
