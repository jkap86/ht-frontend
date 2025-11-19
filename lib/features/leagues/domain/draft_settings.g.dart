// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftSettingsImpl _$$DraftSettingsImplFromJson(Map<String, dynamic> json) =>
    _$DraftSettingsImpl(
      draftOrder: json['draftOrder'] as String? ?? 'randomize',
      playerPool: json['playerPool'] as String? ?? 'all',
      currentPickerIndex: (json['currentPickerIndex'] as num?)?.toInt(),
      draftOrderList: (json['draftOrderList'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      derbyStartTime: json['derbyStartTime'] == null
          ? null
          : DateTime.parse(json['derbyStartTime'] as String),
      derbyStatus: json['derbyStatus'] as String?,
    );

Map<String, dynamic> _$$DraftSettingsImplToJson(_$DraftSettingsImpl instance) =>
    <String, dynamic>{
      'draftOrder': instance.draftOrder,
      'playerPool': instance.playerPool,
      'currentPickerIndex': instance.currentPickerIndex,
      'draftOrderList': instance.draftOrderList,
      'derbyStartTime': instance.derbyStartTime?.toIso8601String(),
      'derbyStatus': instance.derbyStatus,
    };
