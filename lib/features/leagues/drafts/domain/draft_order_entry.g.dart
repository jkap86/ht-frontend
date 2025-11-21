// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_order_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftOrderEntryImpl _$$DraftOrderEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$DraftOrderEntryImpl(
      id: (json['id'] as num).toInt(),
      draftId: (json['draftId'] as num).toInt(),
      rosterId: (json['rosterId'] as num).toInt(),
      draftPosition: (json['draftPosition'] as num).toInt(),
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      teamName: json['teamName'] as String?,
    );

Map<String, dynamic> _$$DraftOrderEntryImplToJson(
        _$DraftOrderEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'draftId': instance.draftId,
      'rosterId': instance.rosterId,
      'draftPosition': instance.draftPosition,
      'userId': instance.userId,
      'username': instance.username,
      'teamName': instance.teamName,
    };
