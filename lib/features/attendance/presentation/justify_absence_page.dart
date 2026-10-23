import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ui.dart';
import '../../children/application/children_providers.dart';
import '../data/attendance_repository.dart';
import '../domain/attendance_models.dart';

/// Fichier choisi par l'utilisateur, prêt à être envoyé en multipart.
class PickedFile {
  final String path;
  final String name;
  const PickedFile(this.path, this.name);

  String get mime {
    final n = name.toLowerCase();
    if (n.endsWith('.pdf')) return 'application/pdf';
    if (n.endsWith('.png')) return 'image/png';
    if (n.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  Future<MultipartFile> toMultipart() => MultipartFile.fromFile(path, filename: name, contentType: MediaType.parse(mime));
}

/// Sélecteur photo / PDF réutilisable (justificatifs, pièces de dossier, messagerie).
Future<PickedFile?> pickProof(BuildContext context) async {
  final l = context.l10n;
  final choice = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final s = ctx.strato;
      Widget option(int i, IconData icon, Color color, String label, String value) => Expanded(
            child: Reveal(
              index: i,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 22),
                onTap: () => Navigator.pop(ctx, value),
                semanticLabel: label,
                child: Column(children: [
                  GlowIcon(icon, color: color, size: 54, radius: 18),
                  const SizedBox(height: 12),
                  Text(label, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          );
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(children: [
            option(0, Icons.photo_camera_rounded, s.gold, l.takePhoto, 'camera'),
            const SizedBox(width: 12),
            option(1, Icons.attach_file_rounded, s.accent, l.chooseFile, 'file'),
          ]),
        ),
      );
    },
  );
  if (choice == 'camera') {
    // Images allégées pour les réseaux lents.
    final x = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 1600);
    return x == null ? null : PickedFile(x.path, x.name);
  }
  if (choice == 'file') {
    final r = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp']);
    final f = r?.files.single;
    if (f?.path == null) return null;
    if (File(f!.path!).lengthSync() > 8 * 1024 * 1024) {
      if (context.mounted) context.showSnack('Fichier trop volumineux (8 Mo maximum)', error: true);
      return null;
    }
    return PickedFile(f.path!, f.name);
  }
  return null;
}

/// Zone de dépôt de pièce jointe : pointillés lumineux, nom du fichier une fois choisi.
class AttachmentPicker extends StatelessWidget {
  final PickedFile? file;
  final String label;
  final ValueChanged<PickedFile?> onPicked;
  const AttachmentPicker({super.key, required this.file, required this.label, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    final s = context.strato;
    final picked = file != null;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 20,
      borderColor: picked ? s.success.withValues(alpha: 0.6) : s.gold.withValues(alpha: 0.45),
      tint: picked ? s.success.withValues(alpha: 0.08) : null,
      semanticLabel: label,
      onTap: () async {
        final f = await pickProof(context);
        if (f != null) onPicked(f);
      },
      child: Row(children: [
        GlowIcon(picked ? Icons.check_circle_rounded : Icons.cloud_upload_rounded, color: picked ? s.success : s.gold, size: 44),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(file?.name ?? label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium.copyWith(color: s.text, fontWeight: FontWeight.w700)),
            Text('PDF, JPG, PNG · 8 Mo max', style: AppTextStyles.caption.copyWith(color: s.textMuted)),
          ]),
        ),
        if (picked)
          IconButton(tooltip: context.l10n.cancel, icon: Icon(Icons.close_rounded, color: s.textMuted), onPressed: () => onPicked(null))
        else
          Icon(Icons.add_rounded, color: s.gold),
      ]),
    );
  }
}

class JustifyAbsencePage extends ConsumerStatefulWidget {
  final AttendanceItem item;
  const JustifyAbsencePage({super.key, required this.item});

  @override
  ConsumerState<JustifyAbsencePage> createState() => _JustifyAbsencePageState();
}

class _JustifyAbsencePageState extends ConsumerState<JustifyAbsencePage> {
  final _motif = TextEditingController();
  PickedFile? _file;
  bool _loading = false;

  Future<void> _submit() async {
    final l = context.l10n;
    if (_motif.text.trim().isEmpty || _file == null) return context.showSnack(l.fieldRequired, error: true);
    setState(() => _loading = true);
    try {
      await ref.read(attendanceRepositoryProvider).justify(widget.item.id, _motif.text.trim(), await _file!.toMultipart());
      final child = ref.read(activeChildProvider);
      if (child != null) ref.invalidate(attendanceProvider(child.id));
      if (!mounted) return;
      context.showSnack(l.proofSent);
      context.pop();
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = widget.item;
    final s = context.strato;
    return Scaffold(
      appBar: AppBar(title: Text(l.justifyTitle)),
      body: ListView(padding: EdgeInsets.fromLTRB(16, 6, 16, 28 + context.bottomInset), children: [
        Reveal(
          child: GlassCard(
            child: Row(children: [
              GlowIcon(Icons.event_busy_rounded, color: s.danger, size: 46),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.cours.nom, style: AppTextStyles.h3.copyWith(color: s.text)),
                  const SizedBox(height: 2),
                  Text('${Fmt.date(a.date)} · ${Fmt.time(a.date)} – ${a.enseignant}', style: AppTextStyles.bodySmall.copyWith(color: s.textMuted)),
                ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        Reveal(index: 1, child: TextField(controller: _motif, maxLines: 4, maxLength: 500, decoration: InputDecoration(labelText: l.reason, alignLabelWithHint: true))),
        const SizedBox(height: 8),
        Reveal(index: 2, child: AttachmentPicker(file: _file, label: l.attachProof, onPicked: (f) => setState(() => _file = f))),
        const SizedBox(height: 24),
        Reveal(index: 3, child: AppButton(text: l.send, icon: Icons.send_rounded, isLoading: _loading, onPressed: _submit)),
      ]),
    );
  }
}
