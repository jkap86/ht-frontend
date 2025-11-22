// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftQueueImpl _$$DraftQueueImplFromJson(Map<String, dynamic> json) =>
    _$DraftQueueImpl(
      id: (json['id'] as num).toInt(),
      draftId: (json['draftId'] as num).toInt(),
      rosterId: (json['rosterId'] as num).toInt(),
      playerId: (json['playerId'] as num).toInt(),
      queuePosition: (json['queuePosition'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      player: json['player'] == null
          ? null
          : Player.fromJson(json['player'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DraftQueueImplToJson(_$DraftQueueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'draftId': instance.draftId,
      'rosterId': instance.rosterId,
      'playerId': instance.playerId,
      'queuePosition': instance.queuePosition,
      'createdAt': instance.createdAt.toIso8601String(),
      'player': instance.player,
    };
