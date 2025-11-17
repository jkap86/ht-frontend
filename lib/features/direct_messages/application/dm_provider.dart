import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../leagues/application/league_chat_provider.dart';
import '../data/dm_api_client.dart';
import '../data/dm_socket_client.dart';
import '../domain/direct_message.dart';
import '../domain/conversation.dart';
import '../../auth/application/auth_notifier.dart';

/// Provider for the DM API client
final dmApiClientProvider = Provider<DmApiClient>((ref) {
  final storage = ref.watch(authStorageProvider);
  return DmApiClient(storage: storage);
});

/// Provider for the DM-specific socket client
final dmSocketClientProvider = Provider<DmSocketClient>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return DmSocketClient(socketService);
});

/// Provider for the list of conversations
final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final apiClient = ref.read(dmApiClientProvider);
  final dtos = await apiClient.getConversations();
  return dtos.map((dto) => dto.toDomain()).toList();
});

/// Family provider for direct messages with a specific user
/// Each conversation has its own DM instance
final dmConversationProvider = AsyncNotifierProvider.family<DmConversationNotifier, List<DirectMessage>, String>(() {
  return DmConversationNotifier();
});

class DmConversationNotifier extends FamilyAsyncNotifier<List<DirectMessage>, String> {
  @override
  Future<List<DirectMessage>> build(String otherUserId) async {
    // Initial load of messages for this conversation
    final messages = await _fetchMessages(otherUserId);

    // Set up WebSocket connection and listeners
    _setupWebSocket(otherUserId);

    return messages;
  }

  Future<void> _setupWebSocket(String otherUserId) async {
    try {
      final socketService = ref.read(socketServiceProvider);
      final dmSocketClient = ref.read(dmSocketClientProvider);

      // Connect to WebSocket if not already connected
      if (!socketService.isConnected) {
        print('[DmConversationNotifier] Socket not connected, connecting...');
        await socketService.connect();
        // Wait a bit for the connection to be fully established
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Verify connection before joining
      if (!socketService.isConnected) {
        throw Exception('Failed to establish WebSocket connection');
      }

      // Get current user ID to create conversation ID
      final currentUserId = await _getCurrentUserId();
      final conversationId = _createConversationId(currentUserId, otherUserId);

      print('[DmConversationNotifier] Socket connected, joining conversation $conversationId');
      // Join the DM conversation room
      dmSocketClient.joinConversation(conversationId);

      // Listen for new direct messages
      dmSocketClient.onNewDirectMessage((messageDto) {
        print('[DmConversationNotifier] Received message from WebSocket, adding to state');
        final message = messageDto.toDomain();
        // Only add if this message is part of this conversation
        if (message.senderId == otherUserId || message.receiverId == otherUserId) {
          addMessage(message);
        }
      });
      print('[DmConversationNotifier] WebSocket setup complete for conversation with $otherUserId');
    } catch (e) {
      // Log error but don't fail the initial load
      print('[DmConversationNotifier] Failed to set up WebSocket: $e');
    }
  }

  Future<String> _getCurrentUserId() async {
    // This would ideally come from auth state
    // For now, we can infer it from the messages
    final apiClient = ref.read(dmApiClientProvider);
    final messages = await apiClient.getMessages(arg, limit: 1);
    if (messages.isNotEmpty) {
      final msg = messages.first;
      return msg.senderId == arg ? msg.receiverId : msg.senderId;
    }
    throw Exception('Cannot determine current user ID');
  }

  /// Create a consistent conversation ID from two user IDs (sorted)
  String _createConversationId(String userId1, String userId2) {
    final sorted = [userId1, userId2]..sort();
    return sorted.join('_');
  }

  Future<List<DirectMessage>> _fetchMessages(String otherUserId, {int limit = 100}) async {
    final apiClient = ref.read(dmApiClientProvider);
    final dtos = await apiClient.getMessages(otherUserId, limit: limit);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  /// Refresh the messages
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMessages(arg));
  }

  /// Send a new message
  Future<void> sendMessage(String message) async {
    final apiClient = ref.read(dmApiClientProvider);

    try {
      // Send the message via API
      // The WebSocket will handle adding it to the local state
      await apiClient.sendMessage(
        receiverId: arg,
        message: message,
      );
    } catch (e) {
      // If sending fails, refresh to get the latest state
      await refresh();
      rethrow;
    }
  }

  /// Add a message to the local state (e.g., from a real-time update)
  void addMessage(DirectMessage message) {
    state.whenData((messages) {
      // Check if message already exists (avoid duplicates)
      final exists = messages.any((m) => m.id == message.id);
      if (!exists) {
        state = AsyncValue.data([...messages, message]);
      }
    });
  }
}
