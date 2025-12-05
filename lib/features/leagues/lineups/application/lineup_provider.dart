import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_config_provider.dart';
import '../../../../core/infrastructure/api_client.dart';
import '../data/lineup_api_client.dart';
import '../../../auth/application/auth_notifier.dart';
import '../domain/lineup.dart';

/// Provider for the LineupApiClient
final lineupApiClientProvider = Provider<LineupApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);

  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);

  return LineupApiClient(apiClient: apiClient, storage: storage);
});

/// Provider for fetching lineup for a specific roster/week/season
final lineupProvider = FutureProvider.family<LineupResponse, ({int leagueId, int rosterId, int week, String season})>(
  (ref, params) async {
    final apiClient = ref.watch(lineupApiClientProvider);
    return await apiClient.getLineup(
      leagueId: params.leagueId,
      rosterId: params.rosterId,
      week: params.week,
      season: params.season,
    );
  },
);

/// Edit state for lineup editing
class LineupEditState {
  final List<LineupPlayer> starters;
  final List<LineupPlayer> bench;
  final List<LineupPlayer> ir;
  final LineupPlayer? selectedPlayer;
  final bool isSaving;
  final String? errorMessage;
  final bool hasChanges;

  const LineupEditState({
    required this.starters,
    required this.bench,
    required this.ir,
    this.selectedPlayer,
    this.isSaving = false,
    this.errorMessage,
    this.hasChanges = false,
  });

  LineupEditState copyWith({
    List<LineupPlayer>? starters,
    List<LineupPlayer>? bench,
    List<LineupPlayer>? ir,
    LineupPlayer? selectedPlayer,
    bool? clearSelectedPlayer,
    bool? isSaving,
    String? errorMessage,
    bool? clearError,
    bool? hasChanges,
  }) {
    return LineupEditState(
      starters: starters ?? this.starters,
      bench: bench ?? this.bench,
      ir: ir ?? this.ir,
      selectedPlayer: clearSelectedPlayer == true ? null : (selectedPlayer ?? this.selectedPlayer),
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError == true ? null : (errorMessage ?? this.errorMessage),
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  factory LineupEditState.fromResponse(LineupResponse response) {
    return LineupEditState(
      starters: response.starters,
      bench: response.bench,
      ir: response.ir,
    );
  }
}

/// Notifier for managing lineup editing
class LineupEditNotifier extends StateNotifier<LineupEditState> {
  final LineupApiClient _apiClient;
  final int leagueId;
  final int rosterId;
  final int week;
  final String season;

  LineupEditNotifier({
    required LineupApiClient apiClient,
    required this.leagueId,
    required this.rosterId,
    required this.week,
    required this.season,
    required LineupResponse initialResponse,
  })  : _apiClient = apiClient,
        super(LineupEditState.fromResponse(initialResponse));

  /// Select a player for swapping
  void selectPlayer(LineupPlayer player) {
    // Empty slots (playerId: 0) are never locked
    final isEmpty = player.playerId == 0;

    if (player.isLocked && !isEmpty) {
      state = state.copyWith(
        errorMessage: '${player.playerName}\'s game has started - cannot move',
      );
      return;
    }

    // If no player is selected, select this one
    if (state.selectedPlayer == null) {
      state = state.copyWith(selectedPlayer: player, clearError: true);
      return;
    }

    // If the same player/slot is selected, deselect
    // For empty slots, compare by slot name instead of playerId
    final isSameSelection = isEmpty
        ? state.selectedPlayer!.slot == player.slot
        : state.selectedPlayer!.playerId == player.playerId;

    if (isSameSelection) {
      state = state.copyWith(clearSelectedPlayer: true);
      return;
    }

    // If a different player is selected, try to swap
    _swapPlayers(state.selectedPlayer!, player);
  }

  /// Clear selected player
  void clearSelection() {
    state = state.copyWith(clearSelectedPlayer: true);
  }

  /// Swap two players (handles all swap scenarios including empty slots)
  void _swapPlayers(LineupPlayer player1, LineupPlayer player2) {
    // Check if either player is an empty slot (playerId: 0)
    final isEmpty1 = player1.playerId == 0;
    final isEmpty2 = player2.playerId == 0;

    // Find where each player is - for empty slots, use slot name to identify
    final starter1Index = isEmpty1 && player1.slot != null
        ? state.starters.indexWhere((p) => p.slot == player1.slot)
        : state.starters.indexWhere((p) => p.playerId == player1.playerId);
    final starter2Index = isEmpty2 && player2.slot != null
        ? state.starters.indexWhere((p) => p.slot == player2.slot)
        : state.starters.indexWhere((p) => p.playerId == player2.playerId);
    final bench1Index = state.bench.indexWhere((p) => p.playerId == player1.playerId);
    final bench2Index = state.bench.indexWhere((p) => p.playerId == player2.playerId);

    final isStarter1 = starter1Index >= 0;
    final isStarter2 = starter2Index >= 0;

    // Check for locked players (empty slots are not locked)
    if ((player1.isLocked && !isEmpty1) || (player2.isLocked && !isEmpty2)) {
      state = state.copyWith(
        errorMessage: 'Cannot move players whose games have started',
        clearSelectedPlayer: true,
      );
      return;
    }

    // Validate position eligibility for starter slots
    if (isStarter1 && !isStarter2) {
      // Moving bench player to starter slot (or empty slot selected first)
      final slot = state.starters[starter1Index].slot!;
      if (!isEmpty2 && !PositionEligibility.isEligible(player2.playerPosition, slot)) {
        state = state.copyWith(
          errorMessage: '${player2.playerName} (${player2.playerPosition}) cannot play ${_formatSlotName(slot)}',
          clearSelectedPlayer: true,
        );
        return;
      }
    } else if (!isStarter1 && isStarter2) {
      // Moving starter to bench, bench player to starter slot
      final slot = state.starters[starter2Index].slot!;
      if (!isEmpty1 && !PositionEligibility.isEligible(player1.playerPosition, slot)) {
        state = state.copyWith(
          errorMessage: '${player1.playerName} (${player1.playerPosition}) cannot play ${_formatSlotName(slot)}',
          clearSelectedPlayer: true,
        );
        return;
      }
    } else if (isStarter1 && isStarter2) {
      // Swapping two starters - both need to be eligible for each other's slots
      final slot1 = state.starters[starter1Index].slot!;
      final slot2 = state.starters[starter2Index].slot!;

      if (!isEmpty1 && !PositionEligibility.isEligible(player1.playerPosition, slot2)) {
        state = state.copyWith(
          errorMessage: '${player1.playerName} (${player1.playerPosition}) cannot play ${_formatSlotName(slot2)}',
          clearSelectedPlayer: true,
        );
        return;
      }
      if (!isEmpty2 && !PositionEligibility.isEligible(player2.playerPosition, slot1)) {
        state = state.copyWith(
          errorMessage: '${player2.playerName} (${player2.playerPosition}) cannot play ${_formatSlotName(slot1)}',
          clearSelectedPlayer: true,
        );
        return;
      }
    }

    // Perform the swap
    final newStarters = List<LineupPlayer>.from(state.starters);
    final newBench = List<LineupPlayer>.from(state.bench);

    if (isStarter1 && isStarter2) {
      // Swap two starters (keep their slots)
      final slot1 = newStarters[starter1Index].slot;
      final slot2 = newStarters[starter2Index].slot;
      newStarters[starter1Index] = player2.copyWith(slot: slot1);
      newStarters[starter2Index] = player1.copyWith(slot: slot2);
    } else if (isStarter1 && !isStarter2) {
      // Starter/empty slot to bench, bench to starter
      final slot = newStarters[starter1Index].slot;
      newStarters[starter1Index] = player2.copyWith(slot: slot);
      // Only add to bench if swapped player is not empty
      if (!isEmpty1) {
        newBench[bench2Index] = player1.copyWith(slot: null);
      } else {
        // Removing from bench (filling empty slot)
        newBench.removeAt(bench2Index);
      }
    } else if (!isStarter1 && isStarter2) {
      // Bench to starter, starter/empty slot to bench
      final slot = newStarters[starter2Index].slot;
      newStarters[starter2Index] = player1.copyWith(slot: slot);
      // Only add to bench if swapped player is not empty
      if (!isEmpty2) {
        newBench[bench1Index] = player2.copyWith(slot: null);
      } else {
        // Removing from bench (filling empty slot)
        newBench.removeAt(bench1Index);
      }
    } else {
      // Both on bench - just swap positions
      newBench[bench1Index] = player2;
      newBench[bench2Index] = player1;
    }

    state = state.copyWith(
      starters: newStarters,
      bench: newBench,
      clearSelectedPlayer: true,
      hasChanges: true,
      clearError: true,
    );
  }

  String _formatSlotName(String slot) {
    switch (slot.toUpperCase()) {
      case 'SUPER_FLEX':
        return 'Super Flex';
      case 'FLEX':
        return 'Flex';
      default:
        return slot;
    }
  }

  /// Save lineup changes to backend
  Future<bool> saveLineup() async {
    if (!state.hasChanges) return true;

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      // Convert to StarterSlot format, filtering out empty slots (playerId: 0)
      final starters = state.starters
          .where((p) => p.slot != null && p.playerId > 0)
          .map((p) => StarterSlot(playerId: p.playerId, slot: p.slot!))
          .toList();
      final bench = state.bench.where((p) => p.playerId > 0).map((p) => p.playerId).toList();
      final ir = state.ir.where((p) => p.playerId > 0).map((p) => p.playerId).toList();

      await _apiClient.saveLineup(
        leagueId: leagueId,
        rosterId: rosterId,
        week: week,
        season: season,
        starters: starters,
        bench: bench,
        ir: ir,
      );

      state = state.copyWith(isSaving: false, hasChanges: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  /// Reset to original state
  void reset(LineupResponse response) {
    state = LineupEditState.fromResponse(response);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for lineup editing state
final lineupEditProvider = StateNotifierProvider.family<LineupEditNotifier, LineupEditState, ({int leagueId, int rosterId, int week, String season, LineupResponse initialResponse})>(
  (ref, params) {
    final apiClient = ref.watch(lineupApiClientProvider);
    return LineupEditNotifier(
      apiClient: apiClient,
      leagueId: params.leagueId,
      rosterId: params.rosterId,
      week: params.week,
      season: params.season,
      initialResponse: params.initialResponse,
    );
  },
);
