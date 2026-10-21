/// Erreur métier normalisée. `code` reprend le code renvoyé par l'API
/// (ex. INVALID_CREDENTIALS, OTP_EXPIRED, IDEMPOTENCY_CONFLICT…).
class AppException implements Exception {
  final String message;
  final String code;
  final int? statusCode;
  final dynamic details;

  const AppException({
    required this.message,
    this.code = 'ERROR',
    this.statusCode,
    this.details,
  });

  bool get isNetwork => code == 'NETWORK_ERROR';
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'AppException($code, $statusCode): $message';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Connexion impossible. Vérifiez votre accès Internet.',
  }) : super(code: 'NETWORK_ERROR');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Votre session a expiré. Veuillez vous reconnecter.',
    super.code = 'UNAUTHORIZED',
  }) : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = "Vous n'avez pas les droits nécessaires pour cette action.",
    super.code = 'FORBIDDEN',
  }) : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Élément introuvable.',
    super.code = 'NOT_FOUND',
  }) : super(statusCode: 404);
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Le service est momentanément indisponible. Réessayez dans quelques instants.',
    super.code = 'SERVER_ERROR',
    super.statusCode = 500,
  });
}
