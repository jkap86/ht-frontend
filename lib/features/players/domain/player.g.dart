// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: (json['id'] as num).toInt(),
      sleeperId: json['sleeperId'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fantasyPositions: (json['fantasyPositions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      yearsExp: (json['yearsExp'] as num?)?.toInt(),
      age: (json['age'] as num?)?.toInt(),
      team: json['team'] as String?,
      position: json['position'] as String?,
      number: (json['number'] as num?)?.toInt(),
      status: json['status'] as String?,
      injuryStatus: json['injuryStatus'] as String?,
      active: json['active'] as bool?,
      priorSeasonPts: (json['priorSeasonPts'] as num?)?.toDouble(),
      seasonToDatePts: (json['seasonToDatePts'] as num?)?.toDouble(),
      remainingProjectedPts:
          (json['remainingProjectedPts'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sleeperId': instance.sleeperId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fantasyPositions': instance.fantasyPositions,
      'yearsExp': instance.yearsExp,
      'age': instance.age,
      'team': instance.team,
      'position': instance.position,
      'number': instance.number,
      'status': instance.status,
      'injuryStatus': instance.injuryStatus,
      'active': instance.active,
      'priorSeasonPts': instance.priorSeasonPts,
      'seasonToDatePts': instance.seasonToDatePts,
      'remainingProjectedPts': instance.remainingProjectedPts,
    };
