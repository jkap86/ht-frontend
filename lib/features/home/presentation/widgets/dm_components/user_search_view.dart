import 'package:flutter/material.dart';
import '../../../../auth/domain/user.dart';
import 'dm_header.dart';

/// View for searching users to start new conversations
class UserSearchView extends StatelessWidget {
  final VoidCallback onBack;
  final TextEditingController searchController;
  final List<User> searchResults;
  final bool isSearching;
  final String searchError;
  final Function(User) onUserSelected;

  const UserSearchView({
    super.key,
    required this.onBack,
    required this.searchController,
    required this.searchResults,
    required this.isSearching,
    required this.searchError,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        DmHeader(
          title: 'New Conversation',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: onBack,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        // Search bar
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        // Search results
        Expanded(
          child: _buildSearchResults(context),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (searchError.isNotEmpty) {
      return Center(
        child: Text(
          searchError,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchResults.isEmpty && searchController.text.isNotEmpty) {
      return const Center(
        child: Text(
          'No users found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Search for users to start a conversation',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final user = searchResults[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user.username[0].toUpperCase()),
          ),
          title: Text(user.username),
          onTap: () => onUserSelected(user),
        );
      },
    );
  }
}
