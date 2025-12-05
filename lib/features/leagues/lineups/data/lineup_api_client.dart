import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/lineup.dart';

/// API client for roster lineup operations
class LineupApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  LineupApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Get lineup for a specific roster/week/season
  Future<LineupResponse> getLineup({
    required int leagueId,
    required int rosterId,
    required int week,
    required String season,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/rosters/$rosterId/lineup',
      token: token,
      queryParameters: {'week': week, 'season': season},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return LineupResponse.fromJson(json);
    } else {
      throw Exception('Failed to get lineup: ${response.statusCode} - ${response.body}');
    }
  }

  /// Save lineup changes for a roster/week/season
  Future<WeeklyLineup> saveLineup({
    required int leagueId,
    required int rosterId,
    required int week,
    required String season,
    required List<StarterSlot> starters,
    required List<int> bench,
    List<int> ir = const [],
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final body = {
      'week': week,
      'season': season,
      'starters': starters.map((s) => {
        'player_id': s.playerId,
        'slot': s.slot,
      }).toList(),
      'bench': bench,
      'ir': ir,
    };

    final response = await _apiClient.putJson(
      '/api/leagues/$leagueId/rosters/$rosterId/lineup',
      body: body,
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final lineupJson = json['lineup'] as Map<String, dynamic>;
      return WeeklyLineup.fromJson(lineupJson);
    } else {
      // Parse error message from response
      String errorMessage = 'Failed to save lineup';
      try {
        final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = errorJson['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw Exception('$errorMessage (${response.statusCode})');
    }
  }

  /// Get all lineups for a league/week (for matchup overview)
  Future<Map<int, LineupResponse>> getLeagueLineups({
    required int leagueId,
    required int week,
    required String season,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/lineups',
      token: token,
      queryParameters: {'week': week, 'season': season},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = <int, LineupResponse>{};

      for (final entry in json.entries) {
        final rosterId = int.parse(entry.key);
        result[rosterId] = LineupResponse.fromJson(entry.value as Map<String, dynamic>);
      }

      return result;
    } else {
      throw Exception('Failed to get league lineups: ${response.statusCode} - ${response.body}');
    }
  }
}
