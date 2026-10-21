// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonProfile _$PersonProfileFromJson(Map<String, dynamic> json) =>
    _PersonProfile(
      id: json['id'] as String,
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      matricule: json['matricule'] as String?,
      profession: json['profession'] as String?,
      adresse: json['adresse'] as String?,
      contactUrgence: json['contactUrgence'] as String?,
      specialite: json['specialite'] as String?,
    );

Map<String, dynamic> _$PersonProfileToJson(_PersonProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'matricule': instance.matricule,
      'profession': instance.profession,
      'adresse': instance.adresse,
      'contactUrgence': instance.contactUrgence,
      'specialite': instance.specialite,
    };

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  email: json['email'] as String?,
  telephone: json['telephone'] as String?,
  role: json['role'] as String,
  status: json['status'] as String? ?? 'ACTIVE',
  preferredLocale: json['preferredLocale'] as String? ?? 'fr',
  twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
  parentProfile: json['parentProfile'] == null
      ? null
      : PersonProfile.fromJson(json['parentProfile'] as Map<String, dynamic>),
  studentProfile: json['studentProfile'] == null
      ? null
      : PersonProfile.fromJson(json['studentProfile'] as Map<String, dynamic>),
  teacherProfile: json['teacherProfile'] == null
      ? null
      : PersonProfile.fromJson(json['teacherProfile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'telephone': instance.telephone,
  'role': instance.role,
  'status': instance.status,
  'preferredLocale': instance.preferredLocale,
  'twoFactorEnabled': instance.twoFactorEnabled,
  'parentProfile': instance.parentProfile,
  'studentProfile': instance.studentProfile,
  'teacherProfile': instance.teacherProfile,
};
