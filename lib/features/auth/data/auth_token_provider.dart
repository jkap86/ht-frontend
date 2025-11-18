import '../../../core/services/socket/token_provider.dart';
import 'auth_storage.dart';

/// Token provider implementation that reads from AuthStorage.
///
/// This lives in the auth feature and is injected into SocketService
/// so that core does not depend on features.
class AuthTokenProvider implements TokenProvider {
  final AuthStorage _storage;

  AuthTokenProvider(this._storage);

  @override
  Future<String?> readToken() => _storage.readToken();
}
