// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_queue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DraftQueue _$DraftQueueFromJson(Map<String, dynamic> json) {
  return _DraftQueue.fromJson(json);
}

/// @nodoc
mixin _$DraftQueue {
  int get id => throw _privateConstructorUsedError;
  int get draftId => throw _privateConstructorUsedError;
  int get rosterId => throw _privateConstructorUsedError;
  int get playerId => throw _privateConstructorUsedError;
  int get queuePosition => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Player? get player => throw _privateConstructorUsedError;

  /// Serializes this DraftQueue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DraftQueue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftQueueCopyWith<DraftQueue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftQueueCopyWith<$Res> {
  factory $DraftQueueCopyWith(
          DraftQueue value, $Res Function(DraftQueue) then) =
      _$DraftQueueCopyWithImpl<$Res, DraftQueue>;
  @useResult
  $Res call(
      {int id,
      int draftId,
      int rosterId,
      int playerId,
      int queuePosition,
      DateTime createdAt,
      Player? player});

  $PlayerCopyWith<$Res>? get player;
}

/// @nodoc
class _$DraftQueueCopyWithImpl<$Res, $Val extends DraftQueue>
    implements $DraftQueueCopyWith<$Res> {
  _$DraftQueueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftQueue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? draftId = null,
    Object? rosterId = null,
    Object? playerId = null,
    Object? queuePosition = null,
    Object? createdAt = null,
    Object? player = freezed,
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
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      queuePosition: null == queuePosition
          ? _value.queuePosition
          : queuePosition // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
    ) as $Val);
  }

  /// Create a copy of DraftQueue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res>? get player {
    if (_value.player == null) {
      return null;
    }

    return $PlayerCopyWith<$Res>(_value.player!, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DraftQueueImplCopyWith<$Res>
    implements $DraftQueueCopyWith<$Res> {
  factory _$$DraftQueueImplCopyWith(
          _$DraftQueueImpl value, $Res Function(_$DraftQueueImpl) then) =
      __$$DraftQueueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int draftId,
      int rosterId,
      int playerId,
      int queuePosition,
      DateTime createdAt,
      Player? player});

  @override
  $PlayerCopyWith<$Res>? get player;
}

/// @nodoc
class __$$DraftQueueImplCopyWithImpl<$Res>
    extends _$DraftQueueCopyWithImpl<$Res, _$DraftQueueImpl>
    implements _$$DraftQueueImplCopyWith<$Res> {
  __$$DraftQueueImplCopyWithImpl(
      _$DraftQueueImpl _value, $Res Function(_$DraftQueueImpl) _then)
      : super(_value, _then);

  /// Create a copy of DraftQueue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? draftId = null,
    Object? rosterId = null,
    Object? playerId = null,
    Object? queuePosition = null,
    Object? createdAt = null,
    Object? player = freezed,
  }) {
    return _then(_$DraftQueueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      draftId: null == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      queuePosition: null == queuePosition
          ? _value.queuePosition
          : queuePosition // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DraftQueueImpl implements _DraftQueue {
  const _$DraftQueueImpl(
      {required this.id,
      required this.draftId,
      required this.rosterId,
      required this.playerId,
      required this.queuePosition,
      required this.createdAt,
      this.player});

  factory _$DraftQueueImpl.fromJson(Map<String, dynamic> json) =>
      _$$DraftQueueImplFromJson(json);

  @override
  final int id;
  @override
  final int draftId;
  @override
  final int rosterId;
  @override
  final int playerId;
  @override
  final int queuePosition;
  @override
  final DateTime createdAt;
  @override
  final Player? player;

  @override
  String toString() {
    return 'DraftQueue(id: $id, draftId: $draftId, rosterId: $rosterId, playerId: $playerId, queuePosition: $queuePosition, createdAt: $createdAt, player: $player)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftQueueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.draftId, draftId) || other.draftId == draftId) &&
            (identical(other.rosterId, rosterId) ||
                other.rosterId == rosterId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.queuePosition, queuePosition) ||
                other.queuePosition == queuePosition) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.player, player) || other.player == player));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, draftId, rosterId, playerId,
      queuePosition, createdAt, player);

  /// Create a copy of DraftQueue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftQueueImplCopyWith<_$DraftQueueImpl> get copyWith =>
      __$$DraftQueueImplCopyWithImpl<_$DraftQueueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DraftQueueImplToJson(
      this,
    );
  }
}

abstract class _DraftQueue implements DraftQueue {
  const factory _DraftQueue(
      {required final int id,
      required final int draftId,
      required final int rosterId,
      required final int playerId,
      required final int queuePosition,
      required final DateTime createdAt,
      final Player? player}) = _$DraftQueueImpl;

  factory _DraftQueue.fromJson(Map<String, dynamic> json) =
      _$DraftQueueImpl.fromJson;

  @override
  int get id;
  @override
  int get draftId;
  @override
  int get rosterId;
  @override
  int get playerId;
  @override
  int get queuePosition;
  @override
  DateTime get createdAt;
  @override
  Player? get player;

  /// Create a copy of DraftQueue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftQueueImplCopyWith<_$DraftQueueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
