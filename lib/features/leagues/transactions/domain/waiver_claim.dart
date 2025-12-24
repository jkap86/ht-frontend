import 'package:freezed_annotation/freezed_annotation.dart';

part 'waiver_claim.freezed.dart';
part 'waiver_claim.g.dart';

@freezed
class WaiverClaim with _$WaiverClaim {
  const factory WaiverClaim({
    required int id,
    @JsonKey(name: 'league_id') required int leagueId,
    @JsonKey(name: 'roster_id') required int rosterId,
    @JsonKey(name: 'player_id') required int playerId,
    @JsonKey(name: 'drop_player_id') int? dropPlayerId,
    @JsonKey(name: 'faab_amount') @Default(0) int faabAmount,
    int? priority,
    required String status,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    required int week,
    required String season,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'player_name') String? playerName,
    @JsonKey(name: 'player_position') String? playerPosition,
    @JsonKey(name: 'player_team') String? playerTeam,
    @JsonKey(name: 'drop_player_name') String? dropPlayerName,
    @JsonKey(name: 'drop_player_position') String? dropPlayerPosition,
    @JsonKey(name: 'roster_username') String? rosterUsername,
    @JsonKey(name: 'roster_number') int? rosterNumber,
  }) = _WaiverClaim;

  factory WaiverClaim.fromJson(Map<String, dynamic> json) =>
      _$WaiverClaimFromJson(json);
}

@freezed
class AvailablePlayer with _$AvailablePlayer {
  const factory AvailablePlayer({
    @JsonKey(name: 'playerId') required int playerId,
    @JsonKey(name: 'playerName') @Default('Unknown') String playerName,
    @Default('') String position,
    @Default('FA') String team,
    @JsonKey(name: 'isOnWaivers') @Default(false) bool isOnWaivers,
    @JsonKey(name: 'waiverClearsAt') DateTime? waiverClearsAt,
  }) = _AvailablePlayer;

  factory AvailablePlayer.fromJson(Map<String, dynamic> json) =>
      _$AvailablePlayerFromJson(json);
}

@freezed
class SubmitClaimRequest with _$SubmitClaimRequest {
  const factory SubmitClaimRequest({
    @JsonKey(name: 'player_id') required int playerId,
    @JsonKey(name: 'drop_player_id') int? dropPlayerId,
    @JsonKey(name: 'faab_amount') int? faabAmount,
  }) = _SubmitClaimRequest;

  factory SubmitClaimRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitClaimRequestFromJson(json);
}

@freezed
class RosterTransaction with _$RosterTransaction {
  const factory RosterTransaction({
    required int id,
    @JsonKey(name: 'league_id') required int leagueId,
    @JsonKey(name: 'roster_id') required int rosterId,
    @JsonKey(name: 'transaction_type') required String transactionType,
    @JsonKey(name: 'player_id') required int playerId,
    required bool acquired,
    @JsonKey(name: 'related_transaction_id') int? relatedTransactionId,
    @Default({}) Map<String, dynamic> metadata,
    int? week,
    String? season,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'player_name') String? playerName,
    @JsonKey(name: 'player_position') String? playerPosition,
    @JsonKey(name: 'player_team') String? playerTeam,
    @JsonKey(name: 'roster_username') String? rosterUsername,
  }) = _RosterTransaction;

  factory RosterTransaction.fromJson(Map<String, dynamic> json) =>
      _$RosterTransactionFromJson(json);
}
