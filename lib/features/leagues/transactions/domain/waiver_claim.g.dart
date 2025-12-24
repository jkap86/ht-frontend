// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiver_claim.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaiverClaimImpl _$$WaiverClaimImplFromJson(Map<String, dynamic> json) =>
    _$WaiverClaimImpl(
      id: (json['id'] as num).toInt(),
      leagueId: (json['league_id'] as num).toInt(),
      rosterId: (json['roster_id'] as num).toInt(),
      playerId: (json['player_id'] as num).toInt(),
      dropPlayerId: (json['drop_player_id'] as num?)?.toInt(),
      faabAmount: (json['faab_amount'] as num?)?.toInt() ?? 0,
      priority: (json['priority'] as num?)?.toInt(),
      status: json['status'] as String,
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      week: (json['week'] as num).toInt(),
      season: json['season'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      playerName: json['player_name'] as String?,
      playerPosition: json['player_position'] as String?,
      playerTeam: json['player_team'] as String?,
      dropPlayerName: json['drop_player_name'] as String?,
      dropPlayerPosition: json['drop_player_position'] as String?,
      rosterUsername: json['roster_username'] as String?,
      rosterNumber: (json['roster_number'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$WaiverClaimImplToJson(_$WaiverClaimImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'league_id': instance.leagueId,
      'roster_id': instance.rosterId,
      'player_id': instance.playerId,
      'drop_player_id': instance.dropPlayerId,
      'faab_amount': instance.faabAmount,
      'priority': instance.priority,
      'status': instance.status,
      'processed_at': instance.processedAt?.toIso8601String(),
      'week': instance.week,
      'season': instance.season,
      'created_at': instance.createdAt.toIso8601String(),
      'player_name': instance.playerName,
      'player_position': instance.playerPosition,
      'player_team': instance.playerTeam,
      'drop_player_name': instance.dropPlayerName,
      'drop_player_position': instance.dropPlayerPosition,
      'roster_username': instance.rosterUsername,
      'roster_number': instance.rosterNumber,
    };

_$AvailablePlayerImpl _$$AvailablePlayerImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailablePlayerImpl(
      playerId: (json['playerId'] as num).toInt(),
      playerName: json['playerName'] as String? ?? 'Unknown',
      position: json['position'] as String? ?? '',
      team: json['team'] as String? ?? 'FA',
      isOnWaivers: json['isOnWaivers'] as bool? ?? false,
      waiverClearsAt: json['waiverClearsAt'] == null
          ? null
          : DateTime.parse(json['waiverClearsAt'] as String),
    );

Map<String, dynamic> _$$AvailablePlayerImplToJson(
        _$AvailablePlayerImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'position': instance.position,
      'team': instance.team,
      'isOnWaivers': instance.isOnWaivers,
      'waiverClearsAt': instance.waiverClearsAt?.toIso8601String(),
    };

_$SubmitClaimRequestImpl _$$SubmitClaimRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SubmitClaimRequestImpl(
      playerId: (json['player_id'] as num).toInt(),
      dropPlayerId: (json['drop_player_id'] as num?)?.toInt(),
      faabAmount: (json['faab_amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SubmitClaimRequestImplToJson(
        _$SubmitClaimRequestImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'drop_player_id': instance.dropPlayerId,
      'faab_amount': instance.faabAmount,
    };

_$RosterTransactionImpl _$$RosterTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$RosterTransactionImpl(
      id: (json['id'] as num).toInt(),
      leagueId: (json['league_id'] as num).toInt(),
      rosterId: (json['roster_id'] as num).toInt(),
      transactionType: json['transaction_type'] as String,
      playerId: (json['player_id'] as num).toInt(),
      acquired: json['acquired'] as bool,
      relatedTransactionId: (json['related_transaction_id'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      week: (json['week'] as num?)?.toInt(),
      season: json['season'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      playerName: json['player_name'] as String?,
      playerPosition: json['player_position'] as String?,
      playerTeam: json['player_team'] as String?,
      rosterUsername: json['roster_username'] as String?,
    );

Map<String, dynamic> _$$RosterTransactionImplToJson(
        _$RosterTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'league_id': instance.leagueId,
      'roster_id': instance.rosterId,
      'transaction_type': instance.transactionType,
      'player_id': instance.playerId,
      'acquired': instance.acquired,
      'related_transaction_id': instance.relatedTransactionId,
      'metadata': instance.metadata,
      'week': instance.week,
      'season': instance.season,
      'created_at': instance.createdAt.toIso8601String(),
      'player_name': instance.playerName,
      'player_position': instance.playerPosition,
      'player_team': instance.playerTeam,
      'roster_username': instance.rosterUsername,
    };
