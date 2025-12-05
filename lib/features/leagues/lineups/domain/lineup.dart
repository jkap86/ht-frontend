import 'package:freezed_annotation/freezed_annotation.dart';

part 'lineup.freezed.dart';

/// Represents a starter slot with player ID and position slot
@freezed
class StarterSlot with _$StarterSlot {
  const factory StarterSlot({
    required int playerId,
    required String slot,
  }) = _StarterSlot;

  factory StarterSlot.fromJson(Map<String, dynamic> json) {
    return StarterSlot(
      playerId: json['player_id'] as int,
      slot: json['slot'] as String,
    );
  }
}

/// Extended player info for lineup display including lock status
@freezed
class LineupPlayer with _$LineupPlayer {
  const factory LineupPlayer({
    required int playerId,
    required String playerName,
    required String playerPosition,
    required String playerTeam,
    required String playerSleeperId,
    String? slot,
    required bool isLocked,
    String? gameStatus,
    // Matchup display fields
    String? opponent,
    double? projectedPts,
    double? actualPts,
  }) = _LineupPlayer;

  factory LineupPlayer.fromJson(Map<String, dynamic> json) {
    return LineupPlayer(
      playerId: json['playerId'] as int,
      playerName: json['playerName'] as String? ?? 'Unknown',
      playerPosition: json['playerPosition'] as String? ?? '',
      playerTeam: json['playerTeam'] as String? ?? '',
      playerSleeperId: json['playerSleeperId'] as String? ?? '',
      slot: json['slot'] as String?,
      isLocked: json['isLocked'] as bool? ?? false,
      gameStatus: json['gameStatus'] as String?,
      opponent: json['opponent'] as String?,
      projectedPts: (json['projectedPts'] as num?)?.toDouble(),
      actualPts: (json['actualPts'] as num?)?.toDouble(),
    );
  }
}

/// Weekly lineup configuration stored in database
@freezed
class WeeklyLineup with _$WeeklyLineup {
  const factory WeeklyLineup({
    required int id,
    required int rosterId,
    required int leagueId,
    required int week,
    required String season,
    required List<StarterSlot> starters,
    required List<int> bench,
    required List<int> ir,
    String? modifiedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WeeklyLineup;

  factory WeeklyLineup.fromJson(Map<String, dynamic> json) {
    return WeeklyLineup(
      id: json['id'] as int? ?? 0,
      rosterId: json['rosterId'] as int,
      leagueId: json['leagueId'] as int,
      week: json['week'] as int,
      season: json['season'] as String,
      starters: (json['starters'] as List<dynamic>?)
              ?.map((s) => StarterSlot.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      bench: (json['bench'] as List<dynamic>?)
              ?.map((b) => b as int)
              .toList() ??
          [],
      ir: (json['ir'] as List<dynamic>?)?.map((i) => i as int).toList() ?? [],
      modifiedBy: json['modifiedBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}

/// Full lineup response from API with player details and permissions
@freezed
class LineupResponse with _$LineupResponse {
  const factory LineupResponse({
    WeeklyLineup? weeklyLineup,
    required List<LineupPlayer> starters,
    required List<LineupPlayer> bench,
    required List<LineupPlayer> ir,
    required bool canEdit,
    required bool isCommissioner,
    required List<String> lockedTeams,
  }) = _LineupResponse;

  factory LineupResponse.fromJson(Map<String, dynamic> json) {
    return LineupResponse(
      weeklyLineup: json['weeklyLineup'] != null
          ? WeeklyLineup.fromJson(json['weeklyLineup'] as Map<String, dynamic>)
          : null,
      starters: (json['starters'] as List<dynamic>?)
              ?.map((s) => LineupPlayer.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      bench: (json['bench'] as List<dynamic>?)
              ?.map((b) => LineupPlayer.fromJson(b as Map<String, dynamic>))
              .toList() ??
          [],
      ir: (json['ir'] as List<dynamic>?)
              ?.map((i) => LineupPlayer.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      canEdit: json['canEdit'] as bool? ?? false,
      isCommissioner: json['isCommissioner'] as bool? ?? false,
      lockedTeams: (json['lockedTeams'] as List<dynamic>?)
              ?.map((t) => t as String)
              .toList() ??
          [],
    );
  }
}

/// Position eligibility mapping (mirrors backend)
class PositionEligibility {
  static const Map<String, List<String>> eligibility = {
    'QB': ['QB'],
    'QB1': ['QB'],
    'RB': ['RB'],
    'RB1': ['RB'],
    'RB2': ['RB'],
    'WR': ['WR'],
    'WR1': ['WR'],
    'WR2': ['WR'],
    'WR3': ['WR'],
    'TE': ['TE'],
    'TE1': ['TE'],
    'K': ['K'],
    'K1': ['K'],
    'DEF': ['DEF'],
    'DEF1': ['DEF'],
    'FLEX': ['RB', 'WR', 'TE'],
    'SUPER_FLEX': ['QB', 'RB', 'WR', 'TE'],
    'SF': ['QB', 'RB', 'WR', 'TE'],
    'BN': ['QB', 'RB', 'WR', 'TE', 'K', 'DEF'],
    'IR': ['QB', 'RB', 'WR', 'TE', 'K', 'DEF'],
  };

  /// Check if a player position is eligible for a slot
  static bool isEligible(String playerPosition, String slot) {
    final normalizedSlot = slot.toUpperCase().replaceAll(RegExp(r'\d+$'), '');
    final eligible = eligibility[normalizedSlot] ?? eligibility[slot.toUpperCase()] ?? [];
    return eligible.contains(playerPosition.toUpperCase());
  }

  /// Get all slots a player position can fill
  static List<String> getEligibleSlots(
      String playerPosition, Map<String, int> rosterPositions) {
    final eligible = <String>[];
    final pos = playerPosition.toUpperCase();

    for (final entry in rosterPositions.entries) {
      if (entry.value > 0) {
        final slotEligible = eligibility[entry.key.toUpperCase()] ?? [];
        if (slotEligible.contains(pos)) {
          eligible.add(entry.key);
        }
      }
    }

    return eligible;
  }
}
