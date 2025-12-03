import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../players/domain/player.dart';
import 'draft.dart';
import 'draft_pick.dart';
import 'draft_order_entry.dart';

part 'draft_room_state.freezed.dart';

enum PlayerSortField { name, lastYear, ytd, proj }

@freezed
class DraftRoomState with _$DraftRoomState {
  const DraftRoomState._();

  const factory DraftRoomState({
    required Draft draft,
    @Default([]) List<Player> availablePlayers,
    @Default([]) List<DraftPick> picks,
    @Default([]) List<DraftOrderEntry> draftOrder,
    @Default(false) bool isLoading,
    @Default(false) bool isConnected,
    String? error,
    int? currentPickerRosterId,
    DateTime? pickDeadline,
    DateTime? pausedAtDeadline,
    String? searchQuery,
    @Default([]) List<String> positionFilters,
    @Default({}) Map<int, bool> userAutopickStatuses,
    @Default(PlayerSortField.proj) PlayerSortField sortField,
    @Default(true) bool sortDescending,
  }) = _DraftRoomState;

  bool get isUsersTurn => currentPickerRosterId == draft.userRosterId;

  bool get canMakePick =>
      isUsersTurn && draft.status == 'in_progress' && !isLoading;

  bool get isMyAutopickEnabled {
    if (draft.userRosterId == null) return false;
    return userAutopickStatuses[draft.userRosterId] ?? false;
  }

  int get currentPick => picks.length + 1;

  int get currentRound => ((picks.length) ~/ draft.totalRosters) + 1;

  List<Player> get filteredPlayers {
    var filtered = availablePlayers;

    // Apply search query
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      filtered = filtered.where((player) {
        return player.fullName.toLowerCase().contains(query) ||
            player.displayTeam.toLowerCase().contains(query);
      }).toList();
    }

    // Apply position filters
    if (positionFilters.isNotEmpty) {
      filtered = filtered.where((player) {
        return player.fantasyPositions
            .any((pos) => positionFilters.contains(pos));
      }).toList();
    }

    // Apply sorting
    filtered = List.from(filtered);
    filtered.sort((a, b) {
      int comparison;
      switch (sortField) {
        case PlayerSortField.name:
          comparison = a.fullName.compareTo(b.fullName);
          break;
        case PlayerSortField.lastYear:
          comparison = (a.priorSeasonPts ?? 0).compareTo(b.priorSeasonPts ?? 0);
          break;
        case PlayerSortField.ytd:
          comparison = (a.seasonToDatePts ?? 0).compareTo(b.seasonToDatePts ?? 0);
          break;
        case PlayerSortField.proj:
          comparison = (a.remainingProjectedPts ?? 0).compareTo(b.remainingProjectedPts ?? 0);
          break;
      }
      return sortDescending ? -comparison : comparison;
    });

    return filtered;
  }

  Duration? get timeRemaining {
    if (pickDeadline == null) return null;
    final now = DateTime.now();
    final diff = pickDeadline!.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }
}
