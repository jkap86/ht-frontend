import 'dart:convert';

import '../../../core/infrastructure/api_client.dart';
import 'dtos/league_dto.dart';
import '../../auth/data/auth_storage.dart';

/// API client for league-related endpoints
/// Handles HTTP communication and returns DTOs
class LeaguesApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  LeaguesApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Get all leagues for the current user
  Future<List<LeagueDto>> getMyLeagues() async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/my-leagues',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => LeagueDto.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load leagues: ${response.statusCode}');
    }
  }

  /// Get a specific league by ID
  Future<LeagueDto> getLeague(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId',
      token: token,
    );

    if (response.statusCode == 200) {
      return LeagueDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load league: ${response.statusCode}');
    }
  }

  /// Create a new league
  Future<LeagueDto> createLeague({
    required String name,
    required String season,
    required int totalRosters,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> scoringSettings,
    required Map<String, int> rosterPositions,
    required String seasonType,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Convert Map<String, int> to array of objects as expected by backend
    final rosterPositionsArray = rosterPositions.entries.map((entry) => {
      'position': entry.key,
      'count': entry.value,
    }).toList();

    final response = await _apiClient.postJson(
      '/api/leagues',
      token: token,
      body: {
        'name': name,
        'season': season,
        'total_rosters': totalRosters,
        'settings': settings,
        'scoring_settings': scoringSettings,
        'roster_positions': rosterPositionsArray,
        'season_type': seasonType,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return LeagueDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create league: ${response.statusCode}');
    }
  }

  /// Update an existing league
  Future<LeagueDto> updateLeague({
    required int id,
    String? name,
    String? description,
    int? totalRosters,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    Map<String, dynamic>? rosterPositions,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Build request body with only provided fields
    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (totalRosters != null) body['total_rosters'] = totalRosters;
    if (settings != null) body['settings'] = settings;
    if (scoringSettings != null) body['scoring_settings'] = scoringSettings;
    if (rosterPositions != null) {
      // Convert Map<String, dynamic> to array of objects as expected by backend
      final rosterPositionsArray = rosterPositions.entries.map((entry) => {
        'position': entry.key,
        'count': entry.value,
      }).toList();
      body['roster_positions'] = rosterPositionsArray;
    }

    final response = await _apiClient.putJson(
      '/api/leagues/$id',
      token: token,
      body: body,
    );

    if (response.statusCode == 200) {
      return LeagueDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update league: ${response.statusCode} - ${response.body}');
    }
  }

  /// Reset league - clears rosters, drafts, and matchups but preserves settings
  Future<void> resetLeague(int id) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$id/reset',
      token: token,
      body: {},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset league: ${response.statusCode} - ${response.body}');
    }
  }

  /// Delete league permanently
  Future<void> deleteLeague(int id) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.deleteJson(
      '/api/leagues/$id',
      token: token,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete league: ${response.statusCode} - ${response.body}');
    }
  }

  /// Developer endpoint to add users to league by username
  Future<List<Map<String, dynamic>>> devAddUsersToLeague(
    int leagueId,
    List<String> usernames,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/dev/add-users',
      token: token,
      body: {'usernames': usernames},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      return results.map((r) => r as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to add users to league: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get league members with payment status
  Future<List<Map<String, dynamic>>> getLeagueMembers(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/members',
      token: token,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final members = data['members'] as List<dynamic>;
      return members.map((m) => m as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load league members: ${response.statusCode} - ${response.body}');
    }
  }

  /// Toggle member payment status
  Future<Map<String, dynamic>> toggleMemberPayment(
    int leagueId,
    int rosterId,
    bool paid,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.patchJson(
      '/api/leagues/$leagueId/members/$rosterId/payment',
      token: token,
      body: {'paid': paid},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update payment status: ${response.statusCode} - ${response.body}');
    }
  }

  // ============================================
  // Payout Management
  // ============================================

  /// Get all payouts for a league
  Future<List<Map<String, dynamic>>> getPayouts(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/payouts',
      token: token,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final payouts = data['payouts'] as List<dynamic>;
      return payouts.map((p) => p as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load payouts: ${response.statusCode} - ${response.body}');
    }
  }

  /// Add a new payout to a league
  Future<Map<String, dynamic>> addPayout(
    int leagueId, {
    required String type,
    required int place,
    required double amount,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/payouts',
      token: token,
      body: {
        'type': type,
        'place': place,
        'amount': amount,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['payout'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to add payout: ${response.statusCode} - ${response.body}');
    }
  }

  /// Update an existing payout
  Future<Map<String, dynamic>> updatePayout(
    int leagueId,
    String payoutId, {
    String? type,
    int? place,
    double? amount,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final Map<String, dynamic> body = {};
    if (type != null) body['type'] = type;
    if (place != null) body['place'] = place;
    if (amount != null) body['amount'] = amount;

    final response = await _apiClient.putJson(
      '/api/leagues/$leagueId/payouts/$payoutId',
      token: token,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['payout'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update payout: ${response.statusCode} - ${response.body}');
    }
  }

  /// Delete a payout
  Future<void> deletePayout(int leagueId, String payoutId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.deleteJson(
      '/api/leagues/$leagueId/payouts/$payoutId',
      token: token,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete payout: ${response.statusCode} - ${response.body}');
    }
  }
}
