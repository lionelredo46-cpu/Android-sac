class AuthUser {
  final String id;
  final String? email;
  final String? telephone;
  final String role; // "PARENT", "ETUDIANT", "SUPER_ADMIN", etc.
  final String status;
  final String? parentId;
  final String? studentId;
  final String? nom;
  final String? prenom;
  final bool twoFactorRequired;

  const AuthUser({
    required this.id,
    this.email,
    this.telephone,
    required this.role,
    required this.status,
    this.parentId,
    this.studentId,
    this.nom,
    this.prenom,
    this.twoFactorRequired = false,
  });

  bool get isParent => role == 'PARENT';
  bool get isStudent => role == 'ETUDIANT';
  bool get isAdmin => role == 'SUPER_ADMIN' || role == 'DIRECTION' || role == 'SCOLARITE' || role == 'COMPTABLE';

  String get displayName {
    if (prenom != null && nom != null) {
      return '$prenom $nom';
    }
    return email ?? telephone ?? 'Utilisateur';
  }
}
