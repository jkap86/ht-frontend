import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../core/services/socket/socket_providers.dart';
import '../../../core/services/socket/socket_service.dart';
import '../../chat/application/chat_providers.dart';
import '../../chat/data/chat_socket_client.dart';
import '../data/league_chat_api_client.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../auth/data/auth_storage.dart';
import '../../auth/application/auth_notifier.dart';

/// Enhanced ChatNotifier for league chat that loads initial messages
class LeagueChatNotifier extends StateNotifier<ChatState> {
  final SocketService _socketService;
  final String _roomName;
  final int _leagueId;
  final LeagueChatApiClient _apiClient;

  ChatSocketClient? _client;
  StreamSubscription<dynamic>? _messagesSub;

  LeagueChatNotifier({
    required SocketService socketService,
    required int leagueId,
    required LeagueChatApiClient apiClient,
  })  : _socketService = socketService,
        _leagueId = leagueId,
        _roomName = 'league_$leagueId',
        _apiClient = apiClient,
        super(ChatState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isConnecting: true, errorMessage: null);

    try {
      // Load initial messages from API
      final messages = await _apiClient.getChatMessages(_leagueId, limit: 50);

      // Convert DTOs to Map format that the UI expects
      final messageMaps = messages.map((dto) => {
        'id': dto.id,
        'user_id': dto.userId,
        'username': dto.username,
        'message': dto.message,
        'message_type': dto.messageType,
        'metadata': dto.metadata,
        'created_at': dto.createdAt.toIso8601String(),
      }).toList();

      state = state.copyWith(messages: messageMaps);

      // Setup socket connection
      _client = ChatSocketClient(
        socketService: _socketService,
        roomName: _roomName,
        incomingEvent: 'new_message',  // Backend emits 'new_message' for league chat
        outgoingEvent: 'send_league_chat',  // Handler we added to backend
      );

      await _client!.connect();

      _messagesSub = _client!.messages.listen(
        (msg) {
          final updated = List<Map<String, dynamic>>.from(state.messages)..add(msg);
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

/// Adapter provider that wraps the unified ChatNotifier for league chat
/// This maintains backward compatibility with the LeagueChatState interface
/// while using the unified chat system underneath.
///
/// Usage: ref.watch(unifiedLeagueChatProvider(leagueId))
final unifiedLeagueChatProvider = StateNotifierProvider.family<LeagueChatNotifier, ChatState, int>(
  (ref, leagueId) {
    final socketService = ref.read(socketServiceProvider);
    final sharedPreferences = ref.read(sharedPreferencesProvider);

    // Create API client for loading initial messages
    final apiClient = LeagueChatApiClient(
      apiClient: ApiClient(baseUrl: 'http://localhost:5000'),
      storage: AuthStorage(preferences: sharedPreferences),
    );

    final notifier = LeagueChatNotifier(
      socketService: socketService,
      leagueId: leagueId,
      apiClient: apiClient,
    );

    ref.onDispose(() {
      notifier.dispose();
    });

    return notifier;
  },
);
