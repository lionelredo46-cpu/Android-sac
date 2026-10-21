import 'package:dio/dio.dart';
import '../../errors/error_handler.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Normalisation de l'erreur via ErrorHandler
    final appException = ErrorHandler.fromDioError(err);
    
    // Attacher l'exception métier à l'erreur Dio pour récupération dans les repositories
    final customDioError = err.copyWith(
      error: appException,
      message: appException.message,
    );

    return handler.next(customDioError);
  }
}
