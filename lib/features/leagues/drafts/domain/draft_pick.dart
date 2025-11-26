import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_pick.freezed.dart';

@freezed
class DraftPick with _$DraftPick {
  const factory DraftPick({
    required int id,
    required int draftId,
    required int pickNumber,
    required int roundNumber,
    required int rosterId,
    int? playerId,
    String? playerName,
    String? playerPosition,
    String? playerTeam,
    required DateTime pickedAt,
    bool? wasAutoPick,
  }) = _DraftPick;

  factory DraftPick.fromJson(Map<String, dynamic> json) {
    return DraftPick(
      id: (json['id'] as int?) ?? (throw Exception('DraftPick id is required but was null')),
      draftId: (json['draft_id'] as int?) ?? (throw Exception('DraftPick draft_id is required but was null')),
      pickNumber: (json['pick_number'] as int?) ?? (throw Exception('DraftPick pick_number is required but was null')),
      roundNumber: (json['round'] as int?) ?? (throw Exception('DraftPick round is required but was null')),
      rosterId: (json['roster_id'] as int?) ?? (throw Exception('DraftPick roster_id is required but was null')),
      playerId: json['player_id'] as int?,
      playerName: json['player_name'] as String?,
      playerPosition: json['player_position'] as String?,
      playerTeam: json['player_team'] as String?,
      pickedAt: DateTime.parse(json['picked_at'] as String),
      wasAutoPick: json['is_auto_pick'] as bool?,
    );
  }
}

extension DraftPickExtension on DraftPick {
  String get displayPickNumber => '#$pickNumber';
  String get displayRound => 'Round $roundNumber';

  String get pickDescription {
    if (playerName != null) {
      final pos = playerPosition ?? '';
      final team = playerTeam ?? '';
      final suffix = pos.isNotEmpty || team.isNotEmpty
          ? ' ($pos${pos.isNotEmpty && team.isNotEmpty ? ' - ' : ''}$team)'
          : '';
      return '$playerName$suffix';
    }
    return 'Pick $pickNumber';
  }
}
