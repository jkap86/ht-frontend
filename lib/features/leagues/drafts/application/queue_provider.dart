import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/queue_state.dart';
import 'queue_notifier.dart';
import 'drafts_provider.dart';

/// Provider for queue state
/// Takes leagueId and draftId as parameters
final queueProvider = StateNotifierProvider.family<QueueNotifier,
    QueueState, ({int leagueId, int draftId})>(
  (ref, params) {
    final apiClient = ref.watch(draftsApiClientProvider);

    return QueueNotifier(
      apiClient: apiClient,
      leagueId: params.leagueId,
      draftId: params.draftId,
    );
  },
);
