import '../domain/chat_message.dart';
import '../domain/chat_room.dart';

/// State for a chat room (league or DM conversation)
class ChatRoomState {
  final ChatRoom room;
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatRoomState({
    required this.room,
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatRoomState copyWith({
    ChatRoom? room,
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatRoomState(
      room: room ?? this.room,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
