import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/app_config_provider.dart';
import '../domain/player.dart';
import '../domain/player_repository.dart';
import '../data/players_api_client.dart';
import '../data/player_repository_impl.dart';
import '../../../core/infrastructure/api_client.dart';
import '../../auth/application/auth_notifier.dart';

/// Provider for PlayerRepository
final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);

  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);
  final playersApiClient = PlayersApiClient(
    apiClient: apiClient,
    storage: storage,
  );

  return PlayerRepositoryImpl(apiClient: playersApiClient);
});

/// State for player search
class PlayerSearchState {
  final List<Player> players;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedPosition;
  final String? selectedTeam;

  const PlayerSearchState({
    this.players = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedPosition,
    this.selectedTeam,
  });

  PlayerSearchState copyWith({
    List<Player>? players,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedPosition,
    String? selectedTeam,
  }) {
    return PlayerSearchState(
      players: players ?? this.players,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedPosition: selectedPosition ?? this.selectedPosition,
      selectedTeam: selectedTeam ?? this.selectedTeam,
    );
  }
}

/// Notifier for managing player search state
class PlayerSearchNotifier extends StateNotifier<PlayerSearchState> {
  final PlayerRepository _playerRepository;

  PlayerSearchNotifier(this._playerRepository) : super(const PlayerSearchState());

  /// Search players with current filters
  Future<void> searchPlayers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final filters = PlayerFilters(
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        position: state.selectedPosition,
        team: state.selectedTeam,
        limit: 100, // Limit results for performance
      );

      final players = await _playerRepository.searchPlayers(filters);
      state = state.copyWith(players: players, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Load all active players
  Future<void> loadActivePlayers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final players = await _playerRepository.getActivePlayers();
      state = state.copyWith(players: players, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update selected position filter
  void updatePositionFilter(String? position) {
    state = state.copyWith(selectedPosition: position);
    searchPlayers(); // Auto-search when filter changes
  }

  /// Update selected team filter
  void updateTeamFilter(String? team) {
    state = state.copyWith(selectedTeam: team);
    searchPlayers(); // Auto-search when filter changes
  }

  /// Clear all filters
  void clearFilters() {
    state = const PlayerSearchState();
  }
}

/// Provider for player search state
final playerSearchProvider =
    StateNotifierProvider<PlayerSearchNotifier, PlayerSearchState>((ref) {
  final repository = ref.watch(playerRepositoryProvider);
  return PlayerSearchNotifier(repository);
});
