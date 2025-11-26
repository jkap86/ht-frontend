// lib/features/auth/application/auth_state.dart
import '../domain/user.dart';

/// Overall authentication status for the app
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

/// Immutable auth state using domain models
class AuthState {
  final AuthStatus status;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.status,
    this.user,
    this.isLoading = false,
    this.error,
  });

  const AuthState.initial() : this(status: AuthStatus.unknown);

  /// Convenience getter for backwards compatibility
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Convenience getter for backwards compatibility
  String? get username => user?.username;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
