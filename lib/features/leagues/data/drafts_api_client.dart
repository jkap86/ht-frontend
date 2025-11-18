import 'dart:convert';

import '../../../core/infrastructure/api_client.dart';
import '../../auth/data/auth_storage.dart';

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
  Future<List<Map<String, dynamic>>> getLeagueDrafts(int leagueId) async {
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
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load drafts: ${response.statusCode}');
    }
  }

  /// Create a new draft
  Future<Map<String, dynamic>> createDraft(
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
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create draft: ${response.statusCode} - ${response.body}');
    }
  }

  /// Update an existing draft
  Future<Map<String, dynamic>> updateDraft(
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
      return jsonDecode(response.body) as Map<String, dynamic>;
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
      return data.cast<Map<String, dynamic>>();
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
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to randomize draft order: ${response.statusCode} - ${response.body}');
    }
  }
}
