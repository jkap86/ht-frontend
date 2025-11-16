// Domain model for a fantasy football league
class League {
  final int id;
  final String name;
  final String status;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? scoringSettings;
  final String season;
  final String seasonType;
  final Map<String, dynamic>? rosterPositions;
  final int totalRosters;
  final DateTime createdAt;
  final DateTime updatedAt;

  const League({
    required this.id,
    required this.name,
    required this.status,
    this.settings,
    this.scoringSettings,
    required this.season,
    required this.seasonType,
    this.rosterPositions,
    required this.totalRosters,
    required this.createdAt,
    required this.updatedAt,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String? ?? 'pre_draft',
      settings: json['settings'] as Map<String, dynamic>?,
      scoringSettings: json['scoring_settings'] as Map<String, dynamic>?,
      season: json['season'] as String,
      seasonType: json['season_type'] as String? ?? 'regular',
      rosterPositions: json['roster_positions'] as Map<String, dynamic>?,
      totalRosters: json['total_rosters'] as int? ?? 12,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'settings': settings,
      'scoring_settings': scoringSettings,
      'season': season,
      'season_type': seasonType,
      'roster_positions': rosterPositions,
      'total_rosters': totalRosters,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  League copyWith({
    int? id,
    String? name,
    String? status,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    String? season,
    String? seasonType,
    Map<String, dynamic>? rosterPositions,
    int? totalRosters,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return League(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      settings: settings ?? this.settings,
      scoringSettings: scoringSettings ?? this.scoringSettings,
      season: season ?? this.season,
      seasonType: seasonType ?? this.seasonType,
      rosterPositions: rosterPositions ?? this.rosterPositions,
      totalRosters: totalRosters ?? this.totalRosters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
