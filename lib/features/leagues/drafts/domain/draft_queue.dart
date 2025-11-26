import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../players/domain/player.dart';

part 'draft_queue.freezed.dart';
part 'draft_queue.g.dart';

@freezed
class DraftQueue with _$DraftQueue {
  const factory DraftQueue({
    required int id,
    required int draftId,
    required int rosterId,
    required int playerId,
    required int queuePosition,
    required DateTime createdAt,
    Player? player,
  }) = _DraftQueue;

  factory DraftQueue.fromJson(Map<String, dynamic> json) =>
      _$DraftQueueFromJson(json);
}
