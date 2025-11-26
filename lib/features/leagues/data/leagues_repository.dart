import '../domain/league.dart';
import '../dues_payouts/domain/league_member.dart';
import '../domain/repositories/leagues_repository_interface.dart';
import 'leagues_api_client.dart';

/// Repository implementation for leagues
/// Wraps the API client and handles DTO/Domain conversion
class LeaguesRepository implements ILeaguesRepository {
  final LeaguesApiClient _apiClient;

  LeaguesRepository({
    required LeaguesApiClient apiClient,
  }) : _apiClient = apiClient;

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
    int? totalRosters,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    Map<String, dynamic>? rosterPositions,
  }) async {
    try {
      final dto = await _apiClient.updateLeague(
        id: id,
        name: name,
        description: description,
        totalRosters: totalRosters,
        settings: settings,
        scoringSettings: scoringSettings,
        rosterPositions: rosterPositions,
      );
      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetLeague(int id) async {
    try {
      await _apiClient.resetLeague(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteLeague(int id) async {
    try {
      await _apiClient.deleteLeague(id);
    } catch (e) {
      rethrow;
    }
  }

  /// Developer endpoint to add users to league by username
  @override
  Future<List<Map<String, dynamic>>> devAddUsersToLeague(
    int leagueId,
    List<String> usernames,
  ) async {
    try {
      return await _apiClient.devAddUsersToLeague(leagueId, usernames);
    } catch (e) {
      rethrow;
    }
  }

  /// Legacy method for backward compatibility - will be removed
  @Deprecated('Use getLeagueById instead')
  Future<League> getLeague(int leagueId) async {
    return getLeagueById(leagueId);
  }

  /// Get league members with payment status
  @override
  Future<List<LeagueMember>> getLeagueMembers(int leagueId) async {
    try {
      final data = await _apiClient.getLeagueMembers(leagueId);
      return data.map((json) => LeagueMember(
        rosterId: json['rosterId'] as int,
        userId: json['userId'] as String,
        username: json['username'] as String,
        paid: json['paid'] as bool,
      )).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle member payment status
  @override
  Future<void> toggleMemberPayment(int leagueId, int rosterId, bool paid) async {
    try {
      await _apiClient.toggleMemberPayment(leagueId, rosterId, paid);
    } catch (e) {
      rethrow;
    }
  }
}
