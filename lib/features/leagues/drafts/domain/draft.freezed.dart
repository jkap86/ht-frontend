// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Draft {
  int get id => throw _privateConstructorUsedError;
  int get leagueId => throw _privateConstructorUsedError;
  String get draftType => throw _privateConstructorUsedError;
  int get rounds => throw _privateConstructorUsedError;
  int get totalRosters => throw _privateConstructorUsedError;
  int? get pickTimeSeconds => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get currentPick => throw _privateConstructorUsedError;
  int? get currentRound => throw _privateConstructorUsedError;
  bool get thirdRoundReversal => throw _privateConstructorUsedError;
  int? get currentRosterId => throw _privateConstructorUsedError;
  int? get commissionerRosterId => throw _privateConstructorUsedError;
  int? get userRosterId => throw _privateConstructorUsedError;
  DateTime? get pickDeadline => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DraftSettings? get settings => throw _privateConstructorUsedError;

  /// Create a copy of Draft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftCopyWith<Draft> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftCopyWith<$Res> {
  factory $DraftCopyWith(Draft value, $Res Function(Draft) then) =
      _$DraftCopyWithImpl<$Res, Draft>;
  @useResult
  $Res call(
      {int id,
      int leagueId,
      String draftType,
      int rounds,
      int totalRosters,
      int? pickTimeSeconds,
      String status,
      int? currentPick,
      int? currentRound,
      bool thirdRoundReversal,
      int? currentRosterId,
      int? commissionerRosterId,
      int? userRosterId,
      DateTime? pickDeadline,
      DateTime? startedAt,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      DraftSettings? settings});

  $DraftSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$DraftCopyWithImpl<$Res, $Val extends Draft>
    implements $DraftCopyWith<$Res> {
  _$DraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Draft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? draftType = null,
    Object? rounds = null,
    Object? totalRosters = null,
    Object? pickTimeSeconds = freezed,
    Object? status = null,
    Object? currentPick = freezed,
    Object? currentRound = freezed,
    Object? thirdRoundReversal = null,
    Object? currentRosterId = freezed,
    Object? commissionerRosterId = freezed,
    Object? userRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? settings = freezed,
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
      draftType: null == draftType
          ? _value.draftType
          : draftType // ignore: cast_nullable_to_non_nullable
              as String,
      rounds: null == rounds
          ? _value.rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as int,
      totalRosters: null == totalRosters
          ? _value.totalRosters
          : totalRosters // ignore: cast_nullable_to_non_nullable
              as int,
      pickTimeSeconds: freezed == pickTimeSeconds
          ? _value.pickTimeSeconds
          : pickTimeSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentPick: freezed == currentPick
          ? _value.currentPick
          : currentPick // ignore: cast_nullable_to_non_nullable
              as int?,
      currentRound: freezed == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int?,
      thirdRoundReversal: null == thirdRoundReversal
          ? _value.thirdRoundReversal
          : thirdRoundReversal // ignore: cast_nullable_to_non_nullable
              as bool,
      currentRosterId: freezed == currentRosterId
          ? _value.currentRosterId
          : currentRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      commissionerRosterId: freezed == commissionerRosterId
          ? _value.commissionerRosterId
          : commissionerRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      userRosterId: freezed == userRosterId
          ? _value.userRosterId
          : userRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      pickDeadline: freezed == pickDeadline
          ? _value.pickDeadline
          : pickDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as DraftSettings?,
    ) as $Val);
  }

  /// Create a copy of Draft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DraftSettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $DraftSettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DraftImplCopyWith<$Res> implements $DraftCopyWith<$Res> {
  factory _$$DraftImplCopyWith(
          _$DraftImpl value, $Res Function(_$DraftImpl) then) =
      __$$DraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int leagueId,
      String draftType,
      int rounds,
      int totalRosters,
      int? pickTimeSeconds,
      String status,
      int? currentPick,
      int? currentRound,
      bool thirdRoundReversal,
      int? currentRosterId,
      int? commissionerRosterId,
      int? userRosterId,
      DateTime? pickDeadline,
      DateTime? startedAt,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      DraftSettings? settings});

  @override
  $DraftSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$DraftImplCopyWithImpl<$Res>
    extends _$DraftCopyWithImpl<$Res, _$DraftImpl>
    implements _$$DraftImplCopyWith<$Res> {
  __$$DraftImplCopyWithImpl(
      _$DraftImpl _value, $Res Function(_$DraftImpl) _then)
      : super(_value, _then);

  /// Create a copy of Draft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? draftType = null,
    Object? rounds = null,
    Object? totalRosters = null,
    Object? pickTimeSeconds = freezed,
    Object? status = null,
    Object? currentPick = freezed,
    Object? currentRound = freezed,
    Object? thirdRoundReversal = null,
    Object? currentRosterId = freezed,
    Object? commissionerRosterId = freezed,
    Object? userRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$DraftImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      leagueId: null == leagueId
          ? _value.leagueId
          : leagueId // ignore: cast_nullable_to_non_nullable
              as int,
      draftType: null == draftType
          ? _value.draftType
          : draftType // ignore: cast_nullable_to_non_nullable
              as String,
      rounds: null == rounds
          ? _value.rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as int,
      totalRosters: null == totalRosters
          ? _value.totalRosters
          : totalRosters // ignore: cast_nullable_to_non_nullable
              as int,
      pickTimeSeconds: freezed == pickTimeSeconds
          ? _value.pickTimeSeconds
          : pickTimeSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentPick: freezed == currentPick
          ? _value.currentPick
          : currentPick // ignore: cast_nullable_to_non_nullable
              as int?,
      currentRound: freezed == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int?,
      thirdRoundReversal: null == thirdRoundReversal
          ? _value.thirdRoundReversal
          : thirdRoundReversal // ignore: cast_nullable_to_non_nullable
              as bool,
      currentRosterId: freezed == currentRosterId
          ? _value.currentRosterId
          : currentRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      commissionerRosterId: freezed == commissionerRosterId
          ? _value.commissionerRosterId
          : commissionerRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      userRosterId: freezed == userRosterId
          ? _value.userRosterId
          : userRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      pickDeadline: freezed == pickDeadline
          ? _value.pickDeadline
          : pickDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as DraftSettings?,
    ));
  }
}

/// @nodoc

class _$DraftImpl extends _Draft {
  const _$DraftImpl(
      {required this.id,
      required this.leagueId,
      required this.draftType,
      required this.rounds,
      required this.totalRosters,
      this.pickTimeSeconds,
      required this.status,
      this.currentPick,
      this.currentRound,
      this.thirdRoundReversal = false,
      this.currentRosterId,
      this.commissionerRosterId,
      this.userRosterId,
      this.pickDeadline,
      this.startedAt,
      this.completedAt,
      this.createdAt,
      this.updatedAt,
      this.settings})
      : super._();

  @override
  final int id;
  @override
  final int leagueId;
  @override
  final String draftType;
  @override
  final int rounds;
  @override
  final int totalRosters;
  @override
  final int? pickTimeSeconds;
  @override
  final String status;
  @override
  final int? currentPick;
  @override
  final int? currentRound;
  @override
  @JsonKey()
  final bool thirdRoundReversal;
  @override
  final int? currentRosterId;
  @override
  final int? commissionerRosterId;
  @override
  final int? userRosterId;
  @override
  final DateTime? pickDeadline;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DraftSettings? settings;

  @override
  String toString() {
    return 'Draft(id: $id, leagueId: $leagueId, draftType: $draftType, rounds: $rounds, totalRosters: $totalRosters, pickTimeSeconds: $pickTimeSeconds, status: $status, currentPick: $currentPick, currentRound: $currentRound, thirdRoundReversal: $thirdRoundReversal, currentRosterId: $currentRosterId, commissionerRosterId: $commissionerRosterId, userRosterId: $userRosterId, pickDeadline: $pickDeadline, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.draftType, draftType) ||
                other.draftType == draftType) &&
            (identical(other.rounds, rounds) || other.rounds == rounds) &&
            (identical(other.totalRosters, totalRosters) ||
                other.totalRosters == totalRosters) &&
            (identical(other.pickTimeSeconds, pickTimeSeconds) ||
                other.pickTimeSeconds == pickTimeSeconds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentPick, currentPick) ||
                other.currentPick == currentPick) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.thirdRoundReversal, thirdRoundReversal) ||
                other.thirdRoundReversal == thirdRoundReversal) &&
            (identical(other.currentRosterId, currentRosterId) ||
                other.currentRosterId == currentRosterId) &&
            (identical(other.commissionerRosterId, commissionerRosterId) ||
                other.commissionerRosterId == commissionerRosterId) &&
            (identical(other.userRosterId, userRosterId) ||
                other.userRosterId == userRosterId) &&
            (identical(other.pickDeadline, pickDeadline) ||
                other.pickDeadline == pickDeadline) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        leagueId,
        draftType,
        rounds,
        totalRosters,
        pickTimeSeconds,
        status,
        currentPick,
        currentRound,
        thirdRoundReversal,
        currentRosterId,
        commissionerRosterId,
        userRosterId,
        pickDeadline,
        startedAt,
        completedAt,
        createdAt,
        updatedAt,
        settings
      ]);

  /// Create a copy of Draft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftImplCopyWith<_$DraftImpl> get copyWith =>
      __$$DraftImplCopyWithImpl<_$DraftImpl>(this, _$identity);
}

abstract class _Draft extends Draft {
  const factory _Draft(
      {required final int id,
      required final int leagueId,
      required final String draftType,
      required final int rounds,
      required final int totalRosters,
      final int? pickTimeSeconds,
      required final String status,
      final int? currentPick,
      final int? currentRound,
      final bool thirdRoundReversal,
      final int? currentRosterId,
      final int? commissionerRosterId,
      final int? userRosterId,
      final DateTime? pickDeadline,
      final DateTime? startedAt,
      final DateTime? completedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DraftSettings? settings}) = _$DraftImpl;
  const _Draft._() : super._();

  @override
  int get id;
  @override
  int get leagueId;
  @override
  String get draftType;
  @override
  int get rounds;
  @override
  int get totalRosters;
  @override
  int? get pickTimeSeconds;
  @override
  String get status;
  @override
  int? get currentPick;
  @override
  int? get currentRound;
  @override
  bool get thirdRoundReversal;
  @override
  int? get currentRosterId;
  @override
  int? get commissionerRosterId;
  @override
  int? get userRosterId;
  @override
  DateTime? get pickDeadline;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DraftSettings? get settings;

  /// Create a copy of Draft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftImplCopyWith<_$DraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
