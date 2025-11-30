import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/matchup_drafts_api_client.dart';
import '../domain/matchup_draft_room_state.dart';
import '../../drafts/domain/draft.dart';
import '../domain/matchup_draft_pick.dart';
import '../domain/available_matchup.dart';
import '../../drafts/domain/draft_order_entry.dart';
import '../../../../core/services/socket/socket_service.dart';

class MatchupDraftRoomNotifier extends StateNotifier<MatchupDraftRoomState> {
  final MatchupDraftsApiClient _apiClient;
  final SocketService _socketService;
  final int _leagueId;
  final int _draftId;

  MatchupDraftRoomNotifier({
    required MatchupDraftsApiClient apiClient,
    required SocketService socketService,
    required int leagueId,
    required int draftId,
    required Draft initialDraft,
  })  : _apiClient = apiClient,
        _socketService = socketService,
        _leagueId = leagueId,
        _draftId = draftId,
        super(MatchupDraftRoomState(draft: initialDraft)) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadDraftRoom();
    _setupSocketListeners();
  }

  Future<void> _loadDraftRoom() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load all data in parallel
      final results = await Future.wait([
        _apiClient.getMatchupDraft(_leagueId, _draftId),
        _apiClient.getAvailableMatchups(_leagueId, _draftId),
        _apiClient.getMatchupDraftPicks(_leagueId, _draftId),
        _apiClient.getMatchupDraftOrder(_leagueId, _draftId),
      ]);

      final draft = results[0] as Draft;
      final matchups = results[1] as List<AvailableMatchup>;
      final picks = results[2] as List<MatchupDraftPick>;
      final draftOrder = results[3] as List<DraftOrderEntry>;

      print('Matchup draft order: ${draftOrder.length} entries');

      state = state.copyWith(
        draft: draft,
        availableMatchups: matchups,
        picks: picks,
        draftOrder: draftOrder,
        isLoading: false,
        currentPickerRosterId: draft.currentRosterId,
        pickDeadline: draft.pickDeadline,
      );
    } catch (e) {
      print('Error loading matchup draft room: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void _setupSocketListeners() {
    // Join the matchup draft room
    _socketService.joinRoom('matchup_draft_$_draftId');

    // Listen for connection status changes
    _socketService.on('connect', _handleConnectionChange);
    _socketService.on('disconnect', _handleDisconnection);

    // Listen for matchup draft events
    _socketService.on('matchup_draft_event', _handleMatchupDraftEvent);

    // Set initial connection status
    state = state.copyWith(isConnected: _socketService.isConnected);
  }

  void _handleMatchupDraftEvent(dynamic data) {
    if (data is! Map<String, dynamic>) return;

    final eventType = data['event_type'] as String?;

    switch (eventType) {
      case 'matchup_draft_started':
        _handleDraftStarted(data);
        break;
      case 'matchup_pick_made':
        _handlePickMade(data);
        break;
      case 'matchup_picker_changed':
        _handlePickerChanged(data);
        break;
      case 'matchup_draft_paused':
        _handleDraftPaused(data);
        break;
      case 'matchup_draft_resumed':
        _handleDraftResumed(data);
        break;
      case 'matchup_draft_completed':
        _handleDraftCompleted(data);
        break;
    }
  }

  void _handlePickMade(Map<String, dynamic> data) {
    final pickData = data['pick'] as Map<String, dynamic>?;
    if (pickData == null) return;

    final pick = MatchupDraftPick.fromJson(pickData);

    // Add pick to list
    final updatedPicks = [...state.picks, pick];

    // Remove matchup from available matchups
    final updatedMatchups = state.availableMatchups
        .where((m) => !(m.opponentRosterId == pick.opponentRosterId &&
            m.weekNumber == pick.weekNumber))
        .toList();

    // Extract updated draft with new pickDeadline
    final draftData = data['draft'] as Map<String, dynamic>?;
    final updatedDraft =
        draftData != null ? Draft.fromJson(draftData) : state.draft;

    state = state.copyWith(
      picks: updatedPicks,
      availableMatchups: updatedMatchups,
      draft: updatedDraft,
      pickDeadline: updatedDraft.pickDeadline,
      currentPickerRosterId: updatedDraft.currentRosterId,
    );
  }

  void _handlePickerChanged(Map<String, dynamic> data) {
    final rosterId = data['roster_id'] as int?;
    final deadline = data['pick_deadline'] as String?;

    state = state.copyWith(
      currentPickerRosterId: rosterId,
      pickDeadline: deadline != null ? DateTime.parse(deadline) : null,
    );
  }

  void _handleDraftPaused(Map<String, dynamic> data) {
    // Capture current pickDeadline before it gets nulled
    state = state.copyWith(
      draft: state.draft.copyWith(status: 'paused'),
      pausedAtDeadline: state.pickDeadline,
    );
  }

  void _handleDraftResumed(Map<String, dynamic> data) {
    final draftData = data['draft'] as Map<String, dynamic>?;
    final updatedDraft = draftData != null
        ? Draft.fromJson(draftData)
        : state.draft.copyWith(status: 'in_progress');

    state = state.copyWith(
      draft: updatedDraft,
      pickDeadline: updatedDraft.pickDeadline,
      pausedAtDeadline: null, // Clear paused deadline when resuming
    );
  }

  void _handleDraftCompleted(Map<String, dynamic> data) {
    state = state.copyWith(
      draft: state.draft.copyWith(status: 'completed'),
    );
  }

  void _handleDraftStarted(Map<String, dynamic> data) {
    final draftData = data['draft'] as Map<String, dynamic>?;
    if (draftData == null) return;

    final updatedDraft = Draft.fromJson(draftData);
    final currentPickerData = data['current_picker'] as Map<String, dynamic>?;

    state = state.copyWith(
      draft: updatedDraft,
      currentPickerRosterId: currentPickerData?['roster_id'] as int?,
      pickDeadline: updatedDraft.pickDeadline,
    );
  }

  void _handleConnectionChange(dynamic data) {
    print('[MatchupDraftRoomNotifier] WebSocket connected');
    state = state.copyWith(isConnected: true);
  }

  void _handleDisconnection(dynamic data) {
    print('[MatchupDraftRoomNotifier] WebSocket disconnected');
    state = state.copyWith(isConnected: false);
  }

  Future<void> makeMatchupPick(int opponentRosterId, int weekNumber) async {
    if (!state.canMakePick) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final pick = await _apiClient.makeMatchupPick(
        _leagueId,
        _draftId,
        opponentRosterId,
        weekNumber,
      );

      // Optimistically update UI (will be confirmed by WebSocket event)
      final updatedPicks = [...state.picks, pick];
      final updatedMatchups = state.availableMatchups
          .where((m) => !(m.opponentRosterId == opponentRosterId &&
              m.weekNumber == weekNumber))
          .toList();

      state = state.copyWith(
        picks: updatedPicks,
        availableMatchups: updatedMatchups,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleWeekFilter(int week) {
    final filters = List<int>.from(state.weekFilters);

    if (filters.contains(week)) {
      filters.remove(week);
    } else {
      filters.add(week);
    }

    state = state.copyWith(weekFilters: filters);
  }

  void clearWeekFilters() {
    state = state.copyWith(weekFilters: []);
  }

  Future<void> startDraft() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final draft = await _apiClient.startMatchupDraft(_leagueId, _draftId);
      state = state.copyWith(
        draft: draft,
        pickDeadline: draft.pickDeadline,
        currentPickerRosterId: draft.currentRosterId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> pauseDraft() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final draft = await _apiClient.pauseMatchupDraft(_leagueId, _draftId);
      state = state.copyWith(
        draft: draft,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> resumeDraft() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final draft = await _apiClient.resumeMatchupDraft(_leagueId, _draftId);
      state = state.copyWith(
        draft: draft,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  @override
  void dispose() {
    _socketService.leaveRoom('matchup_draft_$_draftId');
    _socketService.off('matchup_draft_event');
    _socketService.off('connect');
    _socketService.off('disconnect');
    super.dispose();
  }
}
