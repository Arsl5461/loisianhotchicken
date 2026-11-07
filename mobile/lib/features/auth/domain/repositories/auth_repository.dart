import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<LoginResult> login({required String email, required String password});
  Future<AuthSession> verifyOtp({
    required String email,
    required String challengeId,
    required String code,
  });
  Future<OtpChallenge> resendOtp({
    required String email,
    required String challengeId,
  });
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<AuthUser> currentUser();
  Future<AuthSession> refresh(String refreshToken);
  Future<void> logout();
}
