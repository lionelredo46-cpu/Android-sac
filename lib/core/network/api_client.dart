import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../errors/app_exception.dart';
import '../errors/error_handler.dart';

/// Façade typée au-dessus de Dio : toutes les erreurs ressortent en [AppException].
class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) =>
      _wrap(() => _dio.get<T>(path, queryParameters: _clean(query)));

  Future<T> post<T>(String path, {Object? data, Map<String, String>? headers}) =>
      _wrap(() => _dio.post<T>(path, data: data, options: Options(headers: headers)));

  Future<T> put<T>(String path, {Object? data}) => _wrap(() => _dio.put<T>(path, data: data));

  Future<T> patch<T>(String path, {Object? data}) => _wrap(() => _dio.patch<T>(path, data: data));

  Future<T> delete<T>(String path) => _wrap(() => _dio.delete<T>(path));

  /// Envoi multipart (justificatifs, pièces jointes, documents).
  Future<T> upload<T>(String path, {required Map<String, dynamic> fields, String fileField = 'fichier', MultipartFile? file}) {
    final form = FormData.fromMap({...fields, if (file != null) fileField: file});
    return _wrap(() => _dio.post<T>(path, data: form));
  }

  /// Téléchargement binaire authentifié (PDF de reçus, bulletins, attestations).
  Future<Uint8List> bytes(String path, {Map<String, dynamic>? query}) async {
    final data = await _wrap<List<int>>(
      () => _dio.get<List<int>>(path, queryParameters: _clean(query), options: Options(responseType: ResponseType.bytes)),
    );
    return Uint8List.fromList(data);
  }

  Future<String> text(String path) =>
      _wrap<String>(() => _dio.get<String>(path, options: Options(responseType: ResponseType.plain)));

  Future<T> _wrap<T>(Future<Response<T>> Function() call) async {
    try {
      final res = await call();
      return res.data as T;
    } on DioException catch (e) {
      throw ErrorHandler.fromDioError(e);
    } on AppException {
      rethrow;
    }
  }

  static Map<String, dynamic>? _clean(Map<String, dynamic>? q) =>
      q == null ? null : (Map.of(q)..removeWhere((_, v) => v == null || v == ''));
}
