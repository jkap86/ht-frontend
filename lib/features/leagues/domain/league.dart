/// Pure domain model for a fantasy football league
/// Contains only business logic, no serialization concerns
class League {
  final int id;
  final String name;
  final String? description;
  final int totalRosters;
  final String status;
  final String? draftType;
  final DateTime? draftDate;
  final int? commissionerRosterId;
  final int? userRosterId; // Current user's roster_id in this league
  final String season;
  final String seasonType;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? scoringSettings;
  final Map<String, dynamic>? rosterPositions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const League({
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

  /// Check if current user is the commissioner
  bool get isCommissioner {
    if (commissionerRosterId == null || userRosterId == null) {
      return false;
    }
    return commissionerRosterId == userRosterId;
  }

  League copyWith({
    int? id,
    String? name,
    String? description,
    int? totalRosters,
    String? status,
    String? draftType,
    DateTime? draftDate,
    int? commissionerRosterId,
    int? userRosterId,
    String? season,
    String? seasonType,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    Map<String, dynamic>? rosterPositions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return League(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalRosters: totalRosters ?? this.totalRosters,
      status: status ?? this.status,
      draftType: draftType ?? this.draftType,
      draftDate: draftDate ?? this.draftDate,
      commissionerRosterId: commissionerRosterId ?? this.commissionerRosterId,
      userRosterId: userRosterId ?? this.userRosterId,
      season: season ?? this.season,
      seasonType: seasonType ?? this.seasonType,
      settings: settings ?? this.settings,
      scoringSettings: scoringSettings ?? this.scoringSettings,
      rosterPositions: rosterPositions ?? this.rosterPositions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is League &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.totalRosters == totalRosters &&
        other.status == status &&
        other.draftType == draftType &&
        other.draftDate == draftDate &&
        other.commissionerRosterId == commissionerRosterId &&
        other.userRosterId == userRosterId &&
        other.season == season &&
        other.seasonType == seasonType &&
        _mapsEqual(other.settings, settings) &&
        _mapsEqual(other.scoringSettings, scoringSettings) &&
        _mapsEqual(other.rosterPositions, rosterPositions);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      totalRosters,
      status,
      draftType,
      draftDate,
      commissionerRosterId,
      userRosterId,
      season,
      seasonType,
    );
  }

  /// Helper method to compare maps for equality
  static bool _mapsEqual(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
