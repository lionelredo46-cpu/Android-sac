import 'package:freezed_annotation/freezed_annotation.dart';

part 'documents_models.freezed.dart';
part 'documents_models.g.dart';

@freezed
abstract class VaultDocument with _$VaultDocument {
  const factory VaultDocument({
    required String id,
    required String titre,
    required String categorie,
    @Default(false) bool estSigne,
    Map<String, dynamic>? signatureMetadata,
    required DateTime createdAt,
    @Default(false) bool aSigner,
    String? validation,
  }) = _VaultDocument;
  factory VaultDocument.fromJson(Map<String, dynamic> json) => _$VaultDocumentFromJson(json);
}

@freezed
abstract class DocumentRequest with _$DocumentRequest {
  const factory DocumentRequest({
    required String id,
    required String type,
    String? motif,
    required String statut,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String libelle,
    @Default(false) bool documentDisponible,
  }) = _DocumentRequest;
  factory DocumentRequest.fromJson(Map<String, dynamic> json) => _$DocumentRequestFromJson(json);
}

@freezed
abstract class DisciplineRecord with _$DisciplineRecord {
  const factory DisciplineRecord({
    required String id,
    required String type,
    required String motif,
    String? sanction,
    required DateTime dateIncident,
    DateTime? convocationDate,
    @Default(false) bool accuseReception,
    DateTime? accuseReceptionLe,
    required String libelle,
    @Default(false) bool positif,
    @Default(false) bool accuseRequis,
  }) = _DisciplineRecord;
  factory DisciplineRecord.fromJson(Map<String, dynamic> json) => _$DisciplineRecordFromJson(json);
}
