import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/leagues_repository.dart';
import '../domain/league.dart';
import '../domain/repositories/leagues_repository_interface.dart';

/// Provider for the leagues repository
/// Uses abstract interface for better decoupling
final leaguesRepositoryProvider = Provider<ILeaguesRepository>((ref) {
  return LeaguesRepository();
});

/// Provider for fetching user's leagues
/// This is an AsyncNotifierProvider that manages loading, data, and error states
final myLeaguesProvider = AsyncNotifierProvider<MyLeaguesNotifier, List<League>>(() {
  return MyLeaguesNotifier();
});

class MyLeaguesNotifier extends AsyncNotifier<List<League>> {
  @override
  Future<List<League>> build() async {
    // Initial load of leagues
    return _fetchLeagues();
  }

  Future<List<League>> _fetchLeagues() async {
    final repository = ref.read(leaguesRepositoryProvider);
    return await repository.getMyLeagues();
  }

  /// Refresh the leagues list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchLeagues());
  }

  /// Create a new league and add it to the list
  Future<void> addLeague({
    required String name,
    required String season,
    required int totalRosters,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> scoringSettings,
    required Map<String, int> rosterPositions,
    required String seasonType,
  }) async {
    final repository = ref.read(leaguesRepositoryProvider);

    // Create the league via API
    final newLeague = await repository.createLeague(
      name: name,
      season: season,
      totalRosters: totalRosters,
      settings: settings,
      scoringSettings: scoringSettings,
      rosterPositions: rosterPositions,
      seasonType: seasonType,
    );

    // Add to local state
    state.whenData((leagues) {
      state = AsyncValue.data([newLeague, ...leagues]);
    });
  }

  /// Update an existing league
  Future<void> updateLeague(
    int id, {
    String? name,
    String? description,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? scoringSettings,
    Map<String, dynamic>? rosterPositions,
  }) async {
    final repository = ref.read(leaguesRepositoryProvider);

    // Update the league via API
    final updatedLeague = await repository.updateLeague(
      id: id,
      name: name,
      description: description,
      settings: settings,
      scoringSettings: scoringSettings,
      rosterPositions: rosterPositions,
    );

    // Update local state
    state.whenData((leagues) {
      final updatedLeagues = leagues.map((league) {
        return league.id == id ? updatedLeague : league;
      }).toList();
      state = AsyncValue.data(updatedLeagues);
    });
  }
}
