// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_order_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DraftOrderEntry {
  int get id => throw _privateConstructorUsedError;
  int get draftId => throw _privateConstructorUsedError;
  int get rosterId => throw _privateConstructorUsedError;
  int? get draftPosition => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get teamName => throw _privateConstructorUsedError;

  /// Create a copy of DraftOrderEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftOrderEntryCopyWith<DraftOrderEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftOrderEntryCopyWith<$Res> {
  factory $DraftOrderEntryCopyWith(
          DraftOrderEntry value, $Res Function(DraftOrderEntry) then) =
      _$DraftOrderEntryCopyWithImpl<$Res, DraftOrderEntry>;
  @useResult
  $Res call(
      {int id,
      int draftId,
      int rosterId,
      int? draftPosition,
      String? userId,
      String? username,
      String? teamName});
}

/// @nodoc
class _$DraftOrderEntryCopyWithImpl<$Res, $Val extends DraftOrderEntry>
    implements $DraftOrderEntryCopyWith<$Res> {
  _$DraftOrderEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftOrderEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? draftId = null,
    Object? rosterId = null,
    Object? draftPosition = freezed,
    Object? userId = freezed,
    Object? username = freezed,
    Object? teamName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      draftId: null == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      draftPosition: freezed == draftPosition
          ? _value.draftPosition
          : draftPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      teamName: freezed == teamName
          ? _value.teamName
          : teamName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DraftOrderEntryImplCopyWith<$Res>
    implements $DraftOrderEntryCopyWith<$Res> {
  factory _$$DraftOrderEntryImplCopyWith(_$DraftOrderEntryImpl value,
          $Res Function(_$DraftOrderEntryImpl) then) =
      __$$DraftOrderEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int draftId,
      int rosterId,
      int? draftPosition,
      String? userId,
      String? username,
      String? teamName});
}

/// @nodoc
class __$$DraftOrderEntryImplCopyWithImpl<$Res>
    extends _$DraftOrderEntryCopyWithImpl<$Res, _$DraftOrderEntryImpl>
    implements _$$DraftOrderEntryImplCopyWith<$Res> {
  __$$DraftOrderEntryImplCopyWithImpl(
      _$DraftOrderEntryImpl _value, $Res Function(_$DraftOrderEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of DraftOrderEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? draftId = null,
    Object? rosterId = null,
    Object? draftPosition = freezed,
    Object? userId = freezed,
    Object? username = freezed,
    Object? teamName = freezed,
  }) {
    return _then(_$DraftOrderEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      draftId: null == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as int,
      rosterId: null == rosterId
          ? _value.rosterId
          : rosterId // ignore: cast_nullable_to_non_nullable
              as int,
      draftPosition: freezed == draftPosition
          ? _value.draftPosition
          : draftPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      teamName: freezed == teamName
          ? _value.teamName
          : teamName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DraftOrderEntryImpl implements _DraftOrderEntry {
  const _$DraftOrderEntryImpl(
      {required this.id,
      required this.draftId,
      required this.rosterId,
      this.draftPosition,
      this.userId,
      this.username,
      this.teamName});

  @override
  final int id;
  @override
  final int draftId;
  @override
  final int rosterId;
  @override
  final int? draftPosition;
  @override
  final String? userId;
  @override
  final String? username;
  @override
  final String? teamName;

  @override
  String toString() {
    return 'DraftOrderEntry(id: $id, draftId: $draftId, rosterId: $rosterId, draftPosition: $draftPosition, userId: $userId, username: $username, teamName: $teamName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftOrderEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.draftId, draftId) || other.draftId == draftId) &&
            (identical(other.rosterId, rosterId) ||
                other.rosterId == rosterId) &&
            (identical(other.draftPosition, draftPosition) ||
                other.draftPosition == draftPosition) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.teamName, teamName) ||
                other.teamName == teamName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, draftId, rosterId,
      draftPosition, userId, username, teamName);

  /// Create a copy of DraftOrderEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftOrderEntryImplCopyWith<_$DraftOrderEntryImpl> get copyWith =>
      __$$DraftOrderEntryImplCopyWithImpl<_$DraftOrderEntryImpl>(
          this, _$identity);
}

abstract class _DraftOrderEntry implements DraftOrderEntry {
  const factory _DraftOrderEntry(
      {required final int id,
      required final int draftId,
      required final int rosterId,
      final int? draftPosition,
      final String? userId,
      final String? username,
      final String? teamName}) = _$DraftOrderEntryImpl;

  @override
  int get id;
  @override
  int get draftId;
  @override
  int get rosterId;
  @override
  int? get draftPosition;
  @override
  String? get userId;
  @override
  String? get username;
  @override
  String? get teamName;

  /// Create a copy of DraftOrderEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftOrderEntryImplCopyWith<_$DraftOrderEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
