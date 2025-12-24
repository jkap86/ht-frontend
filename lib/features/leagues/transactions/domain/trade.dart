import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade.freezed.dart';
part 'trade.g.dart';

@freezed
class TradeItem with _$TradeItem {
  const factory TradeItem({
    required int id,
    @JsonKey(name: 'trade_id') required int tradeId,
    @JsonKey(name: 'from_roster_id') required int fromRosterId,
    @JsonKey(name: 'to_roster_id') required int toRosterId,
    @JsonKey(name: 'player_id') required int playerId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'player_name') String? playerName,
    @JsonKey(name: 'player_position') String? playerPosition,
    @JsonKey(name: 'player_team') String? playerTeam,
  }) = _TradeItem;

  factory TradeItem.fromJson(Map<String, dynamic> json) => _$TradeItemFromJson(json);
}

@freezed
class Trade with _$Trade {
  const factory Trade({
    required int id,
    @JsonKey(name: 'league_id') required int leagueId,
    @JsonKey(name: 'proposer_roster_id') required int proposerRosterId,
    @JsonKey(name: 'recipient_roster_id') required int recipientRosterId,
    required String status,
    @JsonKey(name: 'proposed_at') required DateTime proposedAt,
    @JsonKey(name: 'responded_at') DateTime? respondedAt,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default([]) List<TradeItem> items,
    @JsonKey(name: 'proposer_username') String? proposerUsername,
    @JsonKey(name: 'recipient_username') String? recipientUsername,
    @JsonKey(name: 'proposer_roster_number') int? proposerRosterNumber,
    @JsonKey(name: 'recipient_roster_number') int? recipientRosterNumber,
  }) = _Trade;

  factory Trade.fromJson(Map<String, dynamic> json) => _$TradeFromJson(json);
}

@freezed
class ProposeTradeRequest with _$ProposeTradeRequest {
  const factory ProposeTradeRequest({
    @JsonKey(name: 'recipient_roster_id') required int recipientRosterId,
    @JsonKey(name: 'offered_player_ids') required List<int> offeredPlayerIds,
    @JsonKey(name: 'requested_player_ids') required List<int> requestedPlayerIds,
    String? notes,
  }) = _ProposeTradeRequest;

  factory ProposeTradeRequest.fromJson(Map<String, dynamic> json) =>
      _$ProposeTradeRequestFromJson(json);
}
