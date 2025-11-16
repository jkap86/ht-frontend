import '../../domain/chat_message.dart';

/// Data Transfer Object for Chat Message
/// Handles JSON serialization/deserialization (data layer concern)
class ChatMessageDto {
  final int id;
  final int leagueId;
  final String? userId; // Nullable for system messages
  final String message;
  final String messageType;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final String? username; // Nullable for system messages

  ChatMessageDto({
    required this.id,
    required this.leagueId,
    this.userId, // Nullable for system messages
    required this.message,
    required this.messageType,
    this.metadata,
    required this.createdAt,
    this.username, // Nullable for system messages
  });

  /// Convert JSON from API to DTO
  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      id: json['id'] as int,
      leagueId: json['league_id'] as int,
      userId: json['user_id'] as String?, // Nullable for system messages
      message: json['message'] as String,
      messageType: json['message_type'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      username: json['username'] as String?, // Nullable for system messages
    );
  }

  /// Convert DTO to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'league_id': leagueId,
      'user_id': userId,
      'message': message,
      'message_type': messageType,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'username': username,
    };
  }

  /// Convert DTO to domain model
  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      leagueId: leagueId,
      userId: userId,
      message: message,
      messageType: messageType,
      metadata: metadata,
      createdAt: createdAt,
      username: username,
    );
  }

  /// Create DTO from domain model
  factory ChatMessageDto.fromDomain(ChatMessage chatMessage) {
    return ChatMessageDto(
      id: chatMessage.id,
      leagueId: chatMessage.leagueId,
      userId: chatMessage.userId,
      message: chatMessage.message,
      messageType: chatMessage.messageType,
      metadata: chatMessage.metadata,
      createdAt: chatMessage.createdAt,
      username: chatMessage.username,
    );
  }
}
