import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_order_entry.freezed.dart';

@freezed
class DraftOrderEntry with _$DraftOrderEntry {
  const factory DraftOrderEntry({
    required int id,
    required int draftId,
    required int rosterId,
    int? draftPosition,
    String? userId,
    String? username,
    String? teamName,
  }) = _DraftOrderEntry;

  factory DraftOrderEntry.fromJson(Map<String, dynamic> json) {
    return DraftOrderEntry(
      id: (json['id'] as int?) ?? (throw Exception('DraftOrderEntry id is required but was null')),
      draftId: (json['draftId'] as int?) ?? (json['draft_id'] as int?) ?? (throw Exception('DraftOrderEntry draftId is required but was null')),
      rosterId: (json['rosterId'] as int?) ?? (json['roster_id'] as int?) ?? (throw Exception('DraftOrderEntry rosterId is required but was null')),
      draftPosition: (json['draftPosition'] as int?) ?? (json['draft_position'] as int?),
      userId: (json['userId'] as String?) ?? (json['user_id'] as String?),
      username: json['username'] as String?,
      teamName: (json['teamName'] as String?) ?? (json['team_name'] as String?),
    );
  }
}
