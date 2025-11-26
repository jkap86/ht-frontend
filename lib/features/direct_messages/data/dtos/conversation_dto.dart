import '../../domain/conversation.dart';

/// DTO for a conversation list item
class ConversationDto {
  final String otherUserId;
  final String otherUsername;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationDto({
    required this.otherUserId,
    required this.otherUsername,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    // Handle unread_count which might come as string or int from database COUNT()
    final unreadCountValue = json['unread_count'];
    final unreadCount = unreadCountValue is String
        ? int.parse(unreadCountValue)
        : unreadCountValue as int;

    return ConversationDto(
      otherUserId: json['other_user_id'] as String,
      otherUsername: json['other_username'] as String,
      lastMessage: json['last_message'] as String,
      lastMessageTime: DateTime.parse(json['last_message_time'] as String),
      unreadCount: unreadCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'other_user_id': otherUserId,
      'other_username': otherUsername,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'unread_count': unreadCount,
    };
  }

  /// Convert DTO to domain model
  Conversation toDomain() {
    return Conversation(
      otherUserId: otherUserId,
      otherUsername: otherUsername,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
    );
  }
}
