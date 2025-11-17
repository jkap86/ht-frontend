import '../user.dart';
import '../auth_result.dart';

/// Abstract interface for authentication repository
/// Defines contract for auth operations without implementation details
abstract class IAuthRepository {
  /// Register a new user
  Future<AuthResult> register(String username, String password);

  /// Login with username and password
  Future<AuthResult> login(String username, String password);

  /// Get current authenticated user
  Future<User> getCurrentUser();

  /// Refresh the access token
  Future<AuthResult> refreshAccessToken();

  /// Logout user
  Future<void> logout();

  /// Search for users by username
  Future<List<User>> searchUsers(String query);
}
