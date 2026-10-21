import 'dart:io';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.retryInterval = const Duration(milliseconds: 800),
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final currentRetry = (extra['retryCount'] as int?) ?? 0;

    final shouldRetry = _isRetryable(err) && currentRetry < maxRetries;

    if (shouldRetry) {
      final nextRetry = currentRetry + 1;
      err.requestOptions.extra['retryCount'] = nextRetry;

      // Attente exponentielle
      final delay = retryInterval * nextRetry;
      await Future.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryError) {
        return handler.next(retryError);
      }
    }

    return handler.next(err);
  }

  bool _isRetryable(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.error is SocketException);
  }
}
