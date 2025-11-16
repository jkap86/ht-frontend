import '../domain/league.dart';
import 'leagues_api_client.dart';

/// Repository layer for leagues
/// Wraps the API client and could add caching, error handling, etc.
class LeaguesRepository {
  final LeaguesApiClient _apiClient;

  LeaguesRepository({LeaguesApiClient? apiClient})
      : _apiClient = apiClient ?? LeaguesApiClient();

  Future<List<League>> getMyLeagues() async {
    try {
      return await _apiClient.getMyLeagues();
    } catch (e) {
      rethrow;
    }
  }

  Future<League> getLeague(int leagueId) async {
    try {
      return await _apiClient.getLeague(leagueId);
    } catch (e) {
      rethrow;
    }
  }

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
      return await _apiClient.createLeague(
        name: name,
        season: season,
        totalRosters: totalRosters,
        settings: settings,
        scoringSettings: scoringSettings,
        rosterPositions: rosterPositions,
        seasonType: seasonType,
      );
    } catch (e) {
      rethrow;
    }
  }
}
