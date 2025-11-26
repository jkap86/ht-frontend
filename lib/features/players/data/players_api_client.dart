import 'dart:convert';

import '../../../features/auth/data/auth_storage.dart';
import '../../../core/infrastructure/api_client.dart';
import '../domain/player.dart';
import '../domain/player_repository.dart';

/// API client for player-related endpoints
class PlayersApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  PlayersApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Get a player by ID
  Future<Player?> getPlayerById(int id) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/players/$id',
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Player.fromJson(json);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get player: ${response.statusCode} - ${response.body}');
    }
  }

  /// Search players with filters
  Future<List<Player>> searchPlayers(PlayerFilters filters) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/players/search',
      token: token,
      queryParameters: filters.toQueryParams(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Player.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to search players: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get all active players
  Future<List<Player>> getActivePlayers() async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/players',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Player.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get active players: ${response.statusCode} - ${response.body}');
    }
  }
}
