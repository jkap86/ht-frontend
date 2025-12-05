// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StarterSlot {
  int get playerId => throw _privateConstructorUsedError;
  String get slot => throw _privateConstructorUsedError;

  /// Create a copy of StarterSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StarterSlotCopyWith<StarterSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StarterSlotCopyWith<$Res> {
  factory $StarterSlotCopyWith(
          StarterSlot value, $Res Function(StarterSlot) then) =
      _$StarterSlotCopyWithImpl<$Res, StarterSlot>;
  @useResult
  $Res call({int playerId, String slot});
}

/// @nodoc
class _$StarterSlotCopyWithImpl<$Res, $Val extends StarterSlot>
    implements $StarterSlotCopyWith<$Res> {
  _$StarterSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StarterSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? slot = null,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StarterSlotImplCopyWith<$Res>
    implements $StarterSlotCopyWith<$Res> {
  factory _$$StarterSlotImplCopyWith(
          _$StarterSlotImpl value, $Res Function(_$StarterSlotImpl) then) =
      __$$StarterSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int playerId, String slot});
}

/// @nodoc
class __$$StarterSlotImplCopyWithImpl<$Res>
    extends _$StarterSlotCopyWithImpl<$Res, _$StarterSlotImpl>
    implements _$$StarterSlotImplCopyWith<$Res> {
  __$$StarterSlotImplCopyWithImpl(
      _$StarterSlotImpl _value, $Res Function(_$StarterSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of StarterSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? slot = null,
  }) {
    return _then(_$StarterSlotImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StarterSlotImpl implements _StarterSlot {
  const _$StarterSlotImpl({required this.playerId, required this.slot});

  @override
  final int playerId;
  @override
  final String slot;

  @override
  String toString() {
    return 'StarterSlot(playerId: $playerId, slot: $slot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StarterSlotImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.slot, slot) || other.slot == slot));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId, slot);

  /// Create a copy of StarterSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StarterSlotImplCopyWith<_$StarterSlotImpl> get copyWith =>
      __$$StarterSlotImplCopyWithImpl<_$StarterSlotImpl>(this, _$identity);
}

abstract class _StarterSlot implements StarterSlot {
  const factory _StarterSlot(
      {required final int playerId,
      required final String slot}) = _$StarterSlotImpl;

  @override
  int get playerId;
  @override
  String get slot;

  /// Create a copy of StarterSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StarterSlotImplCopyWith<_$StarterSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LineupPlayer {
  int get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get playerPosition => throw _privateConstructorUsedError;
  String get playerTeam => throw _privateConstructorUsedError;
  String get playerSleeperId => throw _privateConstructorUsedError;
  String? get slot => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  String? get gameStatus =>
      throw _privateConstructorUsedError; // Matchup display fields
  String? get opponent => throw _privateConstructorUsedError;
  double? get projectedPts => throw _privateConstructorUsedError;
  double? get actualPts => throw _privateConstructorUsedError;

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupPlayerCopyWith<LineupPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupPlayerCopyWith<$Res> {
  factory $LineupPlayerCopyWith(
          LineupPlayer value, $Res Function(LineupPlayer) then) =
      _$LineupPlayerCopyWithImpl<$Res, LineupPlayer>;
  @useResult
  $Res call(
      {int playerId,
      String playerName,
      String playerPosition,
      String playerTeam,
      String playerSleeperId,
      String? slot,
      bool isLocked,
      String? gameStatus,
      String? opponent,
      double? projectedPts,
      double? actualPts});
}

/// @nodoc
class _$LineupPlayerCopyWithImpl<$Res, $Val extends LineupPlayer>
    implements $LineupPlayerCopyWith<$Res> {
  _$LineupPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? playerPosition = null,
    Object? playerTeam = null,
    Object? playerSleeperId = null,
    Object? slot = freezed,
    Object? isLocked = null,
    Object? gameStatus = freezed,
    Object? opponent = freezed,
    Object? projectedPts = freezed,
    Object? actualPts = freezed,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      playerPosition: null == playerPosition
          ? _value.playerPosition
          : playerPosition // ignore: cast_nullable_to_non_nullable
              as String,
      playerTeam: null == playerTeam
          ? _value.playerTeam
          : playerTeam // ignore: cast_nullable_to_non_nullable
              as String,
      playerSleeperId: null == playerSleeperId
          ? _value.playerSleeperId
          : playerSleeperId // ignore: cast_nullable_to_non_nullable
              as String,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String?,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      gameStatus: freezed == gameStatus
          ? _value.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LineupPlayerImplCopyWith<$Res>
    implements $LineupPlayerCopyWith<$Res> {
  factory _$$LineupPlayerImplCopyWith(
          _$LineupPlayerImpl value, $Res Function(_$LineupPlayerImpl) then) =
      __$$LineupPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int playerId,
      String playerName,
      String playerPosition,
      String playerTeam,
      String playerSleeperId,
      String? slot,
      bool isLocked,
      String? gameStatus,
      String? opponent,
      double? projectedPts,
      double? actualPts});
}

/// @nodoc
class __$$LineupPlayerImplCopyWithImpl<$Res>
    extends _$LineupPlayerCopyWithImpl<$Res, _$LineupPlayerImpl>
    implements _$$LineupPlayerImplCopyWith<$Res> {
  __$$LineupPlayerImplCopyWithImpl(
      _$LineupPlayerImpl _value, $Res Function(_$LineupPlayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? playerPosition = null,
    Object? playerTeam = null,
    Object? playerSleeperId = null,
    Object? slot = freezed,
    Object? isLocked = null,
    Object? gameStatus = freezed,
    Object? opponent = freezed,
    Object? projectedPts = freezed,
    Object? actualPts = freezed,
  }) {
    return _then(_$LineupPlayerImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      playerPosition: null == playerPosition
          ? _value.playerPosition
          : playerPosition // ignore: cast_nullable_to_non_nullable
              as String,
      playerTeam: null == playerTeam
          ? _value.playerTeam
          : playerTeam // ignore: cast_nullable_to_non_nullable
              as String,
      playerSleeperId: null == playerSleeperId
          ? _value.playerSleeperId
          : playerSleeperId // ignore: cast_nullable_to_non_nullable
              as String,
      slot: freezed == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String?,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      gameStatus: freezed == gameStatus
          ? _value.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc

class _$LineupPlayerImpl implements _LineupPlayer {
  const _$LineupPlayerImpl(
      {required this.playerId,
      required this.playerName,
      required this.playerPosition,
      required this.playerTeam,
      required this.playerSleeperId,
      this.slot,
      required this.isLocked,
      this.gameStatus,
      this.opponent,
      this.projectedPts,
      this.actualPts});

  @override
  final int playerId;
  @override
  final String playerName;
  @override
  final String playerPosition;
  @override
  final String playerTeam;
  @override
  final String playerSleeperId;
  @override
  final String? slot;
  @override
  final bool isLocked;
  @override
  final String? gameStatus;
// Matchup display fields
  @override
  final String? opponent;
  @override
  final double? projectedPts;
  @override
  final double? actualPts;

  @override
  String toString() {
    return 'LineupPlayer(playerId: $playerId, playerName: $playerName, playerPosition: $playerPosition, playerTeam: $playerTeam, playerSleeperId: $playerSleeperId, slot: $slot, isLocked: $isLocked, gameStatus: $gameStatus, opponent: $opponent, projectedPts: $projectedPts, actualPts: $actualPts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupPlayerImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.playerPosition, playerPosition) ||
                other.playerPosition == playerPosition) &&
            (identical(other.playerTeam, playerTeam) ||
                other.playerTeam == playerTeam) &&
            (identical(other.playerSleeperId, playerSleeperId) ||
                other.playerSleeperId == playerSleeperId) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.gameStatus, gameStatus) ||
                other.gameStatus == gameStatus) &&
            (identical(other.opponent, opponent) ||
                other.opponent == opponent) &&
            (identical(other.projectedPts, projectedPts) ||
                other.projectedPts == projectedPts) &&
            (identical(other.actualPts, actualPts) ||
                other.actualPts == actualPts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      playerId,
      playerName,
      playerPosition,
      playerTeam,
      playerSleeperId,
      slot,
      isLocked,
      gameStatus,
      opponent,
      projectedPts,
      actualPts);

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupPlayerImplCopyWith<_$LineupPlayerImpl> get copyWith =>
      __$$LineupPlayerImplCopyWithImpl<_$LineupPlayerImpl>(this, _$identity);
}

abstract class _LineupPlayer implements LineupPlayer {
  const factory _LineupPlayer(
      {required final int playerId,
      required final String playerName,
      required final String playerPosition,
      required final String playerTeam,
      required final String playerSleeperId,
      final String? slot,
      required final bool isLocked,
      final String? gameStatus,
      final String? opponent,
      final double? projectedPts,
      final double? actualPts}) = _$LineupPlayerImpl;

  @override
  int get playerId;
  @override
  String get playerName;
  @override
  String get playerPosition;
  @override
  String get playerTeam;
  @override
  String get playerSleeperId;
  @override
  String? get slot;
  @override
  bool get isLocked;
  @override
  String? get gameStatus; // Matchup display fields
  @override
  String? get opponent;
  @override
  double? get projectedPts;
  @override
  double? get actualPts;

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupPlayerImplCopyWith<_$LineupPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeeklyLineup {
  int get id => throw _privateConstructorUsedError;
  int get rosterId => throw _privateConstructorUsedError;
  int get leagueId => throw _privateConstructorUsedError;
  int get week => throw _privateConstructorUsedError;
  String get season => throw _privateConstructorUsedError;
  List<StarterSlot> get starters => throw _privateConstructorUsedError;
  List<int> get bench => throw _privateConstructorUsedError;
  List<int> get ir => throw _privateConstructorUsedError;
  String? get modifiedBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyLineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyLineupCopyWith<WeeklyLineup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyLineupCopyWith<$Res> {
  factory $WeeklyLineupCopyWith(
          WeeklyLineup value, $Res Function(WeeklyLineup) then) =
      _$WeeklyLineupCopyWithImpl<$Res, WeeklyLineup>;
  @useResult
  $Res call(
      {int id,
      int rosterId,
      int leagueId,
      int week,
      String season,
      List<StarterSlot> starters,
      List<int> bench,
      List<int> ir,
      String? modifiedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WeeklyLineupCopyWithImpl<$Res, $Val extends WeeklyLineup>
    implements $WeeklyLineupCopyWith<$Res> {
  _$WeeklyLineupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyLineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rosterId = null,
    Object? leagueId = null,
    Object? week = null,
    Object? season = null,
    Object? starters = null,
    Object? bench = null,
    Object? ir = null,
    Object? modifiedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int,
      season: null == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String,
      starters: null == starters
          ? _value.starters
          : starters // ignore: cast_nullable_to_non_nullable
              as List<StarterSlot>,
      bench: null == bench
          ? _value.bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<int>,
      ir: null == ir
          ? _value.ir
          : ir // ignore: cast_nullable_to_non_nullable
              as List<int>,
      modifiedBy: freezed == modifiedBy
          ? _value.modifiedBy
          : modifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyLineupImplCopyWith<$Res>
    implements $WeeklyLineupCopyWith<$Res> {
  factory _$$WeeklyLineupImplCopyWith(
          _$WeeklyLineupImpl value, $Res Function(_$WeeklyLineupImpl) then) =
      __$$WeeklyLineupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int rosterId,
      int leagueId,
      int week,
      String season,
      List<StarterSlot> starters,
      List<int> bench,
      List<int> ir,
      String? modifiedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WeeklyLineupImplCopyWithImpl<$Res>
    extends _$WeeklyLineupCopyWithImpl<$Res, _$WeeklyLineupImpl>
    implements _$$WeeklyLineupImplCopyWith<$Res> {
  __$$WeeklyLineupImplCopyWithImpl(
      _$WeeklyLineupImpl _value, $Res Function(_$WeeklyLineupImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyLineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rosterId = null,
    Object? leagueId = null,
    Object? week = null,
    Object? season = null,
    Object? starters = null,
    Object? bench = null,
    Object? ir = null,
    Object? modifiedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WeeklyLineupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int,
      season: null == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String,
      starters: null == starters
          ? _value._starters
          : starters // ignore: cast_nullable_to_non_nullable
              as List<StarterSlot>,
      bench: null == bench
          ? _value._bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<int>,
      ir: null == ir
          ? _value._ir
          : ir // ignore: cast_nullable_to_non_nullable
              as List<int>,
      modifiedBy: freezed == modifiedBy
          ? _value.modifiedBy
          : modifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$WeeklyLineupImpl implements _WeeklyLineup {
  const _$WeeklyLineupImpl(
      {required this.id,
      required this.rosterId,
      required this.leagueId,
      required this.week,
      required this.season,
      required final List<StarterSlot> starters,
      required final List<int> bench,
      required final List<int> ir,
      this.modifiedBy,
      this.createdAt,
      this.updatedAt})
      : _starters = starters,
        _bench = bench,
        _ir = ir;

  @override
  final int id;
  @override
  final int rosterId;
  @override
  final int leagueId;
  @override
  final int week;
  @override
  final String season;
  final List<StarterSlot> _starters;
  @override
  List<StarterSlot> get starters {
    if (_starters is EqualUnmodifiableListView) return _starters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_starters);
  }

  final List<int> _bench;
  @override
  List<int> get bench {
    if (_bench is EqualUnmodifiableListView) return _bench;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bench);
  }

  final List<int> _ir;
  @override
  List<int> get ir {
    if (_ir is EqualUnmodifiableListView) return _ir;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ir);
  }

  @override
  final String? modifiedBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WeeklyLineup(id: $id, rosterId: $rosterId, leagueId: $leagueId, week: $week, season: $season, starters: $starters, bench: $bench, ir: $ir, modifiedBy: $modifiedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyLineupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rosterId, rosterId) ||
                other.rosterId == rosterId) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.season, season) || other.season == season) &&
            const DeepCollectionEquality().equals(other._starters, _starters) &&
            const DeepCollectionEquality().equals(other._bench, _bench) &&
            const DeepCollectionEquality().equals(other._ir, _ir) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      rosterId,
      leagueId,
      week,
      season,
      const DeepCollectionEquality().hash(_starters),
      const DeepCollectionEquality().hash(_bench),
      const DeepCollectionEquality().hash(_ir),
      modifiedBy,
      createdAt,
      updatedAt);

  /// Create a copy of WeeklyLineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyLineupImplCopyWith<_$WeeklyLineupImpl> get copyWith =>
      __$$WeeklyLineupImplCopyWithImpl<_$WeeklyLineupImpl>(this, _$identity);
}

abstract class _WeeklyLineup implements WeeklyLineup {
  const factory _WeeklyLineup(
      {required final int id,
      required final int rosterId,
      required final int leagueId,
      required final int week,
      required final String season,
      required final List<StarterSlot> starters,
      required final List<int> bench,
      required final List<int> ir,
      final String? modifiedBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$WeeklyLineupImpl;

  @override
  int get id;
  @override
  int get rosterId;
  @override
  int get leagueId;
  @override
  int get week;
  @override
  String get season;
  @override
  List<StarterSlot> get starters;
  @override
  List<int> get bench;
  @override
  List<int> get ir;
  @override
  String? get modifiedBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of WeeklyLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyLineupImplCopyWith<_$WeeklyLineupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LineupResponse {
  WeeklyLineup? get weeklyLineup => throw _privateConstructorUsedError;
  List<LineupPlayer> get starters => throw _privateConstructorUsedError;
  List<LineupPlayer> get bench => throw _privateConstructorUsedError;
  List<LineupPlayer> get ir => throw _privateConstructorUsedError;
  bool get canEdit => throw _privateConstructorUsedError;
  bool get isCommissioner => throw _privateConstructorUsedError;
  List<String> get lockedTeams => throw _privateConstructorUsedError;

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupResponseCopyWith<LineupResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupResponseCopyWith<$Res> {
  factory $LineupResponseCopyWith(
          LineupResponse value, $Res Function(LineupResponse) then) =
      _$LineupResponseCopyWithImpl<$Res, LineupResponse>;
  @useResult
  $Res call(
      {WeeklyLineup? weeklyLineup,
      List<LineupPlayer> starters,
      List<LineupPlayer> bench,
      List<LineupPlayer> ir,
      bool canEdit,
      bool isCommissioner,
      List<String> lockedTeams});

  $WeeklyLineupCopyWith<$Res>? get weeklyLineup;
}

/// @nodoc
class _$LineupResponseCopyWithImpl<$Res, $Val extends LineupResponse>
    implements $LineupResponseCopyWith<$Res> {
  _$LineupResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklyLineup = freezed,
    Object? starters = null,
    Object? bench = null,
    Object? ir = null,
    Object? canEdit = null,
    Object? isCommissioner = null,
    Object? lockedTeams = null,
  }) {
    return _then(_value.copyWith(
      weeklyLineup: freezed == weeklyLineup
          ? _value.weeklyLineup
          : weeklyLineup // ignore: cast_nullable_to_non_nullable
              as WeeklyLineup?,
      starters: null == starters
          ? _value.starters
          : starters // ignore: cast_nullable_to_non_nullable
              as List<LineupPlayer>,
      bench: null == bench
          ? _value.bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<LineupPlayer>,
      ir: null == ir
          ? _value.ir
          : ir // ignore: cast_nullable_to_non_nullable
              as List<LineupPlayer>,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      isCommissioner: null == isCommissioner
          ? _value.isCommissioner
          : isCommissioner // ignore: cast_nullable_to_non_nullable
              as bool,
      lockedTeams: null == lockedTeams
          ? _value.lockedTeams
          : lockedTeams // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklyLineupCopyWith<$Res>? get weeklyLineup {
    if (_value.weeklyLineup == null) {
      return null;
    }

    return $WeeklyLineupCopyWith<$Res>(_value.weeklyLineup!, (value) {
      return _then(_value.copyWith(weeklyLineup: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LineupResponseImplCopyWith<$Res>
    implements $LineupResponseCopyWith<$Res> {
  factory _$$LineupResponseImplCopyWith(_$LineupResponseImpl value,
          $Res Function(_$LineupResponseImpl) then) =
      __$$LineupResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WeeklyLineup? weeklyLineup,
      List<LineupPlayer> starters,
      List<LineupPlayer> bench,
      List<LineupPlayer> ir,
      bool canEdit,
      bool isCommissioner,
      List<String> lockedTeams});

  @override
  $WeeklyLineupCopyWith<$Res>? get weeklyLineup;
}

/// @nodoc
class __$$LineupResponseImplCopyWithImpl<$Res>
    extends _$LineupResponseCopyWithImpl<$Res, _$LineupResponseImpl>
    implements _$$LineupResponseImplCopyWith<$Res> {
  __$$LineupResponseImplCopyWithImpl(
      _$LineupResponseImpl _value, $Res Function(_$LineupResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklyLineup = freezed,
    Object? starters = null,
    Object? bench = null,
    Object? ir = null,
    Object? canEdit = null,
    Object? isCommissioner = null,
    Object? lockedTeams = null,
  }) {
    return _then(_$LineupResponseImpl(
      weeklyLineup: freezed == weeklyLineup
          ? _value.weeklyLineup
          : weeklyLineup // ignore: cast_nullable_to_non_nullable
              as WeeklyLineup?,
      starters: null == starters
          ? _value._starters
          : starters // ignore: cast_nullable_to_non_nullable
              as List<LineupPlayer>,
      bench: null == bench
          ? _value._bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<LineupPlayer>,
      ir: null == ir
          ? _value._ir
          : ir // ignore: cast_nullable_to_non_nullable
              as List<LineupPlayer>,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      isCommissioner: null == isCommissioner
          ? _value.isCommissioner
          : isCommissioner // ignore: cast_nullable_to_non_nullable
              as bool,
      lockedTeams: null == lockedTeams
          ? _value._lockedTeams
          : lockedTeams // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$LineupResponseImpl implements _LineupResponse {
  const _$LineupResponseImpl(
      {this.weeklyLineup,
      required final List<LineupPlayer> starters,
      required final List<LineupPlayer> bench,
      required final List<LineupPlayer> ir,
      required this.canEdit,
      required this.isCommissioner,
      required final List<String> lockedTeams})
      : _starters = starters,
        _bench = bench,
        _ir = ir,
        _lockedTeams = lockedTeams;

  @override
  final WeeklyLineup? weeklyLineup;
  final List<LineupPlayer> _starters;
  @override
  List<LineupPlayer> get starters {
    if (_starters is EqualUnmodifiableListView) return _starters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_starters);
  }

  final List<LineupPlayer> _bench;
  @override
  List<LineupPlayer> get bench {
    if (_bench is EqualUnmodifiableListView) return _bench;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bench);
  }

  final List<LineupPlayer> _ir;
  @override
  List<LineupPlayer> get ir {
    if (_ir is EqualUnmodifiableListView) return _ir;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ir);
  }

  @override
  final bool canEdit;
  @override
  final bool isCommissioner;
  final List<String> _lockedTeams;
  @override
  List<String> get lockedTeams {
    if (_lockedTeams is EqualUnmodifiableListView) return _lockedTeams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lockedTeams);
  }

  @override
  String toString() {
    return 'LineupResponse(weeklyLineup: $weeklyLineup, starters: $starters, bench: $bench, ir: $ir, canEdit: $canEdit, isCommissioner: $isCommissioner, lockedTeams: $lockedTeams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupResponseImpl &&
            (identical(other.weeklyLineup, weeklyLineup) ||
                other.weeklyLineup == weeklyLineup) &&
            const DeepCollectionEquality().equals(other._starters, _starters) &&
            const DeepCollectionEquality().equals(other._bench, _bench) &&
            const DeepCollectionEquality().equals(other._ir, _ir) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.isCommissioner, isCommissioner) ||
                other.isCommissioner == isCommissioner) &&
            const DeepCollectionEquality()
                .equals(other._lockedTeams, _lockedTeams));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      weeklyLineup,
      const DeepCollectionEquality().hash(_starters),
      const DeepCollectionEquality().hash(_bench),
      const DeepCollectionEquality().hash(_ir),
      canEdit,
      isCommissioner,
      const DeepCollectionEquality().hash(_lockedTeams));

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupResponseImplCopyWith<_$LineupResponseImpl> get copyWith =>
      __$$LineupResponseImplCopyWithImpl<_$LineupResponseImpl>(
          this, _$identity);
}

abstract class _LineupResponse implements LineupResponse {
  const factory _LineupResponse(
      {final WeeklyLineup? weeklyLineup,
      required final List<LineupPlayer> starters,
      required final List<LineupPlayer> bench,
      required final List<LineupPlayer> ir,
      required final bool canEdit,
      required final bool isCommissioner,
      required final List<String> lockedTeams}) = _$LineupResponseImpl;

  @override
  WeeklyLineup? get weeklyLineup;
  @override
  List<LineupPlayer> get starters;
  @override
  List<LineupPlayer> get bench;
  @override
  List<LineupPlayer> get ir;
  @override
  bool get canEdit;
  @override
  bool get isCommissioner;
  @override
  List<String> get lockedTeams;

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupResponseImplCopyWith<_$LineupResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
