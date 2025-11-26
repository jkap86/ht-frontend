import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../../drafts/domain/draft.dart';
import '../domain/matchup_draft_pick.dart';
import '../domain/available_matchup.dart';

/// API client for matchup draft room (runtime) operations
class MatchupDraftRoomApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  MatchupDraftRoomApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Start matchup draft
  Future<Draft> startMatchupDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/start',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to start matchup draft: ${response.statusCode}');
    }
  }

  /// Pause matchup draft
  Future<Draft> pauseMatchupDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/pause',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to pause matchup draft: ${response.statusCode}');
    }
  }

  /// Resume matchup draft
  Future<Draft> resumeMatchupDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/resume',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to resume matchup draft: ${response.statusCode}');
    }
  }

  /// Make a matchup pick
  Future<MatchupDraftPick> makeMatchupPick(
    int leagueId,
    int draftId,
    int opponentRosterId,
    int weekNumber,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/pick',
      token: token,
      body: {
        'opponent_roster_id': opponentRosterId,
        'week_number': weekNumber,
      },
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return MatchupDraftPick.fromJson(json);
    } else {
      throw Exception('Failed to make matchup pick: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get available matchups
  Future<List<AvailableMatchup>> getAvailableMatchups(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/available-matchups',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => AvailableMatchup.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load available matchups: ${response.statusCode}');
    }
  }

  /// Get all matchup draft picks
  Future<List<MatchupDraftPick>> getMatchupDraftPicks(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/picks',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => MatchupDraftPick.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load matchup draft picks: ${response.statusCode}');
    }
  }
}
