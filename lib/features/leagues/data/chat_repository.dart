import '../domain/repositories/chat_repository_interface.dart';
import '../domain/chat_message.dart';
import 'league_chat_api_client.dart';

/// Repository implementation for league chat
/// Handles DTO/Domain conversion and delegates to API client
class ChatRepository implements IChatRepository {
  final LeagueChatApiClient _apiClient;

  ChatRepository({
    required LeagueChatApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<ChatMessage>> getMessages(int leagueId, {int limit = 100}) async {
    final dtos = await _apiClient.getChatMessages(leagueId, limit: limit);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<ChatMessage> sendMessage({
    required int leagueId,
    required String message,
    String messageType = 'chat',
  }) async {
    final dto = await _apiClient.sendChatMessage(
      leagueId: leagueId,
      message: message,
      messageType: messageType,
    );
    return dto.toDomain();
  }
}
