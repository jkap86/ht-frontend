import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_order_entry.freezed.dart';

@freezed
class DraftOrderEntry with _$DraftOrderEntry {
  const factory DraftOrderEntry({
    required int id,
    required int draftId,
    required int rosterId,
    required int draftPosition,
    String? userId,
    String? username,
    String? teamName,
  }) = _DraftOrderEntry;

  factory DraftOrderEntry.fromJson(Map<String, dynamic> json) {
    return DraftOrderEntry(
      id: json['id'] as int,
      draftId: json['draft_id'] as int,
      rosterId: json['roster_id'] as int,
      draftPosition: json['draft_position'] as int,
      userId: json['user_id'] as String?,
      username: json['username'] as String?,
      teamName: json['team_name'] as String?,
    );
  }
}
