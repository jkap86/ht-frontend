import '../../../../core/infrastructure/api_client.dart';
import '../../../auth/data/auth_storage.dart';
import '../../drafts/domain/draft.dart';
import '../../drafts/domain/draft_order_entry.dart';
import '../domain/matchup_draft_pick.dart';
import '../domain/available_matchup.dart';

import 'matchup_draft_config_api_client.dart';
import 'matchup_draft_room_api_client.dart';

/// Main MatchupDraftsApiClient facade - delegates to specialized clients
/// This maintains backward compatibility while using split clients internally
class MatchupDraftsApiClient {
  final MatchupDraftConfigApiClient _configClient;
  final MatchupDraftRoomApiClient _roomClient;

  MatchupDraftsApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _configClient = MatchupDraftConfigApiClient(apiClient: apiClient, storage: storage),
        _roomClient = MatchupDraftRoomApiClient(apiClient: apiClient, storage: storage);

  // ========== Config Operations - Delegate to MatchupDraftConfigApiClient ==========

  Future<Draft> getOrCreateMatchupDraft(int leagueId) {
    return _configClient.getOrCreateMatchupDraft(leagueId);
  }

  Future<Draft> getMatchupDraft(int leagueId, int draftId) {
    return _configClient.getMatchupDraft(leagueId, draftId);
  }

  Future<List<DraftOrderEntry>> getMatchupDraftOrder(int leagueId, int draftId) {
    return _configClient.getMatchupDraftOrder(leagueId, draftId);
  }

  Future<List<DraftOrderEntry>> randomizeMatchupDraftOrder(int leagueId, int draftId) {
    return _configClient.randomizeMatchupDraftOrder(leagueId, draftId);
  }

  Future<Map<String, dynamic>> generateRandomMatchups(int leagueId) {
    return _configClient.generateRandomMatchups(leagueId);
  }

  // ========== Room Operations - Delegate to MatchupDraftRoomApiClient ==========

  Future<Draft> startMatchupDraft(int leagueId, int draftId) {
    return _roomClient.startMatchupDraft(leagueId, draftId);
  }

  Future<Draft> pauseMatchupDraft(int leagueId, int draftId) {
    return _roomClient.pauseMatchupDraft(leagueId, draftId);
  }

  Future<Draft> resumeMatchupDraft(int leagueId, int draftId) {
    return _roomClient.resumeMatchupDraft(leagueId, draftId);
  }

  Future<MatchupDraftPick> makeMatchupPick(
    int leagueId,
    int draftId,
    int opponentRosterId,
    int weekNumber,
  ) {
    return _roomClient.makeMatchupPick(leagueId, draftId, opponentRosterId, weekNumber);
  }

  Future<List<AvailableMatchup>> getAvailableMatchups(int leagueId, int draftId) {
    return _roomClient.getAvailableMatchups(leagueId, draftId);
  }

  Future<List<MatchupDraftPick>> getMatchupDraftPicks(int leagueId, int draftId) {
    return _roomClient.getMatchupDraftPicks(leagueId, draftId);
  }
}
