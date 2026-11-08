import 'package:OApp/core/constants/app_keys.dart';
import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/models/verification_model.dart';
import 'package:OApp/services/global_service.dart';
import 'package:OApp/services/secure_storage_service.dart';
import 'package:get/get.dart';

class AuthRequestResult {
  final bool isSuccess;
  final String? errorMessage;

  const AuthRequestResult({required this.isSuccess, this.errorMessage});
}

/// Handles phone-auth API calls and session persistence.
class AuthRepository {
  AuthRepository({
    NetworkManager? api,
    SecureStorageService? secureStorage,
    GlobalService? globalService,
  })  : _api = api ?? NetworkManager(),
        _secureStorage = secureStorage ?? Get.find<SecureStorageService>(),
        _globalService = globalService ?? Get.find<GlobalService>();

  final NetworkManager _api;
  final SecureStorageService _secureStorage;
  final GlobalService _globalService;

  static String toE164(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return '+$digits';
  }

  Future<String?> getReferralCode() async {
    final code = await _secureStorage.getKey(AppKeys.referralCode);
    if (code == null || code.isEmpty) return null;
    return code;
  }

  Future<VerificationModel?> verifySignUpOtp({
    required String phoneNumber,
    required String otp,
    String? referralCode,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.verifyUser,
      body: {
        'phoneNumber': toE164(phoneNumber),
        'otp': otp,
        if (referralCode != null && referralCode.isNotEmpty)
          'referralCode': referralCode,
      },
      requiresAuth: false,
    );

    if (response?.statusCode != 200 || response?.data is! Map<String, dynamic>) {
      return null;
    }

    return VerificationModel.fromJson(
      response!.data as Map<String, dynamic>,
    );
  }

  Future<AuthRequestResult> requestSignUpOtp(String phoneNumber) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.verifyPhone,
      body: {'phoneNumber': toE164(phoneNumber)},
      requiresAuth: false,
    );

    return AuthRequestResult(
      isSuccess: response?.statusCode == 200,
      errorMessage: errorMessageFromResponse(response?.data),
    );
  }

  Future<AuthRequestResult> requestSignInOtp(String phoneNumber) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.signIn,
      body: {'phoneNumber': toE164(phoneNumber)},
      requiresAuth: false,
    );

    return AuthRequestResult(
      isSuccess: response?.statusCode == 200,
      errorMessage: errorMessageFromResponse(response?.data),
    );
  }

  Future<VerificationModel?> loginWithKeys({
    required String facebookKey,
    required String googleKey,
    required String appleKey,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.loginWithKeys,
      body: {
        'facebookkey': facebookKey,
        'googlekey': googleKey,
        'applekey': appleKey,
      },
    );

    if (response?.statusCode != 200 || response?.data is! Map<String, dynamic>) {
      return null;
    }

    return VerificationModel.fromJson(response!.data as Map<String, dynamic>);
  }

  Future<bool> updateLoginMethods({
    required String phoneNumber,
    required String facebookKey,
    required String googleKey,
    required String appleKey,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Put,
      urlEndPoint: EndPoints.updateLoginMethods,
      body: {
        'phoneNumber': phoneNumber,
        'facebookkey': facebookKey,
        'googlekey': googleKey,
        'applekey': appleKey,
      },
    );

    return response?.statusCode == 200;
  }

  Future<bool> resendSignUpCode(String phoneNumber) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.verifyPhone,
      body: {'phoneNumber': toE164(phoneNumber)},
      requiresAuth: false,
    );

    if (response?.statusCode != 200 || response?.data is! Map<String, dynamic>) {
      return false;
    }

    final data = response!.data as Map<String, dynamic>;
    final userId = data['userId'] as String?;
    final token = data['token'] as String?;

    if (userId != null) {
      await _secureStorage.setKey(AppKeys.userID, userId);
      _globalService.setUserId(userId);
    }
    if (token != null) {
      await _secureStorage.setKey(AppKeys.authToken, token);
    }

    return true;
  }

  Future<VerificationModel?> verifySignInOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.verifySignIn,
      body: {
        'phoneNumber': toE164(phoneNumber),
        'otp': otp,
      },
      requiresAuth: false,
    );

    if (response?.statusCode != 200 || response?.data is! Map<String, dynamic>) {
      return null;
    }

    return VerificationModel.fromJson(
      response!.data as Map<String, dynamic>,
    );
  }

  Future<bool> resendSignInCode(String phoneNumber) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.signIn,
      body: {'phoneNumber': toE164(phoneNumber)},
      requiresAuth: false,
    );

    return response?.statusCode == 200;
  }

  Future<void> saveSession(
    VerificationModel data, {
    bool clearReferral = false,
  }) async {
    await _secureStorage.setKey(AppKeys.authToken, data.token);
    await _secureStorage.setKey(AppKeys.userID, data.userId);
    _globalService.setUserId(data.userId);

    if (clearReferral) {
      await _secureStorage.deleteKey(AppKeys.referralCode);
    }
  }

  String? errorMessageFromResponse(dynamic responseData) {
    if (responseData is Map && responseData['message'] != null) {
      return responseData['message'].toString();
    }
    return null;
  }
}
