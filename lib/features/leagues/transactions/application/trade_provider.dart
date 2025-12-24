import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_config_provider.dart';
import '../../../../core/infrastructure/api_client.dart';
import '../data/trade_api_client.dart';
import '../../../auth/application/auth_notifier.dart';
import '../domain/trade.dart';

/// Provider for the TradeApiClient
final tradeApiClientProvider = Provider<TradeApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(authStorageProvider);
  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);
  return TradeApiClient(apiClient: apiClient, storage: storage);
});

/// Provider for fetching all trades for a specific league
final leagueTradesProvider = FutureProvider.family<List<Trade>, int>(
  (ref, leagueId) async {
    final apiClient = ref.watch(tradeApiClientProvider);
    return await apiClient.getTrades(leagueId);
  },
);

/// Provider for fetching pending trades for a specific league
final pendingTradesProvider = FutureProvider.family<List<Trade>, int>(
  (ref, leagueId) async {
    final apiClient = ref.watch(tradeApiClientProvider);
    return await apiClient.getTrades(leagueId, status: 'pending');
  },
);

/// Provider for fetching a specific trade
final tradeByIdProvider = FutureProvider.family<Trade, ({int leagueId, int tradeId})>(
  (ref, params) async {
    final apiClient = ref.watch(tradeApiClientProvider);
    return await apiClient.getTradeById(params.leagueId, params.tradeId);
  },
);

/// Notifier for managing trade operations
class TradesNotifier extends StateNotifier<AsyncValue<List<Trade>>> {
  final TradeApiClient _apiClient;
  final int _leagueId;

  TradesNotifier(this._apiClient, this._leagueId) : super(const AsyncValue.loading()) {
    _loadTrades();
  }

  Future<void> _loadTrades() async {
    state = const AsyncValue.loading();
    try {
      final trades = await _apiClient.getTrades(_leagueId);
      state = AsyncValue.data(trades);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<Trade> proposeTrade(ProposeTradeRequest request) async {
    try {
      final trade = await _apiClient.proposeTrade(_leagueId, request);
      await _loadTrades();
      return trade;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<Trade> acceptTrade(int tradeId) async {
    try {
      final trade = await _apiClient.acceptTrade(_leagueId, tradeId);
      await _loadTrades();
      return trade;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<Trade> rejectTrade(int tradeId) async {
    try {
      final trade = await _apiClient.rejectTrade(_leagueId, tradeId);
      await _loadTrades();
      return trade;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<Trade> cancelTrade(int tradeId) async {
    try {
      final trade = await _apiClient.cancelTrade(_leagueId, tradeId);
      await _loadTrades();
      return trade;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<Trade> vetoTrade(int tradeId) async {
    try {
      final trade = await _apiClient.vetoTrade(_leagueId, tradeId);
      await _loadTrades();
      return trade;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadTrades();
  }
}

/// Provider for the TradesNotifier
final tradesNotifierProvider = StateNotifierProvider.family<TradesNotifier, AsyncValue<List<Trade>>, int>(
  (ref, leagueId) {
    final apiClient = ref.watch(tradeApiClientProvider);
    return TradesNotifier(apiClient, leagueId);
  },
);
