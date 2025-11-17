/// Domain model for league creation form data
/// Immutable value object representing all league creation settings
class LeagueCreationData {
  // Basic Settings
  final String name;
  final String season;
  final bool isPublic;
  final int totalRosters;
  final String seasonType;

  // Schedule Settings
  final int startWeek;
  final int endWeek;
  final bool playoffsEnabled;
  final int playoffWeekStart;
  final int playoffTeams;
  final String matchupType;

  // Scoring Settings
  final Map<String, double> scoringSettings;

  // Roster Positions
  final Map<String, int> rosterPositions;

  // Waiver Settings
  final String waiverType;
  final int faabBudget;
  final int waiverPeriodDays;
  final String processSchedule;

  // Trade Settings
  final String tradeNotificationSetting;
  final String tradeDetailsSetting;

  // Dues/Payouts
  final double entryFee;
  final List<Map<String, dynamic>> payoutStructure;

  // Draft Settings - stored as list of draft configurations
  final List<Map<String, dynamic>> draftConfigurations;

  const LeagueCreationData({
    required this.name,
    required this.season,
    required this.isPublic,
    required this.totalRosters,
    required this.seasonType,
    required this.startWeek,
    required this.endWeek,
    required this.playoffsEnabled,
    required this.playoffWeekStart,
    required this.playoffTeams,
    required this.matchupType,
    required this.scoringSettings,
    required this.rosterPositions,
    required this.waiverType,
    required this.faabBudget,
    required this.waiverPeriodDays,
    required this.processSchedule,
    required this.tradeNotificationSetting,
    required this.tradeDetailsSetting,
    required this.entryFee,
    required this.payoutStructure,
    required this.draftConfigurations,
  });

  /// Create settings map for API
  Map<String, dynamic> toSettingsMap() {
    return {
      'is_public': isPublic,
      'start_week': startWeek,
      'end_week': endWeek,
      'season': season,
      'season_type': seasonType,
      'playoffs_enabled': playoffsEnabled,
      'playoff_week_start': playoffWeekStart,
      'playoff_teams': playoffTeams,
      'matchup_type': matchupType,
      'waiver_type': waiverType,
      'faab_budget': faabBudget,
      'waiver_period_days': waiverPeriodDays,
      'waiver_process_schedule': processSchedule,
      'trade_notification_setting': tradeNotificationSetting,
      'trade_details_setting': tradeDetailsSetting,
      'dues': entryFee,
      'payout_structure': payoutStructure,
    };
  }

  /// Create default instance with sensible defaults
  factory LeagueCreationData.defaults() {
    return LeagueCreationData(
      name: '',
      season: DateTime.now().year.toString(),
      isPublic: false,
      totalRosters: 12,
      seasonType: 'regular',
      startWeek: 1,
      endWeek: 17,
      playoffsEnabled: true,
      playoffWeekStart: 15,
      playoffTeams: 4,
      matchupType: 'head_to_head',
      scoringSettings: {
        'passing_touchdowns': 4.0,
        'passing_yards': 0.04,
        'rushing_touchdowns': 6.0,
        'rushing_yards': 0.1,
        'receiving_touchdowns': 6.0,
        'receiving_yards': 0.1,
        'receiving_receptions': 1.0,
      },
      rosterPositions: {
        'QB': 1,
        'RB': 2,
        'WR': 2,
        'TE': 1,
        'FLEX': 1,
        'SUPER_FLEX': 0,
        'K': 1,
        'DEF': 1,
        'BN': 6,
      },
      waiverType: 'faab',
      faabBudget: 100,
      waiverPeriodDays: 2,
      processSchedule: 'daily',
      tradeNotificationSetting: 'proposer_choice',
      tradeDetailsSetting: 'proposer_choice',
      entryFee: 0.0,
      payoutStructure: [],
      draftConfigurations: [],
    );
  }

  LeagueCreationData copyWith({
    String? name,
    String? season,
    bool? isPublic,
    int? totalRosters,
    String? seasonType,
    int? startWeek,
    int? endWeek,
    bool? playoffsEnabled,
    int? playoffWeekStart,
    int? playoffTeams,
    String? matchupType,
    Map<String, double>? scoringSettings,
    Map<String, int>? rosterPositions,
    String? waiverType,
    int? faabBudget,
    int? waiverPeriodDays,
    String? processSchedule,
    String? tradeNotificationSetting,
    String? tradeDetailsSetting,
    double? entryFee,
    List<Map<String, dynamic>>? payoutStructure,
    List<Map<String, dynamic>>? draftConfigurations,
  }) {
    return LeagueCreationData(
      name: name ?? this.name,
      season: season ?? this.season,
      isPublic: isPublic ?? this.isPublic,
      totalRosters: totalRosters ?? this.totalRosters,
      seasonType: seasonType ?? this.seasonType,
      startWeek: startWeek ?? this.startWeek,
      endWeek: endWeek ?? this.endWeek,
      playoffsEnabled: playoffsEnabled ?? this.playoffsEnabled,
      playoffWeekStart: playoffWeekStart ?? this.playoffWeekStart,
      playoffTeams: playoffTeams ?? this.playoffTeams,
      matchupType: matchupType ?? this.matchupType,
      scoringSettings: scoringSettings ?? this.scoringSettings,
      rosterPositions: rosterPositions ?? this.rosterPositions,
      waiverType: waiverType ?? this.waiverType,
      faabBudget: faabBudget ?? this.faabBudget,
      waiverPeriodDays: waiverPeriodDays ?? this.waiverPeriodDays,
      processSchedule: processSchedule ?? this.processSchedule,
      tradeNotificationSetting: tradeNotificationSetting ?? this.tradeNotificationSetting,
      tradeDetailsSetting: tradeDetailsSetting ?? this.tradeDetailsSetting,
      entryFee: entryFee ?? this.entryFee,
      payoutStructure: payoutStructure ?? this.payoutStructure,
      draftConfigurations: draftConfigurations ?? this.draftConfigurations,
    );
  }
}
