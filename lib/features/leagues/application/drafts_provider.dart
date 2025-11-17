import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/drafts_api_client.dart';

/// Provider for the DraftsApiClient
final draftsApiClientProvider = Provider<DraftsApiClient>((ref) {
  return DraftsApiClient();
});

/// Provider for fetching drafts for a specific league
final leagueDraftsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>(
  (ref, leagueId) async {
    final apiClient = ref.watch(draftsApiClientProvider);
    return await apiClient.getLeagueDrafts(leagueId);
  },
);

/// Provider for fetching draft order for a specific draft
/// Takes a tuple of (leagueId, draftId) as the family parameter
final draftOrderProvider = StateNotifierProvider.family<DraftOrderNotifier, AsyncValue<List<Map<String, dynamic>>>, ({int leagueId, int draftId})>(
  (ref, params) {
    final apiClient = ref.watch(draftsApiClientProvider);
    return DraftOrderNotifier(apiClient, params.leagueId, params.draftId);
  },
);

/// Notifier for managing draft operations (create, update, delete)
class DraftsNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final DraftsApiClient _apiClient;
  final int _leagueId;

  DraftsNotifier(this._apiClient, this._leagueId) : super(const AsyncValue.loading()) {
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    state = const AsyncValue.loading();
    try {
      final drafts = await _apiClient.getLeagueDrafts(_leagueId);
      state = AsyncValue.data(drafts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createDraft(Map<String, dynamic> draftData) async {
    try {
      await _apiClient.createDraft(_leagueId, draftData);
      await _loadDrafts(); // Reload drafts after creation
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateDraft(int draftId, Map<String, dynamic> draftData) async {
    try {
      await _apiClient.updateDraft(_leagueId, draftId, draftData);
      await _loadDrafts(); // Reload drafts after update
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteDraft(int draftId) async {
    try {
      await _apiClient.deleteDraft(_leagueId, draftId);
      await _loadDrafts(); // Reload drafts after deletion
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadDrafts();
  }
}

/// Provider for the DraftsNotifier
final draftsNotifierProvider = StateNotifierProvider.family<DraftsNotifier, AsyncValue<List<Map<String, dynamic>>>, int>(
  (ref, leagueId) {
    final apiClient = ref.watch(draftsApiClientProvider);
    return DraftsNotifier(apiClient, leagueId);
  },
);

/// Notifier for managing draft order operations (randomize)
class DraftOrderNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final DraftsApiClient _apiClient;
  final int _leagueId;
  final int _draftId;

  DraftOrderNotifier(this._apiClient, this._leagueId, this._draftId)
      : super(const AsyncValue.loading()) {
    _loadDraftOrder();
  }

  /// Load the draft order
  Future<void> _loadDraftOrder() async {
    state = const AsyncValue.loading();
    try {
      final draftOrder = await _apiClient.getDraftOrder(_leagueId, _draftId);
      state = AsyncValue.data(draftOrder);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Randomize the draft order
  Future<void> randomize() async {
    state = const AsyncValue.loading();
    try {
      final draftOrder = await _apiClient.randomizeDraftOrder(_leagueId, _draftId);
      state = AsyncValue.data(draftOrder);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Reload the current draft order
  Future<void> refresh() async {
    await _loadDraftOrder();
  }
}
