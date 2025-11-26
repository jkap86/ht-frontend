/// Unified domain model for chat messages
/// Works for both league chat and direct messages
class ChatMessage {
  final String id;
  final String roomId; // leagueId for leagues, conversationId for DMs
  final String? senderId; // Nullable for system messages
  final String? senderName; // Nullable for system messages
  final String text;
  final String messageType; // 'chat', 'system', 'dm'
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.roomId,
    this.senderId,
    this.senderName,
    required this.text,
    required this.messageType,
    this.metadata,
    required this.createdAt,
  });

  /// Check if this is a system message
  bool get isSystemMessage => messageType == 'system';

  /// Check if this is a regular chat message
  bool get isChatMessage => messageType == 'chat' || messageType == 'dm';

  factory ChatMessage.fromLeagueMessage(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      roomId: json['league_id'].toString(),
      senderId: json['user_id']?.toString(),
      senderName: json['username'],
      text: json['message'] as String,
      messageType: json['message_type'] as String? ?? 'chat',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  factory ChatMessage.fromDirectMessage(Map<String, dynamic> json) {
    // For DMs, we create a conversation ID from sorted user IDs
    final senderId = json['sender_id'] as String;
    final receiverId = json['receiver_id'] as String;
    final conversationId = [senderId, receiverId]..sort();

    return ChatMessage(
      id: json['id'].toString(),
      roomId: conversationId.join('_'),
      senderId: senderId,
      senderName: json['sender_username'] as String?,
      text: json['message'] as String,
      messageType: 'dm',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  ChatMessage copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? senderName,
    String? text,
    String? messageType,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      messageType: messageType ?? this.messageType,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
