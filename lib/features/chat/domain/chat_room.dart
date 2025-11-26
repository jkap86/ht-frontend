/// Type of chat room
enum ChatRoomType {
  league,
  directMessage,
}

/// Represents a chat room (league or DM conversation)
class ChatRoom {
  final String id; // leagueId or conversationId
  final ChatRoomType type;
  final String? displayName; // League name or other user's name
  final Map<String, dynamic>? metadata; // Additional info if needed

  const ChatRoom({
    required this.id,
    required this.type,
    this.displayName,
    this.metadata,
  });

  ChatRoom copyWith({
    String? id,
    ChatRoomType? type,
    String? displayName,
    Map<String, dynamic>? metadata,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoom && other.id == id && other.type == type;
  }

  @override
  int get hashCode => Object.hash(id, type);
}
