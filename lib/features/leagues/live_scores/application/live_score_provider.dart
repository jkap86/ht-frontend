import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/socket/socket_providers.dart';

/// Total game seconds (60 minutes)
const int totalGameSeconds = 3600;

/// Live player stat received from WebSocket
class LivePlayerStat {
  final int playerId;
  final String playerName;
  final String playerPosition;
  final String playerTeam;
  final int rosterId;
  final double actualPts;
  final double? projectedPts;
  final String gameStatus;
  final int? gameSecondsRemaining;
  final bool isStarter;

  LivePlayerStat({
    required this.playerId,
    required this.playerName,
    required this.playerPosition,
    required this.playerTeam,
    required this.rosterId,
    required this.actualPts,
    this.projectedPts,
    required this.gameStatus,
    this.gameSecondsRemaining,
    required this.isStarter,
  });

  factory LivePlayerStat.fromJson(Map<String, dynamic> json) {
    return LivePlayerStat(
      playerId: json['playerId'] as int,
      playerName: json['playerName'] as String? ?? 'Unknown',
      playerPosition: json['playerPosition'] as String? ?? '',
      playerTeam: json['playerTeam'] as String? ?? '',
      rosterId: json['rosterId'] as int,
      actualPts: (json['actualPts'] as num?)?.toDouble() ?? 0,
      projectedPts: (json['projectedPts'] as num?)?.toDouble(),
      gameStatus: json['gameStatus'] as String? ?? 'pre_game',
      gameSecondsRemaining: json['gameSecondsRemaining'] as int?,
      isStarter: json['isStarter'] as bool? ?? false,
    );
  }

  /// Calculate pace-based projection
  /// Formula: if in_progress, projection = actual / (elapsed / total)
  /// If game hasn't started, use original projection
  /// If game is complete, use actual points
  double get paceProjection {
    if (gameStatus == 'complete') return actualPts;
    if (gameStatus == 'pre_game') return projectedPts ?? 0;

    final remaining = gameSecondsRemaining ?? totalGameSeconds;
    final elapsed = totalGameSeconds - remaining;

    // Avoid division by zero - if no time has elapsed, use original projection
    if (elapsed <= 0) return projectedPts ?? 0;

    // Pace projection = current points extrapolated to full game
    return actualPts * totalGameSeconds / elapsed;
  }
}

/// Live game status
class LiveGameStatus {
  final String gameId;
  final String status;
  final String? homeTeam;
  final String? awayTeam;
  final int? homeScore;
  final int? awayScore;
  final int? quarter;
  final String? timeRemaining;
  final int? secondsRemaining;

  LiveGameStatus({
    required this.gameId,
    required this.status,
    this.homeTeam,
    this.awayTeam,
    this.homeScore,
    this.awayScore,
    this.quarter,
    this.timeRemaining,
    this.secondsRemaining,
  });

  factory LiveGameStatus.fromJson(Map<String, dynamic> json) {
    return LiveGameStatus(
      gameId: json['game_id'] as String? ?? '',
      status: json['status'] as String? ?? 'pre_game',
      homeTeam: json['home_team'] as String?,
      awayTeam: json['away_team'] as String?,
      homeScore: json['home_score'] as int?,
      awayScore: json['away_score'] as int?,
      quarter: json['quarter'] as int?,
      timeRemaining: json['time_remaining'] as String?,
      secondsRemaining: json['seconds_remaining'] as int?,
    );
  }
}

/// State for live scores
class LiveScoreState {
  final Map<int, LivePlayerStat> playerStats; // keyed by playerId
  final Map<String, LiveGameStatus> gameStatus; // keyed by team
  final DateTime? lastUpdated;
  final bool isConnected;

  LiveScoreState({
    this.playerStats = const {},
    this.gameStatus = const {},
    this.lastUpdated,
    this.isConnected = false,
  });

  LiveScoreState copyWith({
    Map<int, LivePlayerStat>? playerStats,
    Map<String, LiveGameStatus>? gameStatus,
    DateTime? lastUpdated,
    bool? isConnected,
  }) {
    return LiveScoreState(
      playerStats: playerStats ?? this.playerStats,
      gameStatus: gameStatus ?? this.gameStatus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  /// Get total pace projection for a roster (starters only)
  double getRosterPaceProjection(int rosterId) {
    return playerStats.values
        .where((p) => p.rosterId == rosterId && p.isStarter)
        .fold(0.0, (sum, p) => sum + p.paceProjection);
  }

  /// Get total actual points for a roster (starters only)
  double getRosterActualPoints(int rosterId) {
    return playerStats.values
        .where((p) => p.rosterId == rosterId && p.isStarter)
        .fold(0.0, (sum, p) => sum + p.actualPts);
  }
}

/// Notifier for live scores in a league
class LiveScoreNotifier extends StateNotifier<LiveScoreState> {
  final Ref _ref;
  final int leagueId;
  VoidCallback? _playerStatsListener;
  VoidCallback? _gameStatusListener;

  LiveScoreNotifier(this._ref, this.leagueId) : super(LiveScoreState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final socket = _ref.read(socketServiceProvider);

    // Join the league room
    final roomName = 'league_$leagueId';
    await socket.joinRoom(roomName);

    // Listen for player stats updates
    _playerStatsListener = socket.on('live_player_stats', (data) {
      if (data == null) return;
      _handlePlayerStatsUpdate(data as Map<String, dynamic>);
    });

    // Listen for game status updates
    _gameStatusListener = socket.on('live_game_status', (data) {
      if (data == null) return;
      _handleGameStatusUpdate(data as Map<String, dynamic>);
    });

    state = state.copyWith(isConnected: socket.isConnected);
  }

  void _handlePlayerStatsUpdate(Map<String, dynamic> data) {
    final leagueIdFromData = data['league_id'] as int?;
    if (leagueIdFromData != leagueId) return;

    final players = (data['players'] as List<dynamic>?)
            ?.map((p) => LivePlayerStat.fromJson(p as Map<String, dynamic>))
            .toList() ??
        [];

    final newStats = <int, LivePlayerStat>{};
    for (final player in players) {
      newStats[player.playerId] = player;
    }

    state = state.copyWith(
      playerStats: newStats,
      lastUpdated: DateTime.now(),
    );
  }

  void _handleGameStatusUpdate(Map<String, dynamic> data) {
    final games = (data['games'] as List<dynamic>?)
            ?.map((g) => LiveGameStatus.fromJson(g as Map<String, dynamic>))
            .toList() ??
        [];

    final newGameStatus = <String, LiveGameStatus>{};
    for (final game in games) {
      if (game.homeTeam != null) newGameStatus[game.homeTeam!] = game;
      if (game.awayTeam != null) newGameStatus[game.awayTeam!] = game;
    }

    state = state.copyWith(
      gameStatus: {...state.gameStatus, ...newGameStatus},
      lastUpdated: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _playerStatsListener?.call();
    _gameStatusListener?.call();

    final socket = _ref.read(socketServiceProvider);
    socket.leaveRoom('league_$leagueId');

    super.dispose();
  }
}

/// Provider for live scores in a specific league
final liveScoreProvider =
    StateNotifierProvider.family<LiveScoreNotifier, LiveScoreState, int>(
  (ref, leagueId) => LiveScoreNotifier(ref, leagueId),
);

/// Helper typedef for VoidCallback
typedef VoidCallback = void Function();
