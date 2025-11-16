import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league.dart';
import 'leagues_provider.dart';

/// State for editing league settings
class EditLeagueState {
  final League originalLeague;
  final League editedLeague;
  final bool isSubmitting;
  final String? error;
  final bool isSuccess;

  EditLeagueState({
    required this.originalLeague,
    required this.editedLeague,
    this.isSubmitting = false,
    this.error,
    this.isSuccess = false,
  });

  bool get hasChanges => originalLeague != editedLeague;

  EditLeagueState copyWith({
    League? originalLeague,
    League? editedLeague,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return EditLeagueState(
      originalLeague: originalLeague ?? this.originalLeague,
      editedLeague: editedLeague ?? this.editedLeague,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      isSuccess: isSuccess ?? this.isSuccess,
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

  /// Reset changes
  void resetChanges() {
    state = state.copyWith(
      editedLeague: state.originalLeague,
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

  /// Submit changes
  Future<void> submitChanges() async {
    // Validate
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

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      // Call repository to update league
      await _ref.read(myLeaguesProvider.notifier).updateLeague(
            state.editedLeague.id,
            name: state.editedLeague.name,
            description: state.editedLeague.description,
            settings: state.editedLeague.settings,
            scoringSettings: state.editedLeague.scoringSettings,
            rosterPositions: state.editedLeague.rosterPositions,
          );

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        originalLeague: state.editedLeague, // Update original to edited
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
