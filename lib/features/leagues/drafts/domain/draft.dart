import 'package:freezed_annotation/freezed_annotation.dart';
import 'draft_settings.dart';

part 'draft.freezed.dart';

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

  factory Draft.fromJson(Map<String, dynamic> json) {
    return Draft(
      id: json['id'] as int,
      leagueId: (json['leagueId'] ?? json['league_id']) as int,
      draftType: (json['draftType'] ?? json['draft_type']) as String,
      rounds: json['rounds'] as int,
      totalRosters: (json['totalRosters'] ?? json['total_rosters']) as int,
      pickTimeSeconds: (json['pickTimeSeconds'] ?? json['pick_time_seconds']) as int?,
      status: json['status'] as String,
      currentPick: (json['currentPick'] ?? json['current_pick']) as int?,
      currentRound: (json['currentRound'] ?? json['current_round']) as int?,
      thirdRoundReversal: (json['thirdRoundReversal'] ?? json['third_round_reversal'] ?? false) as bool,
      currentRosterId: (json['currentRosterId'] ?? json['current_roster_id']) as int?,
      commissionerRosterId: (json['commissionerRosterId'] ?? json['commissioner_roster_id']) as int?,
      userRosterId: (json['userRosterId'] ?? json['user_roster_id']) as int?,
      pickDeadline: json['pickDeadline'] != null
          ? DateTime.parse(json['pickDeadline'] as String)
          : (json['pick_deadline'] != null ? DateTime.parse(json['pick_deadline'] as String) : null),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : (json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : (json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : (json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : (json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null),
      settings: json['settings'] != null
          ? DraftSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Check if current user is the commissioner
  bool get isCommissioner {
    if (commissionerRosterId == null || userRosterId == null) {
      return false;
    }
    return commissionerRosterId == userRosterId;
  }
}
