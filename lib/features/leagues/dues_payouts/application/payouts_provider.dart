import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/payout.dart';
import '../../application/leagues_provider.dart';

/// Provider for league payouts
/// Family provider that takes leagueId as parameter
final payoutsProvider =
    AsyncNotifierProvider.family<PayoutsNotifier, List<Payout>, int>(
  () => PayoutsNotifier(),
);

class PayoutsNotifier extends FamilyAsyncNotifier<List<Payout>, int> {
  @override
  Future<List<Payout>> build(int arg) async {
    final repository = ref.read(leaguesRepositoryProvider);
    return repository.getPayouts(arg);
  }

  /// Add a new payout
  Future<void> addPayout({
    required PayoutType type,
    required int place,
    required double amount,
  }) async {
    final repository = ref.read(leaguesRepositoryProvider);
    final leagueId = arg;

    try {
      final newPayout = await repository.addPayout(
        leagueId,
        type: type,
        place: place,
        amount: amount,
      );

      // Update state with new payout
      state = AsyncValue.data([...state.value ?? [], newPayout]);
    } catch (e) {
      // Refetch on error
      state = await AsyncValue.guard(() async {
        return repository.getPayouts(leagueId);
      });
      rethrow;
    }
  }

  /// Update an existing payout
  Future<void> updatePayout(
    String payoutId, {
    PayoutType? type,
    int? place,
    double? amount,
  }) async {
    final repository = ref.read(leaguesRepositoryProvider);
    final leagueId = arg;

    // Optimistically update UI
    state = AsyncValue.data(
      state.value?.map((payout) {
            if (payout.id == payoutId) {
              return payout.copyWith(
                type: type ?? payout.type,
                place: place ?? payout.place,
                amount: amount ?? payout.amount,
              );
            }
            return payout;
          }).toList() ??
          [],
    );

    try {
      await repository.updatePayout(
        leagueId,
        payoutId,
        type: type,
        place: place,
        amount: amount,
      );
    } catch (e) {
      // Revert on error by refetching
      state = await AsyncValue.guard(() async {
        return repository.getPayouts(leagueId);
      });
      rethrow;
    }
  }

  /// Delete a payout
  Future<void> deletePayout(String payoutId) async {
    final repository = ref.read(leaguesRepositoryProvider);
    final leagueId = arg;

    // Optimistically remove from UI
    final originalState = state.value ?? [];
    state = AsyncValue.data(
      originalState.where((p) => p.id != payoutId).toList(),
    );

    try {
      await repository.deletePayout(leagueId, payoutId);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(originalState);
      rethrow;
    }
  }

  /// Refresh payouts from server
  Future<void> refresh() async {
    final repository = ref.read(leaguesRepositoryProvider);
    state = await AsyncValue.guard(() async {
      return repository.getPayouts(arg);
    });
  }
}
