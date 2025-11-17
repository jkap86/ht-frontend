import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import 'dtos/league_dto.dart';
import '../../auth/data/auth_token_storage.dart';

/// API client for league-related endpoints
/// Handles HTTP communication and returns DTOs
class LeaguesApiClient {
  final String _baseUrl = appConfig.apiBaseUrl;
  final http.Client _client;
  final AuthTokenStorage _storage;

  LeaguesApiClient({
    http.Client? client,
    AuthTokenStorage? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? AuthTokenStorage();

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  /// Get all leagues for the current user
  Future<List<LeagueDto>> getMyLeagues() async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _client.get(
      _uri('/api/leagues/my-leagues'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.get(
      _uri('/api/leagues/$leagueId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.post(
      _uri('/api/leagues'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'season': season,
        'total_rosters': totalRosters,
        'settings': settings,
        'scoring_settings': scoringSettings,
        'roster_positions': rosterPositions,
        'season_type': seasonType,
      }),
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
    if (settings != null) body['settings'] = settings;
    if (scoringSettings != null) body['scoring_settings'] = scoringSettings;
    if (rosterPositions != null) body['roster_positions'] = rosterPositions;

    final response = await _client.put(
      _uri('/api/leagues/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
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

    final response = await _client.post(
      _uri('/api/leagues/$id/reset'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.delete(
      _uri('/api/leagues/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.post(
      _uri('/api/leagues/$leagueId/dev/add-users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'usernames': usernames}),
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

    final response = await _client.get(
      _uri('/api/leagues/$leagueId/members'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.patch(
      _uri('/api/leagues/$leagueId/members/$rosterId/payment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'paid': paid}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update payment status: ${response.statusCode} - ${response.body}');
    }
  }
}
