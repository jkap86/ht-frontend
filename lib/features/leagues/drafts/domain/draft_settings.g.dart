// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftSettingsImpl _$$DraftSettingsImplFromJson(Map<String, dynamic> json) =>
    _$DraftSettingsImpl(
      draftOrder: json['draft_order'] as String? ?? 'randomize',
      playerPool: json['player_pool'] as String? ?? 'all',
      currentPickerIndex: (json['current_picker_index'] as num?)?.toInt(),
      draftOrderList: (json['draft_order_list'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      derbyStartTime: json['derby_start_time'] == null
          ? null
          : DateTime.parse(json['derby_start_time'] as String),
      derbyStatus: json['derby_status'] as String?,
      derbyTimerSeconds: (json['derby_timer_seconds'] as num?)?.toInt(),
      derbyOnTimeout: json['derby_on_timeout'] as String?,
    );

Map<String, dynamic> _$$DraftSettingsImplToJson(_$DraftSettingsImpl instance) =>
    <String, dynamic>{
      'draft_order': instance.draftOrder,
      'player_pool': instance.playerPool,
      'current_picker_index': instance.currentPickerIndex,
      'draft_order_list': instance.draftOrderList,
      'derby_start_time': instance.derbyStartTime?.toIso8601String(),
      'derby_status': instance.derbyStatus,
      'derby_timer_seconds': instance.derbyTimerSeconds,
      'derby_on_timeout': instance.derbyOnTimeout,
    };
