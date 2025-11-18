import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_notifier.dart';
import '../../../auth/domain/user.dart';
import '../../../direct_messages/presentation/dm_screen.dart';
import '../../../direct_messages/presentation/widgets/dm_conversations_list.dart';
import 'dm_chat_content.dart';

/// View states for the DM widget
enum _DmViewState {
  conversationList,
  userSearch,
  conversation,
}

/// Multi-state DM content widget that shows:
/// - Conversation list (default)
/// - User search to start new conversations
/// - Individual conversation view
class DmListContent extends ConsumerStatefulWidget {
  final double opacity;
  final VoidCallback onClose;

  const DmListContent({
    super.key,
    required this.opacity,
    required this.onClose,
  });

  @override
  ConsumerState<DmListContent> createState() => _DmListContentState();
}

class _DmListContentState extends ConsumerState<DmListContent> {
  // View state
  _DmViewState _viewState = _DmViewState.conversationList;
  String? _selectedConversationId;
  String? _selectedUserId;
  String? _selectedUsername;

  // Search state
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<User> _searchResults = [];
  bool _isSearching = false;
  String _searchError = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();

    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _searchError = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = '';
    });

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final results = await authRepo.searchUsers(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
          _searchError = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
          _searchError = 'Search failed: ${e.toString()}';
        });
      }
    }
  }

  void _startConversationWithUser(User user) {
    final currentUserId = ref.read(authProvider).user?.userId;
    if (currentUserId == null) return;

    // Create conversation ID by sorting user IDs
    final ids = [currentUserId, user.userId]..sort();
    final conversationId = '${ids[0]}_${ids[1]}';

    setState(() {
      _viewState = _DmViewState.conversation;
      _selectedConversationId = conversationId;
      _selectedUserId = user.userId;
      _selectedUsername = user.username;
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _goBackToList() {
    setState(() {
      _viewState = _DmViewState.conversationList;
      _selectedConversationId = null;
      _selectedUserId = null;
      _selectedUsername = null;
    });
  }

  void _toggleUserSearch() {
    setState(() {
      if (_viewState == _DmViewState.userSearch) {
        _viewState = _DmViewState.conversationList;
        _searchController.clear();
        _searchResults = [];
      } else {
        _viewState = _DmViewState.userSearch;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity,
      child: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_viewState) {
      case _DmViewState.conversationList:
        return _buildConversationList();
      case _DmViewState.userSearch:
        return _buildUserSearch();
      case _DmViewState.conversation:
        return _buildConversation();
    }
  }

  Widget _buildConversationList() {
    final theme = Theme.of(context);
    final conversationsAsync = ref.watch(dmConversationsProvider);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Direct Messages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_add, color: Colors.white, size: 20),
                onPressed: _toggleUserSearch,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'New conversation',
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: widget.onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        // Conversations list
        Expanded(
          child: conversationsAsync.when(
            data: (conversations) {
              return DmConversationsList(
                conversations: conversations,
                onOpenConversation: (context, conversationId, otherUserId, otherUsername) {
                  setState(() {
                    _viewState = _DmViewState.conversation;
                    _selectedConversationId = conversationId;
                    _selectedUserId = otherUserId;
                    _selectedUsername = otherUsername;
                  });
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Failed to load conversations',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserSearch() {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: _toggleUserSearch,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'New Conversation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Search bar
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        // Search results
        Expanded(
          child: _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchError.isNotEmpty) {
      return Center(
        child: Text(
          _searchError,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(
        child: Text(
          'No users found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Search for users to start a conversation',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user.username[0].toUpperCase()),
          ),
          title: Text(user.username),
          onTap: () => _startConversationWithUser(user),
        );
      },
    );
  }

  Widget _buildConversation() {
    if (_selectedConversationId == null || _selectedUserId == null) {
      return const Center(child: Text('No conversation selected'));
    }

    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: _goBackToList,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedUsername ?? 'Conversation',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Chat content
        Expanded(
          child: DmChatContent(
            conversationId: _selectedConversationId!,
            otherUserId: _selectedUserId!,
            otherUsername: _selectedUsername,
          ),
        ),
      ],
    );
  }
}
