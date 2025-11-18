import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../core/services/socket/socket_providers.dart';
import '../../../core/services/socket/socket_service.dart';
import '../../chat/application/chat_providers.dart';
import '../../chat/data/chat_socket_client.dart';
import '../data/dm_api_client.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../auth/data/auth_storage.dart';
import '../../auth/application/auth_notifier.dart';

/// Arguments for [unifiedDmChatProvider].
class UnifiedDmChatProviderArgs {
  final String conversationId;
  final String otherUserId;

  const UnifiedDmChatProviderArgs({
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  bool operator ==(Object other) {
    return other is UnifiedDmChatProviderArgs &&
        other.conversationId == conversationId &&
        other.otherUserId == otherUserId;
  }

  @override
  int get hashCode => Object.hash(conversationId, otherUserId);
}

/// Enhanced ChatNotifier for DM chat that loads initial messages
class DmChatNotifier extends StateNotifier<ChatState> {
  final SocketService _socketService;
  final String _roomName;
  final String _conversationId;
  final String _otherUserId;
  final DmApiClient _apiClient;
  final String _currentUserId;

  ChatSocketClient? _client;
  StreamSubscription<dynamic>? _messagesSub;

  DmChatNotifier({
    required SocketService socketService,
    required String conversationId,
    required String otherUserId,
    required DmApiClient apiClient,
    required String currentUserId,
  })  : _socketService = socketService,
        _conversationId = conversationId,
        _otherUserId = otherUserId,
        _roomName = 'dm_$conversationId',
        _apiClient = apiClient,
        _currentUserId = currentUserId,
        super(ChatState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isConnecting: true, errorMessage: null);

    try {
      // Load initial messages from API
      final messages = await _apiClient.getMessages(_otherUserId, limit: 50);

      // Convert DTOs to Map format that the UI expects
      final messageMaps = messages.map((dto) => {
        'id': dto.id,
        'sender_id': dto.senderId,
        'receiver_id': dto.receiverId,
        'sender_username': dto.senderUsername,
        'receiver_username': dto.receiverUsername,
        'message': dto.message,
        'metadata': dto.metadata,
        'read': dto.read,
        'created_at': dto.createdAt.toIso8601String(),
      }).toList();

      state = state.copyWith(messages: messageMaps);

      // Setup socket connection
      _client = ChatSocketClient(
        socketService: _socketService,
        roomName: _roomName,
        incomingEvent: 'new_dm',
        outgoingEvent: 'send_dm',
      );

      await _client!.connect();

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
        isConnected: _socketService.isConnected,
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

/// Adapter provider that wraps the unified ChatNotifier for direct messages
/// This maintains backward compatibility with the DmChatState interface
/// while using the unified chat system underneath.
///
/// Usage: ref.watch(unifiedDmChatProvider(UnifiedDmChatProviderArgs(...)))
final unifiedDmChatProvider = StateNotifierProvider.family<DmChatNotifier, ChatState, UnifiedDmChatProviderArgs>(
  (ref, args) {
    final socketService = ref.read(socketServiceProvider);
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final authState = ref.read(authProvider);

    final currentUserId = authState.user?.userId;
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // Create API client for loading initial messages
    final apiClient = DmApiClient(
      apiClient: ApiClient(baseUrl: 'http://localhost:5000'),
      storage: AuthStorage(preferences: sharedPreferences),
    );

    final notifier = DmChatNotifier(
      socketService: socketService,
      conversationId: args.conversationId,
      otherUserId: args.otherUserId,
      apiClient: apiClient,
      currentUserId: currentUserId,
    );

    ref.onDispose(() {
      notifier.dispose();
    });

    return notifier;
  },
);
