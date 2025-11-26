import 'dart:async';

import '../services/socket/socket_service.dart';

/// Generic chat client wrapper around [SocketService].
///
/// Responsibilities:
/// - Ensure socket is connected
/// - Join/leave a specific room
/// - Listen for incoming events
/// - Emit outgoing events
class ChatSocketClient {
  final SocketService _socketService;
  final String roomName;
  final String incomingEvent;
  final String outgoingEvent;

  final _messagesController =
      StreamController<Map<String, dynamic>>.broadcast();

  VoidCallback? _listenerDisposer;
  bool _joined = false;

  ChatSocketClient({
    required SocketService socketService,
    required this.roomName,
    this.incomingEvent = 'chat_message',
    this.outgoingEvent = 'send_chat_message',
  }) : _socketService = socketService;

  Stream<Map<String, dynamic>> get messagesStream => _messagesController.stream;

  /// Ensure the socket is connected, join the room, and start listening
  /// for incoming messages.
  Future<void> connect() async {
    if (!_socketService.isConnected) {
      await _socketService.connect();
    }

    final joined = await _socketService.joinRoom(roomName);
    if (!joined) {
      throw Exception('Failed to join room $roomName');
    }
    _joined = true;

    _listenerDisposer = _socketService.on(incomingEvent, (data) {
      if (data is Map<String, dynamic>) {
        _messagesController.add(data);
      } else if (data is Map) {
        // Best-effort cast for loosely typed payloads
        _messagesController.add(Map<String, dynamic>.from(data));
      } else {
        // Ignore malformed payloads
      }
    });
  }

  /// Leave the room and stop listening.
  Future<void> disconnect() async {
    _listenerDisposer?.call();
    _listenerDisposer = null;

    if (_joined) {
      _socketService.leaveRoom(roomName);
      _joined = false;
    }
  }

  /// Fire-and-forget emission of a chat payload.
  Future<void> sendMessage(Map<String, dynamic> payload) async {
    _socketService.tryEmit(outgoingEvent, payload);
  }

  /// Cleanup.
  Future<void> dispose() async {
    await disconnect();
    await _messagesController.close();
  }
}
