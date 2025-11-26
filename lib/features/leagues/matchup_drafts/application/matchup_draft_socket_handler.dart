import '../../../../core/services/socket/socket_service.dart';
import '../domain/matchup_draft_pick.dart';
import '../../drafts/domain/draft.dart';

/// Handles WebSocket events for matchup draft room
class MatchupDraftSocketHandler {
  final SocketService _socketService;
  final int _draftId;
  final void Function(MatchupDraftRoomUpdate) onUpdate;

  MatchupDraftSocketHandler({
    required SocketService socketService,
    required int draftId,
    required this.onUpdate,
  })  : _socketService = socketService,
        _draftId = draftId;

  /// Setup socket listeners and join room
  void setup() {
    // Join the matchup draft room
    _socketService.joinRoom('matchup_draft_$_draftId');

    // Listen for connection status changes
    _socketService.on('connect', _handleConnectionChange);
    _socketService.on('disconnect', _handleDisconnection);

    // Listen for matchup draft events
    _socketService.on('matchup_draft_event', _handleMatchupDraftEvent);
  }

  /// Clean up socket listeners and leave room
  void dispose() {
    _socketService.leaveRoom('matchup_draft_$_draftId');
    _socketService.off('matchup_draft_event');
    _socketService.off('connect');
    _socketService.off('disconnect');
  }

  /// Get current connection status
  bool get isConnected => _socketService.isConnected;

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

    // Extract updated draft with new pickDeadline
    final draftData = data['draft'] as Map<String, dynamic>?;
    final updatedDraft = draftData != null ? Draft.fromJson(draftData) : null;

    onUpdate(MatchupDraftRoomUpdate.pickMade(
      pick: pick,
      draft: updatedDraft,
    ));
  }

  void _handlePickerChanged(Map<String, dynamic> data) {
    final rosterId = data['roster_id'] as int?;
    final deadline = data['pick_deadline'] as String?;

    onUpdate(MatchupDraftRoomUpdate.pickerChanged(
      rosterId: rosterId,
      pickDeadline: deadline != null ? DateTime.parse(deadline) : null,
    ));
  }

  void _handleDraftPaused(Map<String, dynamic> data) {
    onUpdate(MatchupDraftRoomUpdate.draftPaused());
  }

  void _handleDraftResumed(Map<String, dynamic> data) {
    final draftData = data['draft'] as Map<String, dynamic>?;
    final updatedDraft = draftData != null ? Draft.fromJson(draftData) : null;

    onUpdate(MatchupDraftRoomUpdate.draftResumed(draft: updatedDraft));
  }

  void _handleDraftCompleted(Map<String, dynamic> data) {
    onUpdate(MatchupDraftRoomUpdate.draftCompleted());
  }

  void _handleDraftStarted(Map<String, dynamic> data) {
    final draftData = data['draft'] as Map<String, dynamic>?;
    if (draftData == null) return;

    final updatedDraft = Draft.fromJson(draftData);
    final currentPickerData = data['current_picker'] as Map<String, dynamic>?;

    onUpdate(MatchupDraftRoomUpdate.draftStarted(
      draft: updatedDraft,
      currentPickerRosterId: currentPickerData?['roster_id'] as int?,
    ));
  }

  void _handleConnectionChange(dynamic data) {
    print('[MatchupDraftSocketHandler] WebSocket connected');
    onUpdate(MatchupDraftRoomUpdate.connectionChanged(isConnected: true));
  }

  void _handleDisconnection(dynamic data) {
    print('[MatchupDraftSocketHandler] WebSocket disconnected');
    onUpdate(MatchupDraftRoomUpdate.connectionChanged(isConnected: false));
  }
}

/// Update events from socket handler
class MatchupDraftRoomUpdate {
  final MatchupDraftRoomUpdateType type;
  final MatchupDraftPick? pick;
  final Draft? draft;
  final int? rosterId;
  final DateTime? pickDeadline;
  final bool? isConnected;

  MatchupDraftRoomUpdate._({
    required this.type,
    this.pick,
    this.draft,
    this.rosterId,
    this.pickDeadline,
    this.isConnected,
  });

  factory MatchupDraftRoomUpdate.pickMade({
    required MatchupDraftPick pick,
    Draft? draft,
  }) =>
      MatchupDraftRoomUpdate._(
        type: MatchupDraftRoomUpdateType.pickMade,
        pick: pick,
        draft: draft,
      );

  factory MatchupDraftRoomUpdate.pickerChanged({
    int? rosterId,
    DateTime? pickDeadline,
  }) =>
      MatchupDraftRoomUpdate._(
        type: MatchupDraftRoomUpdateType.pickerChanged,
        rosterId: rosterId,
        pickDeadline: pickDeadline,
      );

  factory MatchupDraftRoomUpdate.draftPaused() => MatchupDraftRoomUpdate._(
        type: MatchupDraftRoomUpdateType.draftPaused,
      );

  factory MatchupDraftRoomUpdate.draftResumed({Draft? draft}) =>
      MatchupDraftRoomUpdate._(
        type: MatchupDraftRoomUpdateType.draftResumed,
        draft: draft,
      );

  factory MatchupDraftRoomUpdate.draftCompleted() => MatchupDraftRoomUpdate._(
        type: MatchupDraftRoomUpdateType.draftCompleted,
      );

  factory MatchupDraftRoomUpdate.draftStarted({
    required Draft draft,
    int? currentPickerRosterId,
  }) =>
      MatchupDraftRoomUpdate._(
        type: MatchupDraftRoomUpdateType.draftStarted,
        draft: draft,
        rosterId: currentPickerRosterId,
      );

  factory MatchupDraftRoomUpdate.connectionChanged({required bool isConnected}) =>
      MatchupDraftRoomUpdate._(
        type: MatchupDraftRoomUpdateType.connectionChanged,
        isConnected: isConnected,
      );
}

enum MatchupDraftRoomUpdateType {
  pickMade,
  pickerChanged,
  draftPaused,
  draftResumed,
  draftCompleted,
  draftStarted,
  connectionChanged,
}
