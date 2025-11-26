/// Helper functions for payout-related formatting and utilities
class PayoutHelpers {
  /// Available payout categories with their display names
  static const Map<String, String> availableCategories = {
    'placement': 'Playoff Finish',
    'placement_points': 'Points Ranking',
    'highest_weekly_score': 'Highest Week Score',
    'regular_season_winner': 'Regular Season Finish',
    'highest_points_non_playoff': 'Highest Points (Non-Playoff)',
  };

  /// Get the display title for a payout category type
  static String getCategoryTitle(String type) {
    return availableCategories[type] ?? 'Payout';
  }

  /// Get ordinal representation of a place number (1st, 2nd, 3rd, etc.)
  static String getOrdinal(int place) {
    if (place == 1) return '1st';
    if (place == 2) return '2nd';
    if (place == 3) return '3rd';
    return '${place}th';
  }
}
