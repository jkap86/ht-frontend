import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../players/domain/player.dart';

part 'league_roster_player.freezed.dart';

/// League roster-specific view of a player that combines global player data
/// with roster context (owner, draft position, stats, etc.)
@freezed
class LeagueRosterPlayer with _$LeagueRosterPlayer {
  const LeagueRosterPlayer._();

  const factory LeagueRosterPlayer({
    required Player player,
    required int rosterId,
    String? rosterName,
    int? draftPosition,
    int? draftRound,
    double? totalPoints,
    double? averagePoints,
    @Default([]) List<String> rosterSlots,
    String? currentSlot,
  }) = _LeagueRosterPlayer;

  /// Get the player's ID
  int get id => player.id;

  /// Get the player's sleeper ID
  String get sleeperId => player.sleeperId;

  /// Get the player's full name
  String get fullName => player.fullName;

  /// Get the player's display position
  String get displayPosition => player.displayPosition;

  /// Get the player's team
  String get displayTeam => player.displayTeam;

  /// Check if player is a starter (in a starting slot)
  bool get isStarter {
    if (currentSlot == null) return false;
    return !currentSlot!.toUpperCase().contains('BENCH') &&
           !currentSlot!.toUpperCase().contains('IR');
  }

  /// Check if player is on bench
  bool get isBenched {
    return currentSlot?.toUpperCase().contains('BENCH') ?? false;
  }

  /// Check if player is on IR
  bool get isOnIR {
    return currentSlot?.toUpperCase().contains('IR') ?? false;
  }

  /// Get draft info string
  String? get draftInfo {
    if (draftPosition == null) return null;
    if (draftRound != null) {
      return 'Rd $draftRound, Pick $draftPosition';
    }
    return 'Pick $draftPosition';
  }

  /// Create from a Player instance with roster info
  factory LeagueRosterPlayer.fromPlayer({
    required Player player,
    required int rosterId,
    String? rosterName,
    int? draftPosition,
    int? draftRound,
    String? currentSlot,
  }) {
    return LeagueRosterPlayer(
      player: player,
      rosterId: rosterId,
      rosterName: rosterName,
      draftPosition: draftPosition,
      draftRound: draftRound,
      currentSlot: currentSlot,
    );
  }
}
