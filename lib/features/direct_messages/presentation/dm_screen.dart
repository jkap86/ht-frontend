import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_config_provider.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../auth/application/auth_notifier.dart';
import '../data/dm_api_client.dart';
import 'widgets/dm_conversations_list.dart';

/// Provider for the DmApiClient
final dmApiClientProvider = Provider<DmApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);

  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);

  return DmApiClient(apiClient: apiClient, storage: storage);
});

/// Provider for fetching DM conversations for the current user.
/// Returns a list of conversation objects compatible with DmConversationsList.
final dmConversationsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiClient = ref.watch(dmApiClientProvider);
  final currentUserId = ref.watch(authProvider).user?.userId;

  if (currentUserId == null) {
    return [];
  }

  final conversations = await apiClient.getConversations();

  // Transform DTOs to the format expected by DmConversationsList
  return conversations.map((convo) {
    final dto = convo.toDomain();

    // Create proper conversation ID by sorting both user IDs
    final ids = [currentUserId, dto.otherUserId]..sort();
    final conversationId = '${ids[0]}_${ids[1]}';

    return {
      'conversationId': conversationId,
      'otherUserId': dto.otherUserId,
      'otherUsername': dto.otherUsername,
      'lastMessage': dto.lastMessage,
      'lastMessageAt': dto.lastMessageTime.toIso8601String(),
      'last_message_at': dto.lastMessageTime.toIso8601String(),
      'unreadCount': dto.unreadCount,
    };
  }).toList();
});

/// Main Direct Messages screen.
///
/// Shows a list of conversations. Tapping on a row navigates to the
/// [DmConversationView] for that conversation (handled inside
/// [DmConversationsList] by default).
class DmScreen extends ConsumerWidget {
  const DmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(dmConversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Messages'),
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          return DmConversationsList(
            conversations: conversations,
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load conversations:\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}
