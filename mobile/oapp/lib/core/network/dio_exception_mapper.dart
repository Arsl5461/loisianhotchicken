import 'package:dio/dio.dart';

import 'exceptions.dart';

AppException mapDioException(DioException error) {
  final statusCode = error.response?.statusCode;
  final data = error.response?.data;
  final backendMessage = _extractBackendMessage(data);

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return TimeoutException(
        backendMessage ?? 'Request timed out. Please try again.',
        code: statusCode?.toString(),
        details: error,
      );
    case DioExceptionType.connectionError:
      return NetworkException(
        backendMessage ?? 'Network connection failed.',
        code: statusCode?.toString(),
        details: error,
      );
    case DioExceptionType.cancel:
      return AppException('Request cancelled.', details: error);
    case DioExceptionType.badResponse:
      return _mapStatusCode(statusCode, backendMessage, error);
    case DioExceptionType.badCertificate:
      return NetworkException(
        'Secure connection failed.',
        code: statusCode?.toString(),
        details: error,
      );
    case DioExceptionType.unknown:
      return AppException(
        backendMessage ?? error.message ?? 'Unexpected network error.',
        code: statusCode?.toString(),
        details: error,
      );
  }
}

AppException _mapStatusCode(
  int? statusCode,
  String? message,
  DioException error,
) {
  final fallback = message ?? 'Request failed.';
  final code = statusCode?.toString();

  switch (statusCode) {
    case 400:
      return ValidationException(fallback, code: code, details: error);
    case 401:
    case 403:
      return UnauthorizedException(fallback, code: code, details: error);
    case 404:
      return NotFoundException(fallback, code: code, details: error);
    case 409:
      return ConflictException(fallback, code: code, details: error);
    default:
      if (statusCode != null && statusCode >= 500) {
        return ServerException(fallback, code: code, details: error);
      }
      return AppException(fallback, code: code, details: error);
  }
}

String? _extractBackendMessage(dynamic data) {
  if (data is Map && data['message'] != null) {
    return data['message'].toString();
  }
  return null;
}
