import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/socket/socket_providers.dart';
import '../domain/chat_message.dart';
import '../domain/chat_room.dart';
import 'chat_providers.dart';
import '../../auth/application/auth_notifier.dart';

/// Family provider for chat rooms
/// Each room (league or DM conversation) has its own instance
final chatRoomProvider = AsyncNotifierProvider.family<ChatRoomNotifier, List<ChatMessage>, ChatRoom>(() {
  return ChatRoomNotifier();
});

class ChatRoomNotifier extends FamilyAsyncNotifier<List<ChatMessage>, ChatRoom> {
  @override
  Future<List<ChatMessage>> build(ChatRoom arg) async {
    // Initial load of messages for this room
    final messages = await _fetchMessages(arg);

    // Set up WebSocket connection and listeners
    _setupWebSocket(arg);

    return messages;
  }

  Future<void> _setupWebSocket(ChatRoom room) async {
    try {
      final socketService = ref.read(socketServiceProvider);
      final chatSocketClient = ref.read(chatSocketClientProvider);

      // Connect to WebSocket if not already connected
      if (!socketService.isConnected) {
        print('[ChatRoomNotifier] Socket not connected, connecting...');
        await socketService.connect();
        // Wait a bit for the connection to be fully established
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Verify connection before joining
      if (!socketService.isConnected) {
        throw Exception('Failed to establish WebSocket connection');
      }

      // For DMs, we need to compute the conversation ID (sorted user IDs)
      // room.id is the other user's ID, so we need to get current user's ID
      String roomIdForSocket = room.id;
      if (room.type == ChatRoomType.directMessage) {
        final currentUserId = await _getCurrentUserId();
        final conversationId = _createConversationId(currentUserId, room.id);
        roomIdForSocket = conversationId;
        print('[ChatRoomNotifier] Computed conversationId: $conversationId for DM with ${room.id}');
      }

      print('[ChatRoomNotifier] Socket connected, joining room $roomIdForSocket');
      // Join the chat room (league or DM)
      chatSocketClient.joinRoom(roomIdForSocket, room.type);

      // Listen for new messages based on room type
      if (room.type == ChatRoomType.league) {
        chatSocketClient.onLeagueMessage((message) {
          print('[ChatRoomNotifier] Received league message from WebSocket, adding to state');
          if (message.roomId == room.id) {
            addMessage(message);
          }
        });
      } else {
        chatSocketClient.onDirectMessage((message) {
          print('[ChatRoomNotifier] Received DM from WebSocket for room ${room.id}');
          // For DMs, we don't check roomId since we join a specific conversation
          // and the WebSocket will only send us messages for that conversation.
          // The message roomId may differ from room.id due to sorted user IDs vs otherUserId.
          // Instead, normalize the message roomId to match our convention (otherUserId)
          final normalizedMessage = message.copyWith(roomId: room.id);
          addMessage(normalizedMessage);
        });
      }

      print('[ChatRoomNotifier] WebSocket setup complete for room ${room.id}');
    } catch (e) {
      // Log error but don't fail the initial load
      print('[ChatRoomNotifier] Failed to set up WebSocket: $e');
    }
  }

  Future<List<ChatMessage>> _fetchMessages(ChatRoom room, {int limit = 100}) async {
    final repository = ref.read(chatRepositoryProvider);

    if (room.type == ChatRoomType.league) {
      return await repository.fetchLeagueMessages(room.id, limit: limit);
    } else {
      return await repository.fetchDirectMessages(room.id, limit: limit);
    }
  }

  /// Refresh the chat messages
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMessages(arg));
  }

  /// Send a new message
  Future<void> sendMessage(String message, {String messageType = 'chat'}) async {
    final repository = ref.read(chatRepositoryProvider);

    try {
      // Send the message via API
      // The WebSocket will handle adding it to the local state
      if (arg.type == ChatRoomType.league) {
        await repository.sendLeagueMessage(
          leagueId: arg.id,
          message: message,
          messageType: messageType,
        );
      } else {
        await repository.sendDirectMessage(
          receiverId: arg.id,
          message: message,
        );
      }
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

  /// Leave the chat room
  void leaveRoom() {
    final socketClient = ref.read(chatSocketClientProvider);
    socketClient.leaveRoom(arg.id, arg.type);

    // Remove listeners
    if (arg.type == ChatRoomType.league) {
      socketClient.offLeagueMessage();
    } else {
      socketClient.offDirectMessage();
    }
  }

  /// Get the current user's ID from auth state
  Future<String> _getCurrentUserId() async {
    final authState = ref.read(authProvider);
    if (authState.user == null) {
      throw Exception('User not authenticated');
    }
    return authState.user!.userId;
  }

  /// Create a consistent conversation ID from two user IDs (sorted)
  String _createConversationId(String userId1, String userId2) {
    final sorted = [userId1, userId2]..sort();
    return sorted.join('_');
  }
}
