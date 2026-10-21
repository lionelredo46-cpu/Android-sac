import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Convertit une erreur Dio en [AppException] à partir du format d'erreur
  /// normalisé de l'API : `{ statusCode, code, message, details? }`.
  static AppException fromDioError(DioException e) {
    if (e.error is AppException) return e.error as AppException;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.cancel:
        return const AppException(message: 'Requête annulée.', code: 'CANCELLED');
      case DioExceptionType.badCertificate:
        return const AppException(message: 'Connexion non sécurisée refusée.', code: 'BAD_CERTIFICATE');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final data = e.response?.data;
        String? message;
        String? code;
        dynamic details;
        if (data is Map) {
          final m = data['message'];
          message = m is List ? m.join('\n') : m?.toString();
          code = data['code']?.toString();
          details = data['details'];
        }
        switch (status) {
          case 401:
            return UnauthorizedException(message: message ?? const UnauthorizedException().message, code: code ?? 'UNAUTHORIZED');
          case 403:
            return ForbiddenException(message: message ?? const ForbiddenException().message, code: code ?? 'FORBIDDEN');
          case 404:
            return NotFoundException(message: message ?? const NotFoundException().message, code: code ?? 'NOT_FOUND');
          case 429:
            return AppException(message: message ?? 'Trop de tentatives. Patientez une minute.', code: code ?? 'TOO_MANY_REQUESTS', statusCode: 429);
          default:
            if (status != null && status >= 500) return const ServerException();
            return AppException(message: message ?? 'Requête invalide.', code: code ?? 'BAD_REQUEST', statusCode: status, details: details);
        }
      case DioExceptionType.unknown:
        return const NetworkException();
    }
  }

  static String message(Object error) =>
      error is AppException ? error.message : 'Une erreur inattendue est survenue. Veuillez réessayer.';
}
