import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user.dart';
import 'auth_notifier.dart';

/// Provider for searching users by username
/// Returns list of users matching the search query (excludes current user)
final usersSearchProvider =
    FutureProvider.family<List<User>, String>((ref, query) async {
  final repository = ref.read(authRepositoryProvider);

  if (query.trim().isEmpty) {
    return [];
  }

  return repository.searchUsers(query.trim());
});
