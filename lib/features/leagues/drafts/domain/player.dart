import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required int id,
    required String sleeperId,
    required String firstName,
    required String lastName,
    @JsonKey(name: 'fantasy_positions') required List<String> fantasyPositions,
    int? yearsExp,
    int? age,
    String? team,
    String? position,
    int? number,
    String? status,
    String? injuryStatus,
    bool? active,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

extension PlayerExtension on Player {
  String get fullName => '$firstName $lastName';

  String get displayPosition => fantasyPositions.isNotEmpty
      ? fantasyPositions.first
      : position ?? 'N/A';

  bool get isRookie => (yearsExp ?? 1) == 0;

  bool get isVeteran => (yearsExp ?? 0) > 0;

  String get displayTeam => team ?? 'FA';
}
