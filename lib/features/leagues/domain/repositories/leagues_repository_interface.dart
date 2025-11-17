import '../league.dart';

/// Abstract interface for leagues repository
/// Defines contract for data operations without implementation details
abstract class ILeaguesRepository {
  /// Fetch all leagues for the current user
  Future<List<League>> getMyLeagues();

  /// Fetch a specific league by ID
  Future<League> getLeagueById(int id);

  /// Create a new league
  Future<League> createLeague({
    required String name,
    required String season,
    required int totalRosters,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> scoringSettings,
    required Map<String, int> rosterPositions,
    required String seasonType,
  });

  /// Update an existing league
  Future<League> updateLeague({
    required int id,
    String? name,
    String? description,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    Map<String, dynamic>? rosterPositions,
  });

  /// Reset league - clears rosters, drafts, and matchups but preserves settings
  Future<void> resetLeague(int id);

  /// Delete league permanently
  Future<void> deleteLeague(int id);
}
