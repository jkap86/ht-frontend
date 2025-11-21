// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_room_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DraftRoomState {
  Draft get draft => throw _privateConstructorUsedError;
  List<Player> get availablePlayers => throw _privateConstructorUsedError;
  List<DraftPick> get picks => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int? get currentPickerRosterId => throw _privateConstructorUsedError;
  DateTime? get pickDeadline => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  List<String> get positionFilters => throw _privateConstructorUsedError;

  /// Create a copy of DraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftRoomStateCopyWith<DraftRoomState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftRoomStateCopyWith<$Res> {
  factory $DraftRoomStateCopyWith(
          DraftRoomState value, $Res Function(DraftRoomState) then) =
      _$DraftRoomStateCopyWithImpl<$Res, DraftRoomState>;
  @useResult
  $Res call(
      {Draft draft,
      List<Player> availablePlayers,
      List<DraftPick> picks,
      bool isLoading,
      bool isConnected,
      String? error,
      int? currentPickerRosterId,
      DateTime? pickDeadline,
      String? searchQuery,
      List<String> positionFilters});

  $DraftCopyWith<$Res> get draft;
}

/// @nodoc
class _$DraftRoomStateCopyWithImpl<$Res, $Val extends DraftRoomState>
    implements $DraftRoomStateCopyWith<$Res> {
  _$DraftRoomStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draft = null,
    Object? availablePlayers = null,
    Object? picks = null,
    Object? isLoading = null,
    Object? isConnected = null,
    Object? error = freezed,
    Object? currentPickerRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? searchQuery = freezed,
    Object? positionFilters = null,
  }) {
    return _then(_value.copyWith(
      draft: null == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as Draft,
      availablePlayers: null == availablePlayers
          ? _value.availablePlayers
          : availablePlayers // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      picks: null == picks
          ? _value.picks
          : picks // ignore: cast_nullable_to_non_nullable
              as List<DraftPick>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPickerRosterId: freezed == currentPickerRosterId
          ? _value.currentPickerRosterId
          : currentPickerRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      pickDeadline: freezed == pickDeadline
          ? _value.pickDeadline
          : pickDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      positionFilters: null == positionFilters
          ? _value.positionFilters
          : positionFilters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of DraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DraftCopyWith<$Res> get draft {
    return $DraftCopyWith<$Res>(_value.draft, (value) {
      return _then(_value.copyWith(draft: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DraftRoomStateImplCopyWith<$Res>
    implements $DraftRoomStateCopyWith<$Res> {
  factory _$$DraftRoomStateImplCopyWith(_$DraftRoomStateImpl value,
          $Res Function(_$DraftRoomStateImpl) then) =
      __$$DraftRoomStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Draft draft,
      List<Player> availablePlayers,
      List<DraftPick> picks,
      bool isLoading,
      bool isConnected,
      String? error,
      int? currentPickerRosterId,
      DateTime? pickDeadline,
      String? searchQuery,
      List<String> positionFilters});

  @override
  $DraftCopyWith<$Res> get draft;
}

/// @nodoc
class __$$DraftRoomStateImplCopyWithImpl<$Res>
    extends _$DraftRoomStateCopyWithImpl<$Res, _$DraftRoomStateImpl>
    implements _$$DraftRoomStateImplCopyWith<$Res> {
  __$$DraftRoomStateImplCopyWithImpl(
      _$DraftRoomStateImpl _value, $Res Function(_$DraftRoomStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draft = null,
    Object? availablePlayers = null,
    Object? picks = null,
    Object? isLoading = null,
    Object? isConnected = null,
    Object? error = freezed,
    Object? currentPickerRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? searchQuery = freezed,
    Object? positionFilters = null,
  }) {
    return _then(_$DraftRoomStateImpl(
      draft: null == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as Draft,
      availablePlayers: null == availablePlayers
          ? _value._availablePlayers
          : availablePlayers // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      picks: null == picks
          ? _value._picks
          : picks // ignore: cast_nullable_to_non_nullable
              as List<DraftPick>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPickerRosterId: freezed == currentPickerRosterId
          ? _value.currentPickerRosterId
          : currentPickerRosterId // ignore: cast_nullable_to_non_nullable
              as int?,
      pickDeadline: freezed == pickDeadline
          ? _value.pickDeadline
          : pickDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      positionFilters: null == positionFilters
          ? _value._positionFilters
          : positionFilters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$DraftRoomStateImpl extends _DraftRoomState {
  const _$DraftRoomStateImpl(
      {required this.draft,
      final List<Player> availablePlayers = const [],
      final List<DraftPick> picks = const [],
      this.isLoading = false,
      this.isConnected = false,
      this.error,
      this.currentPickerRosterId,
      this.pickDeadline,
      this.searchQuery,
      final List<String> positionFilters = const []})
      : _availablePlayers = availablePlayers,
        _picks = picks,
        _positionFilters = positionFilters,
        super._();

  @override
  final Draft draft;
  final List<Player> _availablePlayers;
  @override
  @JsonKey()
  List<Player> get availablePlayers {
    if (_availablePlayers is EqualUnmodifiableListView)
      return _availablePlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availablePlayers);
  }

  final List<DraftPick> _picks;
  @override
  @JsonKey()
  List<DraftPick> get picks {
    if (_picks is EqualUnmodifiableListView) return _picks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picks);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isConnected;
  @override
  final String? error;
  @override
  final int? currentPickerRosterId;
  @override
  final DateTime? pickDeadline;
  @override
  final String? searchQuery;
  final List<String> _positionFilters;
  @override
  @JsonKey()
  List<String> get positionFilters {
    if (_positionFilters is EqualUnmodifiableListView) return _positionFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_positionFilters);
  }

  @override
  String toString() {
    return 'DraftRoomState(draft: $draft, availablePlayers: $availablePlayers, picks: $picks, isLoading: $isLoading, isConnected: $isConnected, error: $error, currentPickerRosterId: $currentPickerRosterId, pickDeadline: $pickDeadline, searchQuery: $searchQuery, positionFilters: $positionFilters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftRoomStateImpl &&
            (identical(other.draft, draft) || other.draft == draft) &&
            const DeepCollectionEquality()
                .equals(other._availablePlayers, _availablePlayers) &&
            const DeepCollectionEquality().equals(other._picks, _picks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentPickerRosterId, currentPickerRosterId) ||
                other.currentPickerRosterId == currentPickerRosterId) &&
            (identical(other.pickDeadline, pickDeadline) ||
                other.pickDeadline == pickDeadline) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality()
                .equals(other._positionFilters, _positionFilters));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      draft,
      const DeepCollectionEquality().hash(_availablePlayers),
      const DeepCollectionEquality().hash(_picks),
      isLoading,
      isConnected,
      error,
      currentPickerRosterId,
      pickDeadline,
      searchQuery,
      const DeepCollectionEquality().hash(_positionFilters));

  /// Create a copy of DraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftRoomStateImplCopyWith<_$DraftRoomStateImpl> get copyWith =>
      __$$DraftRoomStateImplCopyWithImpl<_$DraftRoomStateImpl>(
          this, _$identity);
}

abstract class _DraftRoomState extends DraftRoomState {
  const factory _DraftRoomState(
      {required final Draft draft,
      final List<Player> availablePlayers,
      final List<DraftPick> picks,
      final bool isLoading,
      final bool isConnected,
      final String? error,
      final int? currentPickerRosterId,
      final DateTime? pickDeadline,
      final String? searchQuery,
      final List<String> positionFilters}) = _$DraftRoomStateImpl;
  const _DraftRoomState._() : super._();

  @override
  Draft get draft;
  @override
  List<Player> get availablePlayers;
  @override
  List<DraftPick> get picks;
  @override
  bool get isLoading;
  @override
  bool get isConnected;
  @override
  String? get error;
  @override
  int? get currentPickerRosterId;
  @override
  DateTime? get pickDeadline;
  @override
  String? get searchQuery;
  @override
  List<String> get positionFilters;

  /// Create a copy of DraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftRoomStateImplCopyWith<_$DraftRoomStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
