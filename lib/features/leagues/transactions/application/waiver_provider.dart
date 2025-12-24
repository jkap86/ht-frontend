import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_config_provider.dart';
import '../../../../core/infrastructure/api_client.dart';
import '../data/waiver_api_client.dart';
import '../../../auth/application/auth_notifier.dart';
import '../domain/waiver_claim.dart';

/// Provider for the WaiverApiClient
final waiverApiClientProvider = Provider<WaiverApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);
  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);
  return WaiverApiClient(apiClient: apiClient, storage: storage);
});

/// Provider for fetching waiver claims for a specific league
final leagueWaiversProvider = FutureProvider.family<List<WaiverClaim>, int>(
  (ref, leagueId) async {
    final apiClient = ref.watch(waiverApiClientProvider);
    return await apiClient.getWaiverClaims(leagueId);
  },
);

/// Provider for fetching available players for a specific league
final availablePlayersProvider = FutureProvider.family<List<AvailablePlayer>, int>(
  (ref, leagueId) async {
    final apiClient = ref.watch(waiverApiClientProvider);
    return await apiClient.getAvailablePlayers(leagueId);
  },
);

/// Provider for fetching transaction history for a specific league
final transactionHistoryProvider = FutureProvider.family<List<RosterTransaction>, ({int leagueId, int? limit})>(
  (ref, params) async {
    final apiClient = ref.watch(waiverApiClientProvider);
    return await apiClient.getTransactionHistory(params.leagueId, limit: params.limit);
  },
);

/// Notifier for managing waiver operations
class WaiversNotifier extends StateNotifier<AsyncValue<List<WaiverClaim>>> {
  final WaiverApiClient _apiClient;
  final int _leagueId;

  WaiversNotifier(this._apiClient, this._leagueId) : super(const AsyncValue.loading()) {
    _loadWaivers();
  }

  Future<void> _loadWaivers() async {
    state = const AsyncValue.loading();
    try {
      final waivers = await _apiClient.getWaiverClaims(_leagueId);
      state = AsyncValue.data(waivers);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<WaiverClaim> submitClaim(SubmitClaimRequest request) async {
    try {
      final claim = await _apiClient.submitClaim(_leagueId, request);
      await _loadWaivers();
      return claim;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> cancelClaim(int claimId) async {
    try {
      await _apiClient.cancelClaim(_leagueId, claimId);
      await _loadWaivers();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadWaivers();
  }
}

/// Provider for the WaiversNotifier
final waiversNotifierProvider = StateNotifierProvider.family<WaiversNotifier, AsyncValue<List<WaiverClaim>>, int>(
  (ref, leagueId) {
    final apiClient = ref.watch(waiverApiClientProvider);
    return WaiversNotifier(apiClient, leagueId);
  },
);

/// Notifier for managing free agent operations
class FreeAgentsNotifier extends StateNotifier<AsyncValue<List<AvailablePlayer>>> {
  final WaiverApiClient _apiClient;
  final int _leagueId;

  FreeAgentsNotifier(this._apiClient, this._leagueId) : super(const AsyncValue.loading()) {
    _loadFreeAgents();
  }

  Future<void> _loadFreeAgents() async {
    state = const AsyncValue.loading();
    try {
      final players = await _apiClient.getAvailablePlayers(_leagueId);
      state = AsyncValue.data(players);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addFreeAgent(int playerId, {int? dropPlayerId}) async {
    try {
      await _apiClient.addFreeAgent(_leagueId, playerId, dropPlayerId: dropPlayerId);
      await _loadFreeAgents();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadFreeAgents();
  }
}

/// Provider for the FreeAgentsNotifier
final freeAgentsNotifierProvider = StateNotifierProvider.family<FreeAgentsNotifier, AsyncValue<List<AvailablePlayer>>, int>(
  (ref, leagueId) {
    final apiClient = ref.watch(waiverApiClientProvider);
    return FreeAgentsNotifier(apiClient, leagueId);
  },
);
