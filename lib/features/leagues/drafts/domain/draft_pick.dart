import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_pick.freezed.dart';
part 'draft_pick.g.dart';

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

  factory DraftPick.fromJson(Map<String, dynamic> json) =>
      _$DraftPickFromJson(json);
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
