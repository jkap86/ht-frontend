import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/league_chat_provider.dart';
import '../../domain/chat_message.dart';

/// Collapsible chat widget that can be expanded to varying sizes or collapsed to an icon
class CollapsibleChatWidget extends ConsumerStatefulWidget {
  final int leagueId;

  const CollapsibleChatWidget({
    super.key,
    required this.leagueId,
  });

  @override
  ConsumerState<CollapsibleChatWidget> createState() =>
      _CollapsibleChatWidgetState();
}

class _CollapsibleChatWidgetState extends ConsumerState<CollapsibleChatWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  double _height = 400;
  double _width = 600;
  double _left = 16;
  double _bottom = 16;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  // Resize state
  String? _resizingEdge;
  static const double _resizeHandleSize = 10.0;
  static const double _minWidth = 300.0;
  static const double _minHeight = 200.0;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  double _targetHeight = 400;
  double _targetWidth = 600;
  double _targetLeft = 16;
  double _targetBottom = 16;
  double _initialLeft = 16;
  double _initialBottom = 16;
  final double _initialWidth = 56;
  final double _initialHeight = 56;

  // Remember last expanded state
  double? _savedWidth;
  double? _savedHeight;
  double? _savedLeft;
  double? _savedBottom;

  @override
  void initState() {
    super.initState();
    _loadChatState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );
    _animationController.addListener(() {
      setState(() {
        // Animate size
        final currentWidth = _initialWidth + (_targetWidth - _initialWidth) * _sizeAnimation.value;
        final currentHeight = _initialHeight + (_targetHeight - _initialHeight) * _sizeAnimation.value;

        // Interpolate position from initial to target
        final currentLeft = _initialLeft + (_targetLeft - _initialLeft) * _sizeAnimation.value;
        final currentBottom = _initialBottom + (_targetBottom - _initialBottom) * _sizeAnimation.value;

        _width = currentWidth;
        _height = currentHeight;
        _left = currentLeft;
        _bottom = currentBottom;
      });
    });
  }

  Future<void> _loadChatState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedWidth = prefs.getDouble('chat_width');
      _savedHeight = prefs.getDouble('chat_height');
      _savedLeft = prefs.getDouble('chat_left');
      _savedBottom = prefs.getDouble('chat_bottom');
    });
  }

  Future<void> _saveChatState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('chat_width', _width);
    await prefs.setDouble('chat_height', _height);
    await prefs.setDouble('chat_left', _left);
    await prefs.setDouble('chat_bottom', _bottom);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        final screenSize = MediaQuery.of(context).size;
        final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
        final availableHeight = screenSize.height - appBarHeight;

        // Icon is always at bottom-right: 16px from bottom and right
        final iconLeft = screenSize.width - _initialWidth - 16;
        final iconBottom = 16.0;

        // Check if we have saved state from previous expansion
        if (_savedWidth != null && _savedHeight != null && _savedLeft != null && _savedBottom != null) {
          // Restore previous position and size
          _targetWidth = _savedWidth!;
          _targetHeight = _savedHeight!;
          _targetLeft = _savedLeft!;
          _targetBottom = _savedBottom!;
        } else {
          // Default expansion - full width, 1/4 screen height, positioned at bottom
          double newLeft = 0;
          double newWidth = screenSize.width;
          double newBottom = 0;
          double newHeight = availableHeight / 4;

          // Set target values for animation
          _targetWidth = newWidth;
          _targetHeight = newHeight;
          _targetLeft = newLeft;
          _targetBottom = newBottom;
        }

        // Set initial values for animation (icon position)
        _initialLeft = iconLeft;
        _initialBottom = iconBottom;

        // Start from icon size and position
        _width = _initialWidth;
        _height = _initialHeight;
        _left = iconLeft;
        _bottom = iconBottom;

        _animationController.forward(from: 0);
      } else {
        // Save current position and size before collapsing
        _savedWidth = _width;
        _savedHeight = _height;
        _savedLeft = _left;
        _savedBottom = _bottom;

        // Persist to SharedPreferences
        _saveChatState();

        // When collapsing, reset animation
        _animationController.reset();
      }
    });
  }

  void _adjustChatBounds() {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = screenSize.height - appBarHeight;

    // Preferred size
    final preferredWidth = 600.0;
    final preferredHeight = 400.0;

    // Calculate available space from current position
    final maxWidthFromLeft = screenSize.width - _left - 16;
    final maxHeightFromBottom = availableHeight - _bottom - 16;

    // Set width to preferred or max available from current position
    // Only clamp if max is greater than min
    if (maxWidthFromLeft >= _minWidth) {
      _width = preferredWidth.clamp(_minWidth, maxWidthFromLeft);
    } else {
      _width = _minWidth;
    }

    // Set height to preferred or max available from current position
    // Only clamp if max is greater than min
    if (maxHeightFromBottom >= _minHeight) {
      _height = preferredHeight.clamp(_minHeight, maxHeightFromBottom);
    } else {
      _height = _minHeight;
    }

    // If the expanded size would go off screen, shift the position
    if (_left + _width > screenSize.width - 16) {
      final newLeft = screenSize.width - _width - 16;
      _left = newLeft > 0 ? newLeft : 0;
    }

    if (_bottom + _height > availableHeight - 16) {
      final newBottom = availableHeight - _height - 16;
      _bottom = newBottom > 0 ? newBottom : 0;
    }

    // Final safety check to ensure within bounds
    _ensureWithinBounds();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      await ref
          .read(leagueChatProvider(widget.leagueId).notifier)
          .sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return _buildCollapsedButton();
    }

    return _buildExpandedChat();
  }

  Widget _buildCollapsedButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: _toggleExpanded,
        child: const Icon(Icons.chat),
      ),
    );
  }

  void _handleResize(DragUpdateDetails details) {
    setState(() {
      final screenSize = MediaQuery.of(context).size;
      final delta = details.delta;
      final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
      final availableHeight = screenSize.height - appBarHeight;
      final maxWidth = screenSize.width; // Allow full width

      switch (_resizingEdge) {
        case 'top':
          // Dragging top edge: height increases with upward drag, bottom stays fixed
          final newHeight = _height - delta.dy;
          final maxHeightFromBottom = availableHeight - _bottom;
          if (newHeight >= _minHeight && newHeight <= maxHeightFromBottom) {
            _height = newHeight;
          }
          break;
        case 'bottom':
          // Dragging bottom edge down: bottom moves down (decrease), height increases
          final newBottom = _bottom - delta.dy;
          final newHeight = _height + delta.dy;
          if (newHeight >= _minHeight && newBottom >= 0) {
            _height = newHeight;
            _bottom = newBottom;
          }
          break;
        case 'left':
          final newWidth = _width - delta.dx;
          final maxWidthFromLeft = screenSize.width - _left;
          if (newWidth >= _minWidth && newWidth <= maxWidthFromLeft) {
            _width = newWidth;
            _left = _left + delta.dx;
          }
          break;
        case 'right':
          final newWidth = _width + delta.dx;
          final maxWidthFromLeft = maxWidth - _left;
          if (maxWidthFromLeft >= _minWidth) {
            _width = newWidth.clamp(_minWidth, maxWidthFromLeft);
          } else {
            _width = newWidth >= _minWidth ? newWidth : _minWidth;
          }
          break;
        case 'top-left':
          // Handle height (top edge - bottom stays fixed)
          final newHeight = _height - delta.dy;
          final maxHeightFromBottom = availableHeight - _bottom;
          if (newHeight >= _minHeight && newHeight <= maxHeightFromBottom) {
            _height = newHeight;
          }
          // Handle width (left edge)
          final newWidth = _width - delta.dx;
          final maxWidthFromLeft = screenSize.width - _left;
          if (newWidth >= _minWidth && newWidth <= maxWidthFromLeft) {
            _width = newWidth;
            _left = _left + delta.dx;
          }
          break;
        case 'top-right':
          // Handle height (top edge - bottom stays fixed)
          final newHeight = _height - delta.dy;
          final maxHeightFromBottom = availableHeight - _bottom;
          if (newHeight >= _minHeight && newHeight <= maxHeightFromBottom) {
            _height = newHeight;
          }
          // Handle width (right edge)
          final newWidth = _width + delta.dx;
          final maxWidthFromLeft = maxWidth - _left;
          if (maxWidthFromLeft >= _minWidth) {
            _width = newWidth.clamp(_minWidth, maxWidthFromLeft);
          } else {
            _width = newWidth >= _minWidth ? newWidth : _minWidth;
          }
          break;
        case 'bottom-left':
          // Handle height (bottom edge)
          final newBottom = _bottom - delta.dy;
          final newHeight = _height + delta.dy;
          if (newHeight >= _minHeight && newBottom >= 0) {
            _height = newHeight;
            _bottom = newBottom;
          }
          // Handle width (left edge)
          final newWidth = _width - delta.dx;
          final maxWidthFromLeft = screenSize.width - _left;
          if (newWidth >= _minWidth && newWidth <= maxWidthFromLeft) {
            _width = newWidth;
            _left = _left + delta.dx;
          }
          break;
        case 'bottom-right':
          // Handle height (bottom edge)
          final newBottom = _bottom - delta.dy;
          final newHeight = _height + delta.dy;
          if (newHeight >= _minHeight && newBottom >= 0) {
            _height = newHeight;
            _bottom = newBottom;
          }
          // Handle width (right edge)
          final newWidth = _width + delta.dx;
          final maxWidthFromLeft = maxWidth - _left;
          if (maxWidthFromLeft >= _minWidth) {
            _width = newWidth.clamp(_minWidth, maxWidthFromLeft);
          } else {
            _width = newWidth >= _minWidth ? newWidth : _minWidth;
          }
          break;
      }

      // Final bounds check to ensure chat never goes off screen
      _ensureWithinBounds();
    });
  }

  void _ensureWithinBounds() {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = screenSize.height - appBarHeight;

    // Ensure width is not too large for screen (allow full width)
    final maxAllowedWidth = screenSize.width;
    if (_width > maxAllowedWidth) {
      // Only clamp if the max is at least the min
      if (maxAllowedWidth >= _minWidth) {
        _width = maxAllowedWidth;
      } else {
        _width = _minWidth;
      }
    }

    // Ensure height is not too large for available height (allow full height)
    final maxAllowedHeight = availableHeight;
    if (_height > maxAllowedHeight) {
      // Only clamp if the max is at least the min
      if (maxAllowedHeight >= _minHeight) {
        _height = maxAllowedHeight;
      } else {
        _height = _minHeight;
      }
    }

    // Ensure left + width doesn't exceed screen width
    if (_left + _width > screenSize.width) {
      final newLeft = screenSize.width - _width;
      _left = newLeft > 0 ? newLeft : 0;
    }

    // Ensure bottom + height doesn't exceed available height
    if (_bottom + _height > availableHeight) {
      final newBottom = availableHeight - _height;
      _bottom = newBottom > 0 ? newBottom : 0;
    }

    // Ensure left doesn't go negative
    if (_left < 0) {
      _left = 0;
    }

    // Ensure bottom doesn't go negative
    if (_bottom < 0) {
      _bottom = 0;
    }
  }

  Widget _buildResizeHandle(String edge, {AlignmentGeometry? alignment, MouseCursor? cursor}) {
    return Positioned.fill(
      child: Align(
        alignment: alignment ?? Alignment.center,
        child: GestureDetector(
          onPanStart: (_) {
            setState(() {
              _resizingEdge = edge;
            });
          },
          onPanUpdate: _handleResize,
          onPanEnd: (_) {
            setState(() {
              _resizingEdge = null;
            });
            // Save state after resizing
            _saveChatState();
          },
          child: MouseRegion(
            cursor: cursor ?? SystemMouseCursors.resizeUpDown,
            child: Container(
              width: edge.contains('-') ? _resizeHandleSize : (edge == 'left' || edge == 'right' ? _resizeHandleSize : double.infinity),
              height: edge.contains('-') ? _resizeHandleSize : (edge == 'top' || edge == 'bottom' ? _resizeHandleSize : double.infinity),
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedChat() {
    final chatState = ref.watch(leagueChatProvider(widget.leagueId));

    return Positioned(
      bottom: _bottom,
      left: _left,
      width: _width,
      height: _height,
      child: Stack(
        clipBehavior: Clip.none, // Allow resize handles to extend beyond
        children: [
          // Main chat widget
          GestureDetector(
            onPanUpdate: (details) {
              // Only allow dragging if not resizing
              if (_resizingEdge == null) {
                setState(() {
                  final screenSize = MediaQuery.of(context).size;
                  final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
                  final availableHeight = screenSize.height - appBarHeight;

                  // Update position with constraints (allow full screen positioning)
                  _left = (_left + details.delta.dx).clamp(0.0, screenSize.width - _width);
                  _bottom = (_bottom - details.delta.dy).clamp(0.0, availableHeight - _height);

                  // Ensure still within bounds after drag
                  _ensureWithinBounds();
                });
              }
            },
            onPanEnd: (_) {
              // Save state after dragging
              if (_resizingEdge == null) {
                _saveChatState();
              }
            },
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Column(
                      children: [
                        // Header (draggable area)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Stack(
                            children: [
                              // Left-aligned title with icon
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.drag_handle),
                                  SizedBox(width: 8),
                                  Icon(Icons.chat),
                                  SizedBox(width: 8),
                                  Text(
                                    'Chat',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Close button on the right
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: _toggleExpanded,
                                  iconSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Chat messages
                        Expanded(
                          child: chatState.when(
                            data: (messages) {
                              if (messages.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No messages yet.\nStart the conversation!',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _scrollToBottom());

                              return ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(12),
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return _ChatMessageTile(message: messages[index]);
                                },
                              );
                            },
                            loading: () =>
                                const Center(child: CircularProgressIndicator()),
                            error: (error, stack) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Error loading messages',
                                    style: TextStyle(
                                        color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => ref
                                        .refresh(leagueChatProvider(widget.leagueId)),
                                    child: const Text('Retry',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Message input
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  decoration: const InputDecoration(
                                    hintText: 'Type a message...',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _sendMessage,
                                icon: const Icon(Icons.send),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Resize handles - positioned outside the Material widget's clip region
          _buildResizeHandle('top', alignment: Alignment.topCenter, cursor: SystemMouseCursors.resizeUp),
          _buildResizeHandle('bottom', alignment: Alignment.bottomCenter, cursor: SystemMouseCursors.resizeDown),
          _buildResizeHandle('left', alignment: Alignment.centerLeft, cursor: SystemMouseCursors.resizeLeft),
          _buildResizeHandle('right', alignment: Alignment.centerRight, cursor: SystemMouseCursors.resizeRight),
          _buildResizeHandle('top-left', alignment: Alignment.topLeft, cursor: SystemMouseCursors.resizeUpLeft),
          _buildResizeHandle('top-right', alignment: Alignment.topRight, cursor: SystemMouseCursors.resizeUpRight),
          _buildResizeHandle('bottom-left', alignment: Alignment.bottomLeft, cursor: SystemMouseCursors.resizeDownLeft),
          _buildResizeHandle('bottom-right', alignment: Alignment.bottomRight, cursor: SystemMouseCursors.resizeDownRight),
        ],
      ),
    );
  }
}

class _ChatMessageTile extends StatelessWidget {
  final ChatMessage message;

  const _ChatMessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('MMM d, h:mm a');

    if (message.isSystemMessage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 14,
            child: Text(
              message.username.isNotEmpty
                  ? message.username[0].toUpperCase()
                  : '?',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and timestamp
                Row(
                  children: [
                    Text(
                      message.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeFormat.format(message.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Message text
                Text(
                  message.message,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
