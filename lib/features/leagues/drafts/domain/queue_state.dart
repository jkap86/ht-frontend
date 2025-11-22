import 'package:freezed_annotation/freezed_annotation.dart';
import 'draft_queue.dart';

part 'queue_state.freezed.dart';

/// State for the draft queue feature
@freezed
class QueueState with _$QueueState {
  const factory QueueState({
    @Default([]) List<DraftQueue> items,
    @Default(false) bool isLoading,
    String? error,
  }) = _QueueState;
}
