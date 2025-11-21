import 'package:freezed_annotation/freezed_annotation.dart';
import 'draft.dart';
import 'player.dart';
import 'draft_pick.dart';
import 'draft_order_entry.dart';

part 'draft_room_state.freezed.dart';

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
    String? searchQuery,
    @Default([]) List<String> positionFilters,
  }) = _DraftRoomState;

  bool get isUsersTurn => currentPickerRosterId == draft.userRosterId;

  bool get canMakePick =>
      isUsersTurn && draft.status == 'in_progress' && !isLoading;

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

    return filtered;
  }

  Duration? get timeRemaining {
    if (pickDeadline == null) return null;
    final now = DateTime.now();
    final diff = pickDeadline!.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }
}
