import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_settings.freezed.dart';
part 'draft_settings.g.dart';

/// Settings stored in the drafts.settings JSONB field
@freezed
class DraftSettings with _$DraftSettings {
  const factory DraftSettings({
    @Default('randomize') String draftOrder,
    @Default('all') String playerPool,
    int? currentPickerIndex,
    List<Map<String, dynamic>>? draftOrderList,
    // Derby-specific settings
    DateTime? derbyStartTime,
    String? derbyStatus,
  }) = _DraftSettings;

  factory DraftSettings.fromJson(Map<String, dynamic> json) =>
      _$DraftSettingsFromJson(json);
}
