import '../../domain/entities/auth_user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.error,
    this.busy = false,
    this.otpChallenge,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.unauthenticated({String? error, OtpChallenge? otpChallenge})
      : this(status: AuthStatus.unauthenticated, error: error, otpChallenge: otpChallenge);
  const AuthState.authenticated(AuthUser user) : this(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final AuthUser? user;
  final String? error;
  final bool busy;
  final OtpChallenge? otpChallenge;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get requiresOtp => otpChallenge != null;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
    bool? busy,
    OtpChallenge? otpChallenge,
    bool clearError = false,
    bool clearUser = false,
    bool clearOtp = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      error: clearError ? null : error ?? this.error,
      busy: busy ?? this.busy,
      otpChallenge: clearOtp ? null : otpChallenge ?? this.otpChallenge,
    );
  }
}
