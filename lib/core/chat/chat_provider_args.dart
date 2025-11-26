// lib/core/chat/chat_provider_args.dart
class ChatProviderArgs {
  final String roomName;
  final String incomingEvent;
  final String outgoingEvent;

  const ChatProviderArgs({
    required this.roomName,
    this.incomingEvent = 'chat_message',
    this.outgoingEvent = 'send_chat_message',
  });
}
