import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/socket/socket_providers.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../application/league_members_provider.dart';
import '../../application/leagues_provider.dart';

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
                // Select users section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Users to League',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedUsers.length == _testUsers.length) {
                            _selectedUsers.clear();
                          } else {
                            _selectedUsers.addAll(_testUsers);
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: Text(
                        _selectedUsers.length == _testUsers.length
                            ? 'Deselect All'
                            : 'Select All',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // User checkboxes
                ..._testUsers.map((username) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedUsers.contains(username)) {
                            _selectedUsers.remove(username);
                          } else {
                            _selectedUsers.add(username);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _selectedUsers.contains(username),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedUsers.add(username);
                                    } else {
                                      _selectedUsers.remove(username);
                                    }
                                  });
                                },
                                fillColor: MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.white24;
                                }),
                                checkColor: Colors.red.shade900,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 12),

                // Add selected users button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _addSelectedUsersToLeague,
                  icon: const Icon(Icons.group_add, size: 16),
                  label: Text(
                    'Add Selected (${_selectedUsers.length})',
                    style: const TextStyle(fontSize: 12),
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

                // User login buttons
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
