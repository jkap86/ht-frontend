import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../players/domain/player.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/draft.dart';
import '../domain/draft_pick.dart';

/// API client for live draft room operations
class DraftRoomApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  DraftRoomApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Get current draft state
  Future<Draft> getDraftState(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts/$draftId/state',
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      // Extract the draft property from the response
      final draftJson = json['draft'] as Map<String, dynamic>;
      return Draft.fromJson(draftJson);
    } else {
      throw Exception('Failed to get draft state: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get full draft state including autopick statuses
  Future<Map<String, dynamic>> getFullDraftState(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts/$draftId/state',
      token: token,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get draft state: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get available players for draft
  Future<List<Player>> getAvailablePlayers(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts/$draftId/available-players',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Player.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get available players: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get all draft picks
  Future<List<DraftPick>> getDraftPicks(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts/$draftId/picks',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => DraftPick.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get draft picks: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get draft picks with stats for a specific week (for matchup display)
  Future<List<DraftPick>> getDraftPicksWithStats(int leagueId, int draftId, int week, {String? season}) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final seasonParam = season ?? DateTime.now().year.toString();
    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts/$draftId/picks',
      token: token,
      queryParameters: {'week': week.toString(), 'season': seasonParam},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => DraftPick.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get draft picks with stats: ${response.statusCode} - ${response.body}');
    }
  }

  /// Make a draft pick
  Future<DraftPick> makePick(
    int leagueId,
    int draftId,
    int playerId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/pick',
      token: token,
      body: {'player_id': playerId},
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return DraftPick.fromJson(json);
    } else {
      throw Exception('Failed to make pick: ${response.statusCode} - ${response.body}');
    }
  }

  /// Start the draft
  Future<Draft> startDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/start',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to start draft: ${response.statusCode} - ${response.body}');
    }
  }

  /// Pause the draft
  Future<Draft> pauseDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/pause',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to pause draft: ${response.statusCode} - ${response.body}');
    }
  }

  /// Resume the draft
  Future<Draft> resumeDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/resume',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to resume draft: ${response.statusCode} - ${response.body}');
    }
  }

  /// Toggle autopick status for user's roster
  Future<Map<String, dynamic>> toggleAutopick(
    int leagueId,
    int draftId,
    int rosterId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/toggle-autopick',
      token: token,
      body: {
        'roster_id': rosterId,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to toggle autopick: ${response.statusCode} - ${response.body}');
    }
  }
}
