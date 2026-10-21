import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uniparent/core/demo/local_backend.dart';
import 'package:uniparent/core/demo/local_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  late LocalDatabase db;
  late LocalBackend api;

  setUpAll(() => initializeDateFormatting('fr_FR'));

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('uniparent_demo');
    Hive.init(dir.path);
    db = await LocalDatabase.open();
    api = LocalBackend(db);
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  Future<LocalResponse> call(String method, String path, {String? token, Map<String, dynamic> body = const {}, Map<String, String> query = const {}, Map<String, String> headers = const {}}) =>
      api.handle(LocalRequest(method: method, path: path, body: body, query: query, headers: {...headers, if (token != null) 'authorization': 'Bearer $token'}));

  Future<String> login(String identifier) async {
    final r = await call('POST', '/auth/login', body: {'identifier': identifier, 'password': 'Afram2026!'});
    expect(r.status, 201);
    return (r.json! as Map)['accessToken'] as String;
  }

  /// Rend immédiatement exécutables les traitements « back-office » programmés.
  Future<void> fastForward() async {
    final events = (db.read('events') as List?) ?? [];
    await db.write('events', [for (final e in events) {...e as Map, 'at': DateTime(2000).toIso8601String()}]);
  }

  test('connexion : identifiants, téléphone et refus', () async {
    await login('parent@aframgabon.com');
    await login('066701184');
    final bad = await call('POST', '/auth/login', body: {'identifier': 'parent@aframgabon.com', 'password': 'faux'});
    expect(bad.status, 401);
    expect((bad.json! as Map)['code'], 'INVALID_CREDENTIALS');
    expect((await call('GET', '/me')).status, 401);
  });

  test('anti-IDOR : un camarade ne voit pas le dossier d’Alexandre', () async {
    final parent = await login('parent@aframgabon.com');
    final children = (await call('GET', '/me/children', token: parent)).json! as List;
    expect(children, hasLength(2));
    final alex = children.firstWhere((c) => c['prenom'] == 'Alexandre')['id'];
    final lucie = await login('etudiant1@etudiant.afram.ga');
    expect((await call('GET', '/children/$alex/dashboard', token: lucie)).status, 403);
  });

  test('paiement : facture, tableau de bord, reçu PDF et notifications', () async {
    final parent = await login('parent@aframgabon.com');
    final children = (await call('GET', '/me/children', token: parent)).json! as List;
    final alex = children.firstWhere((c) => c['prenom'] == 'Alexandre')['id'];
    final before = ((await call('GET', '/children/$alex/dashboard', token: parent)).json! as Map)['finances'] as Map;
    final invoices = (await call('GET', '/children/$alex/invoices', token: parent)).json! as List;
    final invoice = invoices.firstWhere((i) => (i['soldeRestant'] as int) > 0);
    final soldeAvant = invoice['soldeRestant'] as int;
    final unreadBefore = ((await call('GET', '/notifications/unread-count', token: parent)).json! as Map)['count'] as int;

    final intent = (await call('POST', '/payments/initiate',
            token: parent,
            body: {'invoiceId': invoice['id'], 'montant': 10000, 'canal': 'ONLINE_MOBILE_MONEY', 'provider': 'SANDBOX'},
            headers: {'idempotency-key': 'test-0123456789abcdef'}))
        .json! as Map;
    expect(intent['statut'], 'EN_ATTENTE');

    await fastForward();
    final status = (await call('GET', '/payments/${intent['paymentId']}/status', token: parent)).json! as Map;
    expect(status['statut'], 'VALIDE');
    final receipt = await call('GET', '/receipts/${(status['receipt'] as Map)['id']}/pdf', token: parent);
    expect(String.fromCharCodes(receipt.bytes!.take(4)), '%PDF');

    final after = ((await call('GET', '/children/$alex/dashboard', token: parent)).json! as Map)['finances'] as Map;
    expect(after['totalPaye'], (before['totalPaye'] as int) + 10000);
    expect(after['resteAPayer'], (before['resteAPayer'] as int) - 10000);
    final detail = (await call('GET', '/invoices/${invoice['id']}', token: parent)).json! as Map;
    expect(detail['soldeRestant'], soldeAvant - 10000);
    expect(((await call('GET', '/notifications/unread-count', token: parent)).json! as Map)['count'], unreadBefore + 1);

    // L'étudiant suit le même dossier : il voit le versement mais ne peut pas payer.
    final student = await login('alexandre.obiang@etudiant.afram.ga');
    final payments = (await call('GET', '/children/$alex/payments', token: student)).json! as List;
    expect(payments.first['reference'], status['reference']);
    final denied = await call('POST', '/payments/initiate',
        token: student, body: {'invoiceId': invoice['id'], 'montant': 1000, 'canal': 'ONLINE_CARD'}, headers: {'idempotency-key': 'test-fedcba9876543210'});
    expect(denied.status, 403);
  });

  test('emploi du temps toujours rempli, même loin de la semaine exportée', () async {
    final student = await login('alexandre.obiang@etudiant.afram.ga');
    final alex = ((await call('GET', '/me/children', token: student)).json! as List).first['id'];
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1)).add(const Duration(days: 7 * 20));
    final week = (await call('GET', '/children/$alex/timetable',
            token: student, query: {'from': monday.toUtc().toIso8601String(), 'to': monday.add(const Duration(days: 7)).toUtc().toIso8601String()}))
        .json! as Map;
    expect(week['creneaux'], isNotEmpty);
    expect((week['creneaux'] as List).every((s) => s['statut'] == 'PLANIFIE'), isTrue);
  });

  test('activation du compte de Clarisse puis messagerie avec réponse du service', () async {
    expect((await call('POST', '/auth/login', body: {'identifier': '+241066112233', 'password': 'Afram2026!'})).status, 403);
    final start = (await call('POST', '/auth/activate/start', body: {'activationCode': 'AFRAM-2026-ACTIVATE'})).json! as Map;
    expect(start['prenom'], 'Clarisse');
    final session = await call('POST', '/auth/activate', body: {'activationCode': 'AFRAM-2026-ACTIVATE', 'otpCode': start['devCode'], 'newPassword': 'Nouveau2026!'});
    expect(session.status, 201);
    final token = (session.json! as Map)['accessToken'] as String;

    final created = (await call('POST', '/conversations', token: token, body: {'sujet': 'Bourse', 'service': 'FINANCES', 'message': 'Bonjour'})).json! as Map;
    await fastForward();
    final detail = (await call('GET', '/conversations/${created['id']}/messages', token: token)).json! as Map;
    expect(detail['messages'], hasLength(2));
    expect((detail['messages'] as List).last['auteur'], 'Service Comptabilité');
    expect(detail['statut'], 'EN_COURS');
  });
}
