import 'dart:async';

import '../../../core/services/socket/socket_service.dart';

/// Generic chat client wrapper around [SocketService].
///
/// This is intentionally flexible so you can use it for:
/// - Global chat rooms
/// - League-specific chat channels
/// - Any arbitrary room name
///
/// Defaults:
/// - Room name: you pass it in (e.g. "global_chat", "league_123_general")
/// - Incoming event: 'chat_message'
/// - Outgoing event: 'send_chat_message'
///
/// If your backend uses different event names, change `_incomingEvent`/`_outgoingEvent`
/// defaults or pass them explicitly from the caller.
class ChatSocketClient {
  final SocketService _socketService;
  final String _roomName;
  final String _incomingEvent;
  final String _outgoingEvent;

  /// Stream of incoming chat messages for this room.
  final _messagesController = StreamController<dynamic>.broadcast();

  VoidCallback? _messageListenerDisposer;
  bool _joined = false;

  ChatSocketClient({
    required SocketService socketService,
    required String roomName,
    String incomingEvent = 'chat_message',
    String outgoingEvent = 'send_chat_message',
  })  : _socketService = socketService,
        _roomName = roomName,
        _incomingEvent = incomingEvent,
        _outgoingEvent = outgoingEvent;

  Stream<dynamic> get messages => _messagesController.stream;

  /// Connects to the chat room and starts listening for messages.
  Future<void> connect() async {
    final joined = await _socketService.joinRoom(_roomName);
    _joined = joined || _joined; // track intent even if not yet connected
    _listenToMessages();
  }

  /// Leaves the chat room and stops listening for messages.
  Future<void> disconnect() async {
    _joined = false;
    _messageListenerDisposer?.call();
    _messageListenerDisposer = null;

    // Best-effort leave; it's OK if socket is down.
    _socketService.leaveRoom(_roomName);
  }

  /// Sends a chat message to this room.
  ///
  /// Adjust payload keys to match your backend.
  bool sendMessage({
    required String message,
    Map<String, dynamic>? metadata,
  }) {
    if (message.trim().isEmpty) {
      return false;
    }

    final payload = <String, dynamic>{
      'room': _roomName,
      'message': message.trim(),
      if (metadata != null) 'metadata': metadata,
    };

    // Emit using the configured outgoing event.
    return _socketService.tryEmit(_outgoingEvent, payload);
  }

  void _listenToMessages() {
    // Remove previous listener if any to avoid duplicates.
    _messageListenerDisposer?.call();

    _messageListenerDisposer = _socketService.on(_incomingEvent, (data) {
      // If your backend includes a room field, you can filter:
      //
      // if (data is Map && data['room'] == _roomName) {
      //   _messagesController.add(data);
      // }
      // else {
      //   return;
      // }
      //
      // For now, just forward everything:
      _messagesController.add(data);
    });
  }

  /// Clean up all resources.
  Future<void> dispose() async {
    await disconnect();
    await _messagesController.close();
  }
}
