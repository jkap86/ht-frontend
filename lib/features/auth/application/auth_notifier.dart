// lib/features/auth/application/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

/// Overall authentication status for the app.
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

/// Immutable auth state consumed by the UI.
class AuthState {
  final AuthStatus status;
  final String? username;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.status,
    this.username,
    this.isLoading = false,
    this.error,
  });

  const AuthState.initial() : this(status: AuthStatus.unknown);

  AuthState copyWith({
    AuthStatus? status,
    String? username,
    bool? isLoading,
    String? error, // pass null explicitly to clear
  }) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier that coordinates API calls + token storage via [AuthRepository].
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState.initial());

  void _setState(AuthState newState) {
    state = newState;
  }

  Future<void> register(String username, String password) async {
    _setState(state.copyWith(isLoading: true, error: null));

    try {
      final json = await _repo.register(username.trim(), password);
      final user = json['user'] as Map<String, dynamic>?;

      _setState(
        state.copyWith(
          status: AuthStatus.authenticated,
          username: user?['username'] as String?,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      _setState(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> login(String username, String password) async {
    _setState(state.copyWith(isLoading: true, error: null));

    try {
      final json = await _repo.login(username.trim(), password);
      final user = json['user'] as Map<String, dynamic>?;

      _setState(
        state.copyWith(
          status: AuthStatus.authenticated,
          username: user?['username'] as String?,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      _setState(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Check auth on app start: read token (inside repo), hit /me, update state.
  Future<void> checkAuth() async {
    _setState(state.copyWith(isLoading: true, error: null));

    try {
      final json = await _repo.me();
      final user = json['user'] as Map<String, dynamic>?;

      _setState(
        state.copyWith(
          status: AuthStatus.authenticated,
          username: user?['username'] as String?,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      // If /me fails, clear token and mark unauthenticated.
      await _repo.logout();
      _setState(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Backwards-compatible alias – if other code calls restoreSession(),
  /// it will just perform the same logic as [checkAuth].
  Future<void> restoreSession() async {
    await checkAuth();
  }

  Future<void> logout() async {
    await _repo.logout();
    _setState(
      const AuthState(
        status: AuthStatus.unauthenticated,
        username: null,
        isLoading: false,
        error: null,
      ),
    );
  }
}

/// Global provider for [AuthNotifier] and [AuthState].
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = AuthRepository();
  return AuthNotifier(repo);
});
