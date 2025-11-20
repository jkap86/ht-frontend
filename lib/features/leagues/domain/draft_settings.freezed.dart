// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DraftSettings _$DraftSettingsFromJson(Map<String, dynamic> json) {
  return _DraftSettings.fromJson(json);
}

/// @nodoc
mixin _$DraftSettings {
  @JsonKey(name: 'draft_order')
  String get draftOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_pool')
  String get playerPool => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_picker_index')
  int? get currentPickerIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'draft_order_list')
  List<Map<String, dynamic>>? get draftOrderList =>
      throw _privateConstructorUsedError; // Derby-specific settings
  @JsonKey(name: 'derby_start_time')
  DateTime? get derbyStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'derby_status')
  String? get derbyStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'derby_timer_seconds')
  int? get derbyTimerSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'derby_on_timeout')
  String? get derbyOnTimeout => throw _privateConstructorUsedError;

  /// Serializes this DraftSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DraftSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftSettingsCopyWith<DraftSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftSettingsCopyWith<$Res> {
  factory $DraftSettingsCopyWith(
          DraftSettings value, $Res Function(DraftSettings) then) =
      _$DraftSettingsCopyWithImpl<$Res, DraftSettings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'draft_order') String draftOrder,
      @JsonKey(name: 'player_pool') String playerPool,
      @JsonKey(name: 'current_picker_index') int? currentPickerIndex,
      @JsonKey(name: 'draft_order_list')
      List<Map<String, dynamic>>? draftOrderList,
      @JsonKey(name: 'derby_start_time') DateTime? derbyStartTime,
      @JsonKey(name: 'derby_status') String? derbyStatus,
      @JsonKey(name: 'derby_timer_seconds') int? derbyTimerSeconds,
      @JsonKey(name: 'derby_on_timeout') String? derbyOnTimeout});
}

/// @nodoc
class _$DraftSettingsCopyWithImpl<$Res, $Val extends DraftSettings>
    implements $DraftSettingsCopyWith<$Res> {
  _$DraftSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draftOrder = null,
    Object? playerPool = null,
    Object? currentPickerIndex = freezed,
    Object? draftOrderList = freezed,
    Object? derbyStartTime = freezed,
    Object? derbyStatus = freezed,
    Object? derbyTimerSeconds = freezed,
    Object? derbyOnTimeout = freezed,
  }) {
    return _then(_value.copyWith(
      draftOrder: null == draftOrder
          ? _value.draftOrder
          : draftOrder // ignore: cast_nullable_to_non_nullable
              as String,
      playerPool: null == playerPool
          ? _value.playerPool
          : playerPool // ignore: cast_nullable_to_non_nullable
              as String,
      currentPickerIndex: freezed == currentPickerIndex
          ? _value.currentPickerIndex
          : currentPickerIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      draftOrderList: freezed == draftOrderList
          ? _value.draftOrderList
          : draftOrderList // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      derbyStartTime: freezed == derbyStartTime
          ? _value.derbyStartTime
          : derbyStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      derbyStatus: freezed == derbyStatus
          ? _value.derbyStatus
          : derbyStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      derbyTimerSeconds: freezed == derbyTimerSeconds
          ? _value.derbyTimerSeconds
          : derbyTimerSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      derbyOnTimeout: freezed == derbyOnTimeout
          ? _value.derbyOnTimeout
          : derbyOnTimeout // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DraftSettingsImplCopyWith<$Res>
    implements $DraftSettingsCopyWith<$Res> {
  factory _$$DraftSettingsImplCopyWith(
          _$DraftSettingsImpl value, $Res Function(_$DraftSettingsImpl) then) =
      __$$DraftSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'draft_order') String draftOrder,
      @JsonKey(name: 'player_pool') String playerPool,
      @JsonKey(name: 'current_picker_index') int? currentPickerIndex,
      @JsonKey(name: 'draft_order_list')
      List<Map<String, dynamic>>? draftOrderList,
      @JsonKey(name: 'derby_start_time') DateTime? derbyStartTime,
      @JsonKey(name: 'derby_status') String? derbyStatus,
      @JsonKey(name: 'derby_timer_seconds') int? derbyTimerSeconds,
      @JsonKey(name: 'derby_on_timeout') String? derbyOnTimeout});
}

/// @nodoc
class __$$DraftSettingsImplCopyWithImpl<$Res>
    extends _$DraftSettingsCopyWithImpl<$Res, _$DraftSettingsImpl>
    implements _$$DraftSettingsImplCopyWith<$Res> {
  __$$DraftSettingsImplCopyWithImpl(
      _$DraftSettingsImpl _value, $Res Function(_$DraftSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DraftSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draftOrder = null,
    Object? playerPool = null,
    Object? currentPickerIndex = freezed,
    Object? draftOrderList = freezed,
    Object? derbyStartTime = freezed,
    Object? derbyStatus = freezed,
    Object? derbyTimerSeconds = freezed,
    Object? derbyOnTimeout = freezed,
  }) {
    return _then(_$DraftSettingsImpl(
      draftOrder: null == draftOrder
          ? _value.draftOrder
          : draftOrder // ignore: cast_nullable_to_non_nullable
              as String,
      playerPool: null == playerPool
          ? _value.playerPool
          : playerPool // ignore: cast_nullable_to_non_nullable
              as String,
      currentPickerIndex: freezed == currentPickerIndex
          ? _value.currentPickerIndex
          : currentPickerIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      draftOrderList: freezed == draftOrderList
          ? _value._draftOrderList
          : draftOrderList // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      derbyStartTime: freezed == derbyStartTime
          ? _value.derbyStartTime
          : derbyStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      derbyStatus: freezed == derbyStatus
          ? _value.derbyStatus
          : derbyStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      derbyTimerSeconds: freezed == derbyTimerSeconds
          ? _value.derbyTimerSeconds
          : derbyTimerSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      derbyOnTimeout: freezed == derbyOnTimeout
          ? _value.derbyOnTimeout
          : derbyOnTimeout // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DraftSettingsImpl implements _DraftSettings {
  const _$DraftSettingsImpl(
      {@JsonKey(name: 'draft_order') this.draftOrder = 'randomize',
      @JsonKey(name: 'player_pool') this.playerPool = 'all',
      @JsonKey(name: 'current_picker_index') this.currentPickerIndex,
      @JsonKey(name: 'draft_order_list')
      final List<Map<String, dynamic>>? draftOrderList,
      @JsonKey(name: 'derby_start_time') this.derbyStartTime,
      @JsonKey(name: 'derby_status') this.derbyStatus,
      @JsonKey(name: 'derby_timer_seconds') this.derbyTimerSeconds,
      @JsonKey(name: 'derby_on_timeout') this.derbyOnTimeout})
      : _draftOrderList = draftOrderList;

  factory _$DraftSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DraftSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'draft_order')
  final String draftOrder;
  @override
  @JsonKey(name: 'player_pool')
  final String playerPool;
  @override
  @JsonKey(name: 'current_picker_index')
  final int? currentPickerIndex;
  final List<Map<String, dynamic>>? _draftOrderList;
  @override
  @JsonKey(name: 'draft_order_list')
  List<Map<String, dynamic>>? get draftOrderList {
    final value = _draftOrderList;
    if (value == null) return null;
    if (_draftOrderList is EqualUnmodifiableListView) return _draftOrderList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Derby-specific settings
  @override
  @JsonKey(name: 'derby_start_time')
  final DateTime? derbyStartTime;
  @override
  @JsonKey(name: 'derby_status')
  final String? derbyStatus;
  @override
  @JsonKey(name: 'derby_timer_seconds')
  final int? derbyTimerSeconds;
  @override
  @JsonKey(name: 'derby_on_timeout')
  final String? derbyOnTimeout;

  @override
  String toString() {
    return 'DraftSettings(draftOrder: $draftOrder, playerPool: $playerPool, currentPickerIndex: $currentPickerIndex, draftOrderList: $draftOrderList, derbyStartTime: $derbyStartTime, derbyStatus: $derbyStatus, derbyTimerSeconds: $derbyTimerSeconds, derbyOnTimeout: $derbyOnTimeout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftSettingsImpl &&
            (identical(other.draftOrder, draftOrder) ||
                other.draftOrder == draftOrder) &&
            (identical(other.playerPool, playerPool) ||
                other.playerPool == playerPool) &&
            (identical(other.currentPickerIndex, currentPickerIndex) ||
                other.currentPickerIndex == currentPickerIndex) &&
            const DeepCollectionEquality()
                .equals(other._draftOrderList, _draftOrderList) &&
            (identical(other.derbyStartTime, derbyStartTime) ||
                other.derbyStartTime == derbyStartTime) &&
            (identical(other.derbyStatus, derbyStatus) ||
                other.derbyStatus == derbyStatus) &&
            (identical(other.derbyTimerSeconds, derbyTimerSeconds) ||
                other.derbyTimerSeconds == derbyTimerSeconds) &&
            (identical(other.derbyOnTimeout, derbyOnTimeout) ||
                other.derbyOnTimeout == derbyOnTimeout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      draftOrder,
      playerPool,
      currentPickerIndex,
      const DeepCollectionEquality().hash(_draftOrderList),
      derbyStartTime,
      derbyStatus,
      derbyTimerSeconds,
      derbyOnTimeout);

  /// Create a copy of DraftSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftSettingsImplCopyWith<_$DraftSettingsImpl> get copyWith =>
      __$$DraftSettingsImplCopyWithImpl<_$DraftSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DraftSettingsImplToJson(
      this,
    );
  }
}

abstract class _DraftSettings implements DraftSettings {
  const factory _DraftSettings(
          {@JsonKey(name: 'draft_order') final String draftOrder,
          @JsonKey(name: 'player_pool') final String playerPool,
          @JsonKey(name: 'current_picker_index') final int? currentPickerIndex,
          @JsonKey(name: 'draft_order_list')
          final List<Map<String, dynamic>>? draftOrderList,
          @JsonKey(name: 'derby_start_time') final DateTime? derbyStartTime,
          @JsonKey(name: 'derby_status') final String? derbyStatus,
          @JsonKey(name: 'derby_timer_seconds') final int? derbyTimerSeconds,
          @JsonKey(name: 'derby_on_timeout') final String? derbyOnTimeout}) =
      _$DraftSettingsImpl;

  factory _DraftSettings.fromJson(Map<String, dynamic> json) =
      _$DraftSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'draft_order')
  String get draftOrder;
  @override
  @JsonKey(name: 'player_pool')
  String get playerPool;
  @override
  @JsonKey(name: 'current_picker_index')
  int? get currentPickerIndex;
  @override
  @JsonKey(name: 'draft_order_list')
  List<Map<String, dynamic>>? get draftOrderList; // Derby-specific settings
  @override
  @JsonKey(name: 'derby_start_time')
  DateTime? get derbyStartTime;
  @override
  @JsonKey(name: 'derby_status')
  String? get derbyStatus;
  @override
  @JsonKey(name: 'derby_timer_seconds')
  int? get derbyTimerSeconds;
  @override
  @JsonKey(name: 'derby_on_timeout')
  String? get derbyOnTimeout;

  /// Create a copy of DraftSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftSettingsImplCopyWith<_$DraftSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
