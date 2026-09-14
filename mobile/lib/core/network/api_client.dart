import 'package:dio/dio.dart';

import '../constants/api_paths.dart';
import '../constants/app_config.dart';
import '../errors/failures.dart';
import '../storage/token_storage.dart';
import '../utils/json.dart';
import 'api_envelope.dart';

typedef StoreIdReader = String? Function();
typedef SessionExpiredCallback = Future<void> Function();

class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    required StoreIdReader storeIdReader,
    required SessionExpiredCallback onSessionExpired,
    Dio? dio,
  })  : _tokenStorage = tokenStorage,
        _storeIdReader = storeIdReader,
        _onSessionExpired = onSessionExpired,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.apiBaseUrl,
                connectTimeout: const Duration(seconds: 20),
                receiveTimeout: const Duration(seconds: 20),
                sendTimeout: const Duration(seconds: 20),
                headers: const {'Accept': 'application/json'},
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          final storeId = _storeIdReader();
          if (storeId != null && storeId.isNotEmpty) {
            options.headers['X-Store-Id'] = storeId;
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          final path = error.requestOptions.path;
          final isAuthCall = path.contains(ApiPaths.login) || path.contains(ApiPaths.refresh);
          if (status != 401 || isAuthCall || error.requestOptions.extra['retried'] == true) {
            handler.next(error);
            return;
          }
          try {
            await _refreshTokens();
            final token = await _tokenStorage.readAccessToken();
            final request = error.requestOptions;
            request.extra['retried'] = true;
            if (token != null) {
              request.headers['Authorization'] = 'Bearer $token';
            }
            final response = await _dio.fetch(request);
            handler.resolve(response);
          } catch (_) {
            await _tokenStorage.clear();
            await _onSessionExpired();
            handler.next(error);
          }
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final StoreIdReader _storeIdReader;
  final SessionExpiredCallback _onSessionExpired;
  Future<void>? _refreshing;

  Future<ApiEnvelope> get(
    String path, {
    Map<String, dynamic>? query,
  }) {
    return _send(() => _dio.get<dynamic>(path, queryParameters: _clean(query)));
  }

  Future<ApiEnvelope> post(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
  }) {
    return _send(() => _dio.post<dynamic>(path, data: data, queryParameters: _clean(query)));
  }

  Future<ApiEnvelope> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
  }) {
    return _send(() => _dio.patch<dynamic>(path, data: data, queryParameters: _clean(query)));
  }

  Future<ApiEnvelope> delete(String path, {Object? data}) {
    return _send(() => _dio.delete<dynamic>(path, data: data));
  }

  Future<ApiEnvelope> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return ApiEnvelope.fromJson(response.data);
    } on DioException catch (error) {
      throw mapDioError(error);
    } catch (error) {
      if (error is Failure) rethrow;
      throw UnexpectedFailure(error.toString());
    }
  }

  Future<void> _refreshTokens() {
    return _refreshing ??= () async {
      try {
        final refreshToken = await _tokenStorage.readRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          throw const UnauthorizedFailure();
        }
        final response = await _dio.post<dynamic>(
          ApiPaths.refresh,
          data: {'refreshToken': refreshToken},
          options: Options(extra: {'retried': true}),
        );
        final envelope = ApiEnvelope.fromJson(response.data);
        final data = asMap(envelope.data);
        final access = asString(data['accessToken']);
        final nextRefresh = asString(data['refreshToken']);
        if (access.isEmpty) {
          throw const UnauthorizedFailure();
        }
        await _tokenStorage.saveTokens(
          accessToken: access,
          refreshToken: nextRefresh.isEmpty ? refreshToken : nextRefresh,
        );
      } finally {
        _refreshing = null;
      }
    }();
  }

  Map<String, dynamic>? _clean(Map<String, dynamic>? query) {
    if (query == null) return null;
    final next = Map<String, dynamic>.from(query)..removeWhere((key, value) => value == null || value == '');
    return next.isEmpty ? null : next;
  }
}
