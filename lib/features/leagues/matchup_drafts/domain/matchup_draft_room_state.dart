import 'package:freezed_annotation/freezed_annotation.dart';
import '../../drafts/domain/draft.dart';
import '../../drafts/domain/draft_order_entry.dart';
import 'matchup_draft_pick.dart';
import 'available_matchup.dart';

part 'matchup_draft_room_state.freezed.dart';

@freezed
class MatchupDraftRoomState with _$MatchupDraftRoomState {
  const MatchupDraftRoomState._();

  const factory MatchupDraftRoomState({
    required Draft draft,
    @Default([]) List<AvailableMatchup> availableMatchups,
    @Default([]) List<MatchupDraftPick> picks,
    @Default([]) List<DraftOrderEntry> draftOrder,
    @Default(false) bool isLoading,
    @Default(false) bool isConnected,
    String? error,
    int? currentPickerRosterId,
    DateTime? pickDeadline,
    DateTime? pausedAtDeadline,
    String? searchQuery,
    @Default([]) List<int> weekFilters,
  }) = _MatchupDraftRoomState;

  bool get isUsersTurn => currentPickerRosterId == draft.userRosterId;

  bool get canMakePick =>
      isUsersTurn && draft.status == 'in_progress' && !isLoading;

  int get currentPick => picks.length + 1;

  int get currentRound => ((picks.length) ~/ draft.totalRosters) + 1;

  List<AvailableMatchup> get filteredMatchups {
    var filtered = availableMatchups;

    // Apply search query
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      filtered = filtered.where((matchup) {
        return (matchup.opponentUsername?.toLowerCase().contains(query) ?? false) ||
            matchup.opponentRosterNumber.toLowerCase().contains(query);
      }).toList();
    }

    // Apply week filters
    if (weekFilters.isNotEmpty) {
      filtered = filtered.where((matchup) {
        return weekFilters.contains(matchup.weekNumber);
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
