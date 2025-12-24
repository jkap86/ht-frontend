// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TradeItemImpl _$$TradeItemImplFromJson(Map<String, dynamic> json) =>
    _$TradeItemImpl(
      id: (json['id'] as num).toInt(),
      tradeId: (json['trade_id'] as num).toInt(),
      fromRosterId: (json['from_roster_id'] as num).toInt(),
      toRosterId: (json['to_roster_id'] as num).toInt(),
      playerId: (json['player_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      playerName: json['player_name'] as String?,
      playerPosition: json['player_position'] as String?,
      playerTeam: json['player_team'] as String?,
    );

Map<String, dynamic> _$$TradeItemImplToJson(_$TradeItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trade_id': instance.tradeId,
      'from_roster_id': instance.fromRosterId,
      'to_roster_id': instance.toRosterId,
      'player_id': instance.playerId,
      'created_at': instance.createdAt.toIso8601String(),
      'player_name': instance.playerName,
      'player_position': instance.playerPosition,
      'player_team': instance.playerTeam,
    };

_$TradeImpl _$$TradeImplFromJson(Map<String, dynamic> json) => _$TradeImpl(
      id: (json['id'] as num).toInt(),
      leagueId: (json['league_id'] as num).toInt(),
      proposerRosterId: (json['proposer_roster_id'] as num).toInt(),
      recipientRosterId: (json['recipient_roster_id'] as num).toInt(),
      status: json['status'] as String,
      proposedAt: DateTime.parse(json['proposed_at'] as String),
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.parse(json['responded_at'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TradeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      proposerUsername: json['proposer_username'] as String?,
      recipientUsername: json['recipient_username'] as String?,
      proposerRosterNumber: (json['proposer_roster_number'] as num?)?.toInt(),
      recipientRosterNumber: (json['recipient_roster_number'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TradeImplToJson(_$TradeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'league_id': instance.leagueId,
      'proposer_roster_id': instance.proposerRosterId,
      'recipient_roster_id': instance.recipientRosterId,
      'status': instance.status,
      'proposed_at': instance.proposedAt.toIso8601String(),
      'responded_at': instance.respondedAt?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'items': instance.items,
      'proposer_username': instance.proposerUsername,
      'recipient_username': instance.recipientUsername,
      'proposer_roster_number': instance.proposerRosterNumber,
      'recipient_roster_number': instance.recipientRosterNumber,
    };

_$ProposeTradeRequestImpl _$$ProposeTradeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ProposeTradeRequestImpl(
      recipientRosterId: (json['recipient_roster_id'] as num).toInt(),
      offeredPlayerIds: (json['offered_player_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      requestedPlayerIds: (json['requested_player_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ProposeTradeRequestImplToJson(
        _$ProposeTradeRequestImpl instance) =>
    <String, dynamic>{
      'recipient_roster_id': instance.recipientRosterId,
      'offered_player_ids': instance.offeredPlayerIds,
      'requested_player_ids': instance.requestedPlayerIds,
      'notes': instance.notes,
    };
