import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/draft.dart';

/// API client for draft derby operations
class DraftDerbyApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  DraftDerbyApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

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
