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
      id: json['id'] as int,
      draftId: json['draftId'] as int,
      rosterId: json['rosterId'] as int,
      draftPosition: json['draftPosition'] as int?,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      teamName: json['teamName'] as String?,
    );
  }
}
