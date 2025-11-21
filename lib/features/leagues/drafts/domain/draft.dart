import 'package:freezed_annotation/freezed_annotation.dart';
import 'draft_settings.dart';

part 'draft.freezed.dart';
part 'draft.g.dart';

/// Represents a draft entity with type-safe properties
@freezed
class Draft with _$Draft {
  const Draft._();

  const factory Draft({
    required int id,
    required int leagueId,
    required String draftType,
    required int rounds,
    required int totalRosters,
    int? pickTimeSeconds,
    required String status,
    int? currentPick,
    int? currentRound,
    @Default(false) bool thirdRoundReversal,
    int? currentRosterId,
    int? commissionerRosterId,
    int? userRosterId,
    DateTime? pickDeadline,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DraftSettings? settings,
  }) = _Draft;

  factory Draft.fromJson(Map<String, dynamic> json) => _$DraftFromJson(json);

  /// Check if current user is the commissioner
  bool get isCommissioner {
    if (commissionerRosterId == null || userRosterId == null) {
      return false;
    }
    return commissionerRosterId == userRosterId;
  }
}
