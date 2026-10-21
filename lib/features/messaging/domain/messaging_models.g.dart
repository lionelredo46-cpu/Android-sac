// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentRef _$StudentRefFromJson(Map<String, dynamic> json) => _StudentRef(
  id: json['id'] as String,
  prenom: json['prenom'] as String,
  nom: json['nom'] as String,
);

Map<String, dynamic> _$StudentRefToJson(_StudentRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prenom': instance.prenom,
      'nom': instance.nom,
    };

_LastMessage _$LastMessageFromJson(Map<String, dynamic> json) => _LastMessage(
  contenu: json['contenu'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  auteurId: json['auteurId'] as String,
);

Map<String, dynamic> _$LastMessageToJson(_LastMessage instance) =>
    <String, dynamic>{
      'contenu': instance.contenu,
      'createdAt': instance.createdAt.toIso8601String(),
      'auteurId': instance.auteurId,
    };

_ConversationSummary _$ConversationSummaryFromJson(Map<String, dynamic> json) =>
    _ConversationSummary(
      id: json['id'] as String,
      numeroTicket: json['numeroTicket'] as String,
      sujet: json['sujet'] as String,
      service: json['service'] as String,
      priorite: json['priorite'] as String? ?? 'NORMALE',
      statut: json['statut'] as String,
      satisfaction: (json['satisfaction'] as num?)?.toInt(),
      slaDueAt: json['slaDueAt'] == null
          ? null
          : DateTime.parse(json['slaDueAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      student: json['student'] == null
          ? null
          : StudentRef.fromJson(json['student'] as Map<String, dynamic>),
      dernierMessage: json['dernierMessage'] == null
          ? null
          : LastMessage.fromJson(
              json['dernierMessage'] as Map<String, dynamic>,
            ),
      nonLus: (json['nonLus'] as num?)?.toInt() ?? 0,
      slaDepasse: json['slaDepasse'] as bool? ?? false,
    );

Map<String, dynamic> _$ConversationSummaryToJson(
  _ConversationSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'numeroTicket': instance.numeroTicket,
  'sujet': instance.sujet,
  'service': instance.service,
  'priorite': instance.priorite,
  'statut': instance.statut,
  'satisfaction': instance.satisfaction,
  'slaDueAt': instance.slaDueAt?.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'student': instance.student,
  'dernierMessage': instance.dernierMessage,
  'nonLus': instance.nonLus,
  'slaDepasse': instance.slaDepasse,
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  contenu: json['contenu'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  estLu: json['estLu'] as bool? ?? false,
  luLe: json['luLe'] == null ? null : DateTime.parse(json['luLe'] as String),
  piecesJointes: (json['piecesJointes'] as num?)?.toInt() ?? 0,
  moi: json['moi'] as bool? ?? false,
  auteur: json['auteur'] as String,
  auteurRole: json['auteurRole'] as String,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contenu': instance.contenu,
      'createdAt': instance.createdAt.toIso8601String(),
      'estLu': instance.estLu,
      'luLe': instance.luLe?.toIso8601String(),
      'piecesJointes': instance.piecesJointes,
      'moi': instance.moi,
      'auteur': instance.auteur,
      'auteurRole': instance.auteurRole,
    };

_ConversationDetail _$ConversationDetailFromJson(Map<String, dynamic> json) =>
    _ConversationDetail(
      id: json['id'] as String,
      numeroTicket: json['numeroTicket'] as String,
      sujet: json['sujet'] as String,
      service: json['service'] as String,
      statut: json['statut'] as String,
      priorite: json['priorite'] as String? ?? 'NORMALE',
      satisfaction: (json['satisfaction'] as num?)?.toInt(),
      student: json['student'] == null
          ? null
          : StudentRef.fromJson(json['student'] as Map<String, dynamic>),
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ConversationDetailToJson(_ConversationDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numeroTicket': instance.numeroTicket,
      'sujet': instance.sujet,
      'service': instance.service,
      'statut': instance.statut,
      'priorite': instance.priorite,
      'satisfaction': instance.satisfaction,
      'student': instance.student,
      'messages': instance.messages,
    };

_Announcement _$AnnouncementFromJson(Map<String, dynamic> json) =>
    _Announcement(
      id: json['id'] as String,
      titre: json['titre'] as String,
      contenu: json['contenu'] as String,
      targetType: json['targetType'] as String? ?? 'ALL',
      datePublication: DateTime.parse(json['datePublication'] as String),
    );

Map<String, dynamic> _$AnnouncementToJson(_Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'contenu': instance.contenu,
      'targetType': instance.targetType,
      'datePublication': instance.datePublication.toIso8601String(),
    };

_HostProfile _$HostProfileFromJson(Map<String, dynamic> json) => _HostProfile(
  nom: json['nom'] as String? ?? '',
  prenom: json['prenom'] as String? ?? '',
  specialite: json['specialite'] as String?,
);

Map<String, dynamic> _$HostProfileToJson(_HostProfile instance) =>
    <String, dynamic>{
      'nom': instance.nom,
      'prenom': instance.prenom,
      'specialite': instance.specialite,
    };

_AppointmentHost _$AppointmentHostFromJson(Map<String, dynamic> json) =>
    _AppointmentHost(
      id: json['id'] as String,
      role: json['role'] as String,
      email: json['email'] as String?,
      teacherProfile: json['teacherProfile'] == null
          ? null
          : HostProfile.fromJson(
              json['teacherProfile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AppointmentHostToJson(_AppointmentHost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'email': instance.email,
      'teacherProfile': instance.teacherProfile,
    };

_Appointment _$AppointmentFromJson(Map<String, dynamic> json) => _Appointment(
  id: json['id'] as String,
  objet: json['objet'] as String,
  debut: DateTime.parse(json['debut'] as String),
  fin: DateTime.parse(json['fin'] as String),
  statut: json['statut'] as String,
  lieu: json['lieu'] as String?,
  hote: AppointmentHost.fromJson(json['hote'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentToJson(_Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'objet': instance.objet,
      'debut': instance.debut.toIso8601String(),
      'fin': instance.fin.toIso8601String(),
      'statut': instance.statut,
      'lieu': instance.lieu,
      'hote': instance.hote,
    };
