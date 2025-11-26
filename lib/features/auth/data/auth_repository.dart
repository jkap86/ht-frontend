import '../domain/repositories/auth_repository_interface.dart';
import '../domain/user.dart';
import '../domain/auth_result.dart';
import 'auth_api_client.dart';
import 'auth_storage.dart';

/// Repository implementation for authentication
/// Handles DTO/Domain conversion and token management
class AuthRepository implements IAuthRepository {
  final AuthApiClient _apiClient;
  final AuthStorage _storage;

  AuthRepository({
    required AuthApiClient apiClient,
    required AuthStorage storage,
  })  : _storage = storage,
        _apiClient = apiClient;

  @override
  Future<AuthResult> register(String username, String password) async {
    final dto = await _apiClient.register(username, password);

    // Save tokens
    await _storage.saveToken(dto.token);
    if (dto.refreshToken != null && dto.refreshToken!.isNotEmpty) {
      await _storage.saveRefreshToken(dto.refreshToken!);
    }

    return dto.toDomain();
  }

  @override
  Future<AuthResult> login(String username, String password) async {
    final dto = await _apiClient.login(username, password);

    // Save tokens
    await _storage.saveToken(dto.token);
    if (dto.refreshToken != null && dto.refreshToken!.isNotEmpty) {
      await _storage.saveRefreshToken(dto.refreshToken!);
    }

    return dto.toDomain();
  }

  @override
  Future<User> getCurrentUser() async {
    final dto = await _apiClient.me();
    return dto.toDomain();
  }

  @override
  Future<AuthResult> refreshAccessToken() async {
    final dto = await _apiClient.refreshAccessToken();

    // Save new tokens
    await _storage.saveToken(dto.token);
    if (dto.refreshToken != null && dto.refreshToken!.isNotEmpty) {
      await _storage.saveRefreshToken(dto.refreshToken!);
    }

    return dto.toDomain();
  }

  @override
  Future<void> logout() async {
    await _storage.clearAll();
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    final dtos = await _apiClient.searchUsers(query);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
