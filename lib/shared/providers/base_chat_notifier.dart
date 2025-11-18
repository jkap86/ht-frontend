import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/services/socket/socket_service.dart';
import '../../features/chat/application/chat_providers.dart';
import '../../features/chat/data/chat_socket_client.dart';
import '../repositories/chat_repository.dart';

/// Base chat notifier that handles common chat logic:
/// - Loading initial messages from API
/// - Setting up socket connection
/// - Listening for new messages
/// - Sending messages
abstract class BaseChatNotifier extends StateNotifier<ChatState> {
  final SocketService socketService;
  final ChatRepository repository;

  ChatSocketClient? _client;
  StreamSubscription<dynamic>? _messagesSub;

  BaseChatNotifier({
    required this.socketService,
    required this.repository,
  }) : super(ChatState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isConnecting: true, errorMessage: null);

    try {
      // Load initial messages from repository
      final messageMaps = await repository.loadMessages();

      state = state.copyWith(messages: messageMaps);

      // Setup socket connection
      _client = ChatSocketClient(
        socketService: socketService,
        roomName: repository.roomName,
        incomingEvent: repository.incomingEvent,
        outgoingEvent: repository.outgoingEvent,
      );

      await _client!.connect();

      // Listen to new messages
      _messagesSub = _client!.messages.listen(
        (msg) {
          final updated = List<Map<String, dynamic>>.from(state.messages)..add(msg);
          state = state.copyWith(messages: updated);
        },
        onError: (err, stack) {
          state = state.copyWith(
            errorMessage: 'Error receiving messages',
          );
        },
      );

      state = state.copyWith(
        isConnecting: false,
        isConnected: socketService.isConnected,
      );
    } catch (e) {
      state = state.copyWith(
        isConnecting: false,
        isConnected: false,
        errorMessage: 'Failed to connect to chat: $e',
      );
    }
  }

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
