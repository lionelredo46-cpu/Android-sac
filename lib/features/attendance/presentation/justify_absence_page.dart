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
    builder: (ctx) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.photo_camera_rounded), title: Text(l.takePhoto), onTap: () => Navigator.pop(ctx, 'camera')),
        ListTile(leading: const Icon(Icons.attach_file_rounded), title: Text(l.chooseFile), onTap: () => Navigator.pop(ctx, 'file')),
      ]),
    ),
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
    return Scaffold(
      appBar: AppBar(title: Text(l.justifyTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: ListTile(title: Text(a.cours.nom, style: AppTextStyles.h3), subtitle: Text('${Fmt.date(a.date)} · ${Fmt.time(a.date)} – ${a.enseignant}'))),
        const SizedBox(height: 16),
        TextField(controller: _motif, maxLines: 4, maxLength: 500, decoration: InputDecoration(labelText: l.reason, alignLabelWithHint: true)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: Icon(_file == null ? Icons.attach_file_rounded : Icons.check_circle_rounded),
          label: Text(_file?.name ?? l.attachProof, overflow: TextOverflow.ellipsis),
          onPressed: () async {
            final f = await pickProof(context);
            if (f != null) setState(() => _file = f);
          },
        ),
        const SizedBox(height: 24),
        AppButton(text: l.send, isLoading: _loading, onPressed: _submit),
      ]),
    );
  }
}
