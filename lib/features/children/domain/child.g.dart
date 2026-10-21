// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Program _$ProgramFromJson(Map<String, dynamic> json) => _Program(
  id: json['id'] as String,
  code: json['code'] as String,
  nom: json['nom'] as String,
  niveau: json['niveau'] as String? ?? 'LICENCE',
);

Map<String, dynamic> _$ProgramToJson(_Program instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'nom': instance.nom,
  'niveau': instance.niveau,
};

_StudentGroup _$StudentGroupFromJson(Map<String, dynamic> json) =>
    _StudentGroup(
      id: json['id'] as String,
      nom: json['nom'] as String,
      anneeNiveau: (json['anneeNiveau'] as num?)?.toInt() ?? 1,
      program: Program.fromJson(json['program'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudentGroupToJson(_StudentGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'anneeNiveau': instance.anneeNiveau,
      'program': instance.program,
    };

_Child _$ChildFromJson(Map<String, dynamic> json) => _Child(
  id: json['id'] as String,
  matricule: json['matricule'] as String,
  nom: json['nom'] as String,
  prenom: json['prenom'] as String,
  photoUrl: json['photoUrl'] as String?,
  statut: json['statut'] as String? ?? 'INSCRIT',
  dateNaissance: json['dateNaissance'] == null
      ? null
      : DateTime.parse(json['dateNaissance'] as String),
  dateInscription: json['dateInscription'] == null
      ? null
      : DateTime.parse(json['dateInscription'] as String),
  responsablePeda: json['responsablePeda'] as String?,
  group: StudentGroup.fromJson(json['group'] as Map<String, dynamic>),
  relation: json['relation'] as String? ?? 'SOI',
  estPayeur: json['estPayeur'] as bool? ?? false,
  peutConsulter: json['peutConsulter'] as bool? ?? true,
);

Map<String, dynamic> _$ChildToJson(_Child instance) => <String, dynamic>{
  'id': instance.id,
  'matricule': instance.matricule,
  'nom': instance.nom,
  'prenom': instance.prenom,
  'photoUrl': instance.photoUrl,
  'statut': instance.statut,
  'dateNaissance': instance.dateNaissance?.toIso8601String(),
  'dateInscription': instance.dateInscription?.toIso8601String(),
  'responsablePeda': instance.responsablePeda,
  'group': instance.group,
  'relation': instance.relation,
  'estPayeur': instance.estPayeur,
  'peutConsulter': instance.peutConsulter,
};
