import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/socket/socket_providers.dart';
import '../../../core/services/socket/socket_service.dart';
import '../../chat/application/chat_providers.dart';
import '../data/league_chat_api_client.dart';
import '../data/league_chat_repository.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../auth/data/auth_storage.dart';
import '../../auth/application/auth_notifier.dart';
import '../../../shared/providers/base_chat_notifier.dart';

/// Enhanced ChatNotifier for league chat that loads initial messages
class LeagueChatNotifier extends BaseChatNotifier {
  LeagueChatNotifier({
    required SocketService socketService,
    required int leagueId,
    required LeagueChatApiClient apiClient,
  }) : super(
          socketService: socketService,
          repository: LeagueChatRepository(
            apiClient: apiClient,
            leagueId: leagueId,
          ),
        );
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
