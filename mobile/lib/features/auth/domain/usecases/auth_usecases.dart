import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<AuthSession> call({required String email, required String password}) {
    return _repository.login(email: email.trim(), password: password);
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
