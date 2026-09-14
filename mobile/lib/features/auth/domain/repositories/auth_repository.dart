import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthSession> login({required String email, required String password});
  Future<AuthUser> currentUser();
  Future<AuthSession> refresh(String refreshToken);
  Future<void> logout();
}
