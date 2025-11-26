import '../domain/player.dart';
import '../domain/player_repository.dart';
import 'players_api_client.dart';

/// Concrete implementation of PlayerRepository using the API client
class PlayerRepositoryImpl implements PlayerRepository {
  final PlayersApiClient _apiClient;

  PlayerRepositoryImpl({required PlayersApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Player?> getPlayerById(int id) {
    return _apiClient.getPlayerById(id);
  }

  @override
  Future<List<Player>> searchPlayers(PlayerFilters filters) {
    return _apiClient.searchPlayers(filters);
  }

  @override
  Future<List<Player>> getActivePlayers() {
    return _apiClient.getActivePlayers();
  }
}
