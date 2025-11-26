import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_notifier.dart';
import '../../../auth/domain/user.dart';
import 'dm_components/conversation_list_view.dart';
import 'dm_components/user_search_view.dart';
import 'dm_components/conversation_view.dart';

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
        return ConversationListView(
          onClose: widget.onClose,
          onNewConversation: _toggleUserSearch,
          onOpenConversation: (context, conversationId, otherUserId, otherUsername) {
            setState(() {
              _viewState = _DmViewState.conversation;
              _selectedConversationId = conversationId;
              _selectedUserId = otherUserId;
              _selectedUsername = otherUsername;
            });
          },
        );
      case _DmViewState.userSearch:
        return UserSearchView(
          onBack: _toggleUserSearch,
          searchController: _searchController,
          searchResults: _searchResults,
          isSearching: _isSearching,
          searchError: _searchError,
          onUserSelected: _startConversationWithUser,
        );
      case _DmViewState.conversation:
        if (_selectedConversationId == null || _selectedUserId == null) {
          return const Center(child: Text('No conversation selected'));
        }
        return ConversationView(
          onBack: _goBackToList,
          conversationId: _selectedConversationId!,
          otherUserId: _selectedUserId!,
          otherUsername: _selectedUsername,
        );
    }
  }
}
