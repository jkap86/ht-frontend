// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_pick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftPickImpl _$$DraftPickImplFromJson(Map<String, dynamic> json) =>
    _$DraftPickImpl(
      id: (json['id'] as num).toInt(),
      draftId: (json['draftId'] as num).toInt(),
      pickNumber: (json['pickNumber'] as num).toInt(),
      roundNumber: (json['roundNumber'] as num).toInt(),
      rosterId: (json['rosterId'] as num).toInt(),
      playerId: (json['playerId'] as num?)?.toInt(),
      playerName: json['playerName'] as String?,
      playerPosition: json['playerPosition'] as String?,
      playerTeam: json['playerTeam'] as String?,
      pickedAt: DateTime.parse(json['pickedAt'] as String),
      wasAutoPick: json['wasAutoPick'] as bool?,
    );

Map<String, dynamic> _$$DraftPickImplToJson(_$DraftPickImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'draftId': instance.draftId,
      'pickNumber': instance.pickNumber,
      'roundNumber': instance.roundNumber,
      'rosterId': instance.rosterId,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'playerPosition': instance.playerPosition,
      'playerTeam': instance.playerTeam,
      'pickedAt': instance.pickedAt.toIso8601String(),
      'wasAutoPick': instance.wasAutoPick,
    };
