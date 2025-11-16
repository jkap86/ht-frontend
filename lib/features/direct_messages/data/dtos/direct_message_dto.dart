import '../../domain/direct_message.dart';

/// DTO for a direct message
class DirectMessageDto {
  final int id;
  final String senderId;
  final String receiverId;
  final String senderUsername;
  final String receiverUsername;
  final String message;
  final Map<String, dynamic>? metadata;
  final bool read;
  final DateTime createdAt;

  DirectMessageDto({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderUsername,
    required this.receiverUsername,
    required this.message,
    this.metadata,
    required this.read,
    required this.createdAt,
  });

  factory DirectMessageDto.fromJson(Map<String, dynamic> json) {
    return DirectMessageDto(
      id: json['id'] as int,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      senderUsername: json['sender_username'] as String,
      receiverUsername: json['receiver_username'] as String,
      message: json['message'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      read: json['read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_username': senderUsername,
      'receiver_username': receiverUsername,
      'message': message,
      'metadata': metadata,
      'read': read,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert DTO to domain model
  DirectMessage toDomain() {
    return DirectMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      senderUsername: senderUsername,
      receiverUsername: receiverUsername,
      message: message,
      metadata: metadata,
      read: read,
      createdAt: createdAt,
    );
  }
}
