import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/chat/chat_provider_args.dart';
import '../../../core/chat/chat_socket_client.dart';
import '../../../core/chat/chat_state.dart';
import '../../../core/services/socket/socket_providers.dart';
import '../../../core/services/socket/socket_service.dart';

/// Simple notifier that manages a generic chat room using [ChatSocketClient].
///
/// This is deliberately lightweight and does **not** know about leagues or DMs.
/// Those should use their own notifiers (e.g. LeagueChatNotifier,
/// UnifiedDmChatNotifier) built on top of [BaseChatNotifier].
class ChatNotifier extends StateNotifier<ChatState> {
  final SocketService socketService;
  final ChatSocketClient _client;

  StreamSubscription<Map<String, dynamic>>? _sub;

  ChatNotifier({
    required this.socketService,
    required String roomName,
    String incomingEvent = 'chat_message',
    String outgoingEvent = 'send_chat_message',
  })  : _client = ChatSocketClient(
          socketService: socketService,
          roomName: roomName,
          incomingEvent: incomingEvent,
          outgoingEvent: outgoingEvent,
        ),
        super(ChatState.initial()) {
    _init();
  }

  Future<void> _init() async {
    try {
      state = state.copyWith(isConnecting: true, errorMessage: null);

      await _client.connect();

      _sub = _client.messagesStream.listen((message) {
        final updated = List<Map<String, dynamic>>.from(state.messages)
          ..add(message);
        state = state.copyWith(
          isConnecting: false,
          isConnected: true,
          messages: updated,
        );
      });

      state = state.copyWith(
        isConnecting: false,
        isConnected: true,
      );
    } catch (e) {
      state = state.copyWith(
        isConnecting: false,
        isConnected: false,
        errorMessage: 'Failed to connect: $e',
      );
    }
  }

  Future<void> sendMessage(Map<String, dynamic> payload) async {
    try {
      await _client.sendMessage(payload);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to send message: $e',
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _client.dispose();
    super.dispose();
  }
}

/// Family provider: one [ChatNotifier] per [ChatProviderArgs].
///
/// Example:
///   final state = ref.watch(
///     chatProvider(
///       const ChatProviderArgs(roomName: 'global_chat'),
///     ),
///   );
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

    ref.onDispose(notifier.dispose);

    return notifier;
  },
);
