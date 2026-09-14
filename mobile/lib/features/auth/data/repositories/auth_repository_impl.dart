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
  Future<AuthSession> login({required String email, required String password}) async {
    final envelope = await _client.post(ApiPaths.login, data: {'email': email, 'password': password});
    return _sessionFrom(envelope.data);
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
