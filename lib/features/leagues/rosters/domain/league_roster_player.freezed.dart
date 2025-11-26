// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_roster_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LeagueRosterPlayer {
  Player get player => throw _privateConstructorUsedError;
  int get rosterId => throw _privateConstructorUsedError;
  String? get rosterName => throw _privateConstructorUsedError;
  int? get draftPosition => throw _privateConstructorUsedError;
  int? get draftRound => throw _privateConstructorUsedError;
  double? get totalPoints => throw _privateConstructorUsedError;
  double? get averagePoints => throw _privateConstructorUsedError;
  List<String> get rosterSlots => throw _privateConstructorUsedError;
  String? get currentSlot => throw _privateConstructorUsedError;

  /// Create a copy of LeagueRosterPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueRosterPlayerCopyWith<LeagueRosterPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueRosterPlayerCopyWith<$Res> {
  factory $LeagueRosterPlayerCopyWith(
          LeagueRosterPlayer value, $Res Function(LeagueRosterPlayer) then) =
      _$LeagueRosterPlayerCopyWithImpl<$Res, LeagueRosterPlayer>;
  @useResult
  $Res call(
      {Player player,
      int rosterId,
      String? rosterName,
      int? draftPosition,
      int? draftRound,
      double? totalPoints,
      double? averagePoints,
      List<String> rosterSlots,
      String? currentSlot});

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$LeagueRosterPlayerCopyWithImpl<$Res, $Val extends LeagueRosterPlayer>
    implements $LeagueRosterPlayerCopyWith<$Res> {
  _$LeagueRosterPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeagueRosterPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? rosterId = null,
    Object? rosterName = freezed,
    Object? draftPosition = freezed,
    Object? draftRound = freezed,
    Object? totalPoints = freezed,
    Object? averagePoints = freezed,
    Object? rosterSlots = null,
    Object? currentSlot = freezed,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterName: freezed == rosterName
          ? _value.rosterName
          : rosterName // ignore: cast_nullable_to_non_nullable
              as String?,
      draftPosition: freezed == draftPosition
          ? _value.draftPosition
          : draftPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      draftRound: freezed == draftRound
          ? _value.draftRound
          : draftRound // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPoints: freezed == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as double?,
      averagePoints: freezed == averagePoints
          ? _value.averagePoints
          : averagePoints // ignore: cast_nullable_to_non_nullable
              as double?,
      rosterSlots: null == rosterSlots
          ? _value.rosterSlots
          : rosterSlots // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentSlot: freezed == currentSlot
          ? _value.currentSlot
          : currentSlot // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of LeagueRosterPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeagueRosterPlayerImplCopyWith<$Res>
    implements $LeagueRosterPlayerCopyWith<$Res> {
  factory _$$LeagueRosterPlayerImplCopyWith(_$LeagueRosterPlayerImpl value,
          $Res Function(_$LeagueRosterPlayerImpl) then) =
      __$$LeagueRosterPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Player player,
      int rosterId,
      String? rosterName,
      int? draftPosition,
      int? draftRound,
      double? totalPoints,
      double? averagePoints,
      List<String> rosterSlots,
      String? currentSlot});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$LeagueRosterPlayerImplCopyWithImpl<$Res>
    extends _$LeagueRosterPlayerCopyWithImpl<$Res, _$LeagueRosterPlayerImpl>
    implements _$$LeagueRosterPlayerImplCopyWith<$Res> {
  __$$LeagueRosterPlayerImplCopyWithImpl(_$LeagueRosterPlayerImpl _value,
      $Res Function(_$LeagueRosterPlayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeagueRosterPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? rosterId = null,
    Object? rosterName = freezed,
    Object? draftPosition = freezed,
    Object? draftRound = freezed,
    Object? totalPoints = freezed,
    Object? averagePoints = freezed,
    Object? rosterSlots = null,
    Object? currentSlot = freezed,
  }) {
    return _then(_$LeagueRosterPlayerImpl(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterName: freezed == rosterName
          ? _value.rosterName
          : rosterName // ignore: cast_nullable_to_non_nullable
              as String?,
      draftPosition: freezed == draftPosition
          ? _value.draftPosition
          : draftPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      draftRound: freezed == draftRound
          ? _value.draftRound
          : draftRound // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPoints: freezed == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as double?,
      averagePoints: freezed == averagePoints
          ? _value.averagePoints
          : averagePoints // ignore: cast_nullable_to_non_nullable
              as double?,
      rosterSlots: null == rosterSlots
          ? _value._rosterSlots
          : rosterSlots // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentSlot: freezed == currentSlot
          ? _value.currentSlot
          : currentSlot // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LeagueRosterPlayerImpl extends _LeagueRosterPlayer {
  const _$LeagueRosterPlayerImpl(
      {required this.player,
      required this.rosterId,
      this.rosterName,
      this.draftPosition,
      this.draftRound,
      this.totalPoints,
      this.averagePoints,
      final List<String> rosterSlots = const [],
      this.currentSlot})
      : _rosterSlots = rosterSlots,
        super._();

  @override
  final Player player;
  @override
  final int rosterId;
  @override
  final String? rosterName;
  @override
  final int? draftPosition;
  @override
  final int? draftRound;
  @override
  final double? totalPoints;
  @override
  final double? averagePoints;
  final List<String> _rosterSlots;
  @override
  @JsonKey()
  List<String> get rosterSlots {
    if (_rosterSlots is EqualUnmodifiableListView) return _rosterSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rosterSlots);
  }

  @override
  final String? currentSlot;

  @override
  String toString() {
    return 'LeagueRosterPlayer(player: $player, rosterId: $rosterId, rosterName: $rosterName, draftPosition: $draftPosition, draftRound: $draftRound, totalPoints: $totalPoints, averagePoints: $averagePoints, rosterSlots: $rosterSlots, currentSlot: $currentSlot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueRosterPlayerImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.rosterId, rosterId) ||
                other.rosterId == rosterId) &&
            (identical(other.rosterName, rosterName) ||
                other.rosterName == rosterName) &&
            (identical(other.draftPosition, draftPosition) ||
                other.draftPosition == draftPosition) &&
            (identical(other.draftRound, draftRound) ||
                other.draftRound == draftRound) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.averagePoints, averagePoints) ||
                other.averagePoints == averagePoints) &&
            const DeepCollectionEquality()
                .equals(other._rosterSlots, _rosterSlots) &&
            (identical(other.currentSlot, currentSlot) ||
                other.currentSlot == currentSlot));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      player,
      rosterId,
      rosterName,
      draftPosition,
      draftRound,
      totalPoints,
      averagePoints,
      const DeepCollectionEquality().hash(_rosterSlots),
      currentSlot);

  /// Create a copy of LeagueRosterPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueRosterPlayerImplCopyWith<_$LeagueRosterPlayerImpl> get copyWith =>
      __$$LeagueRosterPlayerImplCopyWithImpl<_$LeagueRosterPlayerImpl>(
          this, _$identity);
}

abstract class _LeagueRosterPlayer extends LeagueRosterPlayer {
  const factory _LeagueRosterPlayer(
      {required final Player player,
      required final int rosterId,
      final String? rosterName,
      final int? draftPosition,
      final int? draftRound,
      final double? totalPoints,
      final double? averagePoints,
      final List<String> rosterSlots,
      final String? currentSlot}) = _$LeagueRosterPlayerImpl;
  const _LeagueRosterPlayer._() : super._();

  @override
  Player get player;
  @override
  int get rosterId;
  @override
  String? get rosterName;
  @override
  int? get draftPosition;
  @override
  int? get draftRound;
  @override
  double? get totalPoints;
  @override
  double? get averagePoints;
  @override
  List<String> get rosterSlots;
  @override
  String? get currentSlot;

  /// Create a copy of LeagueRosterPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueRosterPlayerImplCopyWith<_$LeagueRosterPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
