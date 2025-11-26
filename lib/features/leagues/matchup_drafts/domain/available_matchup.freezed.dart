// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_matchup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AvailableMatchup {
  int get opponentRosterId => throw _privateConstructorUsedError;
  int get weekNumber => throw _privateConstructorUsedError;
  String? get opponentUsername => throw _privateConstructorUsedError;
  String get opponentRosterNumber => throw _privateConstructorUsedError;

  /// Create a copy of AvailableMatchup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableMatchupCopyWith<AvailableMatchup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableMatchupCopyWith<$Res> {
  factory $AvailableMatchupCopyWith(
          AvailableMatchup value, $Res Function(AvailableMatchup) then) =
      _$AvailableMatchupCopyWithImpl<$Res, AvailableMatchup>;
  @useResult
  $Res call(
      {int opponentRosterId,
      int weekNumber,
      String? opponentUsername,
      String opponentRosterNumber});
}

/// @nodoc
class _$AvailableMatchupCopyWithImpl<$Res, $Val extends AvailableMatchup>
    implements $AvailableMatchupCopyWith<$Res> {
  _$AvailableMatchupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableMatchup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? opponentRosterId = null,
    Object? weekNumber = null,
    Object? opponentUsername = freezed,
    Object? opponentRosterNumber = null,
  }) {
    return _then(_value.copyWith(
      opponentRosterId: null == opponentRosterId
          ? _value.opponentRosterId
          : opponentRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      opponentUsername: freezed == opponentUsername
          ? _value.opponentUsername
          : opponentUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      opponentRosterNumber: null == opponentRosterNumber
          ? _value.opponentRosterNumber
          : opponentRosterNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableMatchupImplCopyWith<$Res>
    implements $AvailableMatchupCopyWith<$Res> {
  factory _$$AvailableMatchupImplCopyWith(_$AvailableMatchupImpl value,
          $Res Function(_$AvailableMatchupImpl) then) =
      __$$AvailableMatchupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int opponentRosterId,
      int weekNumber,
      String? opponentUsername,
      String opponentRosterNumber});
}

/// @nodoc
class __$$AvailableMatchupImplCopyWithImpl<$Res>
    extends _$AvailableMatchupCopyWithImpl<$Res, _$AvailableMatchupImpl>
    implements _$$AvailableMatchupImplCopyWith<$Res> {
  __$$AvailableMatchupImplCopyWithImpl(_$AvailableMatchupImpl _value,
      $Res Function(_$AvailableMatchupImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailableMatchup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? opponentRosterId = null,
    Object? weekNumber = null,
    Object? opponentUsername = freezed,
    Object? opponentRosterNumber = null,
  }) {
    return _then(_$AvailableMatchupImpl(
      opponentRosterId: null == opponentRosterId
          ? _value.opponentRosterId
          : opponentRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      opponentUsername: freezed == opponentUsername
          ? _value.opponentUsername
          : opponentUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      opponentRosterNumber: null == opponentRosterNumber
          ? _value.opponentRosterNumber
          : opponentRosterNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AvailableMatchupImpl implements _AvailableMatchup {
  const _$AvailableMatchupImpl(
      {required this.opponentRosterId,
      required this.weekNumber,
      this.opponentUsername,
      required this.opponentRosterNumber});

  @override
  final int opponentRosterId;
  @override
  final int weekNumber;
  @override
  final String? opponentUsername;
  @override
  final String opponentRosterNumber;

  @override
  String toString() {
    return 'AvailableMatchup(opponentRosterId: $opponentRosterId, weekNumber: $weekNumber, opponentUsername: $opponentUsername, opponentRosterNumber: $opponentRosterNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableMatchupImpl &&
            (identical(other.opponentRosterId, opponentRosterId) ||
                other.opponentRosterId == opponentRosterId) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.opponentUsername, opponentUsername) ||
                other.opponentUsername == opponentUsername) &&
            (identical(other.opponentRosterNumber, opponentRosterNumber) ||
                other.opponentRosterNumber == opponentRosterNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, opponentRosterId, weekNumber,
      opponentUsername, opponentRosterNumber);

  /// Create a copy of AvailableMatchup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableMatchupImplCopyWith<_$AvailableMatchupImpl> get copyWith =>
      __$$AvailableMatchupImplCopyWithImpl<_$AvailableMatchupImpl>(
          this, _$identity);
}

abstract class _AvailableMatchup implements AvailableMatchup {
  const factory _AvailableMatchup(
      {required final int opponentRosterId,
      required final int weekNumber,
      final String? opponentUsername,
      required final String opponentRosterNumber}) = _$AvailableMatchupImpl;

  @override
  int get opponentRosterId;
  @override
  int get weekNumber;
  @override
  String? get opponentUsername;
  @override
  String get opponentRosterNumber;

  /// Create a copy of AvailableMatchup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableMatchupImplCopyWith<_$AvailableMatchupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
