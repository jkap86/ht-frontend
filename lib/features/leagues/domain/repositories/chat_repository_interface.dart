import '../chat_message.dart';

/// Abstract interface for chat repository
/// Follows the repository pattern used throughout the application
abstract class IChatRepository {
  /// Get chat messages for a league
  Future<List<ChatMessage>> getMessages(int leagueId, {int limit = 100});

  /// Send a message to a league chat
  Future<ChatMessage> sendMessage({
    required int leagueId,
    required String message,
    String messageType = 'chat',
  });
}
