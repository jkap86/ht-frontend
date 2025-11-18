import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/unified_league_chat_notifier.dart';
import '../../../chat/application/chat_providers.dart';
import 'chat_content.dart';
import 'chat_resize_handles.dart';

/// Collapsible league chat widget that can be expanded to varying sizes or collapsed to an icon
class CollapsibleChatWidget extends ConsumerStatefulWidget {
  final int leagueId;
  final String? leagueName;

  const CollapsibleChatWidget({
    super.key,
    required this.leagueId,
    this.leagueName,
  });

  @override
  ConsumerState<CollapsibleChatWidget> createState() =>
      _CollapsibleChatWidgetState();
}

class _CollapsibleChatWidgetState extends ConsumerState<CollapsibleChatWidget>
    with SingleTickerProviderStateMixin {
  // State
  bool _isExpanded = false;
  double _initialWidth = 56;
  double _initialHeight = 56;
  double _height = 56;
  double _width = 56;
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
  double _targetHeight = 56;
  double _targetWidth = 56;
  double _targetLeft = 16;
  double _targetBottom = 16;
  double _initialLeft = 16;
  double _initialBottom = 16;

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

  bool _hasInitializedPosition = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Position collapsed icon in bottom right on FIRST build only (not after collapse animations)
    if (!_hasInitializedPosition) {
      _hasInitializedPosition = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isExpanded) {
          final screenWidth = MediaQuery.of(context).size.width;
          setState(() {
            _left = screenWidth - _initialWidth - 16;
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
    _animationController.addStatusListener(_onAnimationStatus);
  }

  void _onAnimationStatus(AnimationStatus status) {
    // No longer update positions after animation - let the animation handle it
  }

  void _onAnimationTick() {
    setState(() {
      // Simply interpolate based on animation value
      final progress = _sizeAnimation.value;

      // Interpolate size
      _width = _initialWidth + (_targetWidth - _initialWidth) * progress;
      _height = _initialHeight + (_targetHeight - _initialHeight) * progress;

      // Interpolate position
      _left = _initialLeft + (_targetLeft - _initialLeft) * progress;
      _bottom = _initialBottom + (_targetBottom - _initialBottom) * progress;
    });
  }

  Future<void> _loadChatState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLeft = prefs.getDouble('league_chat_${widget.leagueId}_left');

    // Only load saved state if it seems valid (not in the left 20% of screen)
    // This prevents loading old positions from before we fixed the bottom-right positioning
    if (savedLeft != null) {
      // We'll validate this in _toggleExpanded when expanding
      setState(() {
        _savedWidth = prefs.getDouble('league_chat_${widget.leagueId}_width');
        _savedHeight = prefs.getDouble('league_chat_${widget.leagueId}_height');
        _savedLeft = savedLeft;
        _savedBottom = prefs.getDouble('league_chat_${widget.leagueId}_bottom');
      });
    }
  }

  Future<void> _saveChatState() async {
    // Only save expanded state, not collapsed state
    if (_isExpanded) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('league_chat_${widget.leagueId}_width', _width);
      await prefs.setDouble('league_chat_${widget.leagueId}_height', _height);
      await prefs.setDouble('league_chat_${widget.leagueId}_left', _left);
      await prefs.setDouble('league_chat_${widget.leagueId}_bottom', _bottom);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    if (_isExpanded) {
      // Collapsing - save current expanded state and animate to bottom right
      _savedWidth = _width;
      _savedHeight = _height;
      _savedLeft = _left;
      _savedBottom = _bottom;

      // For reverse animation: initial = collapsed state, target = current expanded state
      // (because animation value goes from 1 to 0 when reversing)
      final screenWidth = MediaQuery.of(context).size.width;
      _initialLeft = screenWidth - 56 - 16;  // Bottom-right position
      _initialBottom = 16;
      _initialWidth = 56;
      _initialHeight = 56;

      _targetLeft = _left;  // Current expanded position
      _targetBottom = _bottom;
      _targetWidth = _width;
      _targetHeight = _height;

      _animationController.reverse();
    } else {
      // Expanding - restore saved expanded state or use defaults
      _initialLeft = _left;
      _initialBottom = _bottom;
      _initialWidth = _width;
      _initialHeight = _height;

      final screenWidth = MediaQuery.of(context).size.width;
      final expandedWidth = _savedWidth ?? 600;
      final expandedHeight = _savedHeight ?? 400;

      // Ensure expanded window fits on screen
      _targetWidth = expandedWidth.clamp(_minWidth, screenWidth - 32);
      _targetHeight = expandedHeight.clamp(_minHeight, MediaQuery.of(context).size.height - 32);

      // If no saved left position, default to right-aligned
      final defaultLeft = screenWidth - _targetWidth - 16;
      _targetLeft = (_savedLeft ?? defaultLeft).clamp(16.0, screenWidth - _targetWidth - 16);
      _targetBottom = (_savedBottom ?? 16).clamp(16.0, double.infinity);

      _animationController.forward();
    }

    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(unifiedLeagueChatProvider(widget.leagueId));
    final unreadCount = _computeUnread(chatState);

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
                child: _isExpanded ? _buildExpandedContent() : _buildCollapsedIcon(unreadCount),
              ),
              if (_isExpanded)
                ChatResizeHandles(
                  onResizeStart: (edge) => setState(() => _resizingEdge = edge),
                  onResizeUpdate: _handleResize,
                  onResizeEnd: () => setState(() => _resizingEdge = null),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedIcon(int unreadCount) {
    return InkWell(
      onTap: _toggleExpanded,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: _initialWidth,
        height: _initialHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: LeagueChatContent(
              leagueId: widget.leagueId,
              leagueName: widget.leagueName,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final leagueName = widget.leagueName ?? 'League Chat';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              leagueName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: _toggleExpanded,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      _left = (_left + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - _width);
      _bottom = (_bottom - details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - _height);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    _saveChatState();
  }

  void _handleResize(DragUpdateDetails details) {
    if (_resizingEdge == null) return;

    setState(() {
      if (_resizingEdge!.contains('left')) {
        final newWidth = _width - details.delta.dx;
        if (newWidth >= _minWidth) {
          _width = newWidth;
          _left += details.delta.dx;
        }
      }
      if (_resizingEdge!.contains('right')) {
        _width = (_width + details.delta.dx).clamp(_minWidth, double.infinity);
      }
      // For bottom-positioned widget: dragging top edge UP increases height
      if (_resizingEdge!.contains('top')) {
        final newHeight = _height - details.delta.dy;  // Negative delta.dy = dragging up = increase height
        if (newHeight >= _minHeight) {
          _height = newHeight;
          // Don't change bottom position when dragging top edge
        }
      }
      // For bottom-positioned widget: dragging bottom edge DOWN increases height
      if (_resizingEdge!.contains('bottom')) {
        final newHeight = _height - details.delta.dy;  // Negative delta.dy = dragging up = decrease height
        if (newHeight >= _minHeight) {
          _height = newHeight;
          _bottom += details.delta.dy;  // Move bottom position
        }
      }
    });
  }


  int _computeUnread(ChatState state) {
    // TODO: implement real unread logic
    return 0;
  }
}
