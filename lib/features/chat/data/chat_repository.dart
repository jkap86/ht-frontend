import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../auth/data/auth_storage.dart';
import '../domain/chat_message.dart';

/// Unified repository for chat operations (league and DM)
class ChatRepository {
  final String _baseUrl = appConfig.apiBaseUrl;
  final http.Client _client;
  final AuthStorage _storage;

  ChatRepository({
    http.Client? client,
    required AuthStorage storage,
  })  : _client = client ?? http.Client(),
        _storage = storage;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  /// Fetch league chat messages
  Future<List<ChatMessage>> fetchLeagueMessages(String leagueId, {int limit = 100}) async {
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
      return data.map((json) => ChatMessage.fromLeagueMessage(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load league messages: ${response.statusCode}');
    }
  }

  /// Send a league chat message
  Future<ChatMessage> sendLeagueMessage({
    required String leagueId,
    required String message,
    String messageType = 'chat',
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
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ChatMessage.fromLeagueMessage(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to send league message: ${response.statusCode} - ${response.body}');
    }
  }

  /// Fetch direct messages with another user
  /// The roomId parameter should be the other user's ID (API uses this format)
  Future<List<ChatMessage>> fetchDirectMessages(String otherUserId, {int limit = 100}) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _client.get(
      _uri('/api/direct-messages/$otherUserId?limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) {
        final message = ChatMessage.fromDirectMessage(json as Map<String, dynamic>);
        // Override the roomId to use otherUserId for consistency with ChatRoom.id
        return message.copyWith(roomId: otherUserId);
      }).toList();
    } else {
      throw Exception('Failed to load direct messages: ${response.statusCode}');
    }
  }

  /// Send a direct message
  /// The receiverId is the other user's ID
  Future<ChatMessage> sendDirectMessage({
    required String receiverId,
    required String message,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _client.post(
      _uri('/api/direct-messages/$receiverId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'metadata': {},
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final dmMessage = ChatMessage.fromDirectMessage(jsonDecode(response.body) as Map<String, dynamic>);
      // Override the roomId to use receiverId for consistency with ChatRoom.id
      return dmMessage.copyWith(roomId: receiverId);
    } else {
      throw Exception('Failed to send direct message: ${response.statusCode} - ${response.body}');
    }
  }
}
