import '../league.dart';
import '../../dues_payouts/domain/league_member.dart';
import '../../dues_payouts/domain/payout.dart';

/// Abstract interface for leagues repository
/// Defines contract for data operations without implementation details
abstract class ILeaguesRepository {
  /// Fetch all leagues for the current user
  Future<List<League>> getMyLeagues();

  /// Fetch a specific league by ID
  Future<League> getLeagueById(int id);

  /// Create a new league
  Future<League> createLeague({
    required String name,
    required String season,
    required int totalRosters,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> scoringSettings,
    required Map<String, int> rosterPositions,
    required String seasonType,
  });

  /// Update an existing league
  Future<League> updateLeague({
    required int id,
    String? name,
    String? description,
    int? totalRosters,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    Map<String, dynamic>? rosterPositions,
  });

  /// Reset league - clears rosters, drafts, and matchups but preserves settings
  Future<void> resetLeague(int id);

  /// Delete league permanently
  Future<void> deleteLeague(int id);

  /// Developer endpoint to add users to league by username
  Future<List<Map<String, dynamic>>> devAddUsersToLeague(
    int leagueId,
    List<String> usernames,
  );

  /// Get league members with payment status
  Future<List<LeagueMember>> getLeagueMembers(int leagueId);

  /// Toggle member payment status
  Future<void> toggleMemberPayment(int leagueId, int rosterId, bool paid);

  // ============================================
  // Payout Management
  // ============================================

  /// Get all payouts for a league
  Future<List<Payout>> getPayouts(int leagueId);

  /// Add a new payout to a league
  Future<Payout> addPayout(int leagueId, {
    required PayoutType type,
    required int place,
    required double amount,
  });

  /// Update an existing payout
  Future<Payout> updatePayout(int leagueId, String payoutId, {
    PayoutType? type,
    int? place,
    double? amount,
  });

  /// Delete a payout
  Future<void> deletePayout(int leagueId, String payoutId);
}
