import 'dart:convert';

import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/trade.dart';

class TradeApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  TradeApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  Future<List<Trade>> getTrades(int leagueId, {String? status}) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/trades',
      token: token,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Trade.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load trades: ${response.statusCode}');
    }
  }

  Future<Trade> getTradeById(int leagueId, int tradeId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/trades/$tradeId',
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Trade.fromJson(json);
    } else {
      throw Exception('Failed to load trade: ${response.statusCode}');
    }
  }

  Future<Trade> proposeTrade(int leagueId, ProposeTradeRequest request) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/trades',
      token: token,
      body: request.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Trade.fromJson(json);
    } else {
      throw Exception('Failed to propose trade: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Trade> acceptTrade(int leagueId, int tradeId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.putJson(
      '/api/leagues/$leagueId/trades/$tradeId/accept',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Trade.fromJson(json);
    } else {
      throw Exception('Failed to accept trade: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Trade> rejectTrade(int leagueId, int tradeId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.putJson(
      '/api/leagues/$leagueId/trades/$tradeId/reject',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Trade.fromJson(json);
    } else {
      throw Exception('Failed to reject trade: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Trade> cancelTrade(int leagueId, int tradeId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.deleteJson(
      '/api/leagues/$leagueId/trades/$tradeId',
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Trade.fromJson(json);
    } else {
      throw Exception('Failed to cancel trade: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Trade> vetoTrade(int leagueId, int tradeId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.putJson(
      '/api/leagues/$leagueId/trades/$tradeId/veto',
      token: token,
      body: {},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Trade.fromJson(json);
    } else {
      throw Exception('Failed to veto trade: ${response.statusCode} - ${response.body}');
    }
  }
}
