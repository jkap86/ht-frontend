import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../auth/data/auth_token_storage.dart';

/// API client for draft-related endpoints
class DraftsApiClient {
  final String _baseUrl = appConfig.apiBaseUrl;
  final http.Client _client;
  final AuthTokenStorage _storage;

  DraftsApiClient({
    http.Client? client,
    AuthTokenStorage? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? AuthTokenStorage();

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  /// Get all drafts for a league
  Future<List<Map<String, dynamic>>> getLeagueDrafts(int leagueId) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _client.get(
      _uri('/api/leagues/$leagueId/drafts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.post(
      _uri('/api/leagues/$leagueId/drafts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(draftData),
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

    final response = await _client.put(
      _uri('/api/leagues/$leagueId/drafts/$draftId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(draftData),
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

    final response = await _client.delete(
      _uri('/api/leagues/$leagueId/drafts/$draftId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.get(
      _uri('/api/leagues/$leagueId/drafts/$draftId/order'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final response = await _client.post(
      _uri('/api/leagues/$leagueId/drafts/$draftId/randomize'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to randomize draft order: ${response.statusCode} - ${response.body}');
    }
  }
}
