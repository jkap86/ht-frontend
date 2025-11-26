import 'user.dart';

/// Domain model for authentication result
class AuthResult {
  final User user;
  final String token;
  final String refreshToken;

  const AuthResult({
    required this.user,
    required this.token,
    required this.refreshToken,
  });
}
