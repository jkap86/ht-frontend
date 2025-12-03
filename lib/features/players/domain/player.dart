import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required int id,
    @JsonKey(name: 'sleeperId') required String sleeperId,
    @JsonKey(name: 'firstName') String? firstName,
    @JsonKey(name: 'lastName') String? lastName,
    @JsonKey(name: 'fantasyPositions') required List<String> fantasyPositions,
    @JsonKey(name: 'yearsExp') int? yearsExp,
    int? age,
    String? team,
    String? position,
    int? number,
    String? status,
    @JsonKey(name: 'injuryStatus') String? injuryStatus,
    bool? active,
    // Fantasy stats
    @JsonKey(name: 'priorSeasonPts') double? priorSeasonPts,
    @JsonKey(name: 'seasonToDatePts') double? seasonToDatePts,
    @JsonKey(name: 'remainingProjectedPts') double? remainingProjectedPts,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

extension PlayerExtension on Player {
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  String get displayPosition => fantasyPositions.isNotEmpty
      ? fantasyPositions.first
      : position ?? 'N/A';

  bool get isRookie => (yearsExp ?? 1) == 0;

  bool get isVeteran => (yearsExp ?? 0) > 0;

  String get displayTeam => team ?? 'FA';
}
