import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/league_chat_api_client.dart';
import '../domain/chat_message.dart';

/// Provider for the league chat API client
final leagueChatApiClientProvider = Provider<LeagueChatApiClient>((ref) {
  return LeagueChatApiClient();
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
    return _fetchMessages(leagueId);
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
      final messageDto = await apiClient.sendChatMessage(
        leagueId: arg,
        message: message,
        messageType: messageType,
      );

      // Add the new message to local state
      state.whenData((messages) {
        state = AsyncValue.data([...messages, messageDto.toDomain()]);
      });
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
