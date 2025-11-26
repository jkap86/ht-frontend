// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matchup_draft_room_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MatchupDraftRoomState {
  Draft get draft => throw _privateConstructorUsedError;
  List<AvailableMatchup> get availableMatchups =>
      throw _privateConstructorUsedError;
  List<MatchupDraftPick> get picks => throw _privateConstructorUsedError;
  List<DraftOrderEntry> get draftOrder => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int? get currentPickerRosterId => throw _privateConstructorUsedError;
  DateTime? get pickDeadline => throw _privateConstructorUsedError;
  DateTime? get pausedAtDeadline => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  List<int> get weekFilters => throw _privateConstructorUsedError;

  /// Create a copy of MatchupDraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchupDraftRoomStateCopyWith<MatchupDraftRoomState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchupDraftRoomStateCopyWith<$Res> {
  factory $MatchupDraftRoomStateCopyWith(MatchupDraftRoomState value,
          $Res Function(MatchupDraftRoomState) then) =
      _$MatchupDraftRoomStateCopyWithImpl<$Res, MatchupDraftRoomState>;
  @useResult
  $Res call(
      {Draft draft,
      List<AvailableMatchup> availableMatchups,
      List<MatchupDraftPick> picks,
      List<DraftOrderEntry> draftOrder,
      bool isLoading,
      bool isConnected,
      String? error,
      int? currentPickerRosterId,
      DateTime? pickDeadline,
      DateTime? pausedAtDeadline,
      String? searchQuery,
      List<int> weekFilters});

  $DraftCopyWith<$Res> get draft;
}

/// @nodoc
class _$MatchupDraftRoomStateCopyWithImpl<$Res,
        $Val extends MatchupDraftRoomState>
    implements $MatchupDraftRoomStateCopyWith<$Res> {
  _$MatchupDraftRoomStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchupDraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draft = null,
    Object? availableMatchups = null,
    Object? picks = null,
    Object? draftOrder = null,
    Object? isLoading = null,
    Object? isConnected = null,
    Object? error = freezed,
    Object? currentPickerRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? pausedAtDeadline = freezed,
    Object? searchQuery = freezed,
    Object? weekFilters = null,
  }) {
    return _then(_value.copyWith(
      draft: null == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as Draft,
      availableMatchups: null == availableMatchups
          ? _value.availableMatchups
          : availableMatchups // ignore: cast_nullable_to_non_nullable
              as List<AvailableMatchup>,
      picks: null == picks
          ? _value.picks
          : picks // ignore: cast_nullable_to_non_nullable
              as List<MatchupDraftPick>,
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
      weekFilters: null == weekFilters
          ? _value.weekFilters
          : weekFilters // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }

  /// Create a copy of MatchupDraftRoomState
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
abstract class _$$MatchupDraftRoomStateImplCopyWith<$Res>
    implements $MatchupDraftRoomStateCopyWith<$Res> {
  factory _$$MatchupDraftRoomStateImplCopyWith(
          _$MatchupDraftRoomStateImpl value,
          $Res Function(_$MatchupDraftRoomStateImpl) then) =
      __$$MatchupDraftRoomStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Draft draft,
      List<AvailableMatchup> availableMatchups,
      List<MatchupDraftPick> picks,
      List<DraftOrderEntry> draftOrder,
      bool isLoading,
      bool isConnected,
      String? error,
      int? currentPickerRosterId,
      DateTime? pickDeadline,
      DateTime? pausedAtDeadline,
      String? searchQuery,
      List<int> weekFilters});

  @override
  $DraftCopyWith<$Res> get draft;
}

/// @nodoc
class __$$MatchupDraftRoomStateImplCopyWithImpl<$Res>
    extends _$MatchupDraftRoomStateCopyWithImpl<$Res,
        _$MatchupDraftRoomStateImpl>
    implements _$$MatchupDraftRoomStateImplCopyWith<$Res> {
  __$$MatchupDraftRoomStateImplCopyWithImpl(_$MatchupDraftRoomStateImpl _value,
      $Res Function(_$MatchupDraftRoomStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchupDraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? draft = null,
    Object? availableMatchups = null,
    Object? picks = null,
    Object? draftOrder = null,
    Object? isLoading = null,
    Object? isConnected = null,
    Object? error = freezed,
    Object? currentPickerRosterId = freezed,
    Object? pickDeadline = freezed,
    Object? pausedAtDeadline = freezed,
    Object? searchQuery = freezed,
    Object? weekFilters = null,
  }) {
    return _then(_$MatchupDraftRoomStateImpl(
      draft: null == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as Draft,
      availableMatchups: null == availableMatchups
          ? _value._availableMatchups
          : availableMatchups // ignore: cast_nullable_to_non_nullable
              as List<AvailableMatchup>,
      picks: null == picks
          ? _value._picks
          : picks // ignore: cast_nullable_to_non_nullable
              as List<MatchupDraftPick>,
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
      weekFilters: null == weekFilters
          ? _value._weekFilters
          : weekFilters // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$MatchupDraftRoomStateImpl extends _MatchupDraftRoomState {
  const _$MatchupDraftRoomStateImpl(
      {required this.draft,
      final List<AvailableMatchup> availableMatchups = const [],
      final List<MatchupDraftPick> picks = const [],
      final List<DraftOrderEntry> draftOrder = const [],
      this.isLoading = false,
      this.isConnected = false,
      this.error,
      this.currentPickerRosterId,
      this.pickDeadline,
      this.pausedAtDeadline,
      this.searchQuery,
      final List<int> weekFilters = const []})
      : _availableMatchups = availableMatchups,
        _picks = picks,
        _draftOrder = draftOrder,
        _weekFilters = weekFilters,
        super._();

  @override
  final Draft draft;
  final List<AvailableMatchup> _availableMatchups;
  @override
  @JsonKey()
  List<AvailableMatchup> get availableMatchups {
    if (_availableMatchups is EqualUnmodifiableListView)
      return _availableMatchups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableMatchups);
  }

  final List<MatchupDraftPick> _picks;
  @override
  @JsonKey()
  List<MatchupDraftPick> get picks {
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
  final List<int> _weekFilters;
  @override
  @JsonKey()
  List<int> get weekFilters {
    if (_weekFilters is EqualUnmodifiableListView) return _weekFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekFilters);
  }

  @override
  String toString() {
    return 'MatchupDraftRoomState(draft: $draft, availableMatchups: $availableMatchups, picks: $picks, draftOrder: $draftOrder, isLoading: $isLoading, isConnected: $isConnected, error: $error, currentPickerRosterId: $currentPickerRosterId, pickDeadline: $pickDeadline, pausedAtDeadline: $pausedAtDeadline, searchQuery: $searchQuery, weekFilters: $weekFilters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchupDraftRoomStateImpl &&
            (identical(other.draft, draft) || other.draft == draft) &&
            const DeepCollectionEquality()
                .equals(other._availableMatchups, _availableMatchups) &&
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
                .equals(other._weekFilters, _weekFilters));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      draft,
      const DeepCollectionEquality().hash(_availableMatchups),
      const DeepCollectionEquality().hash(_picks),
      const DeepCollectionEquality().hash(_draftOrder),
      isLoading,
      isConnected,
      error,
      currentPickerRosterId,
      pickDeadline,
      pausedAtDeadline,
      searchQuery,
      const DeepCollectionEquality().hash(_weekFilters));

  /// Create a copy of MatchupDraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchupDraftRoomStateImplCopyWith<_$MatchupDraftRoomStateImpl>
      get copyWith => __$$MatchupDraftRoomStateImplCopyWithImpl<
          _$MatchupDraftRoomStateImpl>(this, _$identity);
}

abstract class _MatchupDraftRoomState extends MatchupDraftRoomState {
  const factory _MatchupDraftRoomState(
      {required final Draft draft,
      final List<AvailableMatchup> availableMatchups,
      final List<MatchupDraftPick> picks,
      final List<DraftOrderEntry> draftOrder,
      final bool isLoading,
      final bool isConnected,
      final String? error,
      final int? currentPickerRosterId,
      final DateTime? pickDeadline,
      final DateTime? pausedAtDeadline,
      final String? searchQuery,
      final List<int> weekFilters}) = _$MatchupDraftRoomStateImpl;
  const _MatchupDraftRoomState._() : super._();

  @override
  Draft get draft;
  @override
  List<AvailableMatchup> get availableMatchups;
  @override
  List<MatchupDraftPick> get picks;
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
  List<int> get weekFilters;

  /// Create a copy of MatchupDraftRoomState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchupDraftRoomStateImplCopyWith<_$MatchupDraftRoomStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
