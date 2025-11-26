import '../../../core/chat/chat_repository.dart';
import 'dm_api_client.dart';

/// Repository for direct message chat
class DmChatRepository implements ChatRepository {
  final DmApiClient apiClient;
  final String conversationId;
  final String otherUserId;

  DmChatRepository({
    required this.apiClient,
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  Future<List<Map<String, dynamic>>> loadMessages({int limit = 50}) async {
    final messages = await apiClient.getMessages(otherUserId, limit: limit);

    // Convert DTOs to Map format that the UI expects
    return messages
        .map((dto) => {
              'id': dto.id,
              'sender_id': dto.senderId,
              'receiver_id': dto.receiverId,
              'sender_username': dto.senderUsername,
              'receiver_username': dto.receiverUsername,
              'message': dto.message,
              'metadata': dto.metadata,
              'read': dto.read,
              'created_at': dto.createdAt.toIso8601String(),
            })
        .toList();
  }

  @override
  String get roomName => 'dm_$conversationId';

  @override
  String get incomingEvent => 'new_dm';

  @override
  String get outgoingEvent => 'send_dm';
}
