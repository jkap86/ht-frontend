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
    this.settings,
    this.scoringSettings,
    this.rosterPositions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert JSON from API to DTO
  factory LeagueDto.fromJson(Map<String, dynamic> json) {
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
      settings: json['settings'] as Map<String, dynamic>?,
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
      settings: league.settings,
      scoringSettings: league.scoringSettings,
      rosterPositions: league.rosterPositions,
      createdAt: league.createdAt,
      updatedAt: league.updatedAt,
    );
  }
}
