import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league.dart';
import 'leagues_provider.dart';
import '../dues_payouts/application/league_members_provider.dart';
import '../dues_payouts/application/payouts_provider.dart';
import '../dues_payouts/domain/payout.dart';

/// Represents a pending payout change
class PendingPayoutChange {
  final String id; // Original id for updates/deletes, temp id for adds
  final PayoutChangeType changeType;
  final Payout? payout; // The payout data (for add/update)

  PendingPayoutChange({
    required this.id,
    required this.changeType,
    this.payout,
  });
}

enum PayoutChangeType { add, update, delete }

/// State for editing league settings
class EditLeagueState {
  final League originalLeague;
  final League editedLeague;
  final bool isSubmitting;
  final String? error;
  final bool isSuccess;
  final Map<int, bool> pendingPaymentChanges; // rosterId -> paid status
  final List<Payout> originalPayouts; // Initial payouts from server
  final Map<String, PendingPayoutChange> pendingPayoutChanges; // id -> change

  EditLeagueState({
    required this.originalLeague,
    required this.editedLeague,
    this.isSubmitting = false,
    this.error,
    this.isSuccess = false,
    this.pendingPaymentChanges = const {},
    this.originalPayouts = const [],
    this.pendingPayoutChanges = const {},
  });

  bool get hasChanges =>
      originalLeague != editedLeague ||
      pendingPaymentChanges.isNotEmpty ||
      pendingPayoutChanges.isNotEmpty;

  /// Get the current list of payouts with pending changes applied
  List<Payout> get editedPayouts {
    final result = <Payout>[];

    // Start with original payouts
    for (final payout in originalPayouts) {
      final change = pendingPayoutChanges[payout.id];
      if (change == null) {
        // No change, keep original
        result.add(payout);
      } else if (change.changeType == PayoutChangeType.update) {
        // Updated payout
        result.add(change.payout!);
      }
      // If delete, don't add to result
    }

    // Add new payouts
    for (final change in pendingPayoutChanges.values) {
      if (change.changeType == PayoutChangeType.add) {
        result.add(change.payout!);
      }
    }

    return result;
  }

  EditLeagueState copyWith({
    League? originalLeague,
    League? editedLeague,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
    bool? isSuccess,
    Map<int, bool>? pendingPaymentChanges,
    List<Payout>? originalPayouts,
    Map<String, PendingPayoutChange>? pendingPayoutChanges,
  }) {
    return EditLeagueState(
      originalLeague: originalLeague ?? this.originalLeague,
      editedLeague: editedLeague ?? this.editedLeague,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      isSuccess: isSuccess ?? this.isSuccess,
      pendingPaymentChanges: pendingPaymentChanges ?? this.pendingPaymentChanges,
      originalPayouts: originalPayouts ?? this.originalPayouts,
      pendingPayoutChanges: pendingPayoutChanges ?? this.pendingPayoutChanges,
    );
  }
}

/// Controller for editing league settings
class EditLeagueController extends StateNotifier<EditLeagueState> {
  final Ref _ref;

  EditLeagueController(this._ref, League league)
      : super(EditLeagueState(
          originalLeague: league,
          editedLeague: league,
        ));

  /// Update league name
  void updateName(String name) {
    state = state.copyWith(
      editedLeague: state.editedLeague.copyWith(name: name),
      clearError: true,
    );
  }

  /// Update league description
  void updateDescription(String? description) {
    state = state.copyWith(
      editedLeague: state.editedLeague.copyWith(description: description),
      clearError: true,
    );
  }

  /// Update total rosters
  void updateTotalRosters(int totalRosters) {
    state = state.copyWith(
      editedLeague: state.editedLeague.copyWith(totalRosters: totalRosters),
      clearError: true,
    );
  }

  /// Update league settings
  void updateSettings(Map<String, dynamic> settings) {
    state = state.copyWith(
      editedLeague: state.editedLeague.copyWith(settings: settings),
      clearError: true,
    );
  }

  /// Update specific setting value
  void updateSetting(String key, dynamic value) {
    final currentSettings =
        Map<String, dynamic>.from(state.editedLeague.settings ?? {});
    currentSettings[key] = value;
    updateSettings(currentSettings);
  }

  /// Update scoring settings
  void updateScoringSettings(Map<String, dynamic> scoringSettings) {
    state = state.copyWith(
      editedLeague:
          state.editedLeague.copyWith(scoringSettings: scoringSettings),
      clearError: true,
    );
  }

  /// Update specific scoring setting value
  void updateScoringSetting(String key, dynamic value) {
    final currentSettings =
        Map<String, dynamic>.from(state.editedLeague.scoringSettings ?? {});
    currentSettings[key] = value;
    updateScoringSettings(currentSettings);
  }

  /// Update roster positions
  void updateRosterPositions(Map<String, dynamic> rosterPositions) {
    state = state.copyWith(
      editedLeague:
          state.editedLeague.copyWith(rosterPositions: rosterPositions),
      clearError: true,
    );
  }

  /// Update specific roster position value
  void updateRosterPosition(String position, int count) {
    final currentPositions =
        Map<String, dynamic>.from(state.editedLeague.rosterPositions ?? {});
    currentPositions[position] = count;
    updateRosterPositions(currentPositions);
  }

  /// Update member payment status (staged for save)
  void updateMemberPaymentStatus(int rosterId, bool paid) {
    final updated = Map<int, bool>.from(state.pendingPaymentChanges);
    updated[rosterId] = paid;
    state = state.copyWith(
      pendingPaymentChanges: updated,
      clearError: true,
    );
  }

  /// Initialize original payouts from server data
  void setOriginalPayouts(List<Payout> payouts) {
    // Only set if not already initialized
    if (state.originalPayouts.isEmpty && payouts.isNotEmpty) {
      state = state.copyWith(originalPayouts: payouts);
    }
  }

  /// Check if a type/place combo already exists (excluding a specific payout id)
  bool _isDuplicateTypePlaceCombo(PayoutType type, int place, {String? excludeId}) {
    for (final payout in state.editedPayouts) {
      if (payout.type == type && payout.place == place) {
        if (excludeId == null || payout.id != excludeId) {
          return true;
        }
      }
    }
    return false;
  }

  /// Stage a new payout to be added
  /// Returns error message if validation fails, null on success
  String? addPayout({
    required PayoutType type,
    required int place,
    required double amount,
  }) {
    // Check for duplicate type/place combo
    if (_isDuplicateTypePlaceCombo(type, place)) {
      final typeLabel = type == PayoutType.playoffFinish ? 'Playoff' : 'Reg Season';
      return '$typeLabel ${_getOrdinal(place)} place already exists';
    }

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final payout = Payout(
      id: tempId,
      type: type,
      place: place,
      amount: amount,
    );

    final updated = Map<String, PendingPayoutChange>.from(state.pendingPayoutChanges);
    updated[tempId] = PendingPayoutChange(
      id: tempId,
      changeType: PayoutChangeType.add,
      payout: payout,
    );

    state = state.copyWith(
      pendingPayoutChanges: updated,
      clearError: true,
    );
    return null;
  }

  /// Stage a payout update
  /// Returns error message if validation fails, null on success
  String? updatePayout(String payoutId, {
    PayoutType? type,
    int? place,
    double? amount,
  }) {
    // Get the current payout to determine final type/place
    Payout? currentPayout;
    final existingChange = state.pendingPayoutChanges[payoutId];
    if (existingChange?.payout != null) {
      currentPayout = existingChange!.payout;
    } else {
      currentPayout = state.originalPayouts.where((p) => p.id == payoutId).firstOrNull;
    }

    if (currentPayout == null) return 'Payout not found';

    final finalType = type ?? currentPayout.type;
    final finalPlace = place ?? currentPayout.place;

    // Check for duplicate type/place combo (excluding current payout)
    if (_isDuplicateTypePlaceCombo(finalType, finalPlace, excludeId: payoutId)) {
      final typeLabel = finalType == PayoutType.playoffFinish ? 'Playoff' : 'Reg Season';
      return '$typeLabel ${_getOrdinal(finalPlace)} place already exists';
    }

    final updated = Map<String, PendingPayoutChange>.from(state.pendingPayoutChanges);

    // Check if this is a temp payout (being added)
    if (payoutId.startsWith('temp_')) {
      final existing = updated[payoutId];
      if (existing != null && existing.payout != null) {
        updated[payoutId] = PendingPayoutChange(
          id: payoutId,
          changeType: PayoutChangeType.add,
          payout: existing.payout!.copyWith(
            type: type,
            place: place,
            amount: amount,
          ),
        );
      }
    } else {
      updated[payoutId] = PendingPayoutChange(
        id: payoutId,
        changeType: PayoutChangeType.update,
        payout: currentPayout.copyWith(
          type: type,
          place: place,
          amount: amount,
        ),
      );
    }

    state = state.copyWith(
      pendingPayoutChanges: updated,
      clearError: true,
    );
    return null;
  }

  /// Helper to get ordinal suffix
  static String _getOrdinal(int place) {
    if (place == 1) return '1st';
    if (place == 2) return '2nd';
    if (place == 3) return '3rd';
    return '${place}th';
  }

  /// Stage a payout deletion
  void deletePayout(String payoutId) {
    final updated = Map<String, PendingPayoutChange>.from(state.pendingPayoutChanges);

    // If it's a temp payout (not yet saved), just remove the add
    if (payoutId.startsWith('temp_')) {
      updated.remove(payoutId);
    } else {
      // Mark existing payout for deletion
      updated[payoutId] = PendingPayoutChange(
        id: payoutId,
        changeType: PayoutChangeType.delete,
      );
    }

    state = state.copyWith(
      pendingPayoutChanges: updated,
      clearError: true,
    );
  }

  /// Reset changes
  void resetChanges() {
    state = state.copyWith(
      editedLeague: state.originalLeague,
      pendingPaymentChanges: {},
      pendingPayoutChanges: {},
      clearError: true,
    );
  }

  /// Validate league settings
  String? validate() {
    if (state.editedLeague.name.trim().isEmpty) {
      return 'League name is required';
    }
    if (state.editedLeague.name.trim().length < 3) {
      return 'League name must be at least 3 characters';
    }
    return null;
  }

  /// Validate payout allocation
  /// Returns error message if payouts don't match total pot, null if valid
  String? validatePayouts(List<Payout> payouts) {
    final settings = state.editedLeague.settings;
    if (settings == null) return null;

    final dues = (settings['dues'] as num?)?.toDouble() ?? 0.0;

    // If no dues, payouts should be empty or zero
    if (dues == 0) {
      final totalPayouts = payouts.fold<double>(0, (sum, p) => sum + p.amount);
      if (totalPayouts > 0) {
        return 'Payouts configured but entry fee is \$0. Either set an entry fee or remove payouts.';
      }
      return null;
    }

    final totalRosters = state.editedLeague.totalRosters;
    final totalPot = dues * totalRosters;
    final totalPayouts = payouts.fold<double>(0, (sum, p) => sum + p.amount);

    // Allow small floating point tolerance
    const tolerance = 0.01;
    final difference = totalPayouts - totalPot;

    if (difference.abs() < tolerance) {
      return null; // Valid - fully allocated
    } else if (totalPayouts < totalPot) {
      final remaining = totalPot - totalPayouts;
      return 'Payouts under-allocated by \$${remaining.toStringAsFixed(2)}. Total pot: \$${totalPot.toStringAsFixed(2)}, Allocated: \$${totalPayouts.toStringAsFixed(2)}';
    } else {
      final over = totalPayouts - totalPot;
      return 'Payouts over-allocated by \$${over.toStringAsFixed(2)}. Total pot: \$${totalPot.toStringAsFixed(2)}, Allocated: \$${totalPayouts.toStringAsFixed(2)}';
    }
  }

  /// Submit changes
  Future<void> submitChanges() async {
    // Validate basic settings
    final validationError = validate();
    if (validationError != null) {
      state = state.copyWith(error: validationError);
      return;
    }

    // Check if there are changes
    if (!state.hasChanges) {
      state = state.copyWith(error: 'No changes to save');
      return;
    }

    // Validate payout allocation using local edited state
    final payoutError = validatePayouts(state.editedPayouts);
    if (payoutError != null) {
      state = state.copyWith(error: payoutError);
      return;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      // Update league settings if changed
      if (state.originalLeague != state.editedLeague) {
        await _ref.read(myLeaguesProvider.notifier).updateLeague(
              state.editedLeague.id,
              name: state.editedLeague.name,
              description: state.editedLeague.description,
              totalRosters: state.editedLeague.totalRosters,
              settings: state.editedLeague.settings,
              scoringSettings: state.editedLeague.scoringSettings,
              rosterPositions: state.editedLeague.rosterPositions,
            );
      }

      // Update payment statuses if changed
      if (state.pendingPaymentChanges.isNotEmpty) {
        final membersNotifier = _ref.read(leagueMembersProvider(state.editedLeague.id).notifier);
        for (final entry in state.pendingPaymentChanges.entries) {
          await membersNotifier.togglePaymentStatus(entry.key, entry.value);
        }
      }

      // Save payout changes
      if (state.pendingPayoutChanges.isNotEmpty) {
        final payoutsNotifier = _ref.read(payoutsProvider(state.editedLeague.id).notifier);

        for (final change in state.pendingPayoutChanges.values) {
          switch (change.changeType) {
            case PayoutChangeType.add:
              await payoutsNotifier.addPayout(
                type: change.payout!.type,
                place: change.payout!.place,
                amount: change.payout!.amount,
              );
              break;
            case PayoutChangeType.update:
              await payoutsNotifier.updatePayout(
                change.id,
                type: change.payout!.type,
                place: change.payout!.place,
                amount: change.payout!.amount,
              );
              break;
            case PayoutChangeType.delete:
              await payoutsNotifier.deletePayout(change.id);
              break;
          }
        }
      }

      // Refresh payouts from server to get the new state
      await _ref.read(payoutsProvider(state.editedLeague.id).notifier).refresh();
      final refreshedPayouts = _ref.read(payoutsProvider(state.editedLeague.id)).valueOrNull ?? [];

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        originalLeague: state.editedLeague,
        pendingPaymentChanges: {},
        pendingPayoutChanges: {},
        originalPayouts: refreshedPayouts,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Failed to update league: ${e.toString()}',
      );
    }
  }
}

/// Provider for edit league controller
final editLeagueControllerProvider = StateNotifierProvider.family<
    EditLeagueController, EditLeagueState, League>(
  (ref, league) => EditLeagueController(ref, league),
);
