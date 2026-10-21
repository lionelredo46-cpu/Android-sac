// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VaultDocument _$VaultDocumentFromJson(Map<String, dynamic> json) =>
    _VaultDocument(
      id: json['id'] as String,
      titre: json['titre'] as String,
      categorie: json['categorie'] as String,
      estSigne: json['estSigne'] as bool? ?? false,
      signatureMetadata: json['signatureMetadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      aSigner: json['aSigner'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$VaultDocumentToJson(_VaultDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'categorie': instance.categorie,
      'estSigne': instance.estSigne,
      'signatureMetadata': instance.signatureMetadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'aSigner': instance.aSigner,
      'validation': instance.validation,
    };

_DocumentRequest _$DocumentRequestFromJson(Map<String, dynamic> json) =>
    _DocumentRequest(
      id: json['id'] as String,
      type: json['type'] as String,
      motif: json['motif'] as String?,
      statut: json['statut'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      libelle: json['libelle'] as String,
      documentDisponible: json['documentDisponible'] as bool? ?? false,
    );

Map<String, dynamic> _$DocumentRequestToJson(_DocumentRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'motif': instance.motif,
      'statut': instance.statut,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'libelle': instance.libelle,
      'documentDisponible': instance.documentDisponible,
    };

_DisciplineRecord _$DisciplineRecordFromJson(Map<String, dynamic> json) =>
    _DisciplineRecord(
      id: json['id'] as String,
      type: json['type'] as String,
      motif: json['motif'] as String,
      sanction: json['sanction'] as String?,
      dateIncident: DateTime.parse(json['dateIncident'] as String),
      convocationDate: json['convocationDate'] == null
          ? null
          : DateTime.parse(json['convocationDate'] as String),
      accuseReception: json['accuseReception'] as bool? ?? false,
      accuseReceptionLe: json['accuseReceptionLe'] == null
          ? null
          : DateTime.parse(json['accuseReceptionLe'] as String),
      libelle: json['libelle'] as String,
      positif: json['positif'] as bool? ?? false,
      accuseRequis: json['accuseRequis'] as bool? ?? false,
    );

Map<String, dynamic> _$DisciplineRecordToJson(_DisciplineRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'motif': instance.motif,
      'sanction': instance.sanction,
      'dateIncident': instance.dateIncident.toIso8601String(),
      'convocationDate': instance.convocationDate?.toIso8601String(),
      'accuseReception': instance.accuseReception,
      'accuseReceptionLe': instance.accuseReceptionLe?.toIso8601String(),
      'libelle': instance.libelle,
      'positif': instance.positif,
      'accuseRequis': instance.accuseRequis,
    };
