import '../domain/league.dart';
import '../domain/repositories/leagues_repository_interface.dart';
import 'leagues_api_client.dart';

/// Repository implementation for leagues
/// Wraps the API client and handles DTO/Domain conversion
class LeaguesRepository implements ILeaguesRepository {
  final LeaguesApiClient _apiClient;

  LeaguesRepository({LeaguesApiClient? apiClient})
      : _apiClient = apiClient ?? LeaguesApiClient();

  @override
  Future<List<League>> getMyLeagues() async {
    try {
      final dtos = await _apiClient.getMyLeagues();
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<League> getLeagueById(int id) async {
    try {
      final dto = await _apiClient.getLeague(id);
      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<League> createLeague({
    required String name,
    required String season,
    required int totalRosters,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> scoringSettings,
    required Map<String, int> rosterPositions,
    required String seasonType,
  }) async {
    try {
      final dto = await _apiClient.createLeague(
        name: name,
        season: season,
        totalRosters: totalRosters,
        settings: settings,
        scoringSettings: scoringSettings,
        rosterPositions: rosterPositions,
        seasonType: seasonType,
      );
      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<League> updateLeague({
    required int id,
    String? name,
    String? description,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    Map<String, dynamic>? rosterPositions,
  }) async {
    try {
      final dto = await _apiClient.updateLeague(
        id: id,
        name: name,
        description: description,
        settings: settings,
        scoringSettings: scoringSettings,
        rosterPositions: rosterPositions,
      );
      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  /// Legacy method for backward compatibility - will be removed
  @Deprecated('Use getLeagueById instead')
  Future<League> getLeague(int leagueId) async {
    return getLeagueById(leagueId);
  }
}
