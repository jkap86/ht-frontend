// lib/core/chat/chat_repository.dart
import 'dart:async';

/// Generic chat repository interface for loading and sending messages
abstract class ChatRepository {
  /// Load initial messages (most recent first, usually limited)
  Future<List<Map<String, dynamic>>> loadMessages({int limit = 50});

  /// Get the room name for socket connections
  String get roomName;

  /// Get the incoming socket event name
  String get incomingEvent;

  /// Get the outgoing socket event name
  String get outgoingEvent;
}
