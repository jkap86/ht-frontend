/// Helper utilities for draft and derby operations
class DraftHelpers {
  /// Calculate which slots have been taken based on draft order and current picker index
  static Map<int, Map<String, dynamic>> getTakenPositions(
    List<Map<String, dynamic>> draftOrder,
    int currentPickerIndex,
  ) {
    final takenPositions = <int, Map<String, dynamic>>{};

    // Mark positions as taken for all users who have picked (draftPosition is not null)
    for (int i = 0; i < draftOrder.length; i++) {
      final item = draftOrder[i];
      final position = item['draftPosition'] as int?;
      if (position != null) {
        takenPositions[position] = item;
      }
    }

    return takenPositions;
  }

  /// Check if the current user can pick a slot
  static bool canUserPickSlot(
    String? currentUserId,
    List<Map<String, dynamic>> draftOrder,
    int currentPickerIndex,
  ) {
    if (currentUserId == null) return false;
    if (currentPickerIndex >= draftOrder.length) return false;

    final currentPicker = draftOrder[currentPickerIndex];
    final pickerUserId = currentPicker['userId']?.toString();

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
