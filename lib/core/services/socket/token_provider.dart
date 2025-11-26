/// Abstraction for anything that can provide an auth token
/// for WebSocket connections.
///
/// Core should depend on this instead of concrete AuthStorage.
abstract class TokenProvider {
  /// Returns the current auth token, or null if not logged in.
  Future<String?> readToken();
}
