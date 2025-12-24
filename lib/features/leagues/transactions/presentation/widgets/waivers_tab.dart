import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/waiver_provider.dart';
import '../../domain/waiver_claim.dart';
import 'waiver_claim_card.dart';

class WaiversTab extends ConsumerWidget {
  final int leagueId;
  final int? userRosterId;

  const WaiversTab({
    super.key,
    required this.leagueId,
    this.userRosterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waiversAsync = ref.watch(waiversNotifierProvider(leagueId));

    return waiversAsync.when(
      data: (claims) {
        if (claims.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  'No pending waiver claims',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Submit claims from the Free Agents tab',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        // Sort claims: user's claims first, then by priority/faab amount
        final sortedClaims = List<WaiverClaim>.from(claims)
          ..sort((a, b) {
            // User's claims first
            if (a.rosterId == userRosterId && b.rosterId != userRosterId) return -1;
            if (a.rosterId != userRosterId && b.rosterId == userRosterId) return 1;
            // Then by FAAB amount (higher first) or priority (lower first)
            if (a.faabAmount != b.faabAmount) {
              return b.faabAmount.compareTo(a.faabAmount);
            }
            if (a.priority != null && b.priority != null) {
              return a.priority!.compareTo(b.priority!);
            }
            return a.createdAt.compareTo(b.createdAt);
          });

        return RefreshIndicator(
          onRefresh: () => ref.read(waiversNotifierProvider(leagueId).notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sortedClaims.length,
            itemBuilder: (context, index) {
              final claim = sortedClaims[index];
              return WaiverClaimCard(
                claim: claim,
                leagueId: leagueId,
                isOwner: claim.rosterId == userRosterId,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text('Error: $error'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.invalidate(waiversNotifierProvider(leagueId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
