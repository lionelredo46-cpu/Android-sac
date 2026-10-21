import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uniparent/core/errors/app_exception.dart';
import 'package:uniparent/core/errors/error_handler.dart';
import 'package:uniparent/core/storage/cache_store.dart';
import 'package:uniparent/core/utils/formatters.dart';
import 'package:uniparent/features/auth/presentation/auth_scaffold.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    Intl.defaultLocale = 'fr_FR';
  });

  group('Fmt', () {
    test('formate les montants entiers en FCFA sans décimales', () {
      expect(Fmt.money(1085000), '1 085 000 FCFA');
      expect(Fmt.money(0), '0 FCFA');
      expect(Fmt.money(250, 'EUR'), '250 EUR');
    });

    test('formate les notes et pourcentages', () {
      expect(Fmt.grade(14.5), '14,5 / 20');
      expect(Fmt.grade(16, 20), '16 / 20');
      expect(Fmt.percent(null), '—');
      expect(Fmt.percent(91.3), '91,3 %');
    });
  });

  group('normalizePhone', () {
    test('ajoute l’indicatif du Gabon et supprime les espaces', () {
      expect(normalizePhone('06 67 01 18 4'), '+241066701184');
      expect(normalizePhone('0066 123 456 78'), '+6612345678');
      expect(normalizePhone('+241 066 70 11 84'), '+241066701184');
    });

    test('valide le format international', () {
      expect(phoneRegex.hasMatch(normalizePhone('066701184')), isTrue);
      expect(phoneRegex.hasMatch('abc'), isFalse);
    });

    test('politique de mot de passe identique au serveur', () {
      expect(passwordRegex.hasMatch('Afram2026'), isTrue);
      expect(passwordRegex.hasMatch('afram2026'), isFalse);
      expect(passwordRegex.hasMatch('Court1'), isFalse);
    });
  });

  group('ErrorHandler', () {
    DioException bad(int status, Map<String, dynamic> body) => DioException(
          requestOptions: RequestOptions(path: '/x'),
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: RequestOptions(path: '/x'), statusCode: status, data: body),
        );

    test('reprend le code et le message normalisés de l’API', () {
      final e = ErrorHandler.fromDioError(bad(401, {'code': 'INVALID_CREDENTIALS', 'message': 'Identifiants incorrects'}));
      expect(e, isA<UnauthorizedException>());
      expect(e.code, 'INVALID_CREDENTIALS');
      expect(e.message, 'Identifiants incorrects');
    });

    test('mappe les erreurs réseau et serveur', () {
      expect(ErrorHandler.fromDioError(DioException(requestOptions: RequestOptions(path: '/'), type: DioExceptionType.connectionError)).isNetwork, isTrue);
      expect(ErrorHandler.fromDioError(bad(503, {})), isA<ServerException>());
      expect(ErrorHandler.fromDioError(bad(429, {})).code, 'TOO_MANY_REQUESTS');
      expect(ErrorHandler.fromDioError(bad(400, {'message': ['a', 'b']})).message, 'a\nb');
    });
  });

  group('CacheStore (mode hors ligne)', () {
    late CacheStore cache;
    setUpAll(() async => cache = await CacheStore.openAt((await Directory.systemTemp.createTemp('cache')).path));

    test('réseau OK : renvoie et mémorise la donnée', () async {
      final r = await cache.fetch('k', () async => {'v': 1}, (j) => (j! as Map)['v'] as int);
      expect(r.data, 1);
      expect(r.fromCache, isFalse);
    });

    test('réseau coupé : renvoie le dernier état connu', () async {
      final r = await cache.fetch<int>('k', () async => throw const NetworkException(), (j) => (j! as Map)['v'] as int);
      expect(r.data, 1);
      expect(r.fromCache, isTrue);
    });

    test('erreur métier : ne masque pas l’erreur par le cache', () async {
      expect(
        () => cache.fetch<int>('k', () async => throw const ForbiddenException(), (j) => 0),
        throwsA(isA<ForbiddenException>()),
      );
    });

    test('réseau coupé sans cache : propage l’erreur', () async {
      expect(() => cache.fetch<int>('absent', () async => throw const NetworkException(), (j) => 0), throwsA(isA<NetworkException>()));
    });
  });
}
