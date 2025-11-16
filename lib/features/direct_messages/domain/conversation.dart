/// Represents a conversation with another user
class Conversation {
  final String otherUserId;
  final String otherUsername;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  Conversation({
    required this.otherUserId,
    required this.otherUsername,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}
