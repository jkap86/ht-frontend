import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/draft.dart';

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
}
