import '../../domain/entities/auth_user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.error,
    this.busy = false,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.unauthenticated({String? error})
      : this(status: AuthStatus.unauthenticated, error: error);
  const AuthState.authenticated(AuthUser user) : this(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final AuthUser? user;
  final String? error;
  final bool busy;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
    bool? busy,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      error: clearError ? null : error ?? this.error,
      busy: busy ?? this.busy,
    );
  }
}
