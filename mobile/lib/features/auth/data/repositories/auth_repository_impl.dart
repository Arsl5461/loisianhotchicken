import '../../../../core/constants/api_paths.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/json.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<LoginResult> login({required String email, required String password}) async {
    final envelope = await _client.post(ApiPaths.login, data: {'email': email, 'password': password});
    final map = asMap(envelope.data);
    if (asBool(map['requiresOtp'])) {
      return LoginOtpResult(
        OtpChallenge(
          challengeId: asString(map['challengeId']),
          email: asString(map['email']).isEmpty ? email : asString(map['email']),
        ),
      );
    }
    return LoginSessionResult(_sessionFrom(map));
  }

  @override
  Future<AuthSession> verifyOtp({
    required String email,
    required String challengeId,
    required String code,
  }) async {
    final envelope = await _client.post(
      ApiPaths.verifyOtp,
      data: {'email': email, 'challengeId': challengeId, 'code': code},
    );
    return _sessionFrom(envelope.data);
  }

  @override
  Future<OtpChallenge> resendOtp({
    required String email,
    required String challengeId,
  }) async {
    final envelope = await _client.post(
      ApiPaths.resendOtp,
      data: {'email': email, 'challengeId': challengeId},
    );
    final map = asMap(envelope.data);
    return OtpChallenge(
      challengeId: asString(map['challengeId']),
      email: asString(map['email']).isEmpty ? email : asString(map['email']),
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _client.post(ApiPaths.forgotPassword, data: {'email': email});
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _client.post(
      ApiPaths.resetPassword,
      data: {'email': email, 'code': code, 'newPassword': newPassword},
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.patch(
      ApiPaths.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  @override
  Future<AuthUser> currentUser() async {
    final envelope = await _client.get(ApiPaths.me);
    return AuthUser.fromJson(asMap(envelope.data));
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    final envelope = await _client.post(ApiPaths.refresh, data: {'refreshToken': refreshToken});
    return _sessionFrom(envelope.data);
  }

  @override
  Future<void> logout() async {
    try {
      await _client.post(ApiPaths.logout);
    } on Failure {
      // Local session is still cleared by the notifier.
    }
  }

  AuthSession _sessionFrom(dynamic data) {
    final map = asMap(data);
    final access = asString(map['accessToken']);
    final refresh = asString(map['refreshToken']);
    if (access.isEmpty) {
      throw const UnauthorizedFailure('Login did not return an access token.');
    }
    return AuthSession(
      user: AuthUser.fromJson(asMap(map['user'])),
      accessToken: access,
      refreshToken: refresh,
    );
  }
}
