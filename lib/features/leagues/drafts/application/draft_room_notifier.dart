import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/players/player.dart';
import '../data/drafts_api_client.dart';
import '../domain/draft_room_state.dart';
import '../domain/draft.dart';
import '../domain/draft_pick.dart';
import '../domain/draft_order_entry.dart';
import '../../../../core/services/socket/socket_service.dart';

class DraftRoomNotifier extends StateNotifier<DraftRoomState> {
  final DraftsApiClient _apiClient;
  final SocketService _socketService;
  final int _leagueId;
  final int _draftId;

  DraftRoomNotifier({
    required DraftsApiClient apiClient,
    required SocketService socketService,
    required int leagueId,
    required int draftId,
    required Draft initialDraft,
  })  : _apiClient = apiClient,
        _socketService = socketService,
        _leagueId = leagueId,
        _draftId = draftId,
        super(DraftRoomState(draft: initialDraft)) {
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
        _apiClient.getDraftState(_leagueId, _draftId),
        _apiClient.getAvailablePlayers(_leagueId, _draftId),
        _apiClient.getDraftPicks(_leagueId, _draftId),
        _apiClient.getDraftOrder(_leagueId, _draftId),
      ]);

      final draft = results[0] as Draft;
      final players = results[1] as List<Player>;
      final picks = results[2] as List<DraftPick>;
      final orderData = results[3] as List<Map<String, dynamic>>;

      // Parse draft order entries
      print('Draft order raw data: $orderData');
      final draftOrder = orderData
          .map((json) => DraftOrderEntry.fromJson(json))
          .toList();
      print('Parsed draft order: ${draftOrder.length} entries');

      state = state.copyWith(
        draft: draft,
        availablePlayers: players,
        picks: picks,
        draftOrder: draftOrder,
        isLoading: false,
        currentPickerRosterId: draft.currentRosterId,
        pickDeadline: draft.pickDeadline,
      );
    } catch (e) {
      print('Error loading draft room: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void _setupSocketListeners() {
    // Join the draft room
    _socketService.joinRoom('draft_${_draftId}');

    // Listen for draft events
    _socketService.on('draft_event', _handleDraftEvent);
  }

  void _handleDraftEvent(dynamic data) {
    if (data is! Map<String, dynamic>) return;

    final eventType = data['event_type'] as String?;

    switch (eventType) {
      case 'pick_made':
        _handlePickMade(data);
        break;
      case 'picker_changed':
        _handlePickerChanged(data);
        break;
      case 'draft_paused':
        _handleDraftPaused(data);
        break;
      case 'draft_resumed':
        _handleDraftResumed(data);
        break;
      case 'draft_completed':
        _handleDraftCompleted(data);
        break;
      case 'auto_pick_occurred':
        _handleAutoPickOccurred(data);
        break;
    }
  }

  void _handlePickMade(Map<String, dynamic> data) {
    final pickData = data['pick'] as Map<String, dynamic>?;
    if (pickData == null) return;

    final pick = DraftPick.fromJson(pickData);

    // Add pick to list
    final updatedPicks = [...state.picks, pick];

    // Remove player from available players
    final updatedPlayers = state.availablePlayers
        .where((p) => p.id != pick.playerId)
        .toList();

    state = state.copyWith(
      picks: updatedPicks,
      availablePlayers: updatedPlayers,
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
    state = state.copyWith(
      draft: state.draft.copyWith(status: 'paused'),
    );
  }

  void _handleDraftResumed(Map<String, dynamic> data) {
    final deadline = data['pick_deadline'] as String?;

    state = state.copyWith(
      draft: state.draft.copyWith(status: 'in_progress'),
      pickDeadline: deadline != null ? DateTime.parse(deadline) : null,
    );
  }

  void _handleDraftCompleted(Map<String, dynamic> data) {
    state = state.copyWith(
      draft: state.draft.copyWith(status: 'completed'),
    );
  }

  void _handleAutoPickOccurred(Map<String, dynamic> data) {
    // Handle auto-pick the same way as regular pick
    _handlePickMade(data);
  }

  Future<void> makePick(int playerId) async {
    if (!state.canMakePick) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final pick = await _apiClient.makePick(_leagueId, _draftId, playerId);

      // Optimistically update UI (will be confirmed by WebSocket event)
      final updatedPicks = [...state.picks, pick];
      final updatedPlayers = state.availablePlayers
          .where((p) => p.id != playerId)
          .toList();

      state = state.copyWith(
        picks: updatedPicks,
        availablePlayers: updatedPlayers,
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

  void togglePositionFilter(String position) {
    final filters = List<String>.from(state.positionFilters);

    if (filters.contains(position)) {
      filters.remove(position);
    } else {
      filters.add(position);
    }

    state = state.copyWith(positionFilters: filters);
  }

  void clearPositionFilters() {
    state = state.copyWith(positionFilters: []);
  }

  Future<void> startDraft() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final draft = await _apiClient.startDraft(_leagueId, _draftId);
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

  Future<void> pauseDraft() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final draft = await _apiClient.pauseDraft(_leagueId, _draftId);
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
      final draft = await _apiClient.resumeDraft(_leagueId, _draftId);
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
    _socketService.leaveRoom('draft_${_draftId}');
    _socketService.off('draft_event');
    super.dispose();
  }
}
