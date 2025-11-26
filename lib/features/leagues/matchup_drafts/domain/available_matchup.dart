import 'package:freezed_annotation/freezed_annotation.dart';

part 'available_matchup.freezed.dart';

@freezed
class AvailableMatchup with _$AvailableMatchup {
  const factory AvailableMatchup({
    required int opponentRosterId,
    required int weekNumber,
    String? opponentUsername,
    required String opponentRosterNumber,
  }) = _AvailableMatchup;

  factory AvailableMatchup.fromJson(Map<String, dynamic> json) {
    return AvailableMatchup(
      opponentRosterId: (json['opponentRosterId'] as int?) ?? (json['opponent_roster_id'] as int?) ?? (throw Exception('AvailableMatchup opponentRosterId is required but was null')),
      weekNumber: (json['weekNumber'] as int?) ?? (json['week_number'] as int?) ?? (throw Exception('AvailableMatchup weekNumber is required but was null')),
      opponentUsername: (json['opponentUsername'] as String?) ?? (json['opponent_username'] as String?),
      opponentRosterNumber: (json['opponentRosterNumber'] as String?) ?? (json['opponent_roster_number'] as String?) ?? (throw Exception('AvailableMatchup opponentRosterNumber is required but was null')),
    );
  }
}

extension AvailableMatchupExtension on AvailableMatchup {
  String get displayName => '${opponentUsername ?? "Team $opponentRosterNumber"} - Week $weekNumber';
  String get shortDisplayName => 'Roster $opponentRosterNumber (Wk $weekNumber)';
}
