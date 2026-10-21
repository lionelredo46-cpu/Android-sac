import 'package:dio/dio.dart';

import '../config/flavor_config.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required SecureStorageService storageService,
    required void Function() onSessionExpired,
    Dio? customDio,
    HttpClientAdapter? adapter,
  }) {
    final config = FlavorConfig.instance;
    dio = customDio ??
        Dio(
          BaseOptions(
            baseUrl: config.apiBaseUrl,
            connectTimeout: config.connectTimeout,
            receiveTimeout: config.receiveTimeout,
            headers: {'Accept': 'application/json', 'Accept-Language': 'fr'},
          ),
        );
    if (adapter != null) dio.httpClientAdapter = adapter;

    // Ordre : relance réseau → authentification → normalisation des erreurs → logs.
    dio.interceptors.addAll([
      RetryInterceptor(dio: dio),
      AuthInterceptor(storageService, dio, onSessionExpired: onSessionExpired),
      ErrorInterceptor(),
      if (config.enableLogging) LogInterceptor(requestBody: false, responseBody: false),
    ]);
  }
}
