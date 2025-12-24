// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiver_claim.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WaiverClaim _$WaiverClaimFromJson(Map<String, dynamic> json) {
  return _WaiverClaim.fromJson(json);
}

/// @nodoc
mixin _$WaiverClaim {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'league_id')
  int get leagueId => throw _privateConstructorUsedError;
  @JsonKey(name: 'roster_id')
  int get rosterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_id')
  int get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_player_id')
  int? get dropPlayerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'faab_amount')
  int get faabAmount => throw _privateConstructorUsedError;
  int? get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'processed_at')
  DateTime? get processedAt => throw _privateConstructorUsedError;
  int get week => throw _privateConstructorUsedError;
  String get season => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_name')
  String? get playerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_position')
  String? get playerPosition => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_team')
  String? get playerTeam => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_player_name')
  String? get dropPlayerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_player_position')
  String? get dropPlayerPosition => throw _privateConstructorUsedError;
  @JsonKey(name: 'roster_username')
  String? get rosterUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'roster_number')
  int? get rosterNumber => throw _privateConstructorUsedError;

  /// Serializes this WaiverClaim to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WaiverClaim
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaiverClaimCopyWith<WaiverClaim> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaiverClaimCopyWith<$Res> {
  factory $WaiverClaimCopyWith(
          WaiverClaim value, $Res Function(WaiverClaim) then) =
      _$WaiverClaimCopyWithImpl<$Res, WaiverClaim>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'league_id') int leagueId,
      @JsonKey(name: 'roster_id') int rosterId,
      @JsonKey(name: 'player_id') int playerId,
      @JsonKey(name: 'drop_player_id') int? dropPlayerId,
      @JsonKey(name: 'faab_amount') int faabAmount,
      int? priority,
      String status,
      @JsonKey(name: 'processed_at') DateTime? processedAt,
      int week,
      String season,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_name') String? playerName,
      @JsonKey(name: 'player_position') String? playerPosition,
      @JsonKey(name: 'player_team') String? playerTeam,
      @JsonKey(name: 'drop_player_name') String? dropPlayerName,
      @JsonKey(name: 'drop_player_position') String? dropPlayerPosition,
      @JsonKey(name: 'roster_username') String? rosterUsername,
      @JsonKey(name: 'roster_number') int? rosterNumber});
}

/// @nodoc
class _$WaiverClaimCopyWithImpl<$Res, $Val extends WaiverClaim>
    implements $WaiverClaimCopyWith<$Res> {
  _$WaiverClaimCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaiverClaim
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? rosterId = null,
    Object? playerId = null,
    Object? dropPlayerId = freezed,
    Object? faabAmount = null,
    Object? priority = freezed,
    Object? status = null,
    Object? processedAt = freezed,
    Object? week = null,
    Object? season = null,
    Object? createdAt = null,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
    Object? dropPlayerName = freezed,
    Object? dropPlayerPosition = freezed,
    Object? rosterUsername = freezed,
    Object? rosterNumber = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      dropPlayerId: freezed == dropPlayerId
          ? _value.dropPlayerId
          : dropPlayerId // ignore: cast_nullable_to_non_nullable
              as int?,
      faabAmount: null == faabAmount
          ? _value.faabAmount
          : faabAmount // ignore: cast_nullable_to_non_nullable
              as int,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int,
      season: null == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      dropPlayerName: freezed == dropPlayerName
          ? _value.dropPlayerName
          : dropPlayerName // ignore: cast_nullable_to_non_nullable
              as String?,
      dropPlayerPosition: freezed == dropPlayerPosition
          ? _value.dropPlayerPosition
          : dropPlayerPosition // ignore: cast_nullable_to_non_nullable
              as String?,
      rosterUsername: freezed == rosterUsername
          ? _value.rosterUsername
          : rosterUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      rosterNumber: freezed == rosterNumber
          ? _value.rosterNumber
          : rosterNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WaiverClaimImplCopyWith<$Res>
    implements $WaiverClaimCopyWith<$Res> {
  factory _$$WaiverClaimImplCopyWith(
          _$WaiverClaimImpl value, $Res Function(_$WaiverClaimImpl) then) =
      __$$WaiverClaimImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'league_id') int leagueId,
      @JsonKey(name: 'roster_id') int rosterId,
      @JsonKey(name: 'player_id') int playerId,
      @JsonKey(name: 'drop_player_id') int? dropPlayerId,
      @JsonKey(name: 'faab_amount') int faabAmount,
      int? priority,
      String status,
      @JsonKey(name: 'processed_at') DateTime? processedAt,
      int week,
      String season,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_name') String? playerName,
      @JsonKey(name: 'player_position') String? playerPosition,
      @JsonKey(name: 'player_team') String? playerTeam,
      @JsonKey(name: 'drop_player_name') String? dropPlayerName,
      @JsonKey(name: 'drop_player_position') String? dropPlayerPosition,
      @JsonKey(name: 'roster_username') String? rosterUsername,
      @JsonKey(name: 'roster_number') int? rosterNumber});
}

/// @nodoc
class __$$WaiverClaimImplCopyWithImpl<$Res>
    extends _$WaiverClaimCopyWithImpl<$Res, _$WaiverClaimImpl>
    implements _$$WaiverClaimImplCopyWith<$Res> {
  __$$WaiverClaimImplCopyWithImpl(
      _$WaiverClaimImpl _value, $Res Function(_$WaiverClaimImpl) _then)
      : super(_value, _then);

  /// Create a copy of WaiverClaim
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? rosterId = null,
    Object? playerId = null,
    Object? dropPlayerId = freezed,
    Object? faabAmount = null,
    Object? priority = freezed,
    Object? status = null,
    Object? processedAt = freezed,
    Object? week = null,
    Object? season = null,
    Object? createdAt = null,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
    Object? dropPlayerName = freezed,
    Object? dropPlayerPosition = freezed,
    Object? rosterUsername = freezed,
    Object? rosterNumber = freezed,
  }) {
    return _then(_$WaiverClaimImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      dropPlayerId: freezed == dropPlayerId
          ? _value.dropPlayerId
          : dropPlayerId // ignore: cast_nullable_to_non_nullable
              as int?,
      faabAmount: null == faabAmount
          ? _value.faabAmount
          : faabAmount // ignore: cast_nullable_to_non_nullable
              as int,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int,
      season: null == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      dropPlayerName: freezed == dropPlayerName
          ? _value.dropPlayerName
          : dropPlayerName // ignore: cast_nullable_to_non_nullable
              as String?,
      dropPlayerPosition: freezed == dropPlayerPosition
          ? _value.dropPlayerPosition
          : dropPlayerPosition // ignore: cast_nullable_to_non_nullable
              as String?,
      rosterUsername: freezed == rosterUsername
          ? _value.rosterUsername
          : rosterUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      rosterNumber: freezed == rosterNumber
          ? _value.rosterNumber
          : rosterNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WaiverClaimImpl implements _WaiverClaim {
  const _$WaiverClaimImpl(
      {required this.id,
      @JsonKey(name: 'league_id') required this.leagueId,
      @JsonKey(name: 'roster_id') required this.rosterId,
      @JsonKey(name: 'player_id') required this.playerId,
      @JsonKey(name: 'drop_player_id') this.dropPlayerId,
      @JsonKey(name: 'faab_amount') this.faabAmount = 0,
      this.priority,
      required this.status,
      @JsonKey(name: 'processed_at') this.processedAt,
      required this.week,
      required this.season,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'player_name') this.playerName,
      @JsonKey(name: 'player_position') this.playerPosition,
      @JsonKey(name: 'player_team') this.playerTeam,
      @JsonKey(name: 'drop_player_name') this.dropPlayerName,
      @JsonKey(name: 'drop_player_position') this.dropPlayerPosition,
      @JsonKey(name: 'roster_username') this.rosterUsername,
      @JsonKey(name: 'roster_number') this.rosterNumber});

  factory _$WaiverClaimImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaiverClaimImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'league_id')
  final int leagueId;
  @override
  @JsonKey(name: 'roster_id')
  final int rosterId;
  @override
  @JsonKey(name: 'player_id')
  final int playerId;
  @override
  @JsonKey(name: 'drop_player_id')
  final int? dropPlayerId;
  @override
  @JsonKey(name: 'faab_amount')
  final int faabAmount;
  @override
  final int? priority;
  @override
  final String status;
  @override
  @JsonKey(name: 'processed_at')
  final DateTime? processedAt;
  @override
  final int week;
  @override
  final String season;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'player_name')
  final String? playerName;
  @override
  @JsonKey(name: 'player_position')
  final String? playerPosition;
  @override
  @JsonKey(name: 'player_team')
  final String? playerTeam;
  @override
  @JsonKey(name: 'drop_player_name')
  final String? dropPlayerName;
  @override
  @JsonKey(name: 'drop_player_position')
  final String? dropPlayerPosition;
  @override
  @JsonKey(name: 'roster_username')
  final String? rosterUsername;
  @override
  @JsonKey(name: 'roster_number')
  final int? rosterNumber;

  @override
  String toString() {
    return 'WaiverClaim(id: $id, leagueId: $leagueId, rosterId: $rosterId, playerId: $playerId, dropPlayerId: $dropPlayerId, faabAmount: $faabAmount, priority: $priority, status: $status, processedAt: $processedAt, week: $week, season: $season, createdAt: $createdAt, playerName: $playerName, playerPosition: $playerPosition, playerTeam: $playerTeam, dropPlayerName: $dropPlayerName, dropPlayerPosition: $dropPlayerPosition, rosterUsername: $rosterUsername, rosterNumber: $rosterNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaiverClaimImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.rosterId, rosterId) ||
                other.rosterId == rosterId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.dropPlayerId, dropPlayerId) ||
                other.dropPlayerId == dropPlayerId) &&
            (identical(other.faabAmount, faabAmount) ||
                other.faabAmount == faabAmount) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.playerPosition, playerPosition) ||
                other.playerPosition == playerPosition) &&
            (identical(other.playerTeam, playerTeam) ||
                other.playerTeam == playerTeam) &&
            (identical(other.dropPlayerName, dropPlayerName) ||
                other.dropPlayerName == dropPlayerName) &&
            (identical(other.dropPlayerPosition, dropPlayerPosition) ||
                other.dropPlayerPosition == dropPlayerPosition) &&
            (identical(other.rosterUsername, rosterUsername) ||
                other.rosterUsername == rosterUsername) &&
            (identical(other.rosterNumber, rosterNumber) ||
                other.rosterNumber == rosterNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        leagueId,
        rosterId,
        playerId,
        dropPlayerId,
        faabAmount,
        priority,
        status,
        processedAt,
        week,
        season,
        createdAt,
        playerName,
        playerPosition,
        playerTeam,
        dropPlayerName,
        dropPlayerPosition,
        rosterUsername,
        rosterNumber
      ]);

  /// Create a copy of WaiverClaim
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaiverClaimImplCopyWith<_$WaiverClaimImpl> get copyWith =>
      __$$WaiverClaimImplCopyWithImpl<_$WaiverClaimImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaiverClaimImplToJson(
      this,
    );
  }
}

abstract class _WaiverClaim implements WaiverClaim {
  const factory _WaiverClaim(
      {required final int id,
      @JsonKey(name: 'league_id') required final int leagueId,
      @JsonKey(name: 'roster_id') required final int rosterId,
      @JsonKey(name: 'player_id') required final int playerId,
      @JsonKey(name: 'drop_player_id') final int? dropPlayerId,
      @JsonKey(name: 'faab_amount') final int faabAmount,
      final int? priority,
      required final String status,
      @JsonKey(name: 'processed_at') final DateTime? processedAt,
      required final int week,
      required final String season,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'player_name') final String? playerName,
      @JsonKey(name: 'player_position') final String? playerPosition,
      @JsonKey(name: 'player_team') final String? playerTeam,
      @JsonKey(name: 'drop_player_name') final String? dropPlayerName,
      @JsonKey(name: 'drop_player_position') final String? dropPlayerPosition,
      @JsonKey(name: 'roster_username') final String? rosterUsername,
      @JsonKey(name: 'roster_number')
      final int? rosterNumber}) = _$WaiverClaimImpl;

  factory _WaiverClaim.fromJson(Map<String, dynamic> json) =
      _$WaiverClaimImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'league_id')
  int get leagueId;
  @override
  @JsonKey(name: 'roster_id')
  int get rosterId;
  @override
  @JsonKey(name: 'player_id')
  int get playerId;
  @override
  @JsonKey(name: 'drop_player_id')
  int? get dropPlayerId;
  @override
  @JsonKey(name: 'faab_amount')
  int get faabAmount;
  @override
  int? get priority;
  @override
  String get status;
  @override
  @JsonKey(name: 'processed_at')
  DateTime? get processedAt;
  @override
  int get week;
  @override
  String get season;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'player_name')
  String? get playerName;
  @override
  @JsonKey(name: 'player_position')
  String? get playerPosition;
  @override
  @JsonKey(name: 'player_team')
  String? get playerTeam;
  @override
  @JsonKey(name: 'drop_player_name')
  String? get dropPlayerName;
  @override
  @JsonKey(name: 'drop_player_position')
  String? get dropPlayerPosition;
  @override
  @JsonKey(name: 'roster_username')
  String? get rosterUsername;
  @override
  @JsonKey(name: 'roster_number')
  int? get rosterNumber;

  /// Create a copy of WaiverClaim
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaiverClaimImplCopyWith<_$WaiverClaimImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailablePlayer _$AvailablePlayerFromJson(Map<String, dynamic> json) {
  return _AvailablePlayer.fromJson(json);
}

/// @nodoc
mixin _$AvailablePlayer {
  @JsonKey(name: 'playerId')
  int get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'playerName')
  String get playerName => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  String get team => throw _privateConstructorUsedError;
  @JsonKey(name: 'isOnWaivers')
  bool get isOnWaivers => throw _privateConstructorUsedError;
  @JsonKey(name: 'waiverClearsAt')
  DateTime? get waiverClearsAt => throw _privateConstructorUsedError;

  /// Serializes this AvailablePlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailablePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailablePlayerCopyWith<AvailablePlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailablePlayerCopyWith<$Res> {
  factory $AvailablePlayerCopyWith(
          AvailablePlayer value, $Res Function(AvailablePlayer) then) =
      _$AvailablePlayerCopyWithImpl<$Res, AvailablePlayer>;
  @useResult
  $Res call(
      {@JsonKey(name: 'playerId') int playerId,
      @JsonKey(name: 'playerName') String playerName,
      String position,
      String team,
      @JsonKey(name: 'isOnWaivers') bool isOnWaivers,
      @JsonKey(name: 'waiverClearsAt') DateTime? waiverClearsAt});
}

/// @nodoc
class _$AvailablePlayerCopyWithImpl<$Res, $Val extends AvailablePlayer>
    implements $AvailablePlayerCopyWith<$Res> {
  _$AvailablePlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailablePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? position = null,
    Object? team = null,
    Object? isOnWaivers = null,
    Object? waiverClearsAt = freezed,
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
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as String,
      isOnWaivers: null == isOnWaivers
          ? _value.isOnWaivers
          : isOnWaivers // ignore: cast_nullable_to_non_nullable
              as bool,
      waiverClearsAt: freezed == waiverClearsAt
          ? _value.waiverClearsAt
          : waiverClearsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailablePlayerImplCopyWith<$Res>
    implements $AvailablePlayerCopyWith<$Res> {
  factory _$$AvailablePlayerImplCopyWith(_$AvailablePlayerImpl value,
          $Res Function(_$AvailablePlayerImpl) then) =
      __$$AvailablePlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'playerId') int playerId,
      @JsonKey(name: 'playerName') String playerName,
      String position,
      String team,
      @JsonKey(name: 'isOnWaivers') bool isOnWaivers,
      @JsonKey(name: 'waiverClearsAt') DateTime? waiverClearsAt});
}

/// @nodoc
class __$$AvailablePlayerImplCopyWithImpl<$Res>
    extends _$AvailablePlayerCopyWithImpl<$Res, _$AvailablePlayerImpl>
    implements _$$AvailablePlayerImplCopyWith<$Res> {
  __$$AvailablePlayerImplCopyWithImpl(
      _$AvailablePlayerImpl _value, $Res Function(_$AvailablePlayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailablePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? position = null,
    Object? team = null,
    Object? isOnWaivers = null,
    Object? waiverClearsAt = freezed,
  }) {
    return _then(_$AvailablePlayerImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as String,
      isOnWaivers: null == isOnWaivers
          ? _value.isOnWaivers
          : isOnWaivers // ignore: cast_nullable_to_non_nullable
              as bool,
      waiverClearsAt: freezed == waiverClearsAt
          ? _value.waiverClearsAt
          : waiverClearsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailablePlayerImpl implements _AvailablePlayer {
  const _$AvailablePlayerImpl(
      {@JsonKey(name: 'playerId') required this.playerId,
      @JsonKey(name: 'playerName') this.playerName = 'Unknown',
      this.position = '',
      this.team = 'FA',
      @JsonKey(name: 'isOnWaivers') this.isOnWaivers = false,
      @JsonKey(name: 'waiverClearsAt') this.waiverClearsAt});

  factory _$AvailablePlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailablePlayerImplFromJson(json);

  @override
  @JsonKey(name: 'playerId')
  final int playerId;
  @override
  @JsonKey(name: 'playerName')
  final String playerName;
  @override
  @JsonKey()
  final String position;
  @override
  @JsonKey()
  final String team;
  @override
  @JsonKey(name: 'isOnWaivers')
  final bool isOnWaivers;
  @override
  @JsonKey(name: 'waiverClearsAt')
  final DateTime? waiverClearsAt;

  @override
  String toString() {
    return 'AvailablePlayer(playerId: $playerId, playerName: $playerName, position: $position, team: $team, isOnWaivers: $isOnWaivers, waiverClearsAt: $waiverClearsAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailablePlayerImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.isOnWaivers, isOnWaivers) ||
                other.isOnWaivers == isOnWaivers) &&
            (identical(other.waiverClearsAt, waiverClearsAt) ||
                other.waiverClearsAt == waiverClearsAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerId, playerName, position,
      team, isOnWaivers, waiverClearsAt);

  /// Create a copy of AvailablePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailablePlayerImplCopyWith<_$AvailablePlayerImpl> get copyWith =>
      __$$AvailablePlayerImplCopyWithImpl<_$AvailablePlayerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailablePlayerImplToJson(
      this,
    );
  }
}

abstract class _AvailablePlayer implements AvailablePlayer {
  const factory _AvailablePlayer(
          {@JsonKey(name: 'playerId') required final int playerId,
          @JsonKey(name: 'playerName') final String playerName,
          final String position,
          final String team,
          @JsonKey(name: 'isOnWaivers') final bool isOnWaivers,
          @JsonKey(name: 'waiverClearsAt') final DateTime? waiverClearsAt}) =
      _$AvailablePlayerImpl;

  factory _AvailablePlayer.fromJson(Map<String, dynamic> json) =
      _$AvailablePlayerImpl.fromJson;

  @override
  @JsonKey(name: 'playerId')
  int get playerId;
  @override
  @JsonKey(name: 'playerName')
  String get playerName;
  @override
  String get position;
  @override
  String get team;
  @override
  @JsonKey(name: 'isOnWaivers')
  bool get isOnWaivers;
  @override
  @JsonKey(name: 'waiverClearsAt')
  DateTime? get waiverClearsAt;

  /// Create a copy of AvailablePlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailablePlayerImplCopyWith<_$AvailablePlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmitClaimRequest _$SubmitClaimRequestFromJson(Map<String, dynamic> json) {
  return _SubmitClaimRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitClaimRequest {
  @JsonKey(name: 'player_id')
  int get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_player_id')
  int? get dropPlayerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'faab_amount')
  int? get faabAmount => throw _privateConstructorUsedError;

  /// Serializes this SubmitClaimRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitClaimRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitClaimRequestCopyWith<SubmitClaimRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitClaimRequestCopyWith<$Res> {
  factory $SubmitClaimRequestCopyWith(
          SubmitClaimRequest value, $Res Function(SubmitClaimRequest) then) =
      _$SubmitClaimRequestCopyWithImpl<$Res, SubmitClaimRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'player_id') int playerId,
      @JsonKey(name: 'drop_player_id') int? dropPlayerId,
      @JsonKey(name: 'faab_amount') int? faabAmount});
}

/// @nodoc
class _$SubmitClaimRequestCopyWithImpl<$Res, $Val extends SubmitClaimRequest>
    implements $SubmitClaimRequestCopyWith<$Res> {
  _$SubmitClaimRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitClaimRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? dropPlayerId = freezed,
    Object? faabAmount = freezed,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      dropPlayerId: freezed == dropPlayerId
          ? _value.dropPlayerId
          : dropPlayerId // ignore: cast_nullable_to_non_nullable
              as int?,
      faabAmount: freezed == faabAmount
          ? _value.faabAmount
          : faabAmount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubmitClaimRequestImplCopyWith<$Res>
    implements $SubmitClaimRequestCopyWith<$Res> {
  factory _$$SubmitClaimRequestImplCopyWith(_$SubmitClaimRequestImpl value,
          $Res Function(_$SubmitClaimRequestImpl) then) =
      __$$SubmitClaimRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'player_id') int playerId,
      @JsonKey(name: 'drop_player_id') int? dropPlayerId,
      @JsonKey(name: 'faab_amount') int? faabAmount});
}

/// @nodoc
class __$$SubmitClaimRequestImplCopyWithImpl<$Res>
    extends _$SubmitClaimRequestCopyWithImpl<$Res, _$SubmitClaimRequestImpl>
    implements _$$SubmitClaimRequestImplCopyWith<$Res> {
  __$$SubmitClaimRequestImplCopyWithImpl(_$SubmitClaimRequestImpl _value,
      $Res Function(_$SubmitClaimRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubmitClaimRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? dropPlayerId = freezed,
    Object? faabAmount = freezed,
  }) {
    return _then(_$SubmitClaimRequestImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      dropPlayerId: freezed == dropPlayerId
          ? _value.dropPlayerId
          : dropPlayerId // ignore: cast_nullable_to_non_nullable
              as int?,
      faabAmount: freezed == faabAmount
          ? _value.faabAmount
          : faabAmount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitClaimRequestImpl implements _SubmitClaimRequest {
  const _$SubmitClaimRequestImpl(
      {@JsonKey(name: 'player_id') required this.playerId,
      @JsonKey(name: 'drop_player_id') this.dropPlayerId,
      @JsonKey(name: 'faab_amount') this.faabAmount});

  factory _$SubmitClaimRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitClaimRequestImplFromJson(json);

  @override
  @JsonKey(name: 'player_id')
  final int playerId;
  @override
  @JsonKey(name: 'drop_player_id')
  final int? dropPlayerId;
  @override
  @JsonKey(name: 'faab_amount')
  final int? faabAmount;

  @override
  String toString() {
    return 'SubmitClaimRequest(playerId: $playerId, dropPlayerId: $dropPlayerId, faabAmount: $faabAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitClaimRequestImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.dropPlayerId, dropPlayerId) ||
                other.dropPlayerId == dropPlayerId) &&
            (identical(other.faabAmount, faabAmount) ||
                other.faabAmount == faabAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, playerId, dropPlayerId, faabAmount);

  /// Create a copy of SubmitClaimRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitClaimRequestImplCopyWith<_$SubmitClaimRequestImpl> get copyWith =>
      __$$SubmitClaimRequestImplCopyWithImpl<_$SubmitClaimRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitClaimRequestImplToJson(
      this,
    );
  }
}

abstract class _SubmitClaimRequest implements SubmitClaimRequest {
  const factory _SubmitClaimRequest(
          {@JsonKey(name: 'player_id') required final int playerId,
          @JsonKey(name: 'drop_player_id') final int? dropPlayerId,
          @JsonKey(name: 'faab_amount') final int? faabAmount}) =
      _$SubmitClaimRequestImpl;

  factory _SubmitClaimRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitClaimRequestImpl.fromJson;

  @override
  @JsonKey(name: 'player_id')
  int get playerId;
  @override
  @JsonKey(name: 'drop_player_id')
  int? get dropPlayerId;
  @override
  @JsonKey(name: 'faab_amount')
  int? get faabAmount;

  /// Create a copy of SubmitClaimRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitClaimRequestImplCopyWith<_$SubmitClaimRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RosterTransaction _$RosterTransactionFromJson(Map<String, dynamic> json) {
  return _RosterTransaction.fromJson(json);
}

/// @nodoc
mixin _$RosterTransaction {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'league_id')
  int get leagueId => throw _privateConstructorUsedError;
  @JsonKey(name: 'roster_id')
  int get rosterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_type')
  String get transactionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_id')
  int get playerId => throw _privateConstructorUsedError;
  bool get acquired => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_transaction_id')
  int? get relatedTransactionId => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  int? get week => throw _privateConstructorUsedError;
  String? get season => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_name')
  String? get playerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_position')
  String? get playerPosition => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_team')
  String? get playerTeam => throw _privateConstructorUsedError;
  @JsonKey(name: 'roster_username')
  String? get rosterUsername => throw _privateConstructorUsedError;

  /// Serializes this RosterTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RosterTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RosterTransactionCopyWith<RosterTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RosterTransactionCopyWith<$Res> {
  factory $RosterTransactionCopyWith(
          RosterTransaction value, $Res Function(RosterTransaction) then) =
      _$RosterTransactionCopyWithImpl<$Res, RosterTransaction>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'league_id') int leagueId,
      @JsonKey(name: 'roster_id') int rosterId,
      @JsonKey(name: 'transaction_type') String transactionType,
      @JsonKey(name: 'player_id') int playerId,
      bool acquired,
      @JsonKey(name: 'related_transaction_id') int? relatedTransactionId,
      Map<String, dynamic> metadata,
      int? week,
      String? season,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_name') String? playerName,
      @JsonKey(name: 'player_position') String? playerPosition,
      @JsonKey(name: 'player_team') String? playerTeam,
      @JsonKey(name: 'roster_username') String? rosterUsername});
}

/// @nodoc
class _$RosterTransactionCopyWithImpl<$Res, $Val extends RosterTransaction>
    implements $RosterTransactionCopyWith<$Res> {
  _$RosterTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RosterTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? rosterId = null,
    Object? transactionType = null,
    Object? playerId = null,
    Object? acquired = null,
    Object? relatedTransactionId = freezed,
    Object? metadata = null,
    Object? week = freezed,
    Object? season = freezed,
    Object? createdAt = null,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
    Object? rosterUsername = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      acquired: null == acquired
          ? _value.acquired
          : acquired // ignore: cast_nullable_to_non_nullable
              as bool,
      relatedTransactionId: freezed == relatedTransactionId
          ? _value.relatedTransactionId
          : relatedTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      week: freezed == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      rosterUsername: freezed == rosterUsername
          ? _value.rosterUsername
          : rosterUsername // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RosterTransactionImplCopyWith<$Res>
    implements $RosterTransactionCopyWith<$Res> {
  factory _$$RosterTransactionImplCopyWith(_$RosterTransactionImpl value,
          $Res Function(_$RosterTransactionImpl) then) =
      __$$RosterTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'league_id') int leagueId,
      @JsonKey(name: 'roster_id') int rosterId,
      @JsonKey(name: 'transaction_type') String transactionType,
      @JsonKey(name: 'player_id') int playerId,
      bool acquired,
      @JsonKey(name: 'related_transaction_id') int? relatedTransactionId,
      Map<String, dynamic> metadata,
      int? week,
      String? season,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_name') String? playerName,
      @JsonKey(name: 'player_position') String? playerPosition,
      @JsonKey(name: 'player_team') String? playerTeam,
      @JsonKey(name: 'roster_username') String? rosterUsername});
}

/// @nodoc
class __$$RosterTransactionImplCopyWithImpl<$Res>
    extends _$RosterTransactionCopyWithImpl<$Res, _$RosterTransactionImpl>
    implements _$$RosterTransactionImplCopyWith<$Res> {
  __$$RosterTransactionImplCopyWithImpl(_$RosterTransactionImpl _value,
      $Res Function(_$RosterTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RosterTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? rosterId = null,
    Object? transactionType = null,
    Object? playerId = null,
    Object? acquired = null,
    Object? relatedTransactionId = freezed,
    Object? metadata = null,
    Object? week = freezed,
    Object? season = freezed,
    Object? createdAt = null,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
    Object? rosterUsername = freezed,
  }) {
    return _then(_$RosterTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      acquired: null == acquired
          ? _value.acquired
          : acquired // ignore: cast_nullable_to_non_nullable
              as bool,
      relatedTransactionId: freezed == relatedTransactionId
          ? _value.relatedTransactionId
          : relatedTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      week: freezed == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      rosterUsername: freezed == rosterUsername
          ? _value.rosterUsername
          : rosterUsername // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RosterTransactionImpl implements _RosterTransaction {
  const _$RosterTransactionImpl(
      {required this.id,
      @JsonKey(name: 'league_id') required this.leagueId,
      @JsonKey(name: 'roster_id') required this.rosterId,
      @JsonKey(name: 'transaction_type') required this.transactionType,
      @JsonKey(name: 'player_id') required this.playerId,
      required this.acquired,
      @JsonKey(name: 'related_transaction_id') this.relatedTransactionId,
      final Map<String, dynamic> metadata = const {},
      this.week,
      this.season,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'player_name') this.playerName,
      @JsonKey(name: 'player_position') this.playerPosition,
      @JsonKey(name: 'player_team') this.playerTeam,
      @JsonKey(name: 'roster_username') this.rosterUsername})
      : _metadata = metadata;

  factory _$RosterTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RosterTransactionImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'league_id')
  final int leagueId;
  @override
  @JsonKey(name: 'roster_id')
  final int rosterId;
  @override
  @JsonKey(name: 'transaction_type')
  final String transactionType;
  @override
  @JsonKey(name: 'player_id')
  final int playerId;
  @override
  final bool acquired;
  @override
  @JsonKey(name: 'related_transaction_id')
  final int? relatedTransactionId;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final int? week;
  @override
  final String? season;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'player_name')
  final String? playerName;
  @override
  @JsonKey(name: 'player_position')
  final String? playerPosition;
  @override
  @JsonKey(name: 'player_team')
  final String? playerTeam;
  @override
  @JsonKey(name: 'roster_username')
  final String? rosterUsername;

  @override
  String toString() {
    return 'RosterTransaction(id: $id, leagueId: $leagueId, rosterId: $rosterId, transactionType: $transactionType, playerId: $playerId, acquired: $acquired, relatedTransactionId: $relatedTransactionId, metadata: $metadata, week: $week, season: $season, createdAt: $createdAt, playerName: $playerName, playerPosition: $playerPosition, playerTeam: $playerTeam, rosterUsername: $rosterUsername)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RosterTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.rosterId, rosterId) ||
                other.rosterId == rosterId) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.acquired, acquired) ||
                other.acquired == acquired) &&
            (identical(other.relatedTransactionId, relatedTransactionId) ||
                other.relatedTransactionId == relatedTransactionId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.playerPosition, playerPosition) ||
                other.playerPosition == playerPosition) &&
            (identical(other.playerTeam, playerTeam) ||
                other.playerTeam == playerTeam) &&
            (identical(other.rosterUsername, rosterUsername) ||
                other.rosterUsername == rosterUsername));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      leagueId,
      rosterId,
      transactionType,
      playerId,
      acquired,
      relatedTransactionId,
      const DeepCollectionEquality().hash(_metadata),
      week,
      season,
      createdAt,
      playerName,
      playerPosition,
      playerTeam,
      rosterUsername);

  /// Create a copy of RosterTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RosterTransactionImplCopyWith<_$RosterTransactionImpl> get copyWith =>
      __$$RosterTransactionImplCopyWithImpl<_$RosterTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RosterTransactionImplToJson(
      this,
    );
  }
}

abstract class _RosterTransaction implements RosterTransaction {
  const factory _RosterTransaction(
      {required final int id,
      @JsonKey(name: 'league_id') required final int leagueId,
      @JsonKey(name: 'roster_id') required final int rosterId,
      @JsonKey(name: 'transaction_type') required final String transactionType,
      @JsonKey(name: 'player_id') required final int playerId,
      required final bool acquired,
      @JsonKey(name: 'related_transaction_id') final int? relatedTransactionId,
      final Map<String, dynamic> metadata,
      final int? week,
      final String? season,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'player_name') final String? playerName,
      @JsonKey(name: 'player_position') final String? playerPosition,
      @JsonKey(name: 'player_team') final String? playerTeam,
      @JsonKey(name: 'roster_username')
      final String? rosterUsername}) = _$RosterTransactionImpl;

  factory _RosterTransaction.fromJson(Map<String, dynamic> json) =
      _$RosterTransactionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'league_id')
  int get leagueId;
  @override
  @JsonKey(name: 'roster_id')
  int get rosterId;
  @override
  @JsonKey(name: 'transaction_type')
  String get transactionType;
  @override
  @JsonKey(name: 'player_id')
  int get playerId;
  @override
  bool get acquired;
  @override
  @JsonKey(name: 'related_transaction_id')
  int? get relatedTransactionId;
  @override
  Map<String, dynamic> get metadata;
  @override
  int? get week;
  @override
  String? get season;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'player_name')
  String? get playerName;
  @override
  @JsonKey(name: 'player_position')
  String? get playerPosition;
  @override
  @JsonKey(name: 'player_team')
  String? get playerTeam;
  @override
  @JsonKey(name: 'roster_username')
  String? get rosterUsername;

  /// Create a copy of RosterTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RosterTransactionImplCopyWith<_$RosterTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
