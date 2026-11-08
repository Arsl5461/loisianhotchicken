// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:OApp/core/constants/app_keys.dart';
import 'package:OApp/core/network/dio_exception_mapper.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/core/network/exceptions.dart';
import 'package:OApp/services/secure_storage_service.dart';
import 'package:OApp/services/session_service.dart';
import 'package:OApp/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as getAlias;
import 'package:get/get.dart' hide Response, FormData;

// ignore: constant_identifier_names
enum HttpMethod { Get, Post, Put, Patch, Delete }

class NetworkManager {
  static final NetworkManager _singleton = NetworkManager._internal();
  final SecureStorageService secureStorage = Get.find<SecureStorageService>();

  factory NetworkManager() {
    return _singleton;
  }

  NetworkManager._internal() {
    setDioOptions();
    _addErrorInterceptor();
  }

  Dio dio = Dio();
  bool _interceptorsAttached = false;

  void setDioOptions() {
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.contentType = Headers.jsonContentType;
  }

  // Add error interceptor to handle 401/403 globally
  void _addErrorInterceptor() {
    if (_interceptorsAttached) return;
    _interceptorsAttached = true;

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Check for 401 or 403 status codes
          if (error.response?.statusCode == 401 ||
              error.response?.statusCode == 403) {
            final requestPath = error.requestOptions.path;
            final isLoginEndpoint =
                requestPath.contains('auth/admin/token') ||
                requestPath.contains('auth/reset-password');

            if (!isLoginEndpoint) {
              // Handle unauthorized error silently - no toaster
              _handleUnauthorized(error.response).then((_) {
                handler.reject(error);
              });
              return;
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  // Method to handle logout when unauthorized - silently without toaster
  Future<void> _handleUnauthorized(dynamic errorResponse) async {
    try {
      if (getAlias.Get.isRegistered<SessionService>()) {
        await getAlias.Get.find<SessionService>().invalidateSession();
        return;
      }
      getAlias.Get.closeAllSnackbars();
    } catch (e) {
      debugPrint('Error during unauthorized handling: $e');
    }
  }

  Future<Response?> callApi({
    required HttpMethod method,
    required String? urlEndPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool requiresAuth = true,
    bool returnRawResponse = false,
    ProgressCallback? onSendProgress,
    bool debugNeeded = false,
  }) async {
    setDioOptions();
    // DioLoggerService.attachLoggerInterceptor(dio);

    String requestURL = EndPoints.baseUrl + urlEndPoint!;
    debugPrint("Request URL: $requestURL");
    // Default headers
    Map<String, dynamic> headers = {'Accept': 'application/json'};

    if (body is! FormData) {
      headers['Content-Type'] = 'application/json';
    }

    // Add token to headers if authentication is required
    if (requiresAuth) {
      String? token = await secureStorage.getKey(AppKeys.authToken);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    if (debugNeeded) {
      debugPrint("➡️ [${method.name}] $requestURL");
      debugPrint("Headers: $headers}");
      if (queryParameters != null) {
        debugPrint("Query: $queryParameters");
      }
      if (body != null) {
        debugPrint("Body: $body");
      }
    }
    if (returnRawResponse) {
      dio.options.validateStatus = (status) {
        return status != null; // accept all responses
      };
    }
    dio.options.headers = headers;

    Response? response;
    try {
      switch (method) {
        case HttpMethod.Get:
          response = await dio.get(
            requestURL,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.Post:
          response = await dio.post(
            requestURL,
            queryParameters: queryParameters,
            data: body,
            onSendProgress: onSendProgress,
          );
          break;
        case HttpMethod.Put:
          response = await dio.put(
            requestURL,
            queryParameters: queryParameters,
            data: body,
            onSendProgress: onSendProgress,
          );
          break;
        case HttpMethod.Patch:
          response = await dio.patch(
            requestURL,
            queryParameters: queryParameters,
            data: body,
            onSendProgress: onSendProgress,
          );
          break;
        case HttpMethod.Delete:
          response = await dio.delete(requestURL, data: body);
          break;
      }
      if (debugNeeded) {
        debugPrint("✅ Response (${response.statusCode}): ${response.data}");
      }
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204 ||
          returnRawResponse) {
        return response;
      }
    } on DioException catch (errorResponse) {
      final appException = mapDioException(errorResponse);
      final data = errorResponse.response?.data;

      if (appException is! UnauthorizedException &&
          data != null &&
          data is Map &&
          data.containsKey('message')) {
        showError(data['message'].toString());
      }
      // Check for SSL Pinning/TLS Handshake failures
      final isSslFailure =
          errorResponse.type == DioExceptionType.connectionError &&
          (errorResponse.message?.contains('Handshake') == true ||
              errorResponse.message?.contains('CERTIFICATE_VERIFY_FAILED') ==
                  true ||
              errorResponse.error is TlsException ||
              errorResponse.error is HandshakeException);

      if (isSslFailure) {
        // Toaster.showErrorToast(
        //   'SSL Pinning or TLS Handshake failed. Please check your network or contact support.',
        // );
      }

      if (errorResponse.response?.statusCode == 401 ||
          errorResponse.response?.statusCode == 403) {
        // Don't logout for login/reset-password endpoints (wrong credentials is normal)
        final requestPath = errorResponse.requestOptions.path;
        final isLoginEndpoint =
            requestPath.contains('auth/admin/token') ||
            requestPath.contains('auth/reset-password');

        if (!isLoginEndpoint) {
          // Handle unauthorized error - logout user
          await _handleUnauthorized(errorResponse.response);
          return null;
        }
        // For login endpoints, return the error response normally
      }

      return errorResponse.response;
    } catch (e) {
      // Handle any other errors
      debugPrint('Network error: $e');

      // Check for SSL failures in generic errors too (sometimes they pop up here)
      if (e is TlsException ||
          e is HandshakeException ||
          e.toString().contains('HandshakeException')) {
        // Toaster.showErrorToast(
        //   'SSL Pinning or TLS Handshake failed. Please check your network or contact support.',
        // );
      }

      return null;
    }
    return response;
  }

  /// Throws a typed [AppException] for callers that prefer exceptions over null.
  Future<Response> callApiOrThrow({
    required HttpMethod method,
    required String? urlEndPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool requiresAuth = true,
    bool returnRawResponse = false,
    ProgressCallback? onSendProgress,
    bool debugNeeded = false,
  }) async {
    final response = await callApi(
      method: method,
      urlEndPoint: urlEndPoint,
      queryParameters: queryParameters,
      body: body,
      requiresAuth: requiresAuth,
      returnRawResponse: returnRawResponse,
      onSendProgress: onSendProgress,
      debugNeeded: debugNeeded,
    );

    if (response == null) {
      throw NetworkException('No response received from server.');
    }

    final status = response.statusCode ?? 0;
    if (status == 401 || status == 403) {
      throw UnauthorizedException(
        'Session expired. Please sign in again.',
        code: status.toString(),
      );
    }

    if (status >= 400) {
      final message = response.data is Map
          ? response.data['message']?.toString()
          : null;
      throw ServerException(
        message ?? 'Request failed with status $status.',
        code: status.toString(),
        details: response.data,
      );
    }

    return response;
  }

  // Method to check if user is still authenticated.
  // Reads from secure storage, the single source of truth for the auth token.
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.getKey(AppKeys.authToken);
    return token != null && token.isNotEmpty;
  }
}

void showError(String message) {
  if (message.trim().isEmpty) return;
  // Avoid stacking duplicate snackbars when several requests fail together.
  getAlias.Get.closeAllSnackbars();
  Toast.error(message);
}
