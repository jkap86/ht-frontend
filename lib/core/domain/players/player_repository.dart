import 'player.dart';

/// Filter parameters for player searches
class PlayerFilters {
  final String? position;
  final String? team;
  final String? search;
  final bool? active;
  final int? limit;
  final int? offset;

  const PlayerFilters({
    this.position,
    this.team,
    this.search,
    this.active,
    this.limit,
    this.offset,
  });

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (position != null) params['position'] = position!;
    if (team != null) params['team'] = team!;
    if (search != null) params['search'] = search!;
    if (active != null) params['active'] = active.toString();
    if (limit != null) params['limit'] = limit.toString();
    if (offset != null) params['offset'] = offset.toString();
    return params;
  }
}

/// Repository interface for player data access
abstract class PlayerRepository {
  /// Get a player by ID
  Future<Player?> getPlayerById(int id);

  /// Search players with filters
  Future<List<Player>> searchPlayers(PlayerFilters filters);

  /// Get all active players
  Future<List<Player>> getActivePlayers();
}
