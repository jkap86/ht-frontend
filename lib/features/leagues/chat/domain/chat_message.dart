/// Pure domain model for a league chat message
/// Contains only business logic, no serialization concerns
class ChatMessage {
  final int id;
  final int leagueId;
  final String? userId; // Nullable for system messages
  final String message;
  final String messageType;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final String? username; // Nullable for system messages

  const ChatMessage({
    required this.id,
    required this.leagueId,
    this.userId, // Nullable for system messages
    required this.message,
    required this.messageType,
    this.metadata,
    required this.createdAt,
    this.username, // Nullable for system messages
  });

  /// Check if this is a system message
  bool get isSystemMessage => messageType == 'system';

  /// Check if this is a regular chat message
  bool get isChatMessage => messageType == 'chat';

  ChatMessage copyWith({
    int? id,
    int? leagueId,
    String? userId,
    String? message,
    String? messageType,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    String? username,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      leagueId: leagueId ?? this.leagueId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
    );
  }
}
