import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../auth/data/auth_storage.dart';
import 'dtos/conversation_dto.dart';
import 'dtos/direct_message_dto.dart';

/// API client for direct message endpoints
/// Handles HTTP communication and returns DTOs
class DmApiClient {
  final String _baseUrl = appConfig.apiBaseUrl;
  final http.Client _client;
  final AuthStorage _storage;

  DmApiClient({
    http.Client? client,
    required AuthStorage storage,
  })  : _client = client ?? http.Client(),
        _storage = storage;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  /// Get all conversations for the authenticated user
  Future<List<ConversationDto>> getConversations() async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _client.get(
      _uri('/api/direct-messages/conversations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => ConversationDto.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load conversations: ${response.statusCode}');
    }
  }

  /// Get messages in a conversation with another user
  Future<List<DirectMessageDto>> getMessages(String otherUserId, {int limit = 100}) async {
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
      return data.map((json) => DirectMessageDto.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load messages: ${response.statusCode}');
    }
  }

  /// Send a message to another user
  Future<DirectMessageDto> sendMessage({
    required String receiverId,
    required String message,
    Map<String, dynamic>? metadata,
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
        'metadata': metadata ?? {},
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return DirectMessageDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to send message: ${response.statusCode} - ${response.body}');
    }
  }
}
