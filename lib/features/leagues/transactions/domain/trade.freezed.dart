// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TradeItem _$TradeItemFromJson(Map<String, dynamic> json) {
  return _TradeItem.fromJson(json);
}

/// @nodoc
mixin _$TradeItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'trade_id')
  int get tradeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_roster_id')
  int get fromRosterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_roster_id')
  int get toRosterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_id')
  int get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_name')
  String? get playerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_position')
  String? get playerPosition => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_team')
  String? get playerTeam => throw _privateConstructorUsedError;

  /// Serializes this TradeItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TradeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TradeItemCopyWith<TradeItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeItemCopyWith<$Res> {
  factory $TradeItemCopyWith(TradeItem value, $Res Function(TradeItem) then) =
      _$TradeItemCopyWithImpl<$Res, TradeItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'trade_id') int tradeId,
      @JsonKey(name: 'from_roster_id') int fromRosterId,
      @JsonKey(name: 'to_roster_id') int toRosterId,
      @JsonKey(name: 'player_id') int playerId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_name') String? playerName,
      @JsonKey(name: 'player_position') String? playerPosition,
      @JsonKey(name: 'player_team') String? playerTeam});
}

/// @nodoc
class _$TradeItemCopyWithImpl<$Res, $Val extends TradeItem>
    implements $TradeItemCopyWith<$Res> {
  _$TradeItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TradeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tradeId = null,
    Object? fromRosterId = null,
    Object? toRosterId = null,
    Object? playerId = null,
    Object? createdAt = null,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tradeId: null == tradeId
          ? _value.tradeId
          : tradeId // ignore: cast_nullable_to_non_nullable
              as int,
      fromRosterId: null == fromRosterId
          ? _value.fromRosterId
          : fromRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      toRosterId: null == toRosterId
          ? _value.toRosterId
          : toRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TradeItemImplCopyWith<$Res>
    implements $TradeItemCopyWith<$Res> {
  factory _$$TradeItemImplCopyWith(
          _$TradeItemImpl value, $Res Function(_$TradeItemImpl) then) =
      __$$TradeItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'trade_id') int tradeId,
      @JsonKey(name: 'from_roster_id') int fromRosterId,
      @JsonKey(name: 'to_roster_id') int toRosterId,
      @JsonKey(name: 'player_id') int playerId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_name') String? playerName,
      @JsonKey(name: 'player_position') String? playerPosition,
      @JsonKey(name: 'player_team') String? playerTeam});
}

/// @nodoc
class __$$TradeItemImplCopyWithImpl<$Res>
    extends _$TradeItemCopyWithImpl<$Res, _$TradeItemImpl>
    implements _$$TradeItemImplCopyWith<$Res> {
  __$$TradeItemImplCopyWithImpl(
      _$TradeItemImpl _value, $Res Function(_$TradeItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of TradeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tradeId = null,
    Object? fromRosterId = null,
    Object? toRosterId = null,
    Object? playerId = null,
    Object? createdAt = null,
    Object? playerName = freezed,
    Object? playerPosition = freezed,
    Object? playerTeam = freezed,
  }) {
    return _then(_$TradeItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tradeId: null == tradeId
          ? _value.tradeId
          : tradeId // ignore: cast_nullable_to_non_nullable
              as int,
      fromRosterId: null == fromRosterId
          ? _value.fromRosterId
          : fromRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      toRosterId: null == toRosterId
          ? _value.toRosterId
          : toRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeItemImpl implements _TradeItem {
  const _$TradeItemImpl(
      {required this.id,
      @JsonKey(name: 'trade_id') required this.tradeId,
      @JsonKey(name: 'from_roster_id') required this.fromRosterId,
      @JsonKey(name: 'to_roster_id') required this.toRosterId,
      @JsonKey(name: 'player_id') required this.playerId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'player_name') this.playerName,
      @JsonKey(name: 'player_position') this.playerPosition,
      @JsonKey(name: 'player_team') this.playerTeam});

  factory _$TradeItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'trade_id')
  final int tradeId;
  @override
  @JsonKey(name: 'from_roster_id')
  final int fromRosterId;
  @override
  @JsonKey(name: 'to_roster_id')
  final int toRosterId;
  @override
  @JsonKey(name: 'player_id')
  final int playerId;
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
  String toString() {
    return 'TradeItem(id: $id, tradeId: $tradeId, fromRosterId: $fromRosterId, toRosterId: $toRosterId, playerId: $playerId, createdAt: $createdAt, playerName: $playerName, playerPosition: $playerPosition, playerTeam: $playerTeam)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tradeId, tradeId) || other.tradeId == tradeId) &&
            (identical(other.fromRosterId, fromRosterId) ||
                other.fromRosterId == fromRosterId) &&
            (identical(other.toRosterId, toRosterId) ||
                other.toRosterId == toRosterId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.playerPosition, playerPosition) ||
                other.playerPosition == playerPosition) &&
            (identical(other.playerTeam, playerTeam) ||
                other.playerTeam == playerTeam));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, tradeId, fromRosterId,
      toRosterId, playerId, createdAt, playerName, playerPosition, playerTeam);

  /// Create a copy of TradeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeItemImplCopyWith<_$TradeItemImpl> get copyWith =>
      __$$TradeItemImplCopyWithImpl<_$TradeItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeItemImplToJson(
      this,
    );
  }
}

abstract class _TradeItem implements TradeItem {
  const factory _TradeItem(
          {required final int id,
          @JsonKey(name: 'trade_id') required final int tradeId,
          @JsonKey(name: 'from_roster_id') required final int fromRosterId,
          @JsonKey(name: 'to_roster_id') required final int toRosterId,
          @JsonKey(name: 'player_id') required final int playerId,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'player_name') final String? playerName,
          @JsonKey(name: 'player_position') final String? playerPosition,
          @JsonKey(name: 'player_team') final String? playerTeam}) =
      _$TradeItemImpl;

  factory _TradeItem.fromJson(Map<String, dynamic> json) =
      _$TradeItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'trade_id')
  int get tradeId;
  @override
  @JsonKey(name: 'from_roster_id')
  int get fromRosterId;
  @override
  @JsonKey(name: 'to_roster_id')
  int get toRosterId;
  @override
  @JsonKey(name: 'player_id')
  int get playerId;
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

  /// Create a copy of TradeItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeItemImplCopyWith<_$TradeItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Trade _$TradeFromJson(Map<String, dynamic> json) {
  return _Trade.fromJson(json);
}

/// @nodoc
mixin _$Trade {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'league_id')
  int get leagueId => throw _privateConstructorUsedError;
  @JsonKey(name: 'proposer_roster_id')
  int get proposerRosterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_roster_id')
  int get recipientRosterId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'proposed_at')
  DateTime get proposedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'responded_at')
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<TradeItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'proposer_username')
  String? get proposerUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_username')
  String? get recipientUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'proposer_roster_number')
  int? get proposerRosterNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_roster_number')
  int? get recipientRosterNumber => throw _privateConstructorUsedError;

  /// Serializes this Trade to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TradeCopyWith<Trade> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeCopyWith<$Res> {
  factory $TradeCopyWith(Trade value, $Res Function(Trade) then) =
      _$TradeCopyWithImpl<$Res, Trade>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'league_id') int leagueId,
      @JsonKey(name: 'proposer_roster_id') int proposerRosterId,
      @JsonKey(name: 'recipient_roster_id') int recipientRosterId,
      String status,
      @JsonKey(name: 'proposed_at') DateTime proposedAt,
      @JsonKey(name: 'responded_at') DateTime? respondedAt,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<TradeItem> items,
      @JsonKey(name: 'proposer_username') String? proposerUsername,
      @JsonKey(name: 'recipient_username') String? recipientUsername,
      @JsonKey(name: 'proposer_roster_number') int? proposerRosterNumber,
      @JsonKey(name: 'recipient_roster_number') int? recipientRosterNumber});
}

/// @nodoc
class _$TradeCopyWithImpl<$Res, $Val extends Trade>
    implements $TradeCopyWith<$Res> {
  _$TradeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? proposerRosterId = null,
    Object? recipientRosterId = null,
    Object? status = null,
    Object? proposedAt = null,
    Object? respondedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? items = null,
    Object? proposerUsername = freezed,
    Object? recipientUsername = freezed,
    Object? proposerRosterNumber = freezed,
    Object? recipientRosterNumber = freezed,
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
      proposerRosterId: null == proposerRosterId
          ? _value.proposerRosterId
          : proposerRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      recipientRosterId: null == recipientRosterId
          ? _value.recipientRosterId
          : recipientRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      proposedAt: null == proposedAt
          ? _value.proposedAt
          : proposedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TradeItem>,
      proposerUsername: freezed == proposerUsername
          ? _value.proposerUsername
          : proposerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientUsername: freezed == recipientUsername
          ? _value.recipientUsername
          : recipientUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      proposerRosterNumber: freezed == proposerRosterNumber
          ? _value.proposerRosterNumber
          : proposerRosterNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      recipientRosterNumber: freezed == recipientRosterNumber
          ? _value.recipientRosterNumber
          : recipientRosterNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TradeImplCopyWith<$Res> implements $TradeCopyWith<$Res> {
  factory _$$TradeImplCopyWith(
          _$TradeImpl value, $Res Function(_$TradeImpl) then) =
      __$$TradeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'league_id') int leagueId,
      @JsonKey(name: 'proposer_roster_id') int proposerRosterId,
      @JsonKey(name: 'recipient_roster_id') int recipientRosterId,
      String status,
      @JsonKey(name: 'proposed_at') DateTime proposedAt,
      @JsonKey(name: 'responded_at') DateTime? respondedAt,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<TradeItem> items,
      @JsonKey(name: 'proposer_username') String? proposerUsername,
      @JsonKey(name: 'recipient_username') String? recipientUsername,
      @JsonKey(name: 'proposer_roster_number') int? proposerRosterNumber,
      @JsonKey(name: 'recipient_roster_number') int? recipientRosterNumber});
}

/// @nodoc
class __$$TradeImplCopyWithImpl<$Res>
    extends _$TradeCopyWithImpl<$Res, _$TradeImpl>
    implements _$$TradeImplCopyWith<$Res> {
  __$$TradeImplCopyWithImpl(
      _$TradeImpl _value, $Res Function(_$TradeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? proposerRosterId = null,
    Object? recipientRosterId = null,
    Object? status = null,
    Object? proposedAt = null,
    Object? respondedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? items = null,
    Object? proposerUsername = freezed,
    Object? recipientUsername = freezed,
    Object? proposerRosterNumber = freezed,
    Object? recipientRosterNumber = freezed,
  }) {
    return _then(_$TradeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      proposerRosterId: null == proposerRosterId
          ? _value.proposerRosterId
          : proposerRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      recipientRosterId: null == recipientRosterId
          ? _value.recipientRosterId
          : recipientRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      proposedAt: null == proposedAt
          ? _value.proposedAt
          : proposedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TradeItem>,
      proposerUsername: freezed == proposerUsername
          ? _value.proposerUsername
          : proposerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientUsername: freezed == recipientUsername
          ? _value.recipientUsername
          : recipientUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      proposerRosterNumber: freezed == proposerRosterNumber
          ? _value.proposerRosterNumber
          : proposerRosterNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      recipientRosterNumber: freezed == recipientRosterNumber
          ? _value.recipientRosterNumber
          : recipientRosterNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeImpl implements _Trade {
  const _$TradeImpl(
      {required this.id,
      @JsonKey(name: 'league_id') required this.leagueId,
      @JsonKey(name: 'proposer_roster_id') required this.proposerRosterId,
      @JsonKey(name: 'recipient_roster_id') required this.recipientRosterId,
      required this.status,
      @JsonKey(name: 'proposed_at') required this.proposedAt,
      @JsonKey(name: 'responded_at') this.respondedAt,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      final List<TradeItem> items = const [],
      @JsonKey(name: 'proposer_username') this.proposerUsername,
      @JsonKey(name: 'recipient_username') this.recipientUsername,
      @JsonKey(name: 'proposer_roster_number') this.proposerRosterNumber,
      @JsonKey(name: 'recipient_roster_number') this.recipientRosterNumber})
      : _items = items;

  factory _$TradeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'league_id')
  final int leagueId;
  @override
  @JsonKey(name: 'proposer_roster_id')
  final int proposerRosterId;
  @override
  @JsonKey(name: 'recipient_roster_id')
  final int recipientRosterId;
  @override
  final String status;
  @override
  @JsonKey(name: 'proposed_at')
  final DateTime proposedAt;
  @override
  @JsonKey(name: 'responded_at')
  final DateTime? respondedAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<TradeItem> _items;
  @override
  @JsonKey()
  List<TradeItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'proposer_username')
  final String? proposerUsername;
  @override
  @JsonKey(name: 'recipient_username')
  final String? recipientUsername;
  @override
  @JsonKey(name: 'proposer_roster_number')
  final int? proposerRosterNumber;
  @override
  @JsonKey(name: 'recipient_roster_number')
  final int? recipientRosterNumber;

  @override
  String toString() {
    return 'Trade(id: $id, leagueId: $leagueId, proposerRosterId: $proposerRosterId, recipientRosterId: $recipientRosterId, status: $status, proposedAt: $proposedAt, respondedAt: $respondedAt, notes: $notes, createdAt: $createdAt, items: $items, proposerUsername: $proposerUsername, recipientUsername: $recipientUsername, proposerRosterNumber: $proposerRosterNumber, recipientRosterNumber: $recipientRosterNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.proposerRosterId, proposerRosterId) ||
                other.proposerRosterId == proposerRosterId) &&
            (identical(other.recipientRosterId, recipientRosterId) ||
                other.recipientRosterId == recipientRosterId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.proposedAt, proposedAt) ||
                other.proposedAt == proposedAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.proposerUsername, proposerUsername) ||
                other.proposerUsername == proposerUsername) &&
            (identical(other.recipientUsername, recipientUsername) ||
                other.recipientUsername == recipientUsername) &&
            (identical(other.proposerRosterNumber, proposerRosterNumber) ||
                other.proposerRosterNumber == proposerRosterNumber) &&
            (identical(other.recipientRosterNumber, recipientRosterNumber) ||
                other.recipientRosterNumber == recipientRosterNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      leagueId,
      proposerRosterId,
      recipientRosterId,
      status,
      proposedAt,
      respondedAt,
      notes,
      createdAt,
      const DeepCollectionEquality().hash(_items),
      proposerUsername,
      recipientUsername,
      proposerRosterNumber,
      recipientRosterNumber);

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeImplCopyWith<_$TradeImpl> get copyWith =>
      __$$TradeImplCopyWithImpl<_$TradeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeImplToJson(
      this,
    );
  }
}

abstract class _Trade implements Trade {
  const factory _Trade(
      {required final int id,
      @JsonKey(name: 'league_id') required final int leagueId,
      @JsonKey(name: 'proposer_roster_id') required final int proposerRosterId,
      @JsonKey(name: 'recipient_roster_id')
      required final int recipientRosterId,
      required final String status,
      @JsonKey(name: 'proposed_at') required final DateTime proposedAt,
      @JsonKey(name: 'responded_at') final DateTime? respondedAt,
      final String? notes,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final List<TradeItem> items,
      @JsonKey(name: 'proposer_username') final String? proposerUsername,
      @JsonKey(name: 'recipient_username') final String? recipientUsername,
      @JsonKey(name: 'proposer_roster_number') final int? proposerRosterNumber,
      @JsonKey(name: 'recipient_roster_number')
      final int? recipientRosterNumber}) = _$TradeImpl;

  factory _Trade.fromJson(Map<String, dynamic> json) = _$TradeImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'league_id')
  int get leagueId;
  @override
  @JsonKey(name: 'proposer_roster_id')
  int get proposerRosterId;
  @override
  @JsonKey(name: 'recipient_roster_id')
  int get recipientRosterId;
  @override
  String get status;
  @override
  @JsonKey(name: 'proposed_at')
  DateTime get proposedAt;
  @override
  @JsonKey(name: 'responded_at')
  DateTime? get respondedAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  List<TradeItem> get items;
  @override
  @JsonKey(name: 'proposer_username')
  String? get proposerUsername;
  @override
  @JsonKey(name: 'recipient_username')
  String? get recipientUsername;
  @override
  @JsonKey(name: 'proposer_roster_number')
  int? get proposerRosterNumber;
  @override
  @JsonKey(name: 'recipient_roster_number')
  int? get recipientRosterNumber;

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeImplCopyWith<_$TradeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProposeTradeRequest _$ProposeTradeRequestFromJson(Map<String, dynamic> json) {
  return _ProposeTradeRequest.fromJson(json);
}

/// @nodoc
mixin _$ProposeTradeRequest {
  @JsonKey(name: 'recipient_roster_id')
  int get recipientRosterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'offered_player_ids')
  List<int> get offeredPlayerIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_player_ids')
  List<int> get requestedPlayerIds => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this ProposeTradeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProposeTradeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProposeTradeRequestCopyWith<ProposeTradeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProposeTradeRequestCopyWith<$Res> {
  factory $ProposeTradeRequestCopyWith(
          ProposeTradeRequest value, $Res Function(ProposeTradeRequest) then) =
      _$ProposeTradeRequestCopyWithImpl<$Res, ProposeTradeRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'recipient_roster_id') int recipientRosterId,
      @JsonKey(name: 'offered_player_ids') List<int> offeredPlayerIds,
      @JsonKey(name: 'requested_player_ids') List<int> requestedPlayerIds,
      String? notes});
}

/// @nodoc
class _$ProposeTradeRequestCopyWithImpl<$Res, $Val extends ProposeTradeRequest>
    implements $ProposeTradeRequestCopyWith<$Res> {
  _$ProposeTradeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProposeTradeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientRosterId = null,
    Object? offeredPlayerIds = null,
    Object? requestedPlayerIds = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      recipientRosterId: null == recipientRosterId
          ? _value.recipientRosterId
          : recipientRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      offeredPlayerIds: null == offeredPlayerIds
          ? _value.offeredPlayerIds
          : offeredPlayerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      requestedPlayerIds: null == requestedPlayerIds
          ? _value.requestedPlayerIds
          : requestedPlayerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProposeTradeRequestImplCopyWith<$Res>
    implements $ProposeTradeRequestCopyWith<$Res> {
  factory _$$ProposeTradeRequestImplCopyWith(_$ProposeTradeRequestImpl value,
          $Res Function(_$ProposeTradeRequestImpl) then) =
      __$$ProposeTradeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'recipient_roster_id') int recipientRosterId,
      @JsonKey(name: 'offered_player_ids') List<int> offeredPlayerIds,
      @JsonKey(name: 'requested_player_ids') List<int> requestedPlayerIds,
      String? notes});
}

/// @nodoc
class __$$ProposeTradeRequestImplCopyWithImpl<$Res>
    extends _$ProposeTradeRequestCopyWithImpl<$Res, _$ProposeTradeRequestImpl>
    implements _$$ProposeTradeRequestImplCopyWith<$Res> {
  __$$ProposeTradeRequestImplCopyWithImpl(_$ProposeTradeRequestImpl _value,
      $Res Function(_$ProposeTradeRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProposeTradeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientRosterId = null,
    Object? offeredPlayerIds = null,
    Object? requestedPlayerIds = null,
    Object? notes = freezed,
  }) {
    return _then(_$ProposeTradeRequestImpl(
      recipientRosterId: null == recipientRosterId
          ? _value.recipientRosterId
          : recipientRosterId // ignore: cast_nullable_to_non_nullable
              as int,
      offeredPlayerIds: null == offeredPlayerIds
          ? _value._offeredPlayerIds
          : offeredPlayerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      requestedPlayerIds: null == requestedPlayerIds
          ? _value._requestedPlayerIds
          : requestedPlayerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProposeTradeRequestImpl implements _ProposeTradeRequest {
  const _$ProposeTradeRequestImpl(
      {@JsonKey(name: 'recipient_roster_id') required this.recipientRosterId,
      @JsonKey(name: 'offered_player_ids')
      required final List<int> offeredPlayerIds,
      @JsonKey(name: 'requested_player_ids')
      required final List<int> requestedPlayerIds,
      this.notes})
      : _offeredPlayerIds = offeredPlayerIds,
        _requestedPlayerIds = requestedPlayerIds;

  factory _$ProposeTradeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProposeTradeRequestImplFromJson(json);

  @override
  @JsonKey(name: 'recipient_roster_id')
  final int recipientRosterId;
  final List<int> _offeredPlayerIds;
  @override
  @JsonKey(name: 'offered_player_ids')
  List<int> get offeredPlayerIds {
    if (_offeredPlayerIds is EqualUnmodifiableListView)
      return _offeredPlayerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_offeredPlayerIds);
  }

  final List<int> _requestedPlayerIds;
  @override
  @JsonKey(name: 'requested_player_ids')
  List<int> get requestedPlayerIds {
    if (_requestedPlayerIds is EqualUnmodifiableListView)
      return _requestedPlayerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requestedPlayerIds);
  }

  @override
  final String? notes;

  @override
  String toString() {
    return 'ProposeTradeRequest(recipientRosterId: $recipientRosterId, offeredPlayerIds: $offeredPlayerIds, requestedPlayerIds: $requestedPlayerIds, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProposeTradeRequestImpl &&
            (identical(other.recipientRosterId, recipientRosterId) ||
                other.recipientRosterId == recipientRosterId) &&
            const DeepCollectionEquality()
                .equals(other._offeredPlayerIds, _offeredPlayerIds) &&
            const DeepCollectionEquality()
                .equals(other._requestedPlayerIds, _requestedPlayerIds) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      recipientRosterId,
      const DeepCollectionEquality().hash(_offeredPlayerIds),
      const DeepCollectionEquality().hash(_requestedPlayerIds),
      notes);

  /// Create a copy of ProposeTradeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProposeTradeRequestImplCopyWith<_$ProposeTradeRequestImpl> get copyWith =>
      __$$ProposeTradeRequestImplCopyWithImpl<_$ProposeTradeRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProposeTradeRequestImplToJson(
      this,
    );
  }
}

abstract class _ProposeTradeRequest implements ProposeTradeRequest {
  const factory _ProposeTradeRequest(
      {@JsonKey(name: 'recipient_roster_id')
      required final int recipientRosterId,
      @JsonKey(name: 'offered_player_ids')
      required final List<int> offeredPlayerIds,
      @JsonKey(name: 'requested_player_ids')
      required final List<int> requestedPlayerIds,
      final String? notes}) = _$ProposeTradeRequestImpl;

  factory _ProposeTradeRequest.fromJson(Map<String, dynamic> json) =
      _$ProposeTradeRequestImpl.fromJson;

  @override
  @JsonKey(name: 'recipient_roster_id')
  int get recipientRosterId;
  @override
  @JsonKey(name: 'offered_player_ids')
  List<int> get offeredPlayerIds;
  @override
  @JsonKey(name: 'requested_player_ids')
  List<int> get requestedPlayerIds;
  @override
  String? get notes;

  /// Create a copy of ProposeTradeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProposeTradeRequestImplCopyWith<_$ProposeTradeRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
