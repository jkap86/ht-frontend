// lib/core/chat/chat_state.dart
class ChatState {
  final bool isConnecting;
  final bool isConnected;
  final List<Map<String, dynamic>> messages;
  final String? errorMessage;

  const ChatState({
    required this.isConnecting,
    required this.isConnected,
    required this.messages,
    this.errorMessage,
  });

  factory ChatState.initial() => const ChatState(
        isConnecting: false,
        isConnected: false,
        messages: [],
        errorMessage: null,
      );

  ChatState copyWith({
    bool? isConnecting,
    bool? isConnected,
    List<Map<String, dynamic>>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      messages: messages ?? this.messages,
      // Explicitly pass null to clear error
      errorMessage: errorMessage,
    );
  }
}
