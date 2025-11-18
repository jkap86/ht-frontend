import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/socket/socket_providers.dart';
import '../../../core/services/socket/socket_service.dart';
import '../data/chat_socket_client.dart';

/// Simple state model for a generic chat room.
class ChatState {
  final bool isConnecting;
  final bool isConnected;
  final List<dynamic>
      messages; // Replace `dynamic` with a proper DTO if desired.
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
    List<dynamic>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier that manages a generic chat room via [ChatSocketClient].
class ChatNotifier extends StateNotifier<ChatState> {
  final SocketService _socketService;
  final String _roomName;
  final String _incomingEvent;
  final String _outgoingEvent;

  ChatSocketClient? _client;
  StreamSubscription<dynamic>? _messagesSub;

  ChatNotifier({
    required SocketService socketService,
    required String roomName,
    String incomingEvent = 'chat_message',
    String outgoingEvent = 'send_chat_message',
  })  : _socketService = socketService,
        _roomName = roomName,
        _incomingEvent = incomingEvent,
        _outgoingEvent = outgoingEvent,
        super(ChatState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isConnecting: true, errorMessage: null);

    try {
      _client = ChatSocketClient(
        socketService: _socketService,
        roomName: _roomName,
        incomingEvent: _incomingEvent,
        outgoingEvent: _outgoingEvent,
      );

      await _client!.connect();

      _messagesSub = _client!.messages.listen(
        (msg) {
          final updated = List<dynamic>.from(state.messages)..add(msg);
          state = state.copyWith(messages: updated);
        },
        onError: (err, stack) {
          state = state.copyWith(
            errorMessage: 'Error receiving chat messages',
          );
        },
      );

      state = state.copyWith(
        isConnecting: false,
        isConnected: _socketService.isConnected,
      );
    } catch (e) {
      state = state.copyWith(
        isConnecting: false,
        isConnected: false,
        errorMessage: 'Failed to connect to chat',
      );
    }
  }

  /// Sends a message to this chat room.
  ///
  /// Returns true if successfully passed to the socket layer.
  bool sendMessage({
    required String message,
    Map<String, dynamic>? metadata,
  }) {
    if (_client == null) return false;
    return _client!.sendMessage(
      message: message,
      metadata: metadata,
    );
  }

  /// Clears messages in local state (does not affect server).
  void clearMessages() {
    state = state.copyWith(messages: []);
  }

  @override
  void dispose() {
    _messagesSub?.cancel();
    _client?.dispose();
    super.dispose();
  }
}

/// Arguments for [chatProvider].
class ChatProviderArgs {
  final String roomName;
  final String incomingEvent;
  final String outgoingEvent;

  const ChatProviderArgs({
    required this.roomName,
    this.incomingEvent = 'chat_message',
    this.outgoingEvent = 'send_chat_message',
  });

  @override
  bool operator ==(Object other) {
    return other is ChatProviderArgs &&
        other.roomName == roomName &&
        other.incomingEvent == incomingEvent &&
        other.outgoingEvent == outgoingEvent;
  }

  @override
  int get hashCode => Object.hash(roomName, incomingEvent, outgoingEvent);
}

/// Family provider: one chat state per [ChatProviderArgs].
///
/// Example usage:
/// ```dart
/// final state = ref.watch(
///   chatProvider(
///     const ChatProviderArgs(roomName: 'global_chat'),
///   ),
/// );
/// ```
final chatProvider =
    StateNotifierProvider.family<ChatNotifier, ChatState, ChatProviderArgs>(
        (ref, args) {
  final socketService = ref.read(socketServiceProvider);
  final notifier = ChatNotifier(
    socketService: socketService,
    roomName: args.roomName,
    incomingEvent: args.incomingEvent,
    outgoingEvent: args.outgoingEvent,
  );

  ref.onDispose(() {
    notifier.dispose();
  });

  return notifier;
});
