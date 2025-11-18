import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../leagues/presentation/widgets/collapsible_chat_widget.dart';
import 'widgets/collapsible_dm_chat_widget.dart';

/// HomeScreen
///
/// This is a template that:
/// - Shows your main home content
/// - Optionally overlays:
///    - a collapsible league chat widget (bottom-right)
///    - a collapsible DM chat widget (above it)
///
/// You need to:
/// 1) Plug in your real `activeLeagueId` / `activeLeagueName`
/// 2) Plug in your real `activeConversationId` / `otherUserId` / `otherUsername`
/// where marked with TODO comments.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: wire these from your actual state (providers, notifiers, etc.)
    // For now they're null so the chat widgets simply don't render until you hook them up.
    const int? activeLeagueId = null;
    const String? activeLeagueName = null;

    const String? activeConversationId = null;
    const String? activeOtherUserId = null;
    const String? activeOtherUsername = null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(
        children: [
          // MAIN CONTENT (replace with your existing home layout)
          Positioned.fill(
            child: _buildMainContent(context),
          ),

          // Collapsible League Chat (bottom-right)
          if (activeLeagueId != null)
            Positioned(
              right: 16,
              bottom: 16,
              child: CollapsibleChatWidget(
                leagueId: activeLeagueId,
                leagueName: activeLeagueName,
                startExpanded: false,
              ),
            ),

          // Collapsible DM Chat (stacked above league chat)
          if (activeConversationId != null && activeOtherUserId != null)
            Positioned(
              right: 16,
              bottom: activeLeagueId != null
                  ? 16 + 300
                  : 16, // shift up if league chat present
              child: CollapsibleDmChatWidget(
                conversationId: activeConversationId,
                otherUserId: activeOtherUserId,
                otherUsername: activeOtherUsername,
                startExpanded: false,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // TODO: if you have real tabs/routes, wire navigation here.
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_football_outlined),
            label: 'Leagues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  /// Replace this with your actual home body widget tree.
  ///
  /// Right now it's a simple placeholder that changes per tab index.
  Widget _buildMainContent(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        // TODO: insert your real "home" content here.
        return const Center(child: Text('Home tab content goes here'));
      case 1:
        // TODO: replace with your leagues view.
        return const Center(child: Text('Leagues tab content goes here'));
      case 2:
        // TODO: replace with your chat/DM hub view.
        return const Center(child: Text('Chat tab content goes here'));
      default:
        return const SizedBox.shrink();
    }
  }
}
