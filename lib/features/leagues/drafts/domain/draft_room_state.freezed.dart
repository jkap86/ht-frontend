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
  List<DraftOrderEntry> get draftOrder => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int? get currentPickerRosterId => throw _privateConstructorUsedError;
  DateTime? get pickDeadline => throw _privateConstructorUsedError;
  DateTime? get pausedAtDeadline => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  List<String> get positionFilters => throw _privateConstructorUsedError;
  Map<int, bool> get userAutopickStatuses => throw _privateConstructorUsedError;
  PlayerSortField get sortField => throw _privateConstructorUsedError;
  bool get sortDescending => throw _privateConstructorUsedError;

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
      List<DraftOrderEntry> draftOrder,
      bool isLoading,
      bool isConnected,
      String? error,
      int? currentPickerRosterId,
      DateTime? pickDeadline,
      DateTime? pausedAtDeadline,
      String? searchQuery,
      List<String> positionFilters,
      Map<int, bool> userAutopickStatuses,
      PlayerSortField sortField,
      bool sortDescending});

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
    Object? draftOrder = null,
    Object? isLoading = null,
    Object? isConnected = null,
    Object? error = freezed,
    Object? currentPickerRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? pausedAtDeadline = freezed,
    Object? searchQuery = freezed,
    Object? positionFilters = null,
    Object? userAutopickStatuses = null,
    Object? sortField = null,
    Object? sortDescending = null,
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
      draftOrder: null == draftOrder
          ? _value.draftOrder
          : draftOrder // ignore: cast_nullable_to_non_nullable
              as List<DraftOrderEntry>,
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
      pausedAtDeadline: freezed == pausedAtDeadline
          ? _value.pausedAtDeadline
          : pausedAtDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      positionFilters: null == positionFilters
          ? _value.positionFilters
          : positionFilters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userAutopickStatuses: null == userAutopickStatuses
          ? _value.userAutopickStatuses
          : userAutopickStatuses // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      sortField: null == sortField
          ? _value.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as PlayerSortField,
      sortDescending: null == sortDescending
          ? _value.sortDescending
          : sortDescending // ignore: cast_nullable_to_non_nullable
              as bool,
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
      List<DraftOrderEntry> draftOrder,
      bool isLoading,
      bool isConnected,
      String? error,
      int? currentPickerRosterId,
      DateTime? pickDeadline,
      DateTime? pausedAtDeadline,
      String? searchQuery,
      List<String> positionFilters,
      Map<int, bool> userAutopickStatuses,
      PlayerSortField sortField,
      bool sortDescending});

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
    Object? draftOrder = null,
    Object? isLoading = null,
    Object? isConnected = null,
    Object? error = freezed,
    Object? currentPickerRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? pausedAtDeadline = freezed,
    Object? searchQuery = freezed,
    Object? positionFilters = null,
    Object? userAutopickStatuses = null,
    Object? sortField = null,
    Object? sortDescending = null,
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
      draftOrder: null == draftOrder
          ? _value._draftOrder
          : draftOrder // ignore: cast_nullable_to_non_nullable
              as List<DraftOrderEntry>,
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
      pausedAtDeadline: freezed == pausedAtDeadline
          ? _value.pausedAtDeadline
          : pausedAtDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      positionFilters: null == positionFilters
          ? _value._positionFilters
          : positionFilters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userAutopickStatuses: null == userAutopickStatuses
          ? _value._userAutopickStatuses
          : userAutopickStatuses // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      sortField: null == sortField
          ? _value.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as PlayerSortField,
      sortDescending: null == sortDescending
          ? _value.sortDescending
          : sortDescending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DraftRoomStateImpl extends _DraftRoomState {
  const _$DraftRoomStateImpl(
      {required this.draft,
      final List<Player> availablePlayers = const [],
      final List<DraftPick> picks = const [],
      final List<DraftOrderEntry> draftOrder = const [],
      this.isLoading = false,
      this.isConnected = false,
      this.error,
      this.currentPickerRosterId,
      this.pickDeadline,
      this.pausedAtDeadline,
      this.searchQuery,
      final List<String> positionFilters = const [],
      final Map<int, bool> userAutopickStatuses = const {},
      this.sortField = PlayerSortField.proj,
      this.sortDescending = true})
      : _availablePlayers = availablePlayers,
        _picks = picks,
        _draftOrder = draftOrder,
        _positionFilters = positionFilters,
        _userAutopickStatuses = userAutopickStatuses,
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

  final List<DraftOrderEntry> _draftOrder;
  @override
  @JsonKey()
  List<DraftOrderEntry> get draftOrder {
    if (_draftOrder is EqualUnmodifiableListView) return _draftOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_draftOrder);
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
  final DateTime? pausedAtDeadline;
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

  final Map<int, bool> _userAutopickStatuses;
  @override
  @JsonKey()
  Map<int, bool> get userAutopickStatuses {
    if (_userAutopickStatuses is EqualUnmodifiableMapView)
      return _userAutopickStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userAutopickStatuses);
  }

  @override
  @JsonKey()
  final PlayerSortField sortField;
  @override
  @JsonKey()
  final bool sortDescending;

  @override
  String toString() {
    return 'DraftRoomState(draft: $draft, availablePlayers: $availablePlayers, picks: $picks, draftOrder: $draftOrder, isLoading: $isLoading, isConnected: $isConnected, error: $error, currentPickerRosterId: $currentPickerRosterId, pickDeadline: $pickDeadline, pausedAtDeadline: $pausedAtDeadline, searchQuery: $searchQuery, positionFilters: $positionFilters, userAutopickStatuses: $userAutopickStatuses, sortField: $sortField, sortDescending: $sortDescending)';
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
            const DeepCollectionEquality()
                .equals(other._draftOrder, _draftOrder) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentPickerRosterId, currentPickerRosterId) ||
                other.currentPickerRosterId == currentPickerRosterId) &&
            (identical(other.pickDeadline, pickDeadline) ||
                other.pickDeadline == pickDeadline) &&
            (identical(other.pausedAtDeadline, pausedAtDeadline) ||
                other.pausedAtDeadline == pausedAtDeadline) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality()
                .equals(other._positionFilters, _positionFilters) &&
            const DeepCollectionEquality()
                .equals(other._userAutopickStatuses, _userAutopickStatuses) &&
            (identical(other.sortField, sortField) ||
                other.sortField == sortField) &&
            (identical(other.sortDescending, sortDescending) ||
                other.sortDescending == sortDescending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      draft,
      const DeepCollectionEquality().hash(_availablePlayers),
      const DeepCollectionEquality().hash(_picks),
      const DeepCollectionEquality().hash(_draftOrder),
      isLoading,
      isConnected,
      error,
      currentPickerRosterId,
      pickDeadline,
      pausedAtDeadline,
      searchQuery,
      const DeepCollectionEquality().hash(_positionFilters),
      const DeepCollectionEquality().hash(_userAutopickStatuses),
      sortField,
      sortDescending);

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
      final List<DraftOrderEntry> draftOrder,
      final bool isLoading,
      final bool isConnected,
      final String? error,
      final int? currentPickerRosterId,
      final DateTime? pickDeadline,
      final DateTime? pausedAtDeadline,
      final String? searchQuery,
      final List<String> positionFilters,
      final Map<int, bool> userAutopickStatuses,
      final PlayerSortField sortField,
      final bool sortDescending}) = _$DraftRoomStateImpl;
  const _DraftRoomState._() : super._();

  @override
  Draft get draft;
  @override
  List<Player> get availablePlayers;
  @override
  List<DraftPick> get picks;
  @override
  List<DraftOrderEntry> get draftOrder;
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
  DateTime? get pausedAtDeadline;
  @override
  String? get searchQuery;
  @override
  List<String> get positionFilters;
  @override
  Map<int, bool> get userAutopickStatuses;
  @override
  PlayerSortField get sortField;
  @override
  bool get sortDescending;

  /// Create a copy of DraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftRoomStateImplCopyWith<_$DraftRoomStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
