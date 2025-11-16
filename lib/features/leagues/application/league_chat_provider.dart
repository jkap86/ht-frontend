import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/league_chat_api_client.dart';
import '../data/socket_service.dart';
import '../domain/chat_message.dart';

/// Provider for the league chat API client
final leagueChatApiClientProvider = Provider<LeagueChatApiClient>((ref) {
  return LeagueChatApiClient();
});

/// Provider for the socket service (keepAlive to maintain single instance)
final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  // Keep the socket service alive even when no providers are listening
  ref.keepAlive();
  return service;
});

/// Family provider for league chat messages
/// Each league has its own chat instance
final leagueChatProvider = AsyncNotifierProvider.family<LeagueChatNotifier, List<ChatMessage>, int>(() {
  return LeagueChatNotifier();
});

class LeagueChatNotifier extends FamilyAsyncNotifier<List<ChatMessage>, int> {
  @override
  Future<List<ChatMessage>> build(int leagueId) async {
    // Initial load of chat messages for this league
    final messages = await _fetchMessages(leagueId);

    // Set up WebSocket connection and listeners
    _setupWebSocket(leagueId);

    return messages;
  }

  Future<void> _setupWebSocket(int leagueId) async {
    try {
      final socketService = ref.read(socketServiceProvider);

      // Connect to WebSocket if not already connected
      if (!socketService.isConnected) {
        print('[LeagueChatNotifier] Socket not connected, connecting...');
        await socketService.connect();
        // Wait a bit for the connection to be fully established
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Verify connection before joining
      if (!socketService.isConnected) {
        throw Exception('Failed to establish WebSocket connection');
      }

      print('[LeagueChatNotifier] Socket connected, joining league $leagueId');
      // Join the league chat room
      socketService.joinLeague(leagueId);

      // Listen for new messages
      socketService.onNewMessage((messageDto) {
        print('[LeagueChatNotifier] Received message from WebSocket, adding to state');
        final message = messageDto.toDomain();
        addMessage(message);
      });
      print('[LeagueChatNotifier] WebSocket setup complete for league $leagueId');
    } catch (e) {
      // Log error but don't fail the initial load
      print('[LeagueChatNotifier] Failed to set up WebSocket: $e');
    }
  }


  Future<List<ChatMessage>> _fetchMessages(int leagueId, {int limit = 100}) async {
    final apiClient = ref.read(leagueChatApiClientProvider);
    final dtos = await apiClient.getChatMessages(leagueId, limit: limit);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  /// Refresh the chat messages
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMessages(arg));
  }

  /// Send a new message
  Future<void> sendMessage(String message, {String messageType = 'chat'}) async {
    final apiClient = ref.read(leagueChatApiClientProvider);

    try {
      // Send the message via API
      // The WebSocket will handle adding it to the local state
      await apiClient.sendChatMessage(
        leagueId: arg,
        message: message,
        messageType: messageType,
      );
    } catch (e) {
      // If sending fails, refresh to get the latest state
      await refresh();
      rethrow;
    }
  }

  /// Add a message to the local state (e.g., from a real-time update)
  void addMessage(ChatMessage message) {
    state.whenData((messages) {
      // Check if message already exists (avoid duplicates)
      final exists = messages.any((m) => m.id == message.id);
      if (!exists) {
        state = AsyncValue.data([...messages, message]);
      }
    });
  }
}
