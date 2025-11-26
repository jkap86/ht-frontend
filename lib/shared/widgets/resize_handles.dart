import 'package:flutter/material.dart';

/// Widget that builds resize handles for collapsible widgets
class ResizeHandles extends StatelessWidget {
  final Function(String) onResizeStart;
  final Function(DragUpdateDetails) onResizeUpdate;
  final VoidCallback onResizeEnd;

  const ResizeHandles({
    super.key,
    required this.onResizeStart,
    required this.onResizeUpdate,
    required this.onResizeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildResizeHandle('top', alignment: Alignment.topCenter, cursor: SystemMouseCursors.resizeUp),
        _buildResizeHandle('bottom', alignment: Alignment.bottomCenter, cursor: SystemMouseCursors.resizeDown),
        _buildResizeHandle('left', alignment: Alignment.centerLeft, cursor: SystemMouseCursors.resizeLeft),
        _buildResizeHandle('right', alignment: Alignment.centerRight, cursor: SystemMouseCursors.resizeRight),
        _buildResizeHandle('top-left', alignment: Alignment.topLeft, cursor: SystemMouseCursors.resizeUpLeft),
        _buildResizeHandle('top-right', alignment: Alignment.topRight, cursor: SystemMouseCursors.resizeUpRight),
        _buildResizeHandle('bottom-left', alignment: Alignment.bottomLeft, cursor: SystemMouseCursors.resizeDownLeft),
        _buildResizeHandle('bottom-right', alignment: Alignment.bottomRight, cursor: SystemMouseCursors.resizeDownRight),
      ],
    );
  }

  Widget _buildResizeHandle(
    String edge, {
    required AlignmentGeometry alignment,
    required MouseCursor cursor,
  }) {
    const double resizeHandleSize = 10.0;

    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: GestureDetector(
          onPanStart: (_) => onResizeStart(edge),
          onPanUpdate: onResizeUpdate,
          onPanEnd: (_) => onResizeEnd(),
          child: MouseRegion(
            cursor: cursor,
            child: Container(
              width: edge.contains('-')
                  ? resizeHandleSize
                  : (edge == 'left' || edge == 'right'
                      ? resizeHandleSize
                      : double.infinity),
              height: edge.contains('-')
                  ? resizeHandleSize
                  : (edge == 'top' || edge == 'bottom'
                      ? resizeHandleSize
                      : double.infinity),
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
