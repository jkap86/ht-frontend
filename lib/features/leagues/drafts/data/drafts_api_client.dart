import '../../../../core/infrastructure/api_client.dart';
import '../../../players/domain/player.dart';
import '../../../auth/data/auth_storage.dart';
import '../domain/draft.dart';
import '../domain/draft_pick.dart';
import '../domain/draft_queue.dart';

import 'draft_config_api_client.dart';
import 'draft_room_api_client.dart';
import 'draft_derby_api_client.dart';
import 'draft_queue_api_client.dart';

/// Main DraftsApiClient facade - delegates to specialized clients
/// This maintains backward compatibility while using split clients internally
class DraftsApiClient {
  final DraftConfigApiClient _configClient;
  final DraftRoomApiClient _roomClient;
  final DraftDerbyApiClient _derbyClient;
  final DraftQueueApiClient _queueClient;

  DraftsApiClient({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _configClient = DraftConfigApiClient(apiClient: apiClient, storage: storage),
        _roomClient = DraftRoomApiClient(apiClient: apiClient, storage: storage),
        _derbyClient = DraftDerbyApiClient(apiClient: apiClient, storage: storage),
        _queueClient = DraftQueueApiClient(apiClient: apiClient, storage: storage);

  // ========== Config Operations - Delegate to DraftConfigApiClient ==========

  Future<List<Draft>> getLeagueDrafts(int leagueId) {
    return _configClient.getLeagueDrafts(leagueId);
  }

  Future<Draft> createDraft(int leagueId, Map<String, dynamic> draftData) {
    return _configClient.createDraft(leagueId, draftData);
  }

  Future<Draft> updateDraft(int leagueId, int draftId, Map<String, dynamic> draftData) {
    return _configClient.updateDraft(leagueId, draftId, draftData);
  }

  Future<void> deleteDraft(int leagueId, int draftId) {
    return _configClient.deleteDraft(leagueId, draftId);
  }

  Future<List<Map<String, dynamic>>> getDraftOrder(int leagueId, int draftId) {
    return _configClient.getDraftOrder(leagueId, draftId);
  }

  Future<List<Map<String, dynamic>>> randomizeDraftOrder(int leagueId, int draftId) {
    return _configClient.randomizeDraftOrder(leagueId, draftId);
  }

  // ========== Room Operations - Delegate to DraftRoomApiClient ==========

  Future<Draft> getDraftState(int leagueId, int draftId) {
    return _roomClient.getDraftState(leagueId, draftId);
  }

  Future<Map<String, dynamic>> getFullDraftState(int leagueId, int draftId) {
    return _roomClient.getFullDraftState(leagueId, draftId);
  }

  Future<List<Player>> getAvailablePlayers(int leagueId, int draftId) {
    return _roomClient.getAvailablePlayers(leagueId, draftId);
  }

  Future<List<DraftPick>> getDraftPicks(int leagueId, int draftId) {
    return _roomClient.getDraftPicks(leagueId, draftId);
  }

  /// Get draft picks with stats for a specific week (for matchup display)
  Future<List<DraftPick>> getDraftPicksWithStats(int leagueId, int draftId, int week, {String? season}) {
    return _roomClient.getDraftPicksWithStats(leagueId, draftId, week, season: season);
  }

  Future<DraftPick> makePick(int leagueId, int draftId, int playerId) {
    return _roomClient.makePick(leagueId, draftId, playerId);
  }

  Future<Draft> startDraft(int leagueId, int draftId) {
    return _roomClient.startDraft(leagueId, draftId);
  }

  Future<Draft> pauseDraft(int leagueId, int draftId) {
    return _roomClient.pauseDraft(leagueId, draftId);
  }

  Future<Draft> resumeDraft(int leagueId, int draftId) {
    return _roomClient.resumeDraft(leagueId, draftId);
  }

  Future<Map<String, dynamic>> toggleAutopick(int leagueId, int draftId, int rosterId) {
    return _roomClient.toggleAutopick(leagueId, draftId, rosterId);
  }

  // ========== Derby Operations - Delegate to DraftDerbyApiClient ==========

  Future<Draft> startDerby(int leagueId, int draftId) {
    return _derbyClient.startDerby(leagueId, draftId);
  }

  Future<Draft> pickDerbySlot(int leagueId, int draftId, int slotNumber) {
    return _derbyClient.pickDerbySlot(leagueId, draftId, slotNumber);
  }

  Future<Draft> pauseDerby(int leagueId, int draftId) {
    return _derbyClient.pauseDerby(leagueId, draftId);
  }

  Future<Draft> resumeDerby(int leagueId, int draftId) {
    return _derbyClient.resumeDerby(leagueId, draftId);
  }

  // ========== Queue Operations - Delegate to DraftQueueApiClient ==========

  Future<List<DraftQueue>> getQueue(int leagueId, int draftId) {
    return _queueClient.getQueue(leagueId, draftId);
  }

  Future<DraftQueue> addToQueue(int leagueId, int draftId, int playerId) {
    return _queueClient.addToQueue(leagueId, draftId, playerId);
  }

  Future<void> removeFromQueue(int leagueId, int draftId, int queueId) {
    return _queueClient.removeFromQueue(leagueId, draftId, queueId);
  }

  Future<void> reorderQueue(int leagueId, int draftId, List<Map<String, int>> updates) {
    return _queueClient.reorderQueue(leagueId, draftId, updates);
  }
}
