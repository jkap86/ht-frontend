import 'dart:convert';

import '../../../core/infrastructure/api_client.dart';
import '../../../core/infrastructure/api_exceptions.dart';
import '../../auth/data/auth_storage.dart';
import '../domain/chat_message.dart';

/// Unified repository for chat operations (league and DM)
class ChatRepository {
  final ApiClient _apiClient;
  final AuthStorage _storage;

  ChatRepository({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Fetch league chat messages
  Future<List<ChatMessage>> fetchLeagueMessages(String leagueId, {int limit = 100}) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw const UnauthorizedException(message: 'No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/leagues/$leagueId/chat',
      token: token,
      queryParameters: {'limit': limit},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => ChatMessage.fromLeagueMessage(json as Map<String, dynamic>)).toList();
    } else {
      throw ServerException(
        message: 'Failed to load league messages',
        statusCode: response.statusCode,
        responseBody: response.body,
      );
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
      throw const UnauthorizedException(message: 'No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/leagues/$leagueId/chat',
      token: token,
      body: {
        'message': message,
        'message_type': messageType,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ChatMessage.fromLeagueMessage(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw ServerException(
        message: 'Failed to send league message',
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }
  }

  /// Fetch direct messages with another user
  /// The roomId parameter should be the other user's ID (API uses this format)
  Future<List<ChatMessage>> fetchDirectMessages(String otherUserId, {int limit = 100}) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw const UnauthorizedException(message: 'No authentication token found');
    }

    final response = await _apiClient.getJson(
      '/api/direct-messages/$otherUserId',
      token: token,
      queryParameters: {'limit': limit},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) {
        final message = ChatMessage.fromDirectMessage(json as Map<String, dynamic>);
        // Override the roomId to use otherUserId for consistency with ChatRoom.id
        return message.copyWith(roomId: otherUserId);
      }).toList();
    } else {
      throw ServerException(
        message: 'Failed to load direct messages',
        statusCode: response.statusCode,
        responseBody: response.body,
      );
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
      throw const UnauthorizedException(message: 'No authentication token found');
    }

    final response = await _apiClient.postJson(
      '/api/direct-messages/$receiverId',
      token: token,
      body: {
        'message': message,
        'metadata': {},
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final dmMessage = ChatMessage.fromDirectMessage(jsonDecode(response.body) as Map<String, dynamic>);
      // Override the roomId to use receiverId for consistency with ChatRoom.id
      return dmMessage.copyWith(roomId: receiverId);
    } else {
      throw ServerException(
        message: 'Failed to send direct message',
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }
  }
}
