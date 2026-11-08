import 'package:dio/dio.dart';

import '../../core/network/dio_exception_mapper.dart';
import '../../core/network/exceptions.dart';

/// Shared helpers for repository response parsing and error mapping.
abstract class RepositoryBase {
  T? parseResponse<T>(
    Response? response,
    T Function(dynamic data) parser, {
    Set<int> successCodes = const {200, 201, 204},
  }) {
    if (response == null) return null;
    if (!successCodes.contains(response.statusCode)) return null;
    return parser(response.data);
  }

  Never throwFromDio(DioException error) {
    throw mapDioException(error);
  }

  AppException mapFailure(Object error) {
    if (error is AppException) return error;
    if (error is DioException) return mapDioException(error);
    return AppException(error.toString(), details: error);
  }
}
