import 'package:freezed_annotation/freezed_annotation.dart';

part 'child.freezed.dart';
part 'child.g.dart';

@freezed
abstract class Program with _$Program {
  const factory Program({required String id, required String code, required String nom, @Default('LICENCE') String niveau}) = _Program;
  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);
}

@freezed
abstract class StudentGroup with _$StudentGroup {
  const factory StudentGroup({required String id, required String nom, @Default(1) int anneeNiveau, required Program program}) = _StudentGroup;
  factory StudentGroup.fromJson(Map<String, dynamic> json) => _$StudentGroupFromJson(json);
}

@freezed
abstract class Child with _$Child {
  const Child._();

  const factory Child({
    required String id,
    required String matricule,
    required String nom,
    required String prenom,
    String? photoUrl,
    @Default('INSCRIT') String statut,
    DateTime? dateNaissance,
    DateTime? dateInscription,
    String? responsablePeda,
    required StudentGroup group,
    @Default('SOI') String relation,
    @Default(false) bool estPayeur,
    @Default(true) bool peutConsulter,
  }) = _Child;

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  String get fullName => '$prenom $nom';
  String get initials => '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'.toUpperCase();
  String get subtitle => '${group.nom} · ${group.program.nom}';
}
