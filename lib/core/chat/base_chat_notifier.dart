import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../services/socket/socket_service.dart';
import 'chat_repository.dart';
import 'chat_socket_client.dart';
import 'chat_state.dart';

/// Base chat notifier that handles common chat logic:
/// - Loading initial messages from API
/// - Setting up socket connection
/// - Listening for new messages
/// - Sending messages
///
/// Feature-specific notifiers (league chat, DMs, global chat, etc.)
/// should extend this and provide a concrete [ChatRepository].
abstract class BaseChatNotifier extends StateNotifier<ChatState> {
  final SocketService socketService;
  final ChatRepository repository;

  ChatSocketClient? _client;
  StreamSubscription<Map<String, dynamic>>? _messagesSub;

  BaseChatNotifier({
    required this.socketService,
    required this.repository,
  }) : super(ChatState.initial());

  String get _roomName => repository.roomName;
  String get _incomingEvent => repository.incomingEvent;
  String get _outgoingEvent => repository.outgoingEvent;

  /// Call once after construction to:
  /// - load initial messages
  /// - connect to the socket room
  /// - attach socket listeners
  Future<void> initialize() async {
    await _loadInitialMessages();
    await _connectSocket();
  }

  Future<void> _loadInitialMessages() async {
    try {
      state = state.copyWith(isConnecting: true, errorMessage: null);

      final messages = await repository.loadMessages();
      state = state.copyWith(
        isConnecting: false,
        messages: messages,
      );
    } catch (e) {
      state = state.copyWith(
        isConnecting: false,
        errorMessage: 'Failed to load messages: $e',
      );
    }
  }

  Future<void> _connectSocket() async {
    try {
      final client = ChatSocketClient(
        socketService: socketService,
        roomName: _roomName,
        incomingEvent: _incomingEvent,
        outgoingEvent: _outgoingEvent,
      );

      await client.connect();

      _client = client;
      _messagesSub = client.messagesStream.listen(_handleIncomingMessage);

      // Only mark as connected after listeners are fully attached - this is safe to send messages now
      state = state.copyWith(isConnected: true);
    } catch (e) {
      state = state.copyWith(
        isConnected: false,
        errorMessage: 'Failed to connect to chat: $e',
      );
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> message) {
    onMessageReceived(message);
  }

  /// How to merge a single incoming message into the state.
  ///
  /// Subclasses can override this for custom mapping/ordering logic
  /// (e.g. sort by timestamp, tag messages as mine/theirs, etc.).
  @protected
  void onMessageReceived(Map<String, dynamic> message) {
    final updated = List<Map<String, dynamic>>.from(state.messages)
      ..add(message);
    state = state.copyWith(messages: updated);
  }

  /// Sends a message into this chat room.
  Future<void> sendMessage(Map<String, dynamic> payload) async {
    if (!state.isConnected || _client == null) {
      return;
    }

    await _client?.sendMessage(payload);
  }

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
