import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/socket/socket_providers.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../dues_payouts/application/league_members_provider.dart';
import '../../application/leagues_provider.dart';
import 'dev_tools_components/user_selection_section.dart';
import 'dev_tools_components/quick_login_section.dart';
import 'dev_tools_components/status_display.dart';

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
  final Set<String> _selectedUsers = {};

  Future<void> _addSelectedUsersToLeague() async {
    if (_selectedUsers.isEmpty) {
      setState(() {
        _statusMessage = 'No users selected';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final repository = ref.read(leaguesRepositoryProvider);
      final results = await repository.devAddUsersToLeague(
        widget.leagueId,
        _selectedUsers.toList(),
      );

      if (!mounted) return;

      // Count successes and failures
      final successes = results.where((r) => r['success'] == true).length;
      final failures = results.where((r) => r['success'] == false).length;

      // Refresh league members provider to update the UI
      if (successes > 0) {
        ref.invalidate(leagueMembersProvider(widget.leagueId));
      }

      setState(() {
        if (failures == 0) {
          _statusMessage = 'Successfully added $successes user(s) to league';
          _selectedUsers.clear(); // Clear selection on success
        } else {
          _statusMessage = 'Added $successes user(s), $failures failed';
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Error: $e';
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

  Future<void> _quickLogin(String username) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      // Login as the new user (this will replace the old token)
      await ref.read(authProvider.notifier).login(username, 'password');

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Logged in as $username';
      });

      // IMPORTANT: Invalidate socket service so it reconnects with new token
      ref.invalidate(socketServiceProvider);

      // Navigate to home - HomeScreen will detect the username change and refresh automatically
      context.go('/home');
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
                // User selection section
                UserSelectionSection(
                  testUsers: _testUsers,
                  selectedUsers: _selectedUsers,
                  onUserToggled: (username) {
                    setState(() {
                      if (_selectedUsers.contains(username)) {
                        _selectedUsers.remove(username);
                      } else {
                        _selectedUsers.add(username);
                      }
                    });
                  },
                  onSelectAll: () {
                    setState(() {
                      if (_selectedUsers.length == _testUsers.length) {
                        _selectedUsers.clear();
                      } else {
                        _selectedUsers.addAll(_testUsers);
                      }
                    });
                  },
                  isLoading: _isLoading,
                  onAddSelected: _addSelectedUsersToLeague,
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),

                // Quick login section
                QuickLoginSection(
                  testUsers: _testUsers,
                  isLoading: _isLoading,
                  onLogin: _quickLogin,
                ),

                // Status display
                StatusDisplay(
                  statusMessage: _statusMessage,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
