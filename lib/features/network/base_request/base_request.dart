import 'package:dio/dio.dart';
import 'package:tagbasics/features/error_handler/error_ui_handler.dart';

enum RequestMethod { get, post, put, delete, patch }

class BaseRequest {
  BaseRequest._();

  static void setApiBaseUrl(String apiUrl) {
    _apiUrl = apiUrl;
  }

  static void setAuthorization(String token) {
    _authToken = token;
  }

  static final Dio _dio = Dio();
  static final BaseRequest instance = BaseRequest._();
  static const ErrorLevel _errorLevel = ErrorLevel.baseRequest;
  static String? _apiUrl;
  static String? _authToken;

  static bool get isInitialized => _apiUrl != null;
  static String? get apiUrl => _apiUrl;
  static String? get authToken => _authToken;

  static Future<Response> baseRequest<T>(
    String url, {
    required RequestMethod method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    bool multipart = false,
    bool conAuth = true,
    bool apiPrefix = true,
  }) async {
    try {
      final dioOptions = Options(
        headers: await _parseHeaders(headers, multipart, auth: conAuth),
      );

      late final Response respuesta;
      final String urlFull = "$apiUrl/${apiPrefix ? "api/" : ""}$url";
      switch (method) {
        case RequestMethod.get:
          respuesta = await _dio.get(
            urlFull,
            data: multipart && body != null ? FormData.fromMap(body) : body,
            options: dioOptions,
          );
          break;
        case RequestMethod.post:
          respuesta = await _dio.post(
            urlFull,
            data: multipart && body != null ? FormData.fromMap(body) : body,
            options: dioOptions,
          );
          break;

        case RequestMethod.put:
          respuesta = await _dio.put(
            urlFull,
            data: multipart && body != null ? FormData.fromMap(body) : body,
            options: dioOptions,
          );
          break;

        case RequestMethod.delete:
          respuesta = await _dio.delete(
            urlFull,
            data: multipart && body != null ? FormData.fromMap(body) : body,
            options: dioOptions,
          );
          break;

        case RequestMethod.patch:
          respuesta = await _dio.patch(
            urlFull,
            data: multipart && body != null ? FormData.fromMap(body) : body,
            options: dioOptions,
          );
          break;
      }

      return respuesta;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> _parseHeaders(
    Map<String, dynamic>? headers,
    bool multipart, {
    bool auth = true,
  }) async {
    final Map<String, String> defaultHeaders = {
      "accept": "application/json",
      "content-type": multipart ? "multipart/form-data" : "application/json",
    };

    if (headers != null) {
      for (var header in headers.entries) {
        defaultHeaders[header.key] = header.value;
      }
    }
    if (auth) {
      defaultHeaders["Authorization"] = "Bearer $authToken";
    }
    return defaultHeaders;
  }
}

class CustomException implements Exception {
  CustomException({required this.cause, this.rawError});
  final Object? rawError;
  String cause;

  @override
  String toString() {
    return cause;
  }
}
