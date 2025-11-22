import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/drafts_api_client.dart';
import '../domain/queue_state.dart';
import '../domain/draft_queue.dart';

/// Notifier for managing draft queue state
class QueueNotifier extends StateNotifier<QueueState> {
  final DraftsApiClient _apiClient;
  final int _leagueId;
  final int _draftId;

  QueueNotifier({
    required DraftsApiClient apiClient,
    required int leagueId,
    required int draftId,
  })  : _apiClient = apiClient,
        _leagueId = leagueId,
        _draftId = draftId,
        super(const QueueState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadQueue();
  }

  /// Load the queue from the server
  Future<void> loadQueue() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final queue = await _apiClient.getQueue(_leagueId, _draftId);
      state = state.copyWith(
        items: queue,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add a player to the queue
  Future<void> addToQueue(int playerId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final queueEntry = await _apiClient.addToQueue(_leagueId, _draftId, playerId);

      // Add to queue list
      final updatedQueue = [...state.items, queueEntry];

      state = state.copyWith(
        items: updatedQueue,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Remove a player from the queue
  Future<void> removeFromQueue(int queueId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiClient.removeFromQueue(_leagueId, _draftId, queueId);

      // Remove from queue list
      final updatedQueue = state.items.where((q) => q.id != queueId).toList();

      state = state.copyWith(
        items: updatedQueue,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Reorder queue items
  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    // Optimistically update UI
    final queue = List<DraftQueue>.from(state.items);
    final item = queue.removeAt(oldIndex);
    queue.insert(newIndex, item);

    // Update positions
    final updates = <Map<String, int>>[];
    for (int i = 0; i < queue.length; i++) {
      updates.add({
        'id': queue[i].id,
        'queuePosition': i + 1,
      });
    }

    // Update local state immediately for smooth UI
    state = state.copyWith(items: queue);

    try {
      await _apiClient.reorderQueue(_leagueId, _draftId, updates);
    } catch (e) {
      // Reload queue on error to get correct state
      await loadQueue();
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Remove a player from queue by player ID (called when player is picked)
  void removePlayerFromQueue(int playerId) {
    final updatedQueue = state.items
        .where((q) => q.playerId != playerId)
        .toList();

    state = state.copyWith(items: updatedQueue);
  }

  /// Check if a player is in the queue
  bool isPlayerInQueue(int playerId) {
    return state.items.any((q) => q.playerId == playerId);
  }
}
