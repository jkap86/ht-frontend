import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../direct_messages/presentation/dm_screen.dart';
import '../../../direct_messages/presentation/widgets/dm_conversations_list.dart';
import '../../../leagues/presentation/widgets/chat_resize_handles.dart';

/// Collapsible DM list widget that can be expanded to varying sizes or collapsed to an icon
class CollapsibleDmListWidget extends ConsumerStatefulWidget {
  const CollapsibleDmListWidget({super.key});

  @override
  ConsumerState<CollapsibleDmListWidget> createState() =>
      _CollapsibleDmListWidgetState();
}

class _CollapsibleDmListWidgetState extends ConsumerState<CollapsibleDmListWidget>
    with SingleTickerProviderStateMixin {
  // State
  bool _isExpanded = false;
  double _height = 400;
  double _width = 600;
  double _left = 16;
  double _bottom = 16;

  // Resize state
  String? _resizingEdge;
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
    _initAnimation();
  }

  void _initAnimation() {
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
    _animationController.addListener(_onAnimationTick);
  }

  void _onAnimationTick() {
    setState(() {
      final currentWidth = _initialWidth + (_targetWidth - _initialWidth) * _sizeAnimation.value;
      final currentHeight = _initialHeight + (_targetHeight - _initialHeight) * _sizeAnimation.value;
      final currentLeft = _initialLeft + (_targetLeft - _initialLeft) * _sizeAnimation.value;
      final currentBottom = _initialBottom + (_targetBottom - _initialBottom) * _sizeAnimation.value;

      _width = currentWidth;
      _height = currentHeight;
      _left = currentLeft;
      _bottom = currentBottom;
    });
  }

  Future<void> _loadChatState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedWidth = prefs.getDouble('dm_list_width');
      _savedHeight = prefs.getDouble('dm_list_height');
      _savedLeft = prefs.getDouble('dm_list_left');
      _savedBottom = prefs.getDouble('dm_list_bottom');
    });
  }

  Future<void> _saveChatState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('dm_list_width', _width);
    await prefs.setDouble('dm_list_height', _height);
    await prefs.setDouble('dm_list_left', _left);
    await prefs.setDouble('dm_list_bottom', _bottom);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _startExpansion();
      } else {
        _startCollapse();
      }
    });
  }

  void _startExpansion() {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = screenSize.height - appBarHeight;

    final iconLeft = screenSize.width - _initialWidth - 16;
    final iconBottom = 16.0;

    // Default size: 600x400, positioned at bottom right
    // Clamp to screen size to ensure it fits
    final defaultWidth = 600.0.clamp(_minWidth, screenSize.width - 32);
    final defaultHeight = 400.0.clamp(_minHeight, availableHeight - 32);

    _targetWidth = defaultWidth;
    _targetHeight = defaultHeight;
    _targetLeft = (screenSize.width - defaultWidth - 16).clamp(0.0, screenSize.width - defaultWidth);
    _targetBottom = 16;

    // If we have saved state, use it instead
    if (_savedWidth != null &&
        _savedHeight != null &&
        _savedLeft != null &&
        _savedBottom != null &&
        _savedWidth! >= _minWidth &&
        _savedHeight! >= _minHeight) {
      _targetWidth = _savedWidth!.clamp(_minWidth, screenSize.width);
      _targetHeight = _savedHeight!.clamp(_minHeight, availableHeight);
      _targetLeft = _savedLeft!;
      _targetBottom = _savedBottom!;

      // Ensure saved position is still valid
      if (_targetLeft + _targetWidth > screenSize.width) {
        _targetLeft = (screenSize.width - _targetWidth).clamp(0.0, screenSize.width - _minWidth);
      }
      if (_targetBottom + _targetHeight > availableHeight) {
        _targetBottom = (availableHeight - _targetHeight).clamp(0.0, availableHeight - _minHeight);
      }
    }

    _initialLeft = iconLeft;
    _initialBottom = iconBottom;
    _width = _initialWidth;
    _height = _initialHeight;
    _left = iconLeft;
    _bottom = iconBottom;

    _animationController.forward(from: 0);
  }

  void _startCollapse() {
    _savedWidth = _width;
    _savedHeight = _height;
    _savedLeft = _left;
    _savedBottom = _bottom;
    _saveChatState();
    _animationController.reset();
  }

  void _handleResize(DragUpdateDetails details) {
    setState(() {
      final screenSize = MediaQuery.of(context).size;
      final delta = details.delta;
      final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
      final availableHeight = screenSize.height - appBarHeight;
      final maxWidth = screenSize.width;

      switch (_resizingEdge) {
        case 'top':
          _resizeTop(delta.dy, availableHeight);
          break;
        case 'bottom':
          _resizeBottom(delta.dy);
          break;
        case 'left':
          _resizeLeft(delta.dx, screenSize.width);
          break;
        case 'right':
          _resizeRight(delta.dx, maxWidth);
          break;
        case 'top-left':
          _resizeTop(delta.dy, availableHeight);
          _resizeLeft(delta.dx, screenSize.width);
          break;
        case 'top-right':
          _resizeTop(delta.dy, availableHeight);
          _resizeRight(delta.dx, maxWidth);
          break;
        case 'bottom-left':
          _resizeBottom(delta.dy);
          _resizeLeft(delta.dx, screenSize.width);
          break;
        case 'bottom-right':
          _resizeBottom(delta.dy);
          _resizeRight(delta.dx, maxWidth);
          break;
      }

      _ensureWithinBounds();
    });
  }

  void _resizeTop(double dy, double availableHeight) {
    final newHeight = _height - dy;
    final maxHeightFromBottom = availableHeight - _bottom;
    if (newHeight >= _minHeight && newHeight <= maxHeightFromBottom) {
      _height = newHeight;
    }
  }

  void _resizeBottom(double dy) {
    final newBottom = _bottom - dy;
    final newHeight = _height + dy;
    if (newHeight >= _minHeight && newBottom >= 0) {
      _height = newHeight;
      _bottom = newBottom;
    }
  }

  void _resizeLeft(double dx, double screenWidth) {
    final newWidth = _width - dx;
    final maxWidthFromLeft = screenWidth - _left;
    if (newWidth >= _minWidth && newWidth <= maxWidthFromLeft) {
      _width = newWidth;
      _left = _left + dx;
    }
  }

  void _resizeRight(double dx, double maxWidth) {
    final newWidth = _width + dx;
    final maxWidthFromLeft = maxWidth - _left;
    if (maxWidthFromLeft >= _minWidth) {
      _width = newWidth.clamp(_minWidth, maxWidthFromLeft);
    } else {
      _width = newWidth >= _minWidth ? newWidth : _minWidth;
    }
  }

  void _ensureWithinBounds() {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = screenSize.height - appBarHeight;

    final maxAllowedWidth = screenSize.width;
    if (_width > maxAllowedWidth) {
      _width = maxAllowedWidth >= _minWidth ? maxAllowedWidth : _minWidth;
    }

    final maxAllowedHeight = availableHeight;
    if (_height > maxAllowedHeight) {
      _height = maxAllowedHeight >= _minHeight ? maxAllowedHeight : _minHeight;
    }

    if (_left + _width > screenSize.width) {
      final newLeft = screenSize.width - _width;
      _left = newLeft > 0 ? newLeft : 0;
    }

    if (_bottom + _height > availableHeight) {
      final newBottom = availableHeight - _height;
      _bottom = newBottom > 0 ? newBottom : 0;
    }

    if (_left < 0) _left = 0;
    if (_bottom < 0) _bottom = 0;
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
        tooltip: 'Direct Messages',
        child: const Icon(Icons.message),
      ),
    );
  }

  Widget _buildExpandedChat() {
    return Positioned(
      bottom: _bottom,
      left: _left,
      width: _width,
      height: _height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildChatContainer(),
          ChatResizeHandles(
            onResizeStart: (edge) => setState(() => _resizingEdge = edge),
            onResizeUpdate: _handleResize,
            onResizeEnd: () {
              setState(() => _resizingEdge = null);
              _saveChatState();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatContainer() {
    return GestureDetector(
      onPanUpdate: (details) {
        if (_resizingEdge == null) {
          _handleDrag(details);
        }
      },
      onPanEnd: (_) {
        if (_resizingEdge == null) {
          _saveChatState();
        }
      },
      child: SizedBox.expand(
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: _buildDmListContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDmListContent() {
    final theme = Theme.of(context);
    final conversationsAsync = ref.watch(dmConversationsProvider);

    return Opacity(
      opacity: _opacityAnimation.value,
      child: Column(
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
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: _toggleExpanded,
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
      ),
    );
  }

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      final screenSize = MediaQuery.of(context).size;
      final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
      final availableHeight = screenSize.height - appBarHeight;

      _left = (_left + details.delta.dx).clamp(0.0, screenSize.width - _width);
      _bottom = (_bottom - details.delta.dy).clamp(0.0, availableHeight - _height);

      _ensureWithinBounds();
    });
  }
}
