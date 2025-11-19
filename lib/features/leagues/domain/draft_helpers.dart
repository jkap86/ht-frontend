/// Helper utilities for draft and derby operations
class DraftHelpers {
  /// Calculate which slots have been taken based on draft order and current picker index
  static Map<int, Map<String, dynamic>> getTakenPositions(
    List<Map<String, dynamic>> draftOrder,
    int currentPickerIndex,
  ) {
    final takenPositions = <int, Map<String, dynamic>>{};

    // Only mark positions as taken for users who have already picked
    for (int i = 0; i < currentPickerIndex; i++) {
      final item = draftOrder[i];
      final position = item['draft_position'] as int?;
      if (position != null) {
        takenPositions[position] = item;
      }
    }

    return takenPositions;
  }

  /// Check if the current user can pick a slot
  static bool canUserPickSlot(
    int? currentUserId,
    List<Map<String, dynamic>> draftOrder,
    int currentPickerIndex,
  ) {
    if (currentUserId == null) return false;
    if (currentPickerIndex >= draftOrder.length) return false;

    final currentPicker = draftOrder[currentPickerIndex];
    final pickerUserId = currentPicker['user_id'] as int?;

    return pickerUserId == currentUserId;
  }

  /// Get the current picker's information
  static Map<String, dynamic>? getCurrentPicker(
    List<Map<String, dynamic>> draftOrder,
    int? currentPickerIndex,
  ) {
    if (currentPickerIndex == null) return null;
    if (currentPickerIndex >= draftOrder.length) return null;

    return draftOrder[currentPickerIndex];
  }

  /// Format draft type for display
  static String formatDraftType(String type) {
    switch (type.toLowerCase()) {
      case 'snake':
        return 'Snake';
      case 'linear':
        return 'Linear';
      case 'derby':
        return 'Derby';
      case 'auction':
        return 'Auction';
      default:
        return type;
    }
  }

  /// Format player pool for display
  static String formatPlayerPool(String pool) {
    switch (pool.toLowerCase()) {
      case 'all':
        return 'All';
      case 'rookie':
        return 'Rookie';
      case 'vet':
        return 'Vet';
      default:
        return pool;
    }
  }
}
