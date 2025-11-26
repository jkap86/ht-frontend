import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_config_provider.dart';
import '../../../../core/infrastructure/api_client.dart';
import '../data/matchup_drafts_api_client.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../drafts/domain/draft.dart';
import '../../drafts/domain/draft_order_entry.dart';
import '../domain/matchup_draft_room_state.dart';
import 'matchup_draft_room_notifier.dart';
import '../../../../core/services/socket/socket_providers.dart';

/// Provider for the MatchupDraftsApiClient
final matchupDraftsApiClientProvider = Provider<MatchupDraftsApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);

  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);

  return MatchupDraftsApiClient(apiClient: apiClient, storage: storage);
});

/// Provider for matchup draft room state
/// Takes leagueId and draftId as parameters
final matchupDraftRoomProvider = StateNotifierProvider.family<
    MatchupDraftRoomNotifier,
    MatchupDraftRoomState,
    ({int leagueId, int draftId, Draft draft})>(
  (ref, params) {
    final apiClient = ref.watch(matchupDraftsApiClientProvider);
    final socketService = ref.watch(socketServiceProvider);

    return MatchupDraftRoomNotifier(
      apiClient: apiClient,
      socketService: socketService,
      leagueId: params.leagueId,
      draftId: params.draftId,
      initialDraft: params.draft,
    );
  },
);

/// Provider for getting or creating matchup draft for a league
final matchupDraftProvider = FutureProvider.family<Draft, int>(
  (ref, leagueId) async {
    final apiClient = ref.watch(matchupDraftsApiClientProvider);
    return await apiClient.getOrCreateMatchupDraft(leagueId);
  },
);

/// Provider for getting matchup draft order
final matchupDraftOrderProvider = FutureProvider.family<List<DraftOrderEntry>, ({int leagueId, int draftId})>(
  (ref, params) async {
    final apiClient = ref.watch(matchupDraftsApiClientProvider);
    return await apiClient.getMatchupDraftOrder(params.leagueId, params.draftId);
  },
);
