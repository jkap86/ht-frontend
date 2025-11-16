import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_content.dart';
import 'chat_resize_handles.dart';

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

    // Default size: full width, 1/4 screen height, positioned at bottom
    _targetWidth = screenSize.width;
    _targetHeight = availableHeight / 4;
    _targetLeft = 0;
    _targetBottom = 0;

    // If we have saved state, use it instead
    if (_savedWidth != null &&
        _savedHeight != null &&
        _savedLeft != null &&
        _savedBottom != null &&
        _savedWidth! >= _minWidth &&
        _savedHeight! >= _minHeight) {
      _targetWidth = _savedWidth!;
      _targetHeight = _savedHeight!;
      _targetLeft = _savedLeft!;
      _targetBottom = _savedBottom!;
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
        child: const Icon(Icons.chat),
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
              child: ChatContent(
                leagueId: widget.leagueId,
                opacity: _opacityAnimation.value,
                onClose: _toggleExpanded,
              ),
            ),
          ),
        ),
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
