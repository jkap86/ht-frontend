// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_pick.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DraftPick {
  int get id => throw _privateConstructorUsedError;
  int get draftId => throw _privateConstructorUsedError;
  int get pickNumber => throw _privateConstructorUsedError;
  int get roundNumber => throw _privateConstructorUsedError;
  int get rosterId => throw _privateConstructorUsedError;
  int? get playerId => throw _privateConstructorUsedError;
  String? get playerName => throw _privateConstructorUsedError;
  String? get playerPosition => throw _privateConstructorUsedError;
  String? get playerTeam => throw _privateConstructorUsedError;
  DateTime get pickedAt => throw _privateConstructorUsedError;
  bool? get wasAutoPick =>
      throw _privateConstructorUsedError; // Enhanced fields for matchup display
  String? get opponent => throw _privateConstructorUsedError;
  double? get projectedPts => throw _privateConstructorUsedError;
  double? get actualPts => throw _privateConstructorUsedError;
  bool? get isStarter => throw _privateConstructorUsedError;

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftPickCopyWith<DraftPick> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftPickCopyWith<$Res> {
  factory $DraftPickCopyWith(DraftPick value, $Res Function(DraftPick) then) =
      _$DraftPickCopyWithImpl<$Res, DraftPick>;
  @useResult
  $Res call(
      {int id,
      int draftId,
      int pickNumber,
      int roundNumber,
      int rosterId,
      int? playerId,
      String? playerName,
      String? playerPosition,
      String? playerTeam,
      DateTime pickedAt,
      bool? wasAutoPick,
      String? opponent,
      double? projectedPts,
      double? actualPts,
      bool? isStarter});
}

/// @nodoc
class _$DraftPickCopyWithImpl<$Res, $Val extends DraftPick>
    implements $DraftPickCopyWith<$Res> {
  _$DraftPickCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? draftId = null,
    Object? pickNumber = null,
    Object? roundNumber = null,
    Object? rosterId = null,
    Object? playerId = freezed,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
    Object? pickedAt = null,
    Object? wasAutoPick = freezed,
    Object? opponent = freezed,
    Object? projectedPts = freezed,
    Object? actualPts = freezed,
    Object? isStarter = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      draftId: null == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as int,
      pickNumber: null == pickNumber
          ? _value.pickNumber
          : pickNumber // ignore: cast_nullable_to_non_nullable
              as int,
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int?,
      playerName: freezed == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String?,
      playerPosition: freezed == playerPosition
          ? _value.playerPosition
          : playerPosition // ignore: cast_nullable_to_non_nullable
              as String?,
      playerTeam: freezed == playerTeam
          ? _value.playerTeam
          : playerTeam // ignore: cast_nullable_to_non_nullable
              as String?,
      pickedAt: null == pickedAt
          ? _value.pickedAt
          : pickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      wasAutoPick: freezed == wasAutoPick
          ? _value.wasAutoPick
          : wasAutoPick // ignore: cast_nullable_to_non_nullable
              as bool?,
      opponent: freezed == opponent
          ? _value.opponent
          : opponent // ignore: cast_nullable_to_non_nullable
              as String?,
      projectedPts: freezed == projectedPts
          ? _value.projectedPts
          : projectedPts // ignore: cast_nullable_to_non_nullable
              as double?,
      actualPts: freezed == actualPts
          ? _value.actualPts
          : actualPts // ignore: cast_nullable_to_non_nullable
              as double?,
      isStarter: freezed == isStarter
          ? _value.isStarter
          : isStarter // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DraftPickImplCopyWith<$Res>
    implements $DraftPickCopyWith<$Res> {
  factory _$$DraftPickImplCopyWith(
          _$DraftPickImpl value, $Res Function(_$DraftPickImpl) then) =
      __$$DraftPickImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int draftId,
      int pickNumber,
      int roundNumber,
      int rosterId,
      int? playerId,
      String? playerName,
      String? playerPosition,
      String? playerTeam,
      DateTime pickedAt,
      bool? wasAutoPick,
      String? opponent,
      double? projectedPts,
      double? actualPts,
      bool? isStarter});
}

/// @nodoc
class __$$DraftPickImplCopyWithImpl<$Res>
    extends _$DraftPickCopyWithImpl<$Res, _$DraftPickImpl>
    implements _$$DraftPickImplCopyWith<$Res> {
  __$$DraftPickImplCopyWithImpl(
      _$DraftPickImpl _value, $Res Function(_$DraftPickImpl) _then)
      : super(_value, _then);

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? draftId = null,
    Object? pickNumber = null,
    Object? roundNumber = null,
    Object? rosterId = null,
    Object? playerId = freezed,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
    Object? pickedAt = null,
    Object? wasAutoPick = freezed,
    Object? opponent = freezed,
    Object? projectedPts = freezed,
    Object? actualPts = freezed,
    Object? isStarter = freezed,
  }) {
    return _then(_$DraftPickImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      draftId: null == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as int,
      pickNumber: null == pickNumber
          ? _value.pickNumber
          : pickNumber // ignore: cast_nullable_to_non_nullable
              as int,
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int?,
      playerName: freezed == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String?,
      playerPosition: freezed == playerPosition
          ? _value.playerPosition
          : playerPosition // ignore: cast_nullable_to_non_nullable
              as String?,
      playerTeam: freezed == playerTeam
          ? _value.playerTeam
          : playerTeam // ignore: cast_nullable_to_non_nullable
              as String?,
      pickedAt: null == pickedAt
          ? _value.pickedAt
          : pickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      wasAutoPick: freezed == wasAutoPick
          ? _value.wasAutoPick
          : wasAutoPick // ignore: cast_nullable_to_non_nullable
              as bool?,
      opponent: freezed == opponent
          ? _value.opponent
          : opponent // ignore: cast_nullable_to_non_nullable
              as String?,
      projectedPts: freezed == projectedPts
          ? _value.projectedPts
          : projectedPts // ignore: cast_nullable_to_non_nullable
              as double?,
      actualPts: freezed == actualPts
          ? _value.actualPts
          : actualPts // ignore: cast_nullable_to_non_nullable
              as double?,
      isStarter: freezed == isStarter
          ? _value.isStarter
          : isStarter // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$DraftPickImpl implements _DraftPick {
  const _$DraftPickImpl(
      {required this.id,
      required this.draftId,
      required this.pickNumber,
      required this.roundNumber,
      required this.rosterId,
      this.playerId,
      this.playerName,
      this.playerPosition,
      this.playerTeam,
      required this.pickedAt,
      this.wasAutoPick,
      this.opponent,
      this.projectedPts,
      this.actualPts,
      this.isStarter});

  @override
  final int id;
  @override
  final int draftId;
  @override
  final int pickNumber;
  @override
  final int roundNumber;
  @override
  final int rosterId;
  @override
  final int? playerId;
  @override
  final String? playerName;
  @override
  final String? playerPosition;
  @override
  final String? playerTeam;
  @override
  final DateTime pickedAt;
  @override
  final bool? wasAutoPick;
// Enhanced fields for matchup display
  @override
  final String? opponent;
  @override
  final double? projectedPts;
  @override
  final double? actualPts;
  @override
  final bool? isStarter;

  @override
  String toString() {
    return 'DraftPick(id: $id, draftId: $draftId, pickNumber: $pickNumber, roundNumber: $roundNumber, rosterId: $rosterId, playerId: $playerId, playerName: $playerName, playerPosition: $playerPosition, playerTeam: $playerTeam, pickedAt: $pickedAt, wasAutoPick: $wasAutoPick, opponent: $opponent, projectedPts: $projectedPts, actualPts: $actualPts, isStarter: $isStarter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftPickImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.draftId, draftId) || other.draftId == draftId) &&
            (identical(other.pickNumber, pickNumber) ||
                other.pickNumber == pickNumber) &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.rosterId, rosterId) ||
                other.rosterId == rosterId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.playerPosition, playerPosition) ||
                other.playerPosition == playerPosition) &&
            (identical(other.playerTeam, playerTeam) ||
                other.playerTeam == playerTeam) &&
            (identical(other.pickedAt, pickedAt) ||
                other.pickedAt == pickedAt) &&
            (identical(other.wasAutoPick, wasAutoPick) ||
                other.wasAutoPick == wasAutoPick) &&
            (identical(other.opponent, opponent) ||
                other.opponent == opponent) &&
            (identical(other.projectedPts, projectedPts) ||
                other.projectedPts == projectedPts) &&
            (identical(other.actualPts, actualPts) ||
                other.actualPts == actualPts) &&
            (identical(other.isStarter, isStarter) ||
                other.isStarter == isStarter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      draftId,
      pickNumber,
      roundNumber,
      rosterId,
      playerId,
      playerName,
      playerPosition,
      playerTeam,
      pickedAt,
      wasAutoPick,
      opponent,
      projectedPts,
      actualPts,
      isStarter);

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftPickImplCopyWith<_$DraftPickImpl> get copyWith =>
      __$$DraftPickImplCopyWithImpl<_$DraftPickImpl>(this, _$identity);
}

abstract class _DraftPick implements DraftPick {
  const factory _DraftPick(
      {required final int id,
      required final int draftId,
      required final int pickNumber,
      required final int roundNumber,
      required final int rosterId,
      final int? playerId,
      final String? playerName,
      final String? playerPosition,
      final String? playerTeam,
      required final DateTime pickedAt,
      final bool? wasAutoPick,
      final String? opponent,
      final double? projectedPts,
      final double? actualPts,
      final bool? isStarter}) = _$DraftPickImpl;

  @override
  int get id;
  @override
  int get draftId;
  @override
  int get pickNumber;
  @override
  int get roundNumber;
  @override
  int get rosterId;
  @override
  int? get playerId;
  @override
  String? get playerName;
  @override
  String? get playerPosition;
  @override
  String? get playerTeam;
  @override
  DateTime get pickedAt;
  @override
  bool? get wasAutoPick; // Enhanced fields for matchup display
  @override
  String? get opponent;
  @override
  double? get projectedPts;
  @override
  double? get actualPts;
  @override
  bool? get isStarter;

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftPickImplCopyWith<_$DraftPickImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
