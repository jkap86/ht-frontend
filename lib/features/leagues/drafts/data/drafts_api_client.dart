import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../../core/domain/players/player.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/draft.dart';
import '../domain/draft_pick.dart';
import '../domain/draft_queue.dart';

/// API client for draft-related endpoints
class DraftsApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  DraftsApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Get all drafts for a league
  Future<List<Draft>> getLeagueDrafts(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Draft.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load drafts: ${response.statusCode}');
    }
  }

  /// Create a new draft
  Future<Draft> createDraft(
    int leagueId,
    Map<String, dynamic> draftData,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts',
      token: token,
      body: draftData,
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to create draft: ${response.statusCode} - ${response.body}');
    }
  }

  /// Update an existing draft
  Future<Draft> updateDraft(
    int leagueId,
    int draftId,
    Map<String, dynamic> draftData,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.putJson(
      '/api/leagues/$leagueId/drafts/$draftId',
      token: token,
      body: draftData,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to update draft: ${response.statusCode} - ${response.body}');
    }
  }

  /// Delete a draft
  Future<void> deleteDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.deleteJson(
      '/api/leagues/$leagueId/drafts/$draftId',
      token: token,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete draft: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get draft order for a draft
  Future<List<Map<String, dynamic>>> getDraftOrder(
    int leagueId,
    int draftId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts/$draftId/order',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to get draft order: ${response.statusCode} - ${response.body}');
    }
  }

  /// Randomize draft order for a draft
  Future<List<Map<String, dynamic>>> randomizeDraftOrder(
    int leagueId,
    int draftId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/randomize',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to randomize draft order: ${response.statusCode} - ${response.body}');
    }
  }

  /// Start a derby draft
  Future<Draft> startDerby(
    int leagueId,
    int draftId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/start-derby',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to start derby: ${response.statusCode} - ${response.body}');
    }
  }

  /// Pick a derby slot
  Future<Draft> pickDerbySlot(
    int leagueId,
    int draftId,
    int slotNumber,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/pick-slot',
      token: token,
      body: {'slot_number': slotNumber},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to pick derby slot: ${response.statusCode} - ${response.body}');
    }
  }

  /// Pause a derby draft
  Future<Draft> pauseDerby(
    int leagueId,
    int draftId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/pause-derby',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to pause derby: ${response.statusCode} - ${response.body}');
    }
  }

  /// Resume a derby draft
  Future<Draft> resumeDerby(
    int leagueId,
    int draftId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/resume-derby',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to resume derby: ${response.statusCode} - ${response.body}');
    }
  }

  // ========== Draft Room Endpoints ==========

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

  // ========== Draft Queue Endpoints ==========

  /// Get user's draft queue
  Future<List<DraftQueue>> getQueue(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/drafts/$draftId/queue',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => DraftQueue.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get queue: ${response.statusCode} - ${response.body}');
    }
  }

  /// Add player to queue
  Future<DraftQueue> addToQueue(
    int leagueId,
    int draftId,
    int playerId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/drafts/$draftId/queue',
      token: token,
      body: {'playerId': playerId},
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return DraftQueue.fromJson(json);
    } else {
      throw Exception('Failed to add to queue: ${response.statusCode} - ${response.body}');
    }
  }

  /// Remove player from queue
  Future<void> removeFromQueue(
    int leagueId,
    int draftId,
    int queueId,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.deleteJson(
      '/api/leagues/$leagueId/drafts/$draftId/queue/$queueId',
      token: token,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove from queue: ${response.statusCode} - ${response.body}');
    }
  }

  /// Reorder queue
  Future<void> reorderQueue(
    int leagueId,
    int draftId,
    List<Map<String, int>> updates,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.putJson(
      '/api/leagues/$leagueId/drafts/$draftId/queue/reorder',
      token: token,
      body: {'updates': updates},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reorder queue: ${response.statusCode} - ${response.body}');
    }
  }
}
