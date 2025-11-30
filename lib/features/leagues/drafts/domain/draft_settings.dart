import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_settings.freezed.dart';
part 'draft_settings.g.dart';

/// Settings stored in the drafts.settings JSONB field
@freezed
class DraftSettings with _$DraftSettings {
  const factory DraftSettings({
    @JsonKey(name: 'draft_order') @Default('random') String draftOrder,
    @JsonKey(name: 'player_pool') @Default('all') String playerPool,
    @JsonKey(name: 'current_picker_index') int? currentPickerIndex,
    @JsonKey(name: 'draft_order_list') List<Map<String, dynamic>>? draftOrderList,
    // Derby-specific settings
    @JsonKey(name: 'derby_start_time') DateTime? derbyStartTime,
    @JsonKey(name: 'derby_status') String? derbyStatus,
    @JsonKey(name: 'derby_timer_seconds') int? derbyTimerSeconds,
    @JsonKey(name: 'derby_on_timeout') String? derbyOnTimeout,
  }) = _DraftSettings;

  factory DraftSettings.fromJson(Map<String, dynamic> json) =>
      _$DraftSettingsFromJson(json);
}
