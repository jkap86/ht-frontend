import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../auth/application/auth_notifier.dart';
import '../../../../auth/application/users_search_provider.dart';

/// User search panel for starting new DMs.
/// Provides:
/// - Search input field
/// - List of matching users
/// - "Start DM" action on user selection
class LeagueUserSearchPanel extends ConsumerStatefulWidget {
  final void Function({
    required String conversationId,
    required String otherUserId,
    required String? otherUsername,
  }) onUserSelected;
  final VoidCallback onBack;

  const LeagueUserSearchPanel({
    super.key,
    required this.onUserSelected,
    required this.onBack,
  });

  @override
  ConsumerState<LeagueUserSearchPanel> createState() => _LeagueUserSearchPanelState();
}

class _LeagueUserSearchPanelState extends ConsumerState<LeagueUserSearchPanel> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Back button and search header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _searchController.clear();
                  widget.onBack();
                },
              ),
              const Text(
                'New Message',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Search field
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: _buildUserSearchResults(),
        ),
      ],
    );
  }

  Widget _buildUserSearchResults() {
    final searchQuery = _searchController.text.trim();
    final currentUserId = ref.read(authProvider).user?.userId;

    // If search is empty, show placeholder
    if (searchQuery.isEmpty) {
      return const Center(
        child: Text(
          'Type to search for users...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Fetch users matching the search query
    final usersAsync = ref.watch(usersSearchProvider(searchQuery));

    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Text(
              'No users found matching "$searchQuery"',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  user.username.isNotEmpty
                      ? user.username[0].toUpperCase()
                      : '?',
                ),
              ),
              title: Text(user.username),
              subtitle: const Text('Tap to start a conversation'),
              onTap: () {
                // Create conversation ID (sorted user IDs)
                final userIds = [currentUserId ?? '', user.userId]..sort();
                final conversationId = '${userIds[0]}_${userIds[1]}';

                widget.onUserSelected(
                  conversationId: conversationId,
                  otherUserId: user.userId,
                  otherUsername: user.username,
                );

                _searchController.clear();
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Failed to search users',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}