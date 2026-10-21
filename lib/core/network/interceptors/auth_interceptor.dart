import 'dart:async';

import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';
import '../api_endpoints.dart';

/// Injecte le jeton d'accès et gère son renouvellement (refresh rotatif).
/// QueuedInterceptor : les requêtes concurrentes attendent le même refresh,
/// le refresh token n'est donc jamais utilisé deux fois (sinon le serveur
/// détecterait une réutilisation et révoquerait la session).
class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService _storage;
  final Dio _dio;
  final void Function() onSessionExpired;

  AuthInterceptor(this._storage, this._dio, {required this.onSessionExpired});

  static const _publicAuthPaths = [
    '/auth/login',
    '/auth/otp/',
    '/auth/activate',
    '/auth/refresh',
    '/auth/forgot-password',
    '/auth/reset-password',
  ];

  static bool _isPublic(RequestOptions o) =>
      o.extra['isPublic'] == true || _publicAuthPaths.any(o.path.contains);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isPublic(options)) {
      final token = await _storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 || _isPublic(options) || options.extra['retried'] == true) {
      return handler.next(err);
    }

    final sentToken = (options.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
    final currentToken = await _storage.getAccessToken();

    // Un autre appel a déjà renouvelé le jeton pendant l'attente : on rejoue.
    if (currentToken != null && currentToken.isNotEmpty && currentToken != sentToken) {
      await _retry(options, currentToken, handler, err);
      return;
    }

    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _expire();
      return handler.next(err);
    }

    try {
      final res = await _dio.post(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'isPublic': true}),
      );
      final access = res.data['accessToken'] as String;
      final refresh = res.data['refreshToken'] as String;
      await _storage.saveTokens(accessToken: access, refreshToken: refresh);
      await _retry(options, access, handler, err);
      return;
    } on DioException {
      await _expire();
      return handler.next(err);
    }
  }

  Future<void> _retry(RequestOptions options, String token, ErrorInterceptorHandler handler, DioException original) async {
    options.headers['Authorization'] = 'Bearer $token';
    options.extra['retried'] = true;
    try {
      handler.resolve(await _dio.fetch(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<void> _expire() async {
    await _storage.clearAuth();
    onSessionExpired();
  }
}
