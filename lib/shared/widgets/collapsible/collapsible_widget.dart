import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resize_handles.dart';

/// Position for the collapsible widget when collapsed
enum CollapsiblePosition {
  bottomLeft,
  bottomRight,
}

/// Base class for collapsible widgets that can expand/collapse with animation
/// and support drag/resize functionality
abstract class CollapsibleWidget extends ConsumerStatefulWidget {
  /// Unique identifier for saving/loading widget state
  final String stateKey;

  /// Initial size when collapsed
  final double collapsedSize;

  /// Default size when expanded
  final Size defaultExpandedSize;

  /// Minimum size constraints
  final Size minSize;

  /// Position when collapsed
  final CollapsiblePosition position;

  const CollapsibleWidget({
    super.key,
    required this.stateKey,
    this.collapsedSize = 56.0,
    this.defaultExpandedSize = const Size(600, 400),
    this.minSize = const Size(300, 200),
    this.position = CollapsiblePosition.bottomRight,
  });
}

abstract class CollapsibleWidgetState<T extends CollapsibleWidget>
    extends ConsumerState<T> with SingleTickerProviderStateMixin {
  // State
  bool _isExpanded = false;
  double _width = 56;
  double _height = 56;
  double _left = 16;
  double _bottom = 16;

  // Resize state
  String? _resizingEdge;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  double _targetHeight = 56;
  double _targetWidth = 56;
  double _targetLeft = 16;
  double _targetBottom = 16;
  double _initialLeft = 16;
  double _initialBottom = 16;
  double _initialWidth = 56;
  double _initialHeight = 56;

  // Remember last expanded state
  double? _savedWidth;
  double? _savedHeight;
  double? _savedLeft;
  double? _savedBottom;

  bool _hasInitializedPosition = false;

  @override
  void initState() {
    super.initState();
    _width = widget.collapsedSize;
    _height = widget.collapsedSize;
    _initialWidth = widget.collapsedSize;
    _initialHeight = widget.collapsedSize;
    _loadWidgetState();
    _initAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Position collapsed icon based on position parameter on FIRST build only
    if (!_hasInitializedPosition) {
      _hasInitializedPosition = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isExpanded && mounted) {
          final screenWidth = MediaQuery.of(context).size.width;
          setState(() {
            if (widget.position == CollapsiblePosition.bottomLeft) {
              _left = 16;
            } else {
              _left = screenWidth - widget.collapsedSize - 16;
            }
            _targetLeft = _left;
            _initialLeft = _left;
          });
        }
      });
    }
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
      final progress = _sizeAnimation.value;

      // Interpolate size
      _width = _initialWidth + (_targetWidth - _initialWidth) * progress;
      _height = _initialHeight + (_targetHeight - _initialHeight) * progress;

      // Interpolate position
      _left = _initialLeft + (_targetLeft - _initialLeft) * progress;
      _bottom = _initialBottom + (_targetBottom - _initialBottom) * progress;
    });
  }

  Future<void> _loadWidgetState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLeft = prefs.getDouble('${widget.stateKey}_left');

    if (savedLeft != null && mounted) {
      setState(() {
        _savedWidth = prefs.getDouble('${widget.stateKey}_width');
        _savedHeight = prefs.getDouble('${widget.stateKey}_height');
        _savedLeft = savedLeft;
        _savedBottom = prefs.getDouble('${widget.stateKey}_bottom');
      });
    }
  }

  Future<void> _saveWidgetState() async {
    if (_isExpanded) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('${widget.stateKey}_width', _width);
      await prefs.setDouble('${widget.stateKey}_height', _height);
      await prefs.setDouble('${widget.stateKey}_left', _left);
      await prefs.setDouble('${widget.stateKey}_bottom', _bottom);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleExpanded() {
    if (_isExpanded) {
      _collapse();
    } else {
      _expand();
    }

    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _collapse() {
    // Save current expanded state
    _savedWidth = _width;
    _savedHeight = _height;
    _savedLeft = _left;
    _savedBottom = _bottom;

    // Animate to collapsed position based on widget position
    final screenWidth = MediaQuery.of(context).size.width;
    if (widget.position == CollapsiblePosition.bottomLeft) {
      _initialLeft = 16;
    } else {
      _initialLeft = screenWidth - widget.collapsedSize - 16;
    }
    _initialBottom = 16;
    _initialWidth = widget.collapsedSize;
    _initialHeight = widget.collapsedSize;

    _targetLeft = _left;
    _targetBottom = _bottom;
    _targetWidth = _width;
    _targetHeight = _height;

    _animationController.reverse();
  }

  void _expand() {
    _initialLeft = _left;
    _initialBottom = _bottom;
    _initialWidth = _width;
    _initialHeight = _height;

    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = screenSize.height - appBarHeight;

    final expandedWidth = _savedWidth ?? widget.defaultExpandedSize.width;
    final expandedHeight = _savedHeight ?? widget.defaultExpandedSize.height;

    // Ensure expanded window fits on screen
    _targetWidth = expandedWidth.clamp(widget.minSize.width, screenSize.width - 32);
    _targetHeight = expandedHeight.clamp(widget.minSize.height, availableHeight - 32);

    // Position based on widget position or use saved position
    final double defaultLeft;
    if (widget.position == CollapsiblePosition.bottomLeft) {
      defaultLeft = 16;
    } else {
      defaultLeft = screenSize.width - _targetWidth - 16;
    }
    _targetLeft = (_savedLeft ?? defaultLeft).clamp(16.0, screenSize.width - _targetWidth - 16);
    _targetBottom = (_savedBottom ?? 16).clamp(16.0, availableHeight - _targetHeight);

    _animationController.forward();
  }

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      final screenSize = MediaQuery.of(context).size;
      final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
      final availableHeight = screenSize.height - appBarHeight;

      _left = (_left + details.delta.dx).clamp(0.0, screenSize.width - _width);
      _bottom = (_bottom - details.delta.dy).clamp(0.0, availableHeight - _height);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    _saveWidgetState();
  }

  void _handleResize(DragUpdateDetails details) {
    if (_resizingEdge == null) return;

    setState(() {
      final screenSize = MediaQuery.of(context).size;
      final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
      final availableHeight = screenSize.height - appBarHeight;

      if (_resizingEdge!.contains('left')) {
        final newWidth = _width - details.delta.dx;
        if (newWidth >= widget.minSize.width) {
          _width = newWidth;
          _left += details.delta.dx;
        }
      }
      if (_resizingEdge!.contains('right')) {
        _width = (_width + details.delta.dx).clamp(widget.minSize.width, double.infinity);
      }
      if (_resizingEdge!.contains('top')) {
        final newHeight = _height - details.delta.dy;
        if (newHeight >= widget.minSize.height) {
          _height = newHeight;
        }
      }
      if (_resizingEdge!.contains('bottom')) {
        final newHeight = _height - details.delta.dy;
        if (newHeight >= widget.minSize.height) {
          _height = newHeight;
          _bottom += details.delta.dy;
        }
      }

      // Ensure widget stays within bounds
      _ensureWithinBounds(screenSize.width, availableHeight);
    });
  }

  void _ensureWithinBounds(double screenWidth, double availableHeight) {
    if (_left + _width > screenWidth) {
      _left = (screenWidth - _width).clamp(0.0, screenWidth - widget.minSize.width);
    }
    if (_bottom + _height > availableHeight) {
      _bottom = (availableHeight - _height).clamp(0.0, availableHeight - widget.minSize.height);
    }
    if (_left < 0) _left = 0;
    if (_bottom < 0) _bottom = 0;
  }

  /// Build the collapsed icon/button
  Widget buildCollapsedIcon(BuildContext context);

  /// Build the expanded content
  Widget buildExpandedContent(BuildContext context);

  /// Optional: Build custom header for expanded view
  Widget? buildHeader(BuildContext context) => null;

  /// Get unread count for badge display (optional)
  int getUnreadCount() => 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      bottom: _bottom,
      child: GestureDetector(
        onPanUpdate: _isExpanded && _resizingEdge == null ? _handleDrag : null,
        onPanEnd: _isExpanded && _resizingEdge == null ? _handleDragEnd : null,
        child: SizedBox(
          width: _width,
          height: _height,
          child: Stack(
            children: [
              Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _isExpanded ? _buildExpanded() : buildCollapsedIcon(context),
              ),
              if (_isExpanded)
                ResizeHandles(
                  onResizeStart: (edge) => setState(() => _resizingEdge = edge),
                  onResizeUpdate: _handleResize,
                  onResizeEnd: () {
                    setState(() => _resizingEdge = null);
                    _saveWidgetState();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded() {
    final header = buildHeader(context);

    return Column(
      children: [
        if (header != null) header,
        Expanded(
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: buildExpandedContent(context),
          ),
        ),
      ],
    );
  }

  /// Expose animation value for children
  double get opacityValue => _opacityAnimation.value;

  /// Expose expanded state
  bool get isExpanded => _isExpanded;
}
