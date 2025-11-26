import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../players/domain/player.dart';

part 'draft_player_view.freezed.dart';

/// Draft-specific view of a player that combines global player data
/// with draft context (availability, queue status, etc.)
@freezed
class DraftPlayerView with _$DraftPlayerView {
  const DraftPlayerView._();

  const factory DraftPlayerView({
    required Player player,
    @Default(false) bool isDrafted,
    int? draftedByRosterId,
    String? draftedByTeamName,
    int? pickNumber,
    @Default(false) bool isInUserQueue,
    int? queuePosition,
  }) = _DraftPlayerView;

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

  /// Check if player is available for drafting
  bool get isAvailable => !isDrafted;

  /// Get draft status text
  String get draftStatusText {
    if (!isDrafted) return 'Available';
    if (draftedByTeamName != null) {
      return 'Drafted by $draftedByTeamName';
    }
    return 'Drafted';
  }

  /// Create from a Player instance (for available players)
  factory DraftPlayerView.fromPlayer(Player player) {
    return DraftPlayerView(player: player);
  }

  /// Create from a Player with drafted info
  factory DraftPlayerView.drafted({
    required Player player,
    required int draftedByRosterId,
    required int pickNumber,
    String? draftedByTeamName,
  }) {
    return DraftPlayerView(
      player: player,
      isDrafted: true,
      draftedByRosterId: draftedByRosterId,
      draftedByTeamName: draftedByTeamName,
      pickNumber: pickNumber,
    );
  }

  /// Create from a Player with queue info
  factory DraftPlayerView.queued({
    required Player player,
    required int queuePosition,
  }) {
    return DraftPlayerView(
      player: player,
      isInUserQueue: true,
      queuePosition: queuePosition,
    );
  }
}
