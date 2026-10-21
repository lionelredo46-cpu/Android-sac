import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../network/api_endpoints.dart';
import 'demo_pdf.dart';
import 'local_database.dart';

/// Fichier joint à une requête multipart.
class LocalFile {
  final String field;
  final String? filename;
  final String? mimeType;
  final int length;
  const LocalFile(this.field, this.filename, this.mimeType, this.length);
}

class LocalRequest {
  final String method;

  /// Chemin sans le préfixe /api/v1.
  final String path;
  final Map<String, String> query;
  final Map<String, dynamic> body;
  final List<LocalFile> files;
  final Map<String, String> headers;

  const LocalRequest({required this.method, required this.path, this.query = const {}, this.body = const {}, this.files = const [], this.headers = const {}});
}

class LocalResponse {
  final int status;
  final Object? json;
  final List<int>? bytes;
  final String? text;

  const LocalResponse.json(this.json, {this.status = 200})
      : bytes = null,
        text = null;
  const LocalResponse.bytes(this.bytes)
      : status = 200,
        json = null,
        text = null;
  const LocalResponse.text(this.text)
      : status = 200,
        json = null,
        bytes = null;
}

/// Erreur au format normalisé de l'API : `{ statusCode, code, message }`.
class _ApiError implements Exception {
  final int status;
  final String code;
  final String message;
  const _ApiError(this.status, this.code, this.message);
}

typedef _Handler = FutureOr<LocalResponse> Function(_Call c);

class _Route {
  final String method;
  final RegExp pattern;
  final _Handler handler;
  final bool public;
  _Route(this.method, String pattern, this.handler, {this.public = false}) : pattern = RegExp('^$pattern\$');
}

class _Call {
  final LocalRequest req;
  final List<String> params;
  final Map<String, dynamic>? account;
  const _Call(this.req, this.params, this.account);

  String get uid => account!['id'] as String;
  String get role => account!['role'] as String;
  Map<String, dynamic> get body => req.body;
  Map<String, String> get query => req.query;
  String field(String name) => '${req.body[name] ?? ''}'.trim();
}

/// Serveur UniParent simulé sur l'appareil (mode démo autonome).
///
/// Il reproduit le comportement de l'API pour les écrans de l'application :
/// lectures depuis la base locale, et simulation des traitements du back-office
/// (paiement validé par l'opérateur, réponse du service, rendez-vous confirmé,
/// document prêt, justificatif accepté) quelques secondes après l'action.
class LocalBackend {
  final LocalDatabase db;
  LocalBackend(this.db);

  static const _uuid = Uuid();
  static const _uploadTypes = {'application/pdf', 'image/jpeg', 'image/png', 'image/webp'};
  static const _maxUpload = 8 * 1024 * 1024;
  static const _generatedRequests = {'ATTESTATION_INSCRIPTION', 'CERTIFICAT_SCOLARITE', 'RELEVE_NOTES_OFFICIEL'};
  static const _requestLabels = {
    'ATTESTATION_INSCRIPTION': "Attestation d'inscription",
    'CERTIFICAT_SCOLARITE': 'Certificat de scolarité',
    'RELEVE_NOTES_OFFICIEL': 'Relevé de notes officiel',
    'DUPLICATA_CARTE': "Duplicata de carte d'étudiant",
    'CHANGEMENT_FILIERE': 'Changement de filière',
    'CONGE_ACADEMIQUE': 'Congé académique',
  };

  final _random = Random();

  late final List<_Route> _routes = [
    // Authentification
    _Route('POST', '/auth/login', _login, public: true),
    _Route('POST', '/auth/otp/send', _otpSend, public: true),
    _Route('POST', '/auth/otp/verify', _otpVerify, public: true),
    _Route('POST', '/auth/activate/start', _activateStart, public: true),
    _Route('POST', '/auth/activate', _activate, public: true),
    _Route('POST', '/auth/refresh', _refresh, public: true),
    _Route('POST', '/auth/forgot-password', _forgotPassword, public: true),
    _Route('POST', '/auth/reset-password', _resetPassword, public: true),
    _Route('POST', '/auth/change-password', _changePassword),
    _Route('POST', '/auth/logout(-all)?', (_) => const LocalResponse.json({'success': true}, status: 201)),
    // Profil
    _Route('PATCH', '/me', _updateMe),
    _Route('POST', '/me/devices', (_) => const LocalResponse.json({'success': true}, status: 201)),
    // Tableau de bord, emploi du temps
    _Route('GET', '/children/([^/]+)/dashboard', _dashboard),
    _Route('GET', '/children/([^/]+)/timetable', _timetable),
    _Route('GET', '/children/([^/]+)/timetable\\.ics', _ics),
    // Finances
    _Route('POST', '/payments/initiate', _initiatePayment),
    _Route('GET', '/payments/([^/]+)/status', _paymentStatus),
    _Route('POST', '/payments/([^/]+)/sandbox/confirm', _sandboxConfirm),
    _Route('POST', '/installment-requests', _installmentRequest),
    // Présences et notes
    _Route('POST', '/absences/([^/]+)/justify', _justify),
    _Route('POST', '/attendance/scan', _scan),
    _Route('POST', '/grades/([^/]+)/dispute', _dispute),
    // Messagerie et rendez-vous
    _Route('GET', '/conversations', _conversations),
    _Route('POST', '/conversations', _createConversation),
    _Route('GET', '/conversations/([^/]+)/messages', _conversation),
    _Route('POST', '/conversations/([^/]+)/messages', _reply),
    _Route('POST', '/conversations/([^/]+)/rate', _rate),
    _Route('GET', '/messages/([^/]+)/attachments/(\\d+)', _attachment),
    _Route('POST', '/appointments', _createAppointment),
    _Route('PATCH', '/appointments/([^/]+)', _updateAppointment),
    // Documents et discipline
    _Route('GET', '/documents/([^/]+)/download', _download),
    _Route('POST', '/documents/([^/]+)/sign', _sign),
    _Route('POST', '/children/([^/]+)/documents/upload', _upload),
    _Route('POST', '/requests', _createRequest),
    _Route('GET', '/requests/([^/]+)/document', _requestDocument),
    _Route('POST', '/discipline/([^/]+)/acknowledge', _acknowledge),
    // Notifications
    _Route('GET', '/notifications', _notifications),
    _Route('GET', '/notifications/unread-count', _unreadCount),
    _Route('PATCH', '/notifications/([^/]+)/read', _markRead),
    _Route('POST', '/notifications/read-all', _markAllRead),
    _Route('PUT', '/notification-preferences', _savePreferences),
  ];

  Future<LocalResponse> handle(LocalRequest req) async {
    // Latence réseau simulée : les squelettes de chargement restent visibles.
    await Future<void>.delayed(Duration(milliseconds: 150 + _random.nextInt(250)));
    try {
      for (final r in _routes) {
        if (r.method != req.method) continue;
        final m = r.pattern.firstMatch(req.path);
        if (m == null) continue;
        final account = r.public ? null : await _authenticate(req);
        return await r.handler(_Call(req, [for (var i = 1; i <= m.groupCount; i++) m.group(i) ?? ''], account));
      }
      if (req.method == 'GET') return _stored(_Call(req, const [], await _authenticate(req)));
      throw const _ApiError(404, 'NOT_FOUND', 'Fonction indisponible en mode démo');
    } on _ApiError catch (e) {
      return LocalResponse.json({'statusCode': e.status, 'code': e.code, 'message': e.message}, status: e.status);
    } catch (e, st) {
      debugPrint('[Démo] ${req.method} ${req.path} : $e\n$st');
      return const LocalResponse.json({'statusCode': 500, 'code': 'LOCAL_ERROR', 'message': 'Erreur du mode démo'}, status: 500);
    }
  }

  // ------------------------------------------------------------------ Accès aux données

  List<Map<String, dynamic>> get _accounts => (db.read('accounts')! as List).cast<Map<String, dynamic>>();
  Map<String, dynamic> get _meta => db.read('meta')! as Map<String, dynamic>;

  Map<String, dynamic>? _entry(String path, String? uid) => db.read(LocalDatabase.keyFor(path, userId: uid)) as Map<String, dynamic>?;
  Object? _get(String path, {String? uid}) => _entry(path, uid)?['body'];
  Future<void> _put(String path, Object? body, {String? uid}) =>
      db.write(LocalDatabase.keyFor(path, userId: uid), {'status': 200, 'type': 'json', 'body': body});
  Future<void> _putPdf(String path, List<int> bytes) => db.write(LocalDatabase.keyFor(path), {'status': 200, 'type': 'pdf', 'body': base64Encode(bytes)});

  List<dynamic> _list(String path, {String? uid}) => (_get(path, uid: uid) as List?) ?? [];

  String get _now => DateTime.now().toUtc().toIso8601String();
  String _id() => _uuid.v4();
  String _code() => (100000 + _random.nextInt(900000)).toString();

  Future<String> _reference(String prefix) async {
    final meta = _meta;
    final n = (meta['seq'] as int) + 1;
    meta['seq'] = n;
    await db.write('meta', meta);
    return '$prefix-${DateTime.now().year}-${n.toString().padLeft(6, '0')}';
  }

  Map<String, dynamic> _me(String uid) => _get('/me', uid: uid)! as Map<String, dynamic>;

  String _name(String uid) {
    final me = _me(uid);
    final p = (me['parentProfile'] ?? me['studentProfile']) as Map<String, dynamic>?;
    return p == null ? '${me['email']}' : '${p['prenom']} ${p['nom']}';
  }

  List<Map<String, dynamic>> _children(String uid) => _list('/me/children', uid: uid).cast<Map<String, dynamic>>();

  /// Comptes qui suivent l'étudiant (parents rattachés et l'étudiant lui-même).
  Iterable<String> _stakeholders(String childId) =>
      _accounts.where((a) => a['active'] == true && _children(a['id'] as String).any((c) => c['id'] == childId)).map((a) => a['id'] as String);

  void _assertChild(_Call c, String childId) {
    if (!_children(c.uid).any((ch) => ch['id'] == childId)) throw const _ApiError(403, 'FORBIDDEN', 'Accès refusé à ce dossier');
  }

  LocalResponse _toResponse(Map<String, dynamic> e) => switch (e['type']) {
        'pdf' => LocalResponse.bytes(base64Decode(e['body'] as String)),
        'text' => LocalResponse.text(e['body'] as String),
        _ => LocalResponse.json(e['body'], status: e['status'] as int),
      };

  static String _xaf(num n) {
    final digits = n.round().abs().toString();
    final groups = <String>[];
    for (var i = digits.length; i > 0; i -= 3) {
      groups.insert(0, digits.substring(max(0, i - 3), i));
    }
    return '${n < 0 ? '-' : ''}${groups.join('\u00A0')} FCFA';
  }

  static String _date(String iso) => DateFormat('dd/MM/yyyy', 'fr_FR').format(DateTime.parse(iso).toLocal());
  static String _dateTime(String iso) => DateFormat("dd/MM/yyyy 'à' HH:mm", 'fr_FR').format(DateTime.parse(iso).toLocal());

  /// Lecture simple : réponse exportée de l'API (avec contrôle d'accès au dossier).
  LocalResponse _stored(_Call c) {
    final path = c.req.path;
    final child = RegExp(r'^/children/([^/]+)').firstMatch(path);
    if (child != null) _assertChild(c, child.group(1)!);
    final semester = c.query['semesterId'];
    final entry = (semester != null ? _entry('$path?semesterId=$semester', c.uid) : null) ?? _entry(path, c.uid);
    if (entry == null) throw const _ApiError(404, 'NOT_FOUND', 'Ressource introuvable');
    return _toResponse(entry);
  }

  // ------------------------------------------------------------------ Traitements différés

  /// Programme un traitement « back-office » (validation, réponse…) après un délai.
  Future<void> _schedule(Map<String, dynamic> event, Duration delay) async {
    final events = (db.read('events') as List?) ?? [];
    events.add({...event, 'at': DateTime.now().add(delay).toIso8601String()});
    await db.write('events', events);
  }

  Future<void> _tick() async {
    final events = (db.read('events') as List?) ?? const [];
    final now = DateTime.now();
    final due = <Map<String, dynamic>>[];
    final pending = [];
    for (final e in events) {
      DateTime.parse(e['at'] as String).isAfter(now) ? pending.add(e) : due.add(Map<String, dynamic>.from(e as Map));
    }
    if (due.isEmpty) return;
    await db.write('events', pending);
    for (final e in due) {
      switch (e['type']) {
        case 'payment':
          await _settle(e['paymentId'] as String, success: true);
        case 'reply':
          await _deliverReply(e['uid'] as String, e['conversationId'] as String);
        case 'appointment':
          await _confirmAppointment(e['uid'] as String, e['appointmentId'] as String);
        case 'request':
          await _processRequest(e['childId'] as String, e['requestId'] as String);
        case 'justification':
          await _reviewJustification(e['childId'] as String, e['attendanceId'] as String);
        case 'document':
          await _validateDocument(e['childId'] as String, e['documentId'] as String);
      }
    }
  }

  Future<void> _notify(Iterable<String> userIds, String categorie, String titre, String corps, Map<String, dynamic> data) async {
    for (final uid in userIds) {
      final items = _notificationItems(uid)
        ..insert(0, {
          'id': _id(),
          'userId': uid,
          'titre': titre,
          'corps': corps,
          'canal': 'PUSH',
          'categorie': categorie,
          'dataPayload': data,
          'estLu': false,
          'luLe': null,
          'createdAt': _now,
        });
      await _put(_notificationsPath, {'items': items, 'nextCursor': null}, uid: uid);
    }
  }

  // ------------------------------------------------------------------ Authentification

  Future<Map<String, dynamic>> _authenticate(LocalRequest req) async {
    final parts = (req.headers['authorization'] ?? '').replaceFirst('Bearer ', '').split('.');
    final account = parts.length == 3 && parts[0] == 'local' ? _accounts.where((a) => a['id'] == parts[1] && a['active'] == true).firstOrNull : null;
    if (account == null) throw const _ApiError(401, 'UNAUTHORIZED', 'Session expirée, reconnectez-vous');
    await _tick();
    return account;
  }

  Map<String, dynamic>? _findAccount(String identifier) {
    final id = identifier.trim().toLowerCase();
    final digits = id.replaceAll(RegExp(r'\D'), '');
    return _accounts
        .where((a) =>
            (a['email'] as String?)?.toLowerCase() == id ||
            (digits.length >= 8 && ((a['telephone'] as String?) ?? '').replaceAll(RegExp(r'\D'), '').endsWith(digits)))
        .firstOrNull;
  }

  LocalResponse _session(Map<String, dynamic> account) => LocalResponse.json({
        'accessToken': 'local.${account['id']}.${_random.nextInt(1 << 30)}',
        'refreshToken': 'localr.${account['id']}.${_random.nextInt(1 << 30)}',
        'expiresIn': 900,
        'user': _me(account['id'] as String),
        'twoFactorSetupRequired': false,
      }, status: 201);

  Future<void> _saveAccounts() => db.write('accounts', db.read('accounts'));

  void _checkPassword(String password) {
    if (password.length < 8) throw const _ApiError(400, 'WEAK_PASSWORD', 'Le mot de passe doit contenir au moins 8 caractères');
  }

  void _checkOtp(String target, String code) {
    final otp = db.read('otp') as Map<String, dynamic>?;
    if (otp == null || otp['target'] != target || otp['code'] != code) throw const _ApiError(401, 'OTP_INVALID', 'Code incorrect ou expiré');
  }

  LocalResponse _login(_Call c) {
    final account = _findAccount(c.field('identifier'));
    if (account != null && account['active'] != true) throw const _ApiError(403, 'ACCOUNT_NOT_ACTIVATED', "Ce compte n'est pas encore activé");
    if (account == null || account['password'] != c.body['password']) throw const _ApiError(401, 'INVALID_CREDENTIALS', 'Identifiants incorrects');
    return _session(account);
  }

  Future<LocalResponse> _otpSend(_Call c) async {
    final code = _code();
    await db.write('otp', {'target': c.field('phone'), 'code': code});
    return LocalResponse.json({'success': true, 'message': 'Si ce numéro est enregistré, un code a été envoyé', 'devCode': code}, status: 201);
  }

  LocalResponse _otpVerify(_Call c) {
    _checkOtp(c.field('phone'), c.field('code'));
    final account = _findAccount(c.field('phone'));
    if (account == null || account['active'] != true) throw const _ApiError(401, 'ACCOUNT_INACTIVE', 'Aucun compte actif pour ce numéro');
    return _session(account);
  }

  Map<String, dynamic> _activationAccount(String code) {
    final activation = db.read('activation')! as Map<String, dynamic>;
    final account = _accounts.firstWhere((a) => a['id'] == activation['userId']);
    if (code.toUpperCase() != (activation['code'] as String).toUpperCase() || account['active'] == true) {
      throw const _ApiError(400, 'ACTIVATION_CODE_INVALID', "Code d'activation invalide ou déjà utilisé");
    }
    return account;
  }

  Future<LocalResponse> _activateStart(_Call c) async {
    final code = c.field('activationCode');
    _activationAccount(code);
    final otp = _code();
    await db.write('otp', {'target': code.toUpperCase(), 'code': otp});
    final start = (db.read('activation')! as Map<String, dynamic>)['start'] as Map<String, dynamic>;
    return LocalResponse.json({...start, 'devCode': otp}, status: 201);
  }

  Future<LocalResponse> _activate(_Call c) async {
    final code = c.field('activationCode');
    final account = _activationAccount(code);
    _checkOtp(code.toUpperCase(), c.field('otpCode'));
    _checkPassword('${c.body['newPassword'] ?? ''}');
    account
      ..['active'] = true
      ..['password'] = c.body['newPassword'];
    await _saveAccounts();
    return _session(account);
  }

  LocalResponse _refresh(_Call c) {
    final parts = c.field('refreshToken').split('.');
    final account = parts.length == 3 && parts[0] == 'localr' ? _accounts.where((a) => a['id'] == parts[1] && a['active'] == true).firstOrNull : null;
    if (account == null) throw const _ApiError(401, 'REFRESH_INVALID', 'Session expirée');
    return _session(account);
  }

  Future<LocalResponse> _forgotPassword(_Call c) async {
    final code = _code();
    await db.write('otp', {'target': c.field('identifier').toLowerCase(), 'code': code});
    return LocalResponse.json({'success': true, 'message': 'Si ce compte existe, un code de réinitialisation a été envoyé', 'devCode': code}, status: 201);
  }

  Future<LocalResponse> _resetPassword(_Call c) async {
    final identifier = c.field('identifier');
    _checkOtp(identifier.toLowerCase(), c.field('code'));
    _checkPassword('${c.body['newPassword'] ?? ''}');
    final account = _findAccount(identifier);
    if (account == null) throw const _ApiError(400, 'OTP_INVALID', 'Code incorrect ou expiré');
    account['password'] = c.body['newPassword'];
    await _saveAccounts();
    return const LocalResponse.json({'success': true}, status: 201);
  }

  Future<LocalResponse> _changePassword(_Call c) async {
    if (c.account!['password'] != c.body['currentPassword']) throw const _ApiError(400, 'INVALID_PASSWORD', 'Mot de passe actuel incorrect');
    _checkPassword('${c.body['newPassword'] ?? ''}');
    c.account!['password'] = c.body['newPassword'];
    await _saveAccounts();
    return const LocalResponse.json({'success': true}, status: 201);
  }

  Future<LocalResponse> _updateMe(_Call c) async {
    final me = _me(c.uid);
    final profile = (me['parentProfile'] ?? me['studentProfile']) as Map<String, dynamic>?;
    c.body.forEach((k, v) {
      if (k == 'preferredLocale') {
        me[k] = v;
      } else if (profile != null) {
        profile[k] = v;
      }
    });
    await _put('/me', me, uid: c.uid);
    return LocalResponse.json(me);
  }

  // ------------------------------------------------------------------ Tableau de bord et emploi du temps

  LocalResponse _dashboard(_Call c) {
    final childId = c.params[0];
    _assertChild(c, childId);
    final base = _get('/children/$childId/dashboard') as Map<String, dynamic>?;
    if (base == null) throw const _ApiError(404, 'NOT_FOUND', 'Tableau de bord indisponible');
    final now = DateTime.now();
    final invoices = _list('/children/$childId/invoices').cast<Map<String, dynamic>>().where((i) => i['statut'] != 'ANNULE').toList();
    int sum(Iterable<Map<String, dynamic>> l, String k) => l.fold(0, (s, i) => s + (i[k] as num).toInt());
    final unpaid = invoices.where((i) => (i['soldeRestant'] as num) > 0).toList()
      ..sort((a, b) => (a['dateEcheance'] as String).compareTo(b['dateEcheance'] as String));
    final late = unpaid.where((i) => DateTime.parse(i['dateEcheance'] as String).isBefore(now)).toList();
    final reste = sum(invoices, 'soldeRestant');

    final alerts = [for (final a in (base['alertes'] as List? ?? const [])) if (a['type'] != 'IMPAYE') a];
    if (late.isNotEmpty) {
      alerts.insert(0, {'type': 'IMPAYE', 'niveau': 'danger', 'message': '${late.length} échéance(s) en retard : ${_xaf(sum(late, 'soldeRestant'))} à régler'});
    }
    final attendance = {for (final a in _list('/children/$childId/attendance')) a['id']: a};
    final presence = Map<String, dynamic>.of(base['presence'] as Map<String, dynamic>);
    presence['dernieresAbsences'] = [
      for (final a in (presence['dernieresAbsences'] as List? ?? const []))
        {...a as Map<String, dynamic>, 'justification': (attendance[a['id']]?['justification'] as Map?)?['statut'] ?? a['justification']},
    ];
    final today = DateTime(now.year, now.month, now.day);

    return LocalResponse.json({
      ...base,
      'generatedAt': _now,
      'finances': {
        'devise': invoices.firstOrNull?['devise'] ?? 'XAF',
        'totalDu': sum(invoices, 'montantTotal'),
        'totalPaye': sum(invoices, 'montantPaye'),
        'resteAPayer': reste,
        'prochaineEcheance': unpaid.isEmpty ? null : {'invoiceId': unpaid.first['id'], 'date': unpaid.first['dateEcheance'], 'montant': unpaid.first['soldeRestant']},
        'statut': late.isNotEmpty ? 'EN_RETARD' : (reste > 0 ? 'A_PAYER' : 'A_JOUR'),
      },
      'presence': presence,
      'aujourdhui': [
        for (final s in _slots(childId, today, today.add(const Duration(days: 1))))
          {for (final k in const ['id', 'debut', 'fin', 'statut', 'matiere', 'salle', 'campus', 'enseignant']) k: s[k]},
      ],
      'alertes': alerts,
    });
  }

  /// Créneaux d'une période. Les semaines absentes de l'export reprennent le
  /// modèle de la semaine de référence (l'emploi du temps reste toujours rempli).
  List<Map<String, dynamic>> _slots(String childId, DateTime from, DateTime to) {
    final all = ((_get('/children/$childId/timetable') as Map?)?['creneaux'] as List? ?? const []).cast<Map<String, dynamic>>();
    bool inRange(Map<String, dynamic> s) {
      final d = DateTime.parse(s['debut'] as String);
      return !d.isBefore(from) && d.isBefore(to);
    }

    var slots = all.where(inRange).toList();
    if (slots.isEmpty && all.isNotEmpty) {
      final ref = DateTime.parse(_meta['refMonday'] as String);
      final refMonday = DateTime(ref.year, ref.month, ref.day);
      final f = from.toLocal();
      final weeks = (DateTime(f.year, f.month, f.day).difference(refMonday).inDays / 7).floor();
      final offset = Duration(days: weeks * 7);
      slots = [
        for (final s in all)
          if (_inWeek(s, refMonday) && s['statut'] != 'ANNULE')
            {
              ...s,
              'id': '${s['id']}~$weeks',
              'debut': DateTime.parse(s['debut'] as String).add(offset).toUtc().toIso8601String(),
              'fin': DateTime.parse(s['fin'] as String).add(offset).toUtc().toIso8601String(),
              'statut': 'PLANIFIE',
              'motif': null,
            },
      ].where(inRange).toList();
    }
    final now = DateTime.now();
    return [for (final s in slots) {...s, 'statut': _slotStatus(s, now)}];
  }

  static bool _inWeek(Map<String, dynamic> s, DateTime monday) {
    final d = DateTime.parse(s['debut'] as String).toLocal();
    return !d.isBefore(monday) && d.isBefore(monday.add(const Duration(days: 7)));
  }

  static String _slotStatus(Map<String, dynamic> s, DateTime now) {
    final statut = s['statut'] as String;
    if (statut == 'ANNULE' || statut == 'REPORTE') return statut;
    if (DateTime.parse(s['fin'] as String).isBefore(now)) return 'TERMINE';
    if (DateTime.parse(s['debut'] as String).isBefore(now)) return 'EN_COURS';
    return 'PLANIFIE';
  }

  static DateTime _monday(DateTime d) => DateTime(d.year, d.month, d.day - (d.weekday - 1));

  LocalResponse _timetable(_Call c) {
    final childId = c.params[0];
    _assertChild(c, childId);
    final monday = _monday(DateTime.now());
    final from = DateTime.tryParse(c.query['from'] ?? '') ?? monday;
    final to = DateTime.tryParse(c.query['to'] ?? '') ?? monday.add(const Duration(days: 7));
    return LocalResponse.json({
      'periode': {'from': from.toUtc().toIso8601String(), 'to': to.toUtc().toIso8601String()},
      'creneaux': _slots(childId, from, to),
    });
  }

  LocalResponse _ics(_Call c) {
    final childId = c.params[0];
    _assertChild(c, childId);
    String stamp(String iso) => '${DateTime.parse(iso).toUtc().toIso8601String().replaceAll(RegExp('[-:]'), '').split('.').first}Z';
    final monday = _monday(DateTime.now());
    final lines = ['BEGIN:VCALENDAR', 'VERSION:2.0', 'PRODID:-//UniParent AFRAM//FR', 'CALSCALE:GREGORIAN', 'X-WR-CALNAME:AFRAM — Emploi du temps', 'X-WR-TIMEZONE:Africa/Libreville'];
    for (var w = -1; w <= 4; w++) {
      final from = monday.add(Duration(days: 7 * w));
      for (final s in _slots(childId, from, from.add(const Duration(days: 7)))) {
        lines.addAll([
          'BEGIN:VEVENT',
          'UID:${s['id']}@uniparent.aframgabon.com',
          'DTSTAMP:${stamp(_now)}',
          'DTSTART:${stamp(s['debut'] as String)}',
          'DTEND:${stamp(s['fin'] as String)}',
          'SUMMARY:${s['matiere']} (${s['code']})',
          'LOCATION:${s['salle']} — ${s['campus']}',
          'DESCRIPTION:${s['enseignant']}',
          if (s['statut'] == 'ANNULE') 'STATUS:CANCELLED',
          'END:VEVENT',
        ]);
      }
    }
    lines.add('END:VCALENDAR');
    return LocalResponse.text(lines.join('\r\n'));
  }

  // ------------------------------------------------------------------ Paiements

  Map<String, dynamic> get _payments => (db.read('payments') as Map<String, dynamic>?) ?? <String, dynamic>{};

  Map<String, dynamic> _intent(Map<String, dynamic> p) => {
        'paymentId': p['id'],
        'reference': p['reference'],
        'statut': p['statut'],
        'montant': p['montant'],
        'devise': p['devise'],
        'paymentUrl': null,
        'instructions': p['instructions'],
        'receipt': p['receipt'],
      };

  Future<LocalResponse> _initiatePayment(_Call c) async {
    final key = c.req.headers['idempotency-key'] ?? '';
    if (!RegExp(r'^[A-Za-z0-9-]{16,64}$').hasMatch(key)) throw const _ApiError(400, 'IDEMPOTENCY_KEY_REQUIRED', 'En-tête Idempotency-Key manquant ou invalide');
    final payments = _payments;
    final existing = payments.values.cast<Map<String, dynamic>>().where((p) => p['idempotencyKey'] == key).firstOrNull;
    if (existing != null) return LocalResponse.json(_intent(existing), status: 201);

    final invoice = _get('/invoices/${c.field('invoiceId')}') as Map<String, dynamic>?;
    if (invoice == null) throw const _ApiError(404, 'NOT_FOUND', 'Facture introuvable');
    final childId = invoice['studentId'] as String;
    _assertChild(c, childId);
    if (c.role == 'ETUDIANT') throw const _ApiError(403, 'STUDENT_PAYMENT_DISABLED', 'Le paiement par l’étudiant n’est pas autorisé');
    if (_children(c.uid).firstWhere((ch) => ch['id'] == childId)['estPayeur'] != true) {
      throw const _ApiError(403, 'FORBIDDEN', "Votre rattachement ne permet pas d'effectuer des paiements");
    }
    if (invoice['statut'] == 'ANNULE' || invoice['statut'] == 'PAYE') throw const _ApiError(400, 'INVOICE_NOT_PAYABLE', 'Cette facture n’est pas payable');
    final montant = (c.body['montant'] as num?)?.toInt() ?? 0;
    final solde = (invoice['soldeRestant'] as num).toInt();
    if (montant <= 0 || montant > solde) throw _ApiError(400, 'INVALID_AMOUNT', 'Le montant doit être compris entre 1 et $solde ${invoice['devise']}');

    final canal = c.field('canal');
    final reference = await _reference('PAY');
    final payment = {
      'id': _id(),
      'reference': reference,
      'idempotencyKey': key,
      'invoiceId': invoice['id'],
      'studentId': childId,
      'montant': montant,
      'devise': invoice['devise'] ?? 'XAF',
      'canal': canal,
      'statut': 'EN_ATTENTE',
      'payeurUserId': c.uid,
      'payeurType': 'PARENT',
      'referenceExterne': 'SBX-$reference',
      'createdAt': _now,
      'receipt': null,
      'instructions': canal == 'ONLINE_CARD'
          ? 'Mode démo : aucune carte réelle n’est débitée.'
          : 'Mode démo : la demande de paiement Mobile Money est validée automatiquement dans quelques secondes.',
    };
    payments[payment['id'] as String] = payment;
    await db.write('payments', payments);
    // Simule la validation par l'opérateur (webhook) quelques secondes plus tard.
    await _schedule({'type': 'payment', 'paymentId': payment['id']}, const Duration(seconds: 8));
    return LocalResponse.json(_intent(payment), status: 201);
  }

  Map<String, dynamic> _payment(_Call c, String id) {
    final p = _payments[id] as Map<String, dynamic>?;
    if (p == null) throw const _ApiError(404, 'NOT_FOUND', 'Paiement introuvable');
    _assertChild(c, p['studentId'] as String);
    return p;
  }

  LocalResponse _paymentStatus(_Call c) => LocalResponse.json(_intent(_payment(c, c.params[0])));

  Future<LocalResponse> _sandboxConfirm(_Call c) async {
    _payment(c, c.params[0]);
    await _settle(c.params[0], success: c.body['success'] != false);
    return LocalResponse.json(_intent(_payment(c, c.params[0])), status: 201);
  }

  /// Règlement d'un paiement : facture, échéances, historique, synthèse, reçu PDF, notifications.
  Future<void> _settle(String paymentId, {required bool success}) async {
    final payments = _payments;
    final p = payments[paymentId] as Map<String, dynamic>?;
    if (p == null || p['statut'] != 'EN_ATTENTE') return;
    final childId = p['studentId'] as String;
    final invoicePath = '/invoices/${p['invoiceId']}';
    final invoice = _get(invoicePath)! as Map<String, dynamic>;
    final student = invoice['student'] as Map<String, dynamic>? ?? const {};
    final enfant = '${student['prenom']} ${student['nom']}';
    final montant = p['montant'] as int;

    if (!success) {
      p['statut'] = 'ECHOUE';
      await db.write('payments', payments);
      await _notify([p['payeurUserId'] as String], 'FINANCE', 'Paiement non abouti',
          'Le paiement de ${_xaf(montant)} pour $enfant n’a pas abouti. Aucun montant n’a été débité.', {'type': 'PAYMENT_FAILED', 'paymentId': paymentId, 'studentId': childId});
      return;
    }

    final applied = min(montant, (invoice['soldeRestant'] as num).toInt());
    final receipt = {'id': _id(), 'numeroRecu': await _reference('REC')};
    p
      ..['statut'] = 'VALIDE'
      ..['receipt'] = receipt;
    final record = {
      'id': p['id'],
      'reference': p['reference'],
      'date': _now,
      'montant': montant,
      'devise': p['devise'],
      'statut': 'VALIDE',
      'canal': p['canal'],
      'enLigne': true,
      'fournisseur': 'SANDBOX',
      'referenceExterne': p['referenceExterne'],
      'payeurType': p['payeurType'],
      'auteur': _name(p['payeurUserId'] as String),
      'enregistrePar': null,
      'invoiceId': p['invoiceId'],
      'receipt': receipt,
    };

    _applyToInvoice(invoice, applied, record);
    await _put(invoicePath, invoice);
    final invoices = _list('/children/$childId/invoices');
    for (final i in invoices) {
      if (i['id'] == invoice['id']) _applyToInvoice(i as Map<String, dynamic>, applied, record);
    }
    await _put('/children/$childId/invoices', invoices);
    await _put('/children/$childId/payments', _list('/children/$childId/payments')..insert(0, record));
    await _updateSummary(childId, invoice['academicYearId'] as String?, applied);
    await db.write('payments', payments);

    final canal = p['canal'] == 'ONLINE_CARD' ? 'Carte bancaire (en ligne)' : 'Mobile Money (en ligne)';
    await _putPdf(
      '/receipts/${receipt['id']}/pdf',
      await DemoPdf.build(
        title: 'Reçu de paiement',
        reference: 'Reçu n° ${receipt['numeroRecu']}',
        paragraphs: ['L’AFRAM atteste avoir reçu le versement ci-dessous.'],
        table: [
          ['Référence', '${p['reference']}'],
          ['Facture', '${invoice['numeroFacture']}'],
          ['Étudiant', '$enfant (${student['matricule'] ?? ''})'],
          ['Montant', _xaf(montant)],
          ['Moyen de paiement', canal],
          ['Payé par', '${record['auteur']}'],
          ['Date', _dateTime(record['date'] as String)],
          ['Reste à payer sur la facture', _xaf(invoice['soldeRestant'] as num)],
        ],
      ),
    );
    await _notify(_stakeholders(childId), 'FINANCE', 'Versement reçu', 'Versement de ${_xaf(montant)} reçu pour $enfant. Reçu n° ${receipt['numeroRecu']}.',
        {'type': 'PAYMENT_VALIDATED', 'paymentId': paymentId, 'receiptId': receipt['id'], 'studentId': childId});
  }

  void _applyToInvoice(Map<String, dynamic> invoice, int applied, Map<String, dynamic> record) {
    final paye = (invoice['montantPaye'] as num).toInt() + applied;
    final solde = max(0, (invoice['montantTotal'] as num).toInt() - paye);
    invoice
      ..['montantPaye'] = paye
      ..['soldeRestant'] = solde
      ..['statut'] = solde == 0 ? 'PAYE' : (DateTime.parse(invoice['dateEcheance'] as String).isBefore(DateTime.now()) ? 'EN_RETARD' : 'PARTIELLEMENT_PAYE')
      ..['updatedAt'] = _now;
    if (invoice['lines'] is List) invoice['lines'] = _allocateLines(invoice['lines'] as List, paye);
    if (invoice['payments'] is List) (invoice['payments'] as List).insert(0, record);
  }

  /// Répartit le montant payé sur les lignes par ordre d'échéance (comme l'API).
  static List<dynamic> _allocateLines(List<dynamic> lines, int paid) {
    final now = DateTime.now();
    var remaining = paid;
    final sorted = [...lines]..sort((a, b) => (a['dateLimite'] as String).compareTo(b['dateLimite'] as String));
    for (final l in sorted) {
      final montant = (l['montant'] as num).toInt();
      final applied = min(montant, max(0, remaining));
      remaining -= applied;
      final reste = montant - applied;
      var statut = reste == 0 ? 'PAYE' : (applied > 0 ? 'PARTIELLEMENT_PAYE' : 'A_PAYER');
      if (reste > 0 && DateTime.parse(l['dateLimite'] as String).isBefore(now)) statut = 'EN_RETARD';
      (l as Map<String, dynamic>)
        ..['montantPaye'] = applied
        ..['resteAPayer'] = reste
        ..['statut'] = statut;
    }
    return sorted;
  }

  Future<void> _updateSummary(String childId, String? yearId, int applied) async {
    final path = '/children/$childId/finance/summary';
    final summary = _get(path) as Map<String, dynamic>?;
    if (summary == null) return;
    for (final y in (summary['parAnnee'] as List? ?? const [])) {
      if (y['academicYearId'] != yearId) continue;
      y['paye'] = (y['paye'] as num).toInt() + applied;
      y['reste'] = max(0, (y['reste'] as num).toInt() - applied);
    }
    final mois = DateTime.now().toIso8601String().substring(0, 7);
    final evolution = (summary['evolution'] as List? ?? []).cast<Map<String, dynamic>>().toList();
    final current = evolution.where((e) => e['mois'] == mois).firstOrNull;
    if (current == null) {
      evolution.add({'mois': mois, 'montant': applied, 'cumul': 0});
    } else {
      current['montant'] = (current['montant'] as num).toInt() + applied;
    }
    evolution.sort((a, b) => (a['mois'] as String).compareTo(b['mois'] as String));
    var cumul = 0;
    for (final e in evolution) {
      cumul += (e['montant'] as num).toInt();
      e['cumul'] = cumul;
    }
    summary['evolution'] = evolution;
    await _put(path, summary);
  }

  Future<LocalResponse> _installmentRequest(_Call c) async {
    final path = '/invoices/${c.field('invoiceId')}';
    final invoice = _get(path) as Map<String, dynamic>?;
    if (invoice == null) throw const _ApiError(404, 'NOT_FOUND', 'Facture introuvable');
    _assertChild(c, invoice['studentId'] as String);
    final requests = (invoice['installmentRequests'] as List?) ?? [];
    if (requests.any((r) => r['statut'] == 'SOUMISE')) throw const _ApiError(400, 'ALREADY_PENDING', 'Une demande est déjà en cours pour cette facture');
    final request = {
      'id': _id(),
      'statut': 'SOUMISE',
      'nombreTranches': (c.body['nombreTranches'] as num?)?.toInt() ?? 2,
      'motif': c.field('motif'),
      'reponse': null,
      'createdAt': _now,
    };
    invoice['installmentRequests'] = requests..insert(0, request);
    await _put(path, invoice);
    return LocalResponse.json(request, status: 201);
  }

  // ------------------------------------------------------------------ Présences et notes

  void _checkUpload(_Call c) {
    final file = c.req.files.firstOrNull;
    if (file == null || file.length == 0) throw const _ApiError(400, 'FILE_REQUIRED', 'Fichier manquant');
    if (file.length > _maxUpload) throw const _ApiError(400, 'FILE_TOO_LARGE', 'Fichier trop volumineux (8 Mo maximum)');
    final ext = (file.filename ?? '').split('.').last.toLowerCase();
    final mime = file.mimeType ?? const {'pdf': 'application/pdf', 'jpg': 'image/jpeg', 'jpeg': 'image/jpeg', 'png': 'image/png', 'webp': 'image/webp'}[ext];
    if (!_uploadTypes.contains(mime)) throw const _ApiError(400, 'FILE_TYPE', 'Format non autorisé (PDF, JPG, PNG ou WebP)');
  }

  /// Recherche un élément d'une liste propre à l'un des dossiers de l'utilisateur.
  (String childId, List<dynamic> list, Map<String, dynamic> item) _findInChildren(_Call c, String suffix, String id, String notFound) {
    for (final child in _children(c.uid)) {
      final list = _list('/children/${child['id']}/$suffix');
      final item = list.where((x) => x['id'] == id).firstOrNull;
      if (item != null) return (child['id'] as String, list, item as Map<String, dynamic>);
    }
    throw _ApiError(404, 'NOT_FOUND', notFound);
  }

  Future<LocalResponse> _justify(_Call c) async {
    if (c.role != 'PARENT' && c.role != 'ETUDIANT') throw const _ApiError(403, 'FORBIDDEN', 'Seuls le parent ou l’étudiant peuvent justifier');
    final (childId, list, item) = _findInChildren(c, 'attendance', c.params[0], 'Séance introuvable');
    if (item['statut'] != 'ABSENT' && item['statut'] != 'RETARD') throw const _ApiError(400, 'NOT_JUSTIFIABLE', 'Seules les absences et retards peuvent être justifiés');
    final current = item['justification'] as Map<String, dynamic>?;
    if (current != null && current['statut'] != 'REJETE') throw const _ApiError(400, 'ALREADY_JUSTIFIED', 'Un justificatif est déjà en cours d’examen ou validé');
    if (c.field('motif').isEmpty) throw const _ApiError(400, 'MOTIF_REQUIRED', 'Le motif est obligatoire');
    _checkUpload(c);
    final justification = {'id': _id(), 'motif': c.field('motif'), 'statut': 'EN_ATTENTE', 'commentaire': null, 'createdAt': _now};
    item
      ..['justification'] = justification
      ..['justifiable'] = false;
    await _put('/children/$childId/attendance', list);
    await _schedule({'type': 'justification', 'childId': childId, 'attendanceId': item['id']}, const Duration(seconds: 30));
    return LocalResponse.json(justification, status: 201);
  }

  Future<void> _reviewJustification(String childId, String attendanceId) async {
    final list = _list('/children/$childId/attendance');
    final item = list.where((x) => x['id'] == attendanceId).firstOrNull as Map<String, dynamic>?;
    final justification = item?['justification'] as Map<String, dynamic>?;
    if (item == null || justification?['statut'] != 'EN_ATTENTE') return;
    justification!
      ..['statut'] = 'VALIDE'
      ..['commentaire'] = 'Justificatif accepté par la scolarité';
    await _put('/children/$childId/attendance', list);
    await _notify(_stakeholders(childId), 'PRESENCE', 'Justificatif accepté',
        'Le justificatif pour la séance « ${(item['cours'] as Map?)?['nom']} » du ${_date(item['date'] as String)} a été accepté.', {'type': 'JUSTIFICATION_REVIEWED', 'studentId': childId});
  }

  LocalResponse _scan(_Call c) {
    if (c.role != 'ETUDIANT') throw const _ApiError(403, 'FORBIDDEN', 'Le scan de présence est réservé aux étudiants');
    if (c.field('code').length < 6) throw const _ApiError(400, 'QR_INVALID', 'QR code invalide ou expiré');
    final childId = _children(c.uid).first['id'] as String;
    final now = DateTime.now();
    final today = _slots(childId, DateTime(now.year, now.month, now.day), DateTime(now.year, now.month, now.day + 1)).where((s) => s['statut'] != 'ANNULE').toList();
    if (today.isEmpty) throw const _ApiError(400, 'NO_SESSION', 'Aucune séance aujourd’hui pour votre groupe');
    // Séance en cours, sinon la plus proche de l'heure actuelle.
    int distance(Map<String, dynamic> s) => DateTime.parse(s['debut'] as String).difference(now).inMinutes.abs();
    final slot = today.firstWhere((s) => s['statut'] == 'EN_COURS', orElse: () => (today..sort((a, b) => distance(a) - distance(b))).first);
    final retard = slot['statut'] == 'EN_COURS' ? now.difference(DateTime.parse(slot['debut'] as String)).inMinutes : 0;
    return LocalResponse.json({'statut': retard > 10 ? 'RETARD' : 'PRESENT', 'minutesRetard': retard > 10 ? retard : 0, 'cours': slot['matiere']}, status: 201);
  }

  Future<LocalResponse> _dispute(_Call c) async {
    final gradeId = c.params[0];
    if (c.field('motif').isEmpty) throw const _ApiError(400, 'MOTIF_REQUIRED', 'Le motif est obligatoire');
    for (final child in _children(c.uid)) {
      final childId = child['id'] as String;
      final found = db.keysStartingWith('r:/children/$childId/grades').any((k) {
        final body = (db.read(k) as Map?)?['body'];
        return body is Map && (body['matieres'] as List? ?? const []).any((m) => (m['notes'] as List? ?? const []).any((n) => n['id'] == gradeId));
      });
      if (!found) continue;
      final path = '/children/$childId/grade-disputes';
      final disputes = _list(path);
      if (disputes.any((d) => d['gradeId'] == gradeId && d['statut'] == 'OUVERTE')) throw const _ApiError(400, 'ALREADY_DISPUTED', 'Une réclamation est déjà en cours pour cette note');
      final dispute = {'id': _id(), 'gradeId': gradeId, 'motif': c.field('motif'), 'statut': 'OUVERTE', 'reponse': null, 'createdAt': _now};
      await _put(path, disputes..insert(0, dispute));
      return LocalResponse.json(dispute, status: 201);
    }
    throw const _ApiError(404, 'NOT_FOUND', 'Note introuvable');
  }

  // ------------------------------------------------------------------ Messagerie

  static const _conversationsPath = '/conversations?take=100';

  List<dynamic> _conversationItems(String uid) => ((_get(_conversationsPath, uid: uid) as Map?)?['items'] as List?) ?? [];
  Future<void> _saveConversations(String uid, List<dynamic> items) => _put(_conversationsPath, {'items': items, 'nextCursor': null}, uid: uid);
  Map<String, dynamic>? _detail(String uid, String id) => _get('/conversations/$id/messages', uid: uid) as Map<String, dynamic>?;

  static Map<String, dynamic> _page(List<dynamic> items, Map<String, String> query) {
    final take = int.tryParse(query['take'] ?? '') ?? 30;
    final cursor = query['cursor'];
    final start = cursor == null ? 0 : items.indexWhere((i) => i['id'] == cursor) + 1;
    final page = items.skip(start).take(take).toList();
    return {'items': page, 'nextCursor': start + page.length < items.length && page.isNotEmpty ? page.last['id'] : null};
  }

  LocalResponse _conversations(_Call c) => LocalResponse.json(_page(_conversationItems(c.uid), c.query));

  Future<LocalResponse> _conversation(_Call c) async {
    final detail = _detail(c.uid, c.params[0]);
    if (detail == null) throw const _ApiError(404, 'NOT_FOUND', 'Conversation introuvable');
    for (final m in detail['messages'] as List) {
      if (m['moi'] != true) m['estLu'] = true;
    }
    await _put('/conversations/${c.params[0]}/messages', detail, uid: c.uid);
    final items = _conversationItems(c.uid);
    for (final s in items) {
      if (s['id'] == c.params[0]) s['nonLus'] = 0;
    }
    await _saveConversations(c.uid, items);
    return LocalResponse.json(detail);
  }

  Map<String, dynamic> _message(_Call c, String contenu) => {
        'id': _id(),
        'contenu': contenu,
        'createdAt': _now,
        'estLu': false,
        'luLe': null,
        'piecesJointes': c.req.files.length,
        'moi': true,
        'auteur': _name(c.uid),
        'auteurRole': c.role,
      };

  Future<LocalResponse> _createConversation(_Call c) async {
    final sujet = c.field('sujet');
    final contenu = c.field('message');
    if (sujet.isEmpty || contenu.isEmpty) throw const _ApiError(400, 'VALIDATION', 'Le sujet et le message sont obligatoires');
    if (c.req.files.isNotEmpty) _checkUpload(c);
    final studentId = c.body['studentId'] as String?;
    final child = studentId == null ? null : _children(c.uid).where((ch) => ch['id'] == studentId).firstOrNull;
    if (studentId != null && child == null) throw const _ApiError(403, 'FORBIDDEN', 'Accès refusé à ce dossier');
    final now = _now;
    final base = {
      'id': _id(),
      'numeroTicket': await _reference('TCK'),
      'studentId': studentId,
      'satisfaction': null,
      'slaDueAt': null,
      'sujet': sujet,
      'service': c.field('service'),
      'priorite': c.body['priorite'] ?? 'NORMALE',
      'statut': 'OUVERT',
      'creeParUserId': c.uid,
      'assigneAUserId': null,
      'createdAt': now,
      'updatedAt': now,
      'student': child == null ? null : {'id': child['id'], 'prenom': child['prenom'], 'nom': child['nom']},
    };
    final detail = {...base, 'messages': [_message(c, contenu)]};
    await _put('/conversations/${base['id']}/messages', detail, uid: c.uid);
    await _saveConversations(c.uid, _conversationItems(c.uid)
      ..insert(0, {...base, 'dernierMessage': {'contenu': contenu, 'createdAt': now, 'auteurId': c.uid}, 'nonLus': 0, 'slaDepasse': false}));
    await _schedule({'type': 'reply', 'uid': c.uid, 'conversationId': base['id']}, const Duration(seconds: 15));
    return LocalResponse.json(detail, status: 201);
  }

  Future<LocalResponse> _reply(_Call c) async {
    final id = c.params[0];
    final detail = _detail(c.uid, id);
    if (detail == null) throw const _ApiError(404, 'NOT_FOUND', 'Conversation introuvable');
    if (detail['statut'] == 'CLOTURE') throw const _ApiError(400, 'CLOSED', 'Cette conversation est clôturée');
    final contenu = c.field('contenu');
    if (contenu.isEmpty && c.req.files.isEmpty) throw const _ApiError(400, 'VALIDATION', 'Message vide');
    if (c.req.files.isNotEmpty) _checkUpload(c);
    final message = _message(c, contenu);
    (detail['messages'] as List).add(message);
    if (detail['statut'] == 'RESOLU') detail['statut'] = 'EN_COURS';
    detail['updatedAt'] = message['createdAt'];
    await _put('/conversations/$id/messages', detail, uid: c.uid);
    await _touchSummary(c.uid, detail, {'contenu': contenu, 'createdAt': message['createdAt'], 'auteurId': c.uid});
    await _schedule({'type': 'reply', 'uid': c.uid, 'conversationId': id}, const Duration(seconds: 15));
    return LocalResponse.json(message, status: 201);
  }

  /// Met à jour le résumé d'une conversation et la remonte en tête de liste.
  Future<void> _touchSummary(String uid, Map<String, dynamic> detail, Map<String, dynamic> last, {int unread = 0}) async {
    final items = _conversationItems(uid);
    final summary = items.where((s) => s['id'] == detail['id']).firstOrNull as Map<String, dynamic>?;
    if (summary == null) return;
    summary
      ..['statut'] = detail['statut']
      ..['updatedAt'] = last['createdAt']
      ..['dernierMessage'] = last
      ..['nonLus'] = ((summary['nonLus'] as num?)?.toInt() ?? 0) + unread;
    items
      ..remove(summary)
      ..insert(0, summary);
    await _saveConversations(uid, items);
  }

  static (String, String) _desk(String? service) => switch (service) {
        'FINANCES' => ('Service Comptabilité', 'COMPTABLE'),
        'PEDAGOGIE' => ('Responsable pédagogique', 'ENSEIGNANT'),
        'DISCIPLINE' => ('Vie scolaire', 'SCOLARITE'),
        'SUPPORT_TECHNIQUE' => ('Support UniParent', 'SUPPORT'),
        _ => ('Service Scolarité', 'SCOLARITE'),
      };

  Future<void> _deliverReply(String uid, String id) async {
    final detail = _detail(uid, id);
    if (detail == null) return;
    final (auteur, role) = _desk(detail['service'] as String?);
    final contenu = 'Bonjour, nous avons bien reçu votre message concernant « ${detail['sujet']} » (${detail['numeroTicket']}). '
        'Votre demande est prise en charge, nous revenons vers vous très rapidement.';
    final message = {'id': _id(), 'contenu': contenu, 'createdAt': _now, 'estLu': false, 'luLe': null, 'piecesJointes': 0, 'moi': false, 'auteur': auteur, 'auteurRole': role};
    (detail['messages'] as List).add(message);
    if (detail['statut'] == 'OUVERT') detail['statut'] = 'EN_COURS';
    await _put('/conversations/$id/messages', detail, uid: uid);
    await _touchSummary(uid, detail, {'contenu': contenu, 'createdAt': message['createdAt'], 'auteurId': role}, unread: 1);
    await _notify([uid], 'MESSAGERIE', 'Nouveau message — $auteur', contenu, {'type': 'MESSAGE', 'conversationId': id});
  }

  Future<LocalResponse> _rate(_Call c) async {
    final detail = _detail(c.uid, c.params[0]);
    if (detail == null) throw const _ApiError(404, 'NOT_FOUND', 'Conversation introuvable');
    detail['satisfaction'] = (c.body['satisfaction'] as num?)?.toInt();
    await _put('/conversations/${c.params[0]}/messages', detail, uid: c.uid);
    final items = _conversationItems(c.uid);
    for (final s in items) {
      if (s['id'] == detail['id']) s['satisfaction'] = detail['satisfaction'];
    }
    await _saveConversations(c.uid, items);
    return const LocalResponse.json({'success': true}, status: 201);
  }

  Future<LocalResponse> _attachment(_Call c) async => LocalResponse.bytes(
        await DemoPdf.build(title: 'Pièce jointe', paragraphs: ['Pièce jointe n° ${int.parse(c.params[1]) + 1} du message.', 'Le fichier d’origine reste sur l’appareil de son auteur en mode démo.']),
      );

  // ------------------------------------------------------------------ Rendez-vous

  static String _hostLabel(Map<String, dynamic> host) {
    final t = host['teacherProfile'] as Map<String, dynamic>?;
    if (t != null && '${t['nom'] ?? ''}'.isNotEmpty) return '${t['prenom']} ${t['nom']}';
    return switch (host['role']) {
      'SCOLARITE' => 'Service Scolarité',
      'COMPTABLE' => 'Service Comptabilité',
      'DIRECTION' => 'Direction',
      _ => '${host['email'] ?? host['role']}',
    };
  }

  Future<LocalResponse> _createAppointment(_Call c) async {
    final host = _list('/appointments/hosts', uid: c.uid).where((h) => h['id'] == c.body['hoteId']).firstOrNull as Map<String, dynamic>?;
    if (host == null) throw const _ApiError(400, 'HOST_INVALID', 'Interlocuteur introuvable');
    final debut = DateTime.tryParse(c.field('debut'));
    final fin = DateTime.tryParse(c.field('fin'));
    if (debut == null || fin == null || !fin.isAfter(debut)) throw const _ApiError(400, 'VALIDATION', 'Créneau invalide');
    if (debut.isBefore(DateTime.now())) throw const _ApiError(400, 'VALIDATION', 'Le créneau doit être dans le futur');
    final appointment = {
      'id': _id(),
      'objet': c.field('objet'),
      'debut': debut.toUtc().toIso8601String(),
      'fin': fin.toUtc().toIso8601String(),
      'statut': 'DEMANDE',
      'lieu': null,
      'hote': host,
    };
    await _put('/appointments', _list('/appointments', uid: c.uid)..add(appointment), uid: c.uid);
    await _schedule({'type': 'appointment', 'uid': c.uid, 'appointmentId': appointment['id']}, const Duration(seconds: 20));
    return LocalResponse.json(appointment, status: 201);
  }

  Future<LocalResponse> _updateAppointment(_Call c) async {
    final list = _list('/appointments', uid: c.uid);
    final appointment = list.where((a) => a['id'] == c.params[0]).firstOrNull as Map<String, dynamic>?;
    if (appointment == null) throw const _ApiError(404, 'NOT_FOUND', 'Rendez-vous introuvable');
    if (c.body['statut'] != null) appointment['statut'] = c.body['statut'];
    await _put('/appointments', list, uid: c.uid);
    return LocalResponse.json(appointment);
  }

  Future<void> _confirmAppointment(String uid, String id) async {
    final list = _list('/appointments', uid: uid);
    final appointment = list.where((a) => a['id'] == id).firstOrNull as Map<String, dynamic>?;
    if (appointment == null || appointment['statut'] != 'DEMANDE') return;
    final host = appointment['hote'] as Map<String, dynamic>;
    appointment
      ..['statut'] = 'CONFIRME'
      ..['lieu'] = 'Bureau ${_hostLabel(host)}, campus Batterie IV';
    await _put('/appointments', list, uid: uid);
    await _notify([uid], 'MESSAGERIE', 'Rendez-vous confirmé',
        'Votre rendez-vous « ${appointment['objet']} » avec ${_hostLabel(host)} le ${_dateTime(appointment['debut'] as String)} est confirmé.', {'type': 'APPOINTMENT', 'appointmentId': id});
  }

  // ------------------------------------------------------------------ Documents et discipline

  Future<LocalResponse> _download(_Call c) async {
    final stored = _entry('/documents/${c.params[0]}/download', null);
    if (stored != null) return _toResponse(stored);
    final (_, _, doc) = _findInChildren(c, 'documents', c.params[0], 'Document introuvable');
    return LocalResponse.bytes(await DemoPdf.build(
      title: '${doc['titre']}',
      paragraphs: ['Pièce déposée le ${_date(doc['createdAt'] as String)} (catégorie : ${doc['categorie']}).', 'Le fichier d’origine reste sur l’appareil en mode démo.'],
    ));
  }

  Future<LocalResponse> _sign(_Call c) async {
    if (c.role != 'PARENT' && c.role != 'ETUDIANT') throw const _ApiError(403, 'FORBIDDEN', 'Signature réservée au parent ou à l’étudiant');
    final (childId, list, doc) = _findInChildren(c, 'documents', c.params[0], 'Document introuvable');
    if (doc['estSigne'] == true) throw const _ApiError(400, 'ALREADY_SIGNED', 'Document déjà signé');
    doc
      ..['estSigne'] = true
      ..['aSigner'] = false
      ..['signatureMetadata'] = {'signePar': _name(c.uid), 'userId': c.uid, 'role': c.role, 'le': _now, 'ip': '127.0.0.1'};
    await _put('/children/$childId/documents', list);
    return LocalResponse.json(doc, status: 201);
  }

  Future<LocalResponse> _upload(_Call c) async {
    final childId = c.params[0];
    _assertChild(c, childId);
    if (c.field('titre').isEmpty) throw const _ApiError(400, 'VALIDATION', 'Le titre est obligatoire');
    _checkUpload(c);
    final doc = {
      'id': _id(),
      'studentId': childId,
      'titre': c.field('titre'),
      'categorie': c.field('categorie'),
      'estSigne': false,
      'signatureMetadata': {'validation': 'EN_ATTENTE', 'deposePar': c.uid},
      'createdAt': _now,
      'aSigner': false,
      'validation': 'EN_ATTENTE',
    };
    await _put('/children/$childId/documents', _list('/children/$childId/documents')..insert(0, doc));
    await _schedule({'type': 'document', 'childId': childId, 'documentId': doc['id']}, const Duration(seconds: 30));
    return LocalResponse.json(doc, status: 201);
  }

  Future<void> _validateDocument(String childId, String id) async {
    final list = _list('/children/$childId/documents');
    final doc = list.where((d) => d['id'] == id).firstOrNull as Map<String, dynamic>?;
    if (doc == null || doc['validation'] != 'EN_ATTENTE') return;
    doc['validation'] = 'VALIDE';
    (doc['signatureMetadata'] as Map<String, dynamic>)['validation'] = 'VALIDE';
    await _put('/children/$childId/documents', list);
    await _notify(_stakeholders(childId), 'MESSAGERIE', 'Pièce validée', 'La pièce « ${doc['titre']} » a été validée par la scolarité.', {'type': 'DOCUMENT_REVIEWED', 'documentId': id});
  }

  Future<LocalResponse> _createRequest(_Call c) async {
    final childId = c.field('studentId');
    _assertChild(c, childId);
    final type = c.field('type');
    final label = _requestLabels[type];
    if (label == null) throw const _ApiError(400, 'VALIDATION', 'Type de demande inconnu');
    final path = '/children/$childId/requests';
    final requests = _list(path);
    if (requests.any((r) => r['type'] == type && (r['statut'] == 'SOUMISE' || r['statut'] == 'EN_TRAITEMENT'))) {
      throw const _ApiError(400, 'ALREADY_PENDING', 'Une demande identique est déjà en cours');
    }
    final now = _now;
    final request = {
      'id': _id(),
      'studentId': childId,
      'type': type,
      'motif': c.body['motif'],
      'statut': 'SOUMISE',
      'documentGenereUrl': null,
      'traiteParId': null,
      'createdAt': now,
      'updatedAt': now,
      'libelle': label,
      'documentDisponible': false,
    };
    await _put(path, requests..insert(0, request));
    await _schedule({'type': 'request', 'childId': childId, 'requestId': request['id']}, const Duration(seconds: 30));
    return LocalResponse.json(request, status: 201);
  }

  Future<void> _processRequest(String childId, String id) async {
    final path = '/children/$childId/requests';
    final requests = _list(path);
    final request = requests.where((r) => r['id'] == id).firstOrNull as Map<String, dynamic>?;
    if (request == null || request['statut'] != 'SOUMISE') return;
    final ready = _generatedRequests.contains(request['type']);
    request
      ..['statut'] = ready ? 'PRETE' : 'EN_TRAITEMENT'
      ..['documentDisponible'] = ready
      ..['documentGenereUrl'] = ready ? 'local' : null
      ..['updatedAt'] = _now;
    await _put(path, requests);
    await _notify(
      _stakeholders(childId),
      'MESSAGERIE',
      ready ? 'Document prêt' : 'Demande en traitement',
      ready ? '${request['libelle']} : le document est disponible dans l’application.' : '${request['libelle']} : votre demande est en cours de traitement.',
      {'type': 'DOCUMENT_REQUEST', 'requestId': id},
    );
  }

  Future<LocalResponse> _requestDocument(_Call c) async {
    final (childId, _, request) = _findInChildren(c, 'requests', c.params[0], 'Demande introuvable');
    if (request['documentDisponible'] != true) throw const _ApiError(404, 'NOT_FOUND', 'Document non disponible');
    final child = _children(c.uid).firstWhere((ch) => ch['id'] == childId);
    final group = child['group'] as Map<String, dynamic>? ?? const {};
    final program = group['program'] as Map<String, dynamic>? ?? const {};
    final year = (_list('/children/$childId/invoices').firstOrNull?['academicYear'] as Map?)?['libelle'] ?? '';
    final scolarise = request['type'] == 'CERTIFICAT_SCOLARITE' ? 'scolarisé(e)' : 'inscrit(e)';
    return LocalResponse.bytes(await DemoPdf.build(
      title: '${request['libelle']}',
      reference: 'Délivré le ${_date(request['updatedAt'] as String)}',
      paragraphs: [
        'Le Directeur des études de l’Académie Franco-Américaine de Management (AFRAM) certifie que ${child['prenom']} ${'${child['nom']}'.toUpperCase()}, '
            'né(e) le ${_date(child['dateNaissance'] as String)}, matricule ${child['matricule']}, est régulièrement $scolarise au titre de l’année académique $year '
            'en ${program['nom'] ?? ''}, groupe ${group['nom'] ?? ''}.',
        if ('${request['motif'] ?? ''}'.isNotEmpty) 'Motif de la demande : ${request['motif']}.',
        'Fait à Libreville, pour servir et valoir ce que de droit.',
      ],
    ));
  }

  Future<LocalResponse> _acknowledge(_Call c) async {
    final (childId, list, record) = _findInChildren(c, 'discipline', c.params[0], 'Fiche introuvable');
    record
      ..['accuseReception'] = true
      ..['accuseReceptionLe'] = _now;
    await _put('/children/$childId/discipline', list);
    return LocalResponse.json(record, status: 201);
  }

  // ------------------------------------------------------------------ Notifications

  static const _notificationsPath = '/notifications?take=200';

  List<dynamic> _notificationItems(String uid) => ((_get(_notificationsPath, uid: uid) as Map?)?['items'] as List?) ?? [];

  LocalResponse _notifications(_Call c) {
    final categorie = c.query['categorie'];
    final items = _notificationItems(c.uid).where((n) => categorie == null || n['categorie'] == categorie).toList();
    return LocalResponse.json(_page(items, c.query));
  }

  LocalResponse _unreadCount(_Call c) => LocalResponse.json({'count': _notificationItems(c.uid).where((n) => n['estLu'] != true).length});

  Future<LocalResponse> _markRead(_Call c) async {
    final items = _notificationItems(c.uid);
    final n = items.where((x) => x['id'] == c.params[0]).firstOrNull as Map<String, dynamic>?;
    if (n == null) throw const _ApiError(404, 'NOT_FOUND', 'Notification introuvable');
    n
      ..['estLu'] = true
      ..['luLe'] = _now;
    await _put(_notificationsPath, {'items': items, 'nextCursor': null}, uid: c.uid);
    return LocalResponse.json(n);
  }

  Future<LocalResponse> _markAllRead(_Call c) async {
    final items = _notificationItems(c.uid);
    final unread = items.where((n) => n['estLu'] != true).toList();
    for (final n in unread) {
      n
        ..['estLu'] = true
        ..['luLe'] = _now;
    }
    await _put(_notificationsPath, {'items': items, 'nextCursor': null}, uid: c.uid);
    return LocalResponse.json({'success': true, 'count': unread.length}, status: 201);
  }

  Future<LocalResponse> _savePreferences(_Call c) async {
    final items = [
      for (final p in (c.body['items'] as List? ?? const []))
        {'categorie': p['categorie'], 'push': p['push'] ?? true, 'sms': p['sms'] ?? false, 'email': p['email'] ?? false},
    ];
    await _put('/notification-preferences', items, uid: c.uid);
    return LocalResponse.json(items);
  }
}

/// Branche Dio sur le serveur simulé : aucune requête ne sort de l'appareil.
class LocalHttpAdapter implements HttpClientAdapter {
  final LocalBackend backend;
  LocalHttpAdapter(this.backend);

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final body = <String, dynamic>{};
    final files = <LocalFile>[];
    final data = options.data;
    if (data is FormData) {
      for (final f in data.fields) {
        body[f.key] = f.value;
      }
      for (final f in data.files) {
        files.add(LocalFile(f.key, f.value.filename, f.value.contentType?.mimeType, f.value.length));
      }
    } else if (data is Map) {
      body.addAll(data.cast<String, dynamic>());
    } else if (data is String && data.isNotEmpty) {
      final decoded = jsonDecode(data);
      if (decoded is Map) body.addAll(decoded.cast<String, dynamic>());
    }
    var path = options.uri.path;
    if (path.startsWith(ApiEndpoints.v)) path = path.substring(ApiEndpoints.v.length);

    final res = await backend.handle(LocalRequest(
      method: options.method.toUpperCase(),
      path: path,
      query: options.uri.queryParameters,
      body: body,
      files: files,
      headers: {for (final e in options.headers.entries) e.key.toLowerCase(): '${e.value}'},
    ));
    if (res.bytes != null) {
      return ResponseBody.fromBytes(res.bytes!, res.status, headers: {Headers.contentTypeHeader: ['application/pdf']});
    }
    if (res.text != null) {
      return ResponseBody.fromString(res.text!, res.status, headers: {Headers.contentTypeHeader: ['text/calendar; charset=utf-8']});
    }
    return ResponseBody.fromString(jsonEncode(res.json), res.status, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
  }

  @override
  void close({bool force = false}) {}
}
