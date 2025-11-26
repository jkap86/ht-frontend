import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/draft_queue.dart';

/// API client for draft queue operations
class DraftQueueApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  DraftQueueApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

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
