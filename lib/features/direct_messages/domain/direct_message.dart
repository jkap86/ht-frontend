/// Represents a direct message between two users
class DirectMessage {
  final int id;
  final String senderId;
  final String receiverId;
  final String senderUsername;
  final String receiverUsername;
  final String message;
  final Map<String, dynamic>? metadata;
  final bool read;
  final DateTime createdAt;

  const DirectMessage({
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

  DirectMessage copyWith({
    int? id,
    String? senderId,
    String? receiverId,
    String? senderUsername,
    String? receiverUsername,
    String? message,
    Map<String, dynamic>? metadata,
    bool? read,
    DateTime? createdAt,
  }) {
    return DirectMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderUsername: senderUsername ?? this.senderUsername,
      receiverUsername: receiverUsername ?? this.receiverUsername,
      message: message ?? this.message,
      metadata: metadata ?? this.metadata,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
