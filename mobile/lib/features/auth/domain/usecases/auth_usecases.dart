import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<LoginResult> call({required String email, required String password}) {
    return _repository.login(email: email.trim(), password: password);
  }
}

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<AuthSession> call({
    required String email,
    required String challengeId,
    required String code,
  }) {
    return _repository.verifyOtp(email: email.trim(), challengeId: challengeId, code: code.trim());
  }
}

class ResendOtpUseCase {
  const ResendOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<OtpChallenge> call({required String email, required String challengeId}) {
    return _repository.resendOtp(email: email.trim(), challengeId: challengeId);
  }
}

class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call({required String email}) => _repository.forgotPassword(email: email.trim());
}

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _repository.resetPassword(
      email: email.trim(),
      code: code.trim(),
      newPassword: newPassword,
    );
  }
}

class ChangePasswordUseCase {
  const ChangePasswordUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call({required String currentPassword, required String newPassword}) {
    return _repository.changePassword(currentPassword: currentPassword, newPassword: newPassword);
  }
}

class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AuthRepository _repository;
  Future<void> call() => _repository.logout();
}

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);
  final AuthRepository _repository;
  Future<AuthUser> call() => _repository.currentUser();
}

class RefreshSessionUseCase {
  const RefreshSessionUseCase(this._repository);
  final AuthRepository _repository;
  Future<AuthSession> call(String refreshToken) => _repository.refresh(refreshToken);
}
