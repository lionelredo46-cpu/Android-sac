import 'package:freezed_annotation/freezed_annotation.dart';

part 'messaging_models.freezed.dart';
part 'messaging_models.g.dart';

@freezed
abstract class StudentRef with _$StudentRef {
  const factory StudentRef({required String id, required String prenom, required String nom}) = _StudentRef;
  factory StudentRef.fromJson(Map<String, dynamic> json) => _$StudentRefFromJson(json);
}

@freezed
abstract class LastMessage with _$LastMessage {
  const factory LastMessage({required String contenu, required DateTime createdAt, required String auteurId}) = _LastMessage;
  factory LastMessage.fromJson(Map<String, dynamic> json) => _$LastMessageFromJson(json);
}

@freezed
abstract class ConversationSummary with _$ConversationSummary {
  const factory ConversationSummary({
    required String id,
    required String numeroTicket,
    required String sujet,
    required String service,
    @Default('NORMALE') String priorite,
    required String statut,
    int? satisfaction,
    DateTime? slaDueAt,
    required DateTime updatedAt,
    StudentRef? student,
    LastMessage? dernierMessage,
    @Default(0) int nonLus,
    @Default(false) bool slaDepasse,
  }) = _ConversationSummary;
  factory ConversationSummary.fromJson(Map<String, dynamic> json) => _$ConversationSummaryFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String contenu,
    required DateTime createdAt,
    @Default(false) bool estLu,
    DateTime? luLe,
    @Default(0) int piecesJointes,
    @Default(false) bool moi,
    required String auteur,
    required String auteurRole,
  }) = _ChatMessage;
  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

@freezed
abstract class ConversationDetail with _$ConversationDetail {
  const factory ConversationDetail({
    required String id,
    required String numeroTicket,
    required String sujet,
    required String service,
    required String statut,
    @Default('NORMALE') String priorite,
    int? satisfaction,
    StudentRef? student,
    @Default([]) List<ChatMessage> messages,
  }) = _ConversationDetail;
  factory ConversationDetail.fromJson(Map<String, dynamic> json) => _$ConversationDetailFromJson(json);
}

@freezed
abstract class Announcement with _$Announcement {
  const factory Announcement({required String id, required String titre, required String contenu, @Default('ALL') String targetType, required DateTime datePublication}) = _Announcement;
  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);
}

@freezed
abstract class HostProfile with _$HostProfile {
  const factory HostProfile({@Default('') String nom, @Default('') String prenom, String? specialite}) = _HostProfile;
  factory HostProfile.fromJson(Map<String, dynamic> json) => _$HostProfileFromJson(json);
}

@freezed
abstract class AppointmentHost with _$AppointmentHost {
  const AppointmentHost._();
  const factory AppointmentHost({required String id, required String role, String? email, HostProfile? teacherProfile}) = _AppointmentHost;
  factory AppointmentHost.fromJson(Map<String, dynamic> json) => _$AppointmentHostFromJson(json);

  String get label {
    final t = teacherProfile;
    if (t != null && t.nom.isNotEmpty) return '${t.prenom} ${t.nom}${t.specialite != null ? ' — ${t.specialite}' : ''}';
    return switch (role) {
      'SCOLARITE' => 'Service Scolarité',
      'COMPTABLE' => 'Service Comptabilité',
      'DIRECTION' => 'Direction',
      _ => email ?? role,
    };
  }
}

@freezed
abstract class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String objet,
    required DateTime debut,
    required DateTime fin,
    required String statut,
    String? lieu,
    required AppointmentHost hote,
  }) = _Appointment;
  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
}
