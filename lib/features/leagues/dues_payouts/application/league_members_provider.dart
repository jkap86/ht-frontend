import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league_member.dart';
import '../../application/leagues_provider.dart';

/// Provider for league members with payment status
/// Family provider that takes leagueId as parameter
final leagueMembersProvider =
    AsyncNotifierProvider.family<LeagueMembersNotifier, List<LeagueMember>, int>(
  () => LeagueMembersNotifier(),
);

class LeagueMembersNotifier extends FamilyAsyncNotifier<List<LeagueMember>, int> {
  @override
  Future<List<LeagueMember>> build(int arg) async {
    final repository = ref.read(leaguesRepositoryProvider);
    return repository.getLeagueMembers(arg);
  }

  /// Toggle a member's payment status
  Future<void> togglePaymentStatus(int rosterId, bool paid) async {
    final repository = ref.read(leaguesRepositoryProvider);
    final leagueId = arg;

    // Optimistically update the UI
    state = AsyncValue.data(
      state.value?.map((member) {
            if (member.rosterId == rosterId) {
              return member.copyWith(paid: paid);
            }
            return member;
          }).toList() ??
          [],
    );

    try {
      // Update on the backend
      await repository.toggleMemberPayment(leagueId, rosterId, paid);
    } catch (e) {
      // Revert on error by refetching
      state = await AsyncValue.guard(() async {
        return repository.getLeagueMembers(leagueId);
      });
      rethrow;
    }
  }
}
