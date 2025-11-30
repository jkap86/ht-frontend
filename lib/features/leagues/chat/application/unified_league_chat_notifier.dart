import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_config_provider.dart';
import '../../../../core/chat/base_chat_notifier.dart';
import '../../../../core/chat/chat_state.dart';
import '../../../../core/infrastructure/api_client.dart';
import '../../../../core/services/socket/socket_providers.dart';
import '../../../auth/application/auth_notifier.dart';
import '../data/league_chat_api_client.dart';
import '../data/league_chat_repository.dart';

/// League-specific chat notifier that:
/// - Loads initial league messages from the REST API
/// - Connects to the league chat Socket.IO room
/// - Listens for new league chat messages
class LeagueChatNotifier extends BaseChatNotifier {
  final int leagueId;

  LeagueChatNotifier({
    required super.socketService,
    required LeagueChatRepository super.repository,
    required this.leagueId,
  }) {
    // Kick off initial load + socket wiring
    initialize();
  }

  @override
  void onMessageReceived(Map<String, dynamic> message) {
    // You can customize how league messages are merged here if needed.
    // For now, just use the base behavior (append to list).
    super.onMessageReceived(message);
  }
}

/// Family provider: one LeagueChatNotifier per leagueId.
///
/// Usage:
///   final chatState = ref.watch(leagueChatNotifierProvider(leagueId));
final leagueChatNotifierProvider =
    StateNotifierProvider.family<LeagueChatNotifier, ChatState, int>(
  (ref, leagueId) {
    final config = ref.watch(appConfigProvider);
    final socketService = ref.read(socketServiceProvider);

    // SharedPreferences + AuthStorage wiring
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final authStorage = ref.read(authStorageProvider);

    // Avoid "unused" hints for now – you might use these later for
    // local caching, unread counts, etc.
    final _ = sharedPreferences;

    final apiClient = ApiClient(
      baseUrl: config.apiBaseUrl,
    );

    final leagueApiClient = LeagueChatApiClient(
      apiClient: apiClient,
      storage: authStorage,
    );

    final repository = LeagueChatRepository(
      apiClient: leagueApiClient,
      leagueId: leagueId,
    );

    final notifier = LeagueChatNotifier(
      socketService: socketService,
      repository: repository,
      leagueId: leagueId,
    );

    ref.onDispose(notifier.dispose);

    return notifier;
  },
);
