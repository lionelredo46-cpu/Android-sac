import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class PersonProfile with _$PersonProfile {
  const factory PersonProfile({
    required String id,
    @Default('') String nom,
    @Default('') String prenom,
    String? matricule,
    String? profession,
    String? adresse,
    String? contactUrgence,
    String? specialite,
  }) = _PersonProfile;

  factory PersonProfile.fromJson(Map<String, dynamic> json) => _$PersonProfileFromJson(json);
}

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    String? email,
    String? telephone,
    required String role,
    @Default('ACTIVE') String status,
    @Default('fr') String preferredLocale,
    @Default(false) bool twoFactorEnabled,
    PersonProfile? parentProfile,
    PersonProfile? studentProfile,
    PersonProfile? teacherProfile,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  bool get isParent => role == 'PARENT';
  bool get isStudent => role == 'ETUDIANT';
  bool get isTeacher => role == 'ENSEIGNANT';
  bool get isFamily => isParent || isStudent;

  PersonProfile? get profile => parentProfile ?? studentProfile ?? teacherProfile;

  String get displayName {
    final p = profile;
    if (p != null && (p.prenom.isNotEmpty || p.nom.isNotEmpty)) return '${p.prenom} ${p.nom}'.trim();
    return email ?? telephone ?? 'Utilisateur';
  }

  String get firstName => profile?.prenom.isNotEmpty == true ? profile!.prenom : displayName;
}
