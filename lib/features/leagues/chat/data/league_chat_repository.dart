import '../../../../core/chat/chat_repository.dart';
import 'league_chat_api_client.dart';

/// Repository for league chat messages
class LeagueChatRepository implements ChatRepository {
  final LeagueChatApiClient apiClient;
  final int leagueId;

  LeagueChatRepository({
    required this.apiClient,
    required this.leagueId,
  });

  @override
  Future<List<Map<String, dynamic>>> loadMessages({int limit = 50}) async {
    final messages = await apiClient.getChatMessages(leagueId, limit: limit);

    // Convert DTOs to Map format that the UI expects
    return messages
        .map((dto) => {
              'id': dto.id,
              'user_id': dto.userId,
              'username': dto.username,
              'message': dto.message,
              'message_type': dto.messageType,
              'metadata': dto.metadata,
              'created_at': dto.createdAt.toIso8601String(),
            })
        .toList();
  }

  @override
  String get roomName => 'league_$leagueId';

  @override
  String get incomingEvent => 'new_message';

  @override
  String get outgoingEvent => 'send_league_chat';
}
