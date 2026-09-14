import 'package:dio/dio.dart';

import '../errors/failures.dart';
import '../utils/json.dart';

class ApiEnvelope {
  const ApiEnvelope({
    required this.success,
    required this.message,
    this.data,
    this.meta,
    this.errors = const [],
  });

  final bool success;
  final String message;
  final dynamic data;
  final Map<String, dynamic>? meta;
  final List<String> errors;

  factory ApiEnvelope.fromJson(dynamic json) {
    final map = asMap(json);
    final rawErrors = map['errors'];
    final errors = <String>[];
    if (rawErrors is List) {
      for (final item in rawErrors) {
        if (item is Map) {
          errors.add(asString(item['message']));
        } else {
          errors.add(asString(item));
        }
      }
    }
    return ApiEnvelope(
      success: asBool(map['success'], fallback: true),
      message: asString(map['message']),
      data: map['data'],
      meta: map['meta'] is Map ? Map<String, dynamic>.from(map['meta'] as Map) : null,
      errors: errors.where((item) => item.isNotEmpty).toList(),
    );
  }
}

Failure mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final envelope = _envelopeFrom(error.response?.data);
      final status = error.response?.statusCode;
      final message = envelope?.message.isNotEmpty == true
          ? envelope!.message
          : 'Request failed (${status ?? 'unknown'})';
      switch (status) {
        case 400:
        case 409:
        case 422:
          return ValidationFailure(message, errors: envelope?.errors ?? const []);
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          return ForbiddenFailure(message);
        case 404:
          return NotFoundFailure(message);
        default:
          return ServerFailure(message, status);
      }
    case DioExceptionType.cancel:
      return const UnexpectedFailure('Request cancelled.');
    case DioExceptionType.badCertificate:
      return const ServerFailure('Secure connection failed.');
    case DioExceptionType.unknown:
    case DioExceptionType.transformTimeout:
      return const NetworkFailure();
  }
}

ApiEnvelope? _envelopeFrom(dynamic data) {
  if (data is Map) {
    return ApiEnvelope.fromJson(data);
  }
  return null;
}
