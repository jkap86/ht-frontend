import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import 'dtos/chat_message_dto.dart';
import '../../auth/data/auth_storage.dart';

/// API client for league chat endpoints
/// Handles HTTP communication and returns DTOs
class LeagueChatApiClient {
  final String _baseUrl = appConfig.apiBaseUrl;
  final http.Client _client;
  final AuthStorage _storage;

  LeagueChatApiClient({
    http.Client? client,
    required AuthStorage storage,
  })  : _client = client ?? http.Client(),
        _storage = storage;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  /// Get chat messages for a specific league
  Future<List<ChatMessageDto>> getChatMessages(int leagueId, {int limit = 100}) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _client.get(
      _uri('/api/leagues/$leagueId/chat?limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => ChatMessageDto.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load chat messages: ${response.statusCode}');
    }
  }

  /// Send a chat message to a league
  Future<ChatMessageDto> sendChatMessage({
    required int leagueId,
    required String message,
    String messageType = 'chat',
    Map<String, dynamic>? metadata,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _client.post(
      _uri('/api/leagues/$leagueId/chat'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'message_type': messageType,
        'metadata': metadata ?? {},
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ChatMessageDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to send message: ${response.statusCode} - ${response.body}');
    }
  }
}
