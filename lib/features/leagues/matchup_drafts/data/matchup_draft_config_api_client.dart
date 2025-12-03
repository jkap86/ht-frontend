import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../../drafts/domain/draft.dart';
import '../../drafts/domain/draft_order_entry.dart';

/// API client for matchup draft configuration and CRUD operations
class MatchupDraftConfigApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  MatchupDraftConfigApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Get or create matchup draft for a league
  Future<Draft> getOrCreateMatchupDraft(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/matchup-drafts',
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to load matchup draft: ${response.statusCode}');
    }
  }

  /// Get matchup draft by ID
  Future<Draft> getMatchupDraft(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId',
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Draft.fromJson(json);
    } else {
      throw Exception('Failed to load matchup draft: ${response.statusCode}');
    }
  }

  /// Get matchup draft order
  Future<List<DraftOrderEntry>> getMatchupDraftOrder(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/order',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => DraftOrderEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load matchup draft order: ${response.statusCode}');
    }
  }

  /// Randomize matchup draft order
  Future<List<DraftOrderEntry>> randomizeMatchupDraftOrder(int leagueId, int draftId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/matchup-drafts/$draftId/randomize',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => DraftOrderEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to randomize matchup draft order: ${response.statusCode}');
    }
  }

  /// Generate random matchups for all regular season weeks
  Future<Map<String, dynamic>> generateRandomMatchups(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/matchup-drafts/generate-random',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to generate random matchups: ${response.statusCode}');
    }
  }
}
