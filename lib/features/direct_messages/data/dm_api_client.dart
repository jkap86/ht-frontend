import 'dart:convert';

import '../../../core/infrastructure/api_client.dart';
import '../../auth/data/auth_storage.dart';
import 'dtos/conversation_dto.dart';
import 'dtos/direct_message_dto.dart';

/// API client for direct message endpoints
/// Handles HTTP communication and returns DTOs
class DmApiClient {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  DmApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Get all conversations for the authenticated user
  Future<List<ConversationDto>> getConversations() async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/direct-messages/conversations',
      token: token,
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

    final response = await _apiClient.getJson(
      '/api/direct-messages/$otherUserId',
      token: token,
      queryParameters: {'limit': limit},
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

    final response = await _apiClient.postJson(
      '/api/direct-messages/$receiverId',
      token: token,
      body: {
        'message': message,
        'metadata': metadata ?? {},
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return DirectMessageDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to send message: ${response.statusCode} - ${response.body}');
    }
  }
}
