import 'package:freezed_annotation/freezed_annotation.dart';

part 'matchup_draft_pick.freezed.dart';

@freezed
class MatchupDraftPick with _$MatchupDraftPick {
  const factory MatchupDraftPick({
    required int id,
    required int draftId,
    required int pickNumber,
    required int roundNumber,
    required int rosterId,
    required int opponentRosterId,
    required int weekNumber,
    String? opponentUsername,
    required String opponentRosterNumber,
    required DateTime pickedAt,
    bool? wasAutoPick,
  }) = _MatchupDraftPick;

  factory MatchupDraftPick.fromJson(Map<String, dynamic> json) {
    return MatchupDraftPick(
      id: (json['id'] as int?) ?? (throw Exception('MatchupDraftPick id is required but was null')),
      draftId: (json['draftId'] as int?) ?? (json['draft_id'] as int?) ?? (throw Exception('MatchupDraftPick draftId is required but was null')),
      pickNumber: (json['pickNumber'] as int?) ?? (json['pick_number'] as int?) ?? (throw Exception('MatchupDraftPick pickNumber is required but was null')),
      roundNumber: (json['roundNumber'] as int?) ?? (json['round'] as int?) ?? (throw Exception('MatchupDraftPick roundNumber is required but was null')),
      rosterId: (json['rosterId'] as int?) ?? (json['roster_id'] as int?) ?? (throw Exception('MatchupDraftPick rosterId is required but was null')),
      opponentRosterId: (json['opponentRosterId'] as int?) ?? (json['opponent_roster_id'] as int?) ?? (throw Exception('MatchupDraftPick opponentRosterId is required but was null')),
      weekNumber: (json['weekNumber'] as int?) ?? (json['week_number'] as int?) ?? (throw Exception('MatchupDraftPick weekNumber is required but was null')),
      opponentUsername: (json['opponentUsername'] as String?) ?? (json['opponent_username'] as String?),
      opponentRosterNumber: (json['opponentRosterNumber'] as String?) ?? (json['opponent_roster_number'] as String?) ?? (throw Exception('MatchupDraftPick opponentRosterNumber is required but was null')),
      pickedAt: DateTime.parse(json['picked_at'] as String),
      wasAutoPick: (json['wasAutoPick'] as bool?) ?? (json['is_auto_pick'] as bool?),
    );
  }
}

extension MatchupDraftPickExtension on MatchupDraftPick {
  String get displayPickNumber => '#$pickNumber';
  String get displayRound => 'Round $roundNumber';

  String get pickDescription {
    return 'Roster $opponentRosterNumber (Wk $weekNumber)';
  }

  String get fullDescription {
    return '${opponentUsername ?? "Team $opponentRosterNumber"} - Week $weekNumber';
  }
}
