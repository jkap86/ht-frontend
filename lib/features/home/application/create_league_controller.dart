import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/league_creation_data.dart';
import '../../leagues/application/leagues_provider.dart';
import '../../leagues/drafts/application/drafts_provider.dart';

/// State for the create league form
class CreateLeagueState {
  final LeagueCreationData data;
  final bool isSubmitting;
  final String? error;
  final bool isSuccess;

  const CreateLeagueState({
    required this.data,
    this.isSubmitting = false,
    this.error,
    this.isSuccess = false,
  });

  factory CreateLeagueState.initial() {
    return CreateLeagueState(
      data: LeagueCreationData.defaults(),
    );
  }

  CreateLeagueState copyWith({
    LeagueCreationData? data,
    bool? isSubmitting,
    String? error,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return CreateLeagueState(
      data: data ?? this.data,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Controller for create league form - handles business logic
class CreateLeagueController extends StateNotifier<CreateLeagueState> {
  final Ref _ref;

  CreateLeagueController(this._ref) : super(CreateLeagueState.initial());

  /// Update form data
  void updateData(LeagueCreationData data) {
    state = state.copyWith(data: data, clearError: true);
  }

  /// Update specific field (convenience methods)
  void updateName(String name) {
    state = state.copyWith(
      data: state.data.copyWith(name: name),
      clearError: true,
    );
  }

  void updateSeason(String season) {
    state = state.copyWith(
      data: state.data.copyWith(season: season),
      clearError: true,
    );
  }

  void updateIsPublic(bool isPublic) {
    state = state.copyWith(
      data: state.data.copyWith(isPublic: isPublic),
      clearError: true,
    );
  }

  void updateTotalRosters(int totalRosters) {
    state = state.copyWith(
      data: state.data.copyWith(totalRosters: totalRosters),
      clearError: true,
    );
  }

  void updateSeasonType(String seasonType) {
    state = state.copyWith(
      data: state.data.copyWith(seasonType: seasonType),
      clearError: true,
    );
  }

  void updateStartWeek(int startWeek) {
    state = state.copyWith(
      data: state.data.copyWith(startWeek: startWeek),
      clearError: true,
    );
  }

  void updateEndWeek(int endWeek) {
    state = state.copyWith(
      data: state.data.copyWith(endWeek: endWeek),
      clearError: true,
    );
  }

  void updatePlayoffsEnabled(bool enabled) {
    state = state.copyWith(
      data: state.data.copyWith(playoffsEnabled: enabled),
      clearError: true,
    );
  }

  void updatePlayoffWeekStart(int week) {
    state = state.copyWith(
      data: state.data.copyWith(playoffWeekStart: week),
      clearError: true,
    );
  }

  void updatePlayoffTeams(int teams) {
    state = state.copyWith(
      data: state.data.copyWith(playoffTeams: teams),
      clearError: true,
    );
  }

  void updateMatchupType(String type) {
    state = state.copyWith(
      data: state.data.copyWith(matchupType: type),
      clearError: true,
    );
  }

  void updateMatchupGeneration(String timing) {
    state = state.copyWith(
      data: state.data.copyWith(matchupGeneration: timing),
      clearError: true,
    );
  }

  void updateScoringSettings(Map<String, double> settings) {
    state = state.copyWith(
      data: state.data.copyWith(scoringSettings: settings),
      clearError: true,
    );
  }

  void updateRosterPositions(Map<String, int> positions) {
    state = state.copyWith(
      data: state.data.copyWith(rosterPositions: positions),
      clearError: true,
    );
  }

  void updateWaiverType(String type) {
    state = state.copyWith(
      data: state.data.copyWith(waiverType: type),
      clearError: true,
    );
  }

  void updateFaabBudget(int budget) {
    state = state.copyWith(
      data: state.data.copyWith(faabBudget: budget),
      clearError: true,
    );
  }

  void updateWaiverPeriodDays(int days) {
    state = state.copyWith(
      data: state.data.copyWith(waiverPeriodDays: days),
      clearError: true,
    );
  }

  void updateProcessSchedule(String schedule) {
    state = state.copyWith(
      data: state.data.copyWith(processSchedule: schedule),
      clearError: true,
    );
  }

  void updateTradeNotificationSetting(String setting) {
    state = state.copyWith(
      data: state.data.copyWith(tradeNotificationSetting: setting),
      clearError: true,
    );
  }

  void updateTradeDetailsSetting(String setting) {
    state = state.copyWith(
      data: state.data.copyWith(tradeDetailsSetting: setting),
      clearError: true,
    );
  }

  void updateEntryFee(double fee) {
    state = state.copyWith(
      data: state.data.copyWith(entryFee: fee),
      clearError: true,
    );
  }

  void updatePayoutStructure(List<Map<String, dynamic>> structure) {
    state = state.copyWith(
      data: state.data.copyWith(payoutStructure: structure),
      clearError: true,
    );
  }

  void updateDraftConfigurations(List<Map<String, dynamic>> configurations) {
    state = state.copyWith(
      data: state.data.copyWith(draftConfigurations: configurations),
      clearError: true,
    );
  }

  void addDraftConfiguration(Map<String, dynamic> configuration) {
    final updatedConfigurations = [...state.data.draftConfigurations, configuration];
    updateDraftConfigurations(updatedConfigurations);
  }

  void updateDraftConfiguration(int index, Map<String, dynamic> configuration) {
    final updatedConfigurations = [...state.data.draftConfigurations];
    updatedConfigurations[index] = configuration;
    updateDraftConfigurations(updatedConfigurations);
  }

  void removeDraftConfiguration(int index) {
    final updatedConfigurations = [...state.data.draftConfigurations];
    updatedConfigurations.removeAt(index);
    updateDraftConfigurations(updatedConfigurations);
  }

  /// Validate form data
  String? validateName() {
    if (state.data.name.trim().isEmpty) {
      return 'League name is required';
    }
    if (state.data.name.trim().length < 3) {
      return 'League name must be at least 3 characters';
    }
    return null;
  }

  String? validateSeason() {
    final year = int.tryParse(state.data.season);
    if (year == null) {
      return 'Invalid season year';
    }
    final currentYear = DateTime.now().year;
    if (year < currentYear - 1 || year > currentYear + 5) {
      return 'Season must be between ${currentYear - 1} and ${currentYear + 5}';
    }
    return null;
  }

  /// Submit form - create league and drafts
  Future<void> submitForm() async {
    // Validate
    final nameError = validateName();
    if (nameError != null) {
      state = state.copyWith(error: nameError);
      return;
    }

    final seasonError = validateSeason();
    if (seasonError != null) {
      state = state.copyWith(error: seasonError);
      return;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final data = state.data;

      // Call leagues provider to create league
      await _ref.read(myLeaguesProvider.notifier).addLeague(
            name: data.name.trim(),
            season: data.season,
            totalRosters: data.totalRosters,
            settings: data.toSettingsMap(),
            scoringSettings: data.scoringSettings,
            rosterPositions: data.rosterPositions,
            seasonType: data.seasonType,
          );

      // Get the newly created league to get its ID
      final leagues = await _ref.read(myLeaguesProvider.future);
      if (leagues.isNotEmpty && data.draftConfigurations.isNotEmpty) {
        final newLeague = leagues.first; // The newest league is at the top

        // Create each draft configuration
        final draftsApiClient = _ref.read(draftsApiClientProvider);
        for (final draftConfig in data.draftConfigurations) {
          try {
            await draftsApiClient.createDraft(newLeague.id, draftConfig);
          } catch (e) {
            // Log error but continue with other drafts
            print('Error creating draft: $e');
          }
        }
      }

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      );
    }
  }

  /// Reset form to initial state
  void reset() {
    state = CreateLeagueState.initial();
  }
}

/// Provider for create league controller
final createLeagueControllerProvider =
    StateNotifierProvider.autoDispose<CreateLeagueController, CreateLeagueState>((ref) {
  return CreateLeagueController(ref);
});
