import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_notifier.dart';
import '../../application/leagues_provider.dart';
import '../../application/league_chat_provider.dart';

/// Developer tools widget - only visible in debug/dev mode
class DeveloperToolsWidget extends ConsumerStatefulWidget {
  final int leagueId;

  const DeveloperToolsWidget({
    super.key,
    required this.leagueId,
  });

  @override
  ConsumerState<DeveloperToolsWidget> createState() =>
      _DeveloperToolsWidgetState();
}

class _DeveloperToolsWidgetState extends ConsumerState<DeveloperToolsWidget> {
  bool _isExpanded = false;
  bool _isLoading = false;
  String? _statusMessage;

  final List<String> _testUsers = List.generate(12, (i) => 'test${i + 1}');

  Future<void> _addAllUsersToLeague() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      // TODO: You'll need to create an endpoint to add users to league
      // For now, this is a placeholder
      setState(() {
        _statusMessage = 'Feature not yet implemented';
      });

      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _quickLogin(String username) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      // Login as the new user (this will replace the old token)
      await ref.read(authProvider.notifier).login(username, 'password');

      // Invalidate all data providers to force fresh data with new token
      ref.invalidate(myLeaguesProvider);

      // IMPORTANT: Invalidate socket service so it reconnects with new token
      ref.invalidate(socketServiceProvider);

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Logged in as $username';
      });

      // Wait for state to update
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        // Navigate all the way back to home screen to force full refresh
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Login failed: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.shade900,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isExpanded ? 300 : 48,
          constraints: BoxConstraints(
            maxHeight: _isExpanded ? 500 : 48,
          ),
          child: _isExpanded ? _buildExpandedView() : _buildCollapsedView(),
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    return IconButton(
      icon: const Icon(Icons.developer_mode, color: Colors.white),
      onPressed: () {
        setState(() {
          _isExpanded = true;
        });
      },
      tooltip: 'Developer Tools',
    );
  }

  Widget _buildExpandedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade800,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Developer Tools',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                onPressed: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add all users button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _addAllUsersToLeague,
                  icon: const Icon(Icons.group_add, size: 16),
                  label: const Text(
                    'Add All Users to League',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),

                // Quick login section
                const Text(
                  'Quick Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),

                // User buttons
                ..._testUsers.map((username) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => _quickLogin(username),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                        ),
                        child: Text(
                          username,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    )),

                // Status message
                if (_statusMessage != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _statusMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],

                // Loading indicator
                if (_isLoading) ...[
                  const SizedBox(height: 8),
                  const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
