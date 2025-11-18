import '../../domain/league.dart';

/// Data Transfer Object for League
/// Handles JSON serialization/deserialization (data layer concern)
class LeagueDto {
  final int id;
  final String name;
  final String? description;
  final int totalRosters;
  final String status;
  final String? draftType;
  final DateTime? draftDate;
  final int? commissionerRosterId;
  final int? userRosterId;
  final String season;
  final String seasonType;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? scoringSettings;
  final Map<String, dynamic>? rosterPositions;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeagueDto({
    required this.id,
    required this.name,
    this.description,
    required this.totalRosters,
    required this.status,
    this.draftType,
    this.draftDate,
    this.commissionerRosterId,
    this.userRosterId,
    required this.season,
    required this.seasonType,
    this.settings,
    this.scoringSettings,
    this.rosterPositions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert JSON from API to DTO
  factory LeagueDto.fromJson(Map<String, dynamic> json) {
    // Extract settings object for nested values
    final settings = json['settings'] as Map<String, dynamic>?;

    return LeagueDto(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      totalRosters: json['total_rosters'] as int,
      status: json['status'] as String,
      draftType: json['draft_type'] as String?,
      draftDate: json['draft_date'] != null
          ? DateTime.parse(json['draft_date'] as String)
          : null,
      commissionerRosterId: json['commissioner_roster_id'] as int?,
      userRosterId: json['user_roster_id'] as int?,
      // Season and seasonType are nested in settings
      season: settings?['season'] as String? ?? '',
      seasonType: settings?['season_type'] as String? ?? 'regular',
      settings: settings,
      scoringSettings: json['scoring_settings'] as Map<String, dynamic>?,
      rosterPositions: json['roster_positions'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert DTO to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'total_rosters': totalRosters,
      'status': status,
      'draft_type': draftType,
      'draft_date': draftDate?.toIso8601String(),
      'commissioner_roster_id': commissionerRosterId,
      'user_roster_id': userRosterId,
      'season': season,
      'season_type': seasonType,
      'settings': settings,
      'scoring_settings': scoringSettings,
      'roster_positions': rosterPositions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert DTO to domain model
  League toDomain() {
    return League(
      id: id,
      name: name,
      description: description,
      totalRosters: totalRosters,
      status: status,
      draftType: draftType,
      draftDate: draftDate,
      commissionerRosterId: commissionerRosterId,
      userRosterId: userRosterId,
      season: season,
      seasonType: seasonType,
      settings: settings,
      scoringSettings: scoringSettings,
      rosterPositions: rosterPositions,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create DTO from domain model
  factory LeagueDto.fromDomain(League league) {
    return LeagueDto(
      id: league.id,
      name: league.name,
      description: league.description,
      totalRosters: league.totalRosters,
      status: league.status,
      draftType: league.draftType,
      draftDate: league.draftDate,
      commissionerRosterId: league.commissionerRosterId,
      userRosterId: league.userRosterId,
      season: league.season,
      seasonType: league.seasonType,
      settings: league.settings,
      scoringSettings: league.scoringSettings,
      rosterPositions: league.rosterPositions,
      createdAt: league.createdAt,
      updatedAt: league.updatedAt,
    );
  }
}
