import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../stores/presentation/providers/store_selection_provider.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_providers.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future<void>.microtask(restoreSession);
    return const AuthState.unknown();
  }

  TokenStorage get _tokens => ref.read(tokenStorageProvider);
  LoginUseCase get _login => ref.read(loginUseCaseProvider);
  VerifyOtpUseCase get _verifyOtp => ref.read(verifyOtpUseCaseProvider);
  ResendOtpUseCase get _resendOtp => ref.read(resendOtpUseCaseProvider);
  LogoutUseCase get _logout => ref.read(logoutUseCaseProvider);
  GetCurrentUserUseCase get _me => ref.read(getCurrentUserUseCaseProvider);
  RefreshSessionUseCase get _refresh => ref.read(refreshSessionUseCaseProvider);

  Future<void> restoreSession() async {
    final access = await _tokens.readAccessToken();
    final refresh = await _tokens.readRefreshToken();
    if ((access == null || access.isEmpty) && (refresh == null || refresh.isEmpty)) {
      state = const AuthState.unauthenticated();
      return;
    }
    try {
      final user = await _me();
      _hydrateStore(user);
      state = AuthState.authenticated(user);
    } on Failure {
      if (refresh == null || refresh.isEmpty) {
        await _tokens.clear();
        state = const AuthState.unauthenticated();
        return;
      }
      try {
        final session = await _refresh(refresh);
        await _tokens.saveTokens(
          accessToken: session.accessToken,
          refreshToken: session.refreshToken.isEmpty ? refresh : session.refreshToken,
        );
        _hydrateStore(session.user);
        state = AuthState.authenticated(session.user);
      } on Failure catch (error) {
        await _tokens.clear();
        state = AuthState.unauthenticated(error: error.message);
      }
    }
  }

  /// Returns true when authenticated. Returns false if OTP is required or login failed.
  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(busy: true, clearError: true, clearOtp: true);
    try {
      final result = await _login(email: email, password: password);
      switch (result) {
        case LoginSessionResult(:final session):
          await _tokens.saveTokens(accessToken: session.accessToken, refreshToken: session.refreshToken);
          _hydrateStore(session.user);
          state = AuthState.authenticated(session.user);
          return true;
        case LoginOtpResult(:final challenge):
          state = AuthState.unauthenticated(otpChallenge: challenge).copyWith(busy: false);
          return false;
      }
    } on Failure catch (error) {
      state = AuthState.unauthenticated(error: error.message).copyWith(busy: false);
      return false;
    } catch (_) {
      state = const AuthState.unauthenticated(error: 'Unable to sign in.').copyWith(busy: false);
      return false;
    }
  }

  Future<bool> verifyOtp({required String code}) async {
    final challenge = state.otpChallenge;
    if (challenge == null) {
      state = const AuthState.unauthenticated(error: 'No verification challenge in progress.');
      return false;
    }
    state = state.copyWith(busy: true, clearError: true);
    try {
      final session = await _verifyOtp(
        email: challenge.email,
        challengeId: challenge.challengeId,
        code: code,
      );
      await _tokens.saveTokens(accessToken: session.accessToken, refreshToken: session.refreshToken);
      _hydrateStore(session.user);
      state = AuthState.authenticated(session.user);
      return true;
    } on Failure catch (error) {
      state = state.copyWith(busy: false, error: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(busy: false, error: 'Invalid or expired code.');
      return false;
    }
  }

  Future<bool> resendOtp() async {
    final challenge = state.otpChallenge;
    if (challenge == null) return false;
    state = state.copyWith(busy: true, clearError: true);
    try {
      final next = await _resendOtp(email: challenge.email, challengeId: challenge.challengeId);
      state = AuthState.unauthenticated(otpChallenge: next).copyWith(busy: false);
      return true;
    } on Failure catch (error) {
      state = state.copyWith(busy: false, error: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(busy: false, error: 'Unable to resend code.');
      return false;
    }
  }

  void clearOtpChallenge() {
    state = const AuthState.unauthenticated();
  }

  Future<void> logout() async {
    try {
      await _logout();
    } finally {
      await _tokens.clear();
      ref.read(selectedStoreIdProvider.notifier).state = null;
      await ref.read(sessionStorageProvider).saveStoreId(null);
      state = const AuthState.unauthenticated();
    }
  }

  void markExpired() {
    state = const AuthState.unauthenticated(error: 'Your session has expired. Please sign in again.');
  }

  void _hydrateStore(AuthUser user) {
    final stored = ref.read(sessionStorageProvider).readStoreId();
    final allowed = user.stores.map((store) => store.id).toSet();
    String? next;
    if (stored != null && (user.isSuperAdmin || allowed.contains(stored))) {
      next = stored;
    } else {
      next = user.defaultStore ?? (user.stores.isNotEmpty ? user.stores.first.id : null);
    }
    ref.read(selectedStoreIdProvider.notifier).state = next;
    ref.read(sessionStorageProvider).saveStoreId(next);
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final currentUserProvider = Provider<AuthUser?>((ref) => ref.watch(authNotifierProvider).user);

final permissionCheckerProvider = Provider<bool Function(String)>((ref) {
  final user = ref.watch(currentUserProvider);
  return (permission) => user?.can(permission) ?? false;
});
