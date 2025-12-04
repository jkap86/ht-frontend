import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_config_provider.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/application/auth_state.dart';
import '../data/leagues_api_client.dart';
import '../data/leagues_repository.dart';
import '../domain/league.dart';
import '../domain/repositories/leagues_repository_interface.dart';

/// Provider for the leagues repository
/// Uses abstract interface for better decoupling
final leaguesRepositoryProvider = Provider<ILeaguesRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);

  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);
  final leaguesApiClient = LeaguesApiClient(apiClient: apiClient, storage: storage);

  return LeaguesRepository(apiClient: leaguesApiClient);
});

/// Provider for fetching a single league by ID
final leagueByIdProvider = FutureProvider.family<League, int>((ref, leagueId) async {
  final repository = ref.watch(leaguesRepositoryProvider);
  return await repository.getLeagueById(leagueId);
});

/// Provider for fetching user's leagues
/// This is an AsyncNotifierProvider that manages loading, data, and error states
final myLeaguesProvider = AsyncNotifierProvider<MyLeaguesNotifier, List<League>>(() {
  return MyLeaguesNotifier();
});

class MyLeaguesNotifier extends AsyncNotifier<List<League>> {
  @override
  Future<List<League>> build() async {
    // Watch the auth provider so this provider rebuilds when auth changes
    final authState = ref.watch(authProvider);

    // If not authenticated, return empty list
    if (authState.status != AuthStatus.authenticated) {
      return [];
    }

    // Initial load of leagues for the authenticated user
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
  /// Returns the created league
  Future<League> addLeague({
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

    return newLeague;
  }

  /// Update an existing league
  Future<void> updateLeague(
    int id, {
    String? name,
    String? description,
    int? totalRosters,
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
      totalRosters: totalRosters,
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
