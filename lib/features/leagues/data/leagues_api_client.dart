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
}
