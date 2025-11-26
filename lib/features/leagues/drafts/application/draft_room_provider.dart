import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/draft_room_state.dart';
import '../domain/draft.dart';
import 'draft_room_notifier.dart';
import 'drafts_provider.dart';
import '../../../../core/services/socket/socket_providers.dart';

/// Provider for draft room state
/// Takes leagueId and draftId as parameters
final draftRoomProvider = StateNotifierProvider.family<DraftRoomNotifier,
    DraftRoomState, ({int leagueId, int draftId, Draft draft})>(
  (ref, params) {
    final apiClient = ref.watch(draftsApiClientProvider);
    final socketService = ref.watch(socketServiceProvider);

    return DraftRoomNotifier(
      apiClient: apiClient,
      socketService: socketService,
      leagueId: params.leagueId,
      draftId: params.draftId,
      initialDraft: params.draft,
    );
  },
);
