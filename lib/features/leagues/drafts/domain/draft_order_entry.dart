import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_order_entry.freezed.dart';
part 'draft_order_entry.g.dart';

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

  factory DraftOrderEntry.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderEntryFromJson(json);
}
