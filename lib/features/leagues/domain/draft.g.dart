// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftImpl _$$DraftImplFromJson(Map<String, dynamic> json) => _$DraftImpl(
      id: (json['id'] as num).toInt(),
      leagueId: (json['leagueId'] as num).toInt(),
      draftType: json['draftType'] as String,
      rounds: (json['rounds'] as num).toInt(),
      pickTimeSeconds: (json['pickTimeSeconds'] as num).toInt(),
      status: json['status'] as String,
      currentPick: (json['currentPick'] as num).toInt(),
      currentRound: (json['currentRound'] as num).toInt(),
      thirdRoundReversal: json['thirdRoundReversal'] as bool? ?? false,
      currentRosterId: (json['currentRosterId'] as num?)?.toInt(),
      pickDeadline: json['pickDeadline'] == null
          ? null
          : DateTime.parse(json['pickDeadline'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      settings: json['settings'] == null
          ? null
          : DraftSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DraftImplToJson(_$DraftImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leagueId': instance.leagueId,
      'draftType': instance.draftType,
      'rounds': instance.rounds,
      'pickTimeSeconds': instance.pickTimeSeconds,
      'status': instance.status,
      'currentPick': instance.currentPick,
      'currentRound': instance.currentRound,
      'thirdRoundReversal': instance.thirdRoundReversal,
      'currentRosterId': instance.currentRosterId,
      'pickDeadline': instance.pickDeadline?.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'settings': instance.settings,
    };
