import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/waiver_claim.dart';

class WaiverApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  WaiverApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  Future<List<WaiverClaim>> getWaiverClaims(
    int leagueId, {
    int? week,
    String? season,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final queryParams = <String, dynamic>{};
    if (week != null) queryParams['week'] = week;
    if (season != null) queryParams['season'] = season;

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/waivers',
      token: token,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => WaiverClaim.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load waiver claims: ${response.statusCode}');
    }
  }

  Future<List<AvailablePlayer>> getAvailablePlayers(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/players/available',
      token: token,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => AvailablePlayer.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load available players: ${response.statusCode}');
    }
  }

  Future<WaiverClaim> submitClaim(int leagueId, SubmitClaimRequest request) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/waivers',
      token: token,
      body: request.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WaiverClaim.fromJson(json);
    } else {
      throw Exception('Failed to submit claim: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> cancelClaim(int leagueId, int claimId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.deleteJson(
      '/api/leagues/$leagueId/waivers/$claimId',
      token: token,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel claim: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> addFreeAgent(
    int leagueId,
    int playerId, {
    int? dropPlayerId,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final body = <String, dynamic>{};
    if (dropPlayerId != null) body['drop_player_id'] = dropPlayerId;

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/players/$playerId/add',
      token: token,
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add free agent: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<RosterTransaction>> getTransactionHistory(
    int leagueId, {
    int? limit,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/transactions',
      token: token,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => RosterTransaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load transaction history: ${response.statusCode}');
    }
  }
}
