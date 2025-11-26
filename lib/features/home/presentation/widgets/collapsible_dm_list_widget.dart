import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dm_list_content.dart';
import '../../../../shared/widgets/collapsible/collapsible_widget.dart';

/// Collapsible DM list widget that can be expanded to varying sizes or collapsed to an icon
class CollapsibleDmListWidget extends CollapsibleWidget {
  const CollapsibleDmListWidget({super.key}) : super(stateKey: 'dm_list');

  @override
  ConsumerState<CollapsibleDmListWidget> createState() =>
      _CollapsibleDmListWidgetState();
}

class _CollapsibleDmListWidgetState extends CollapsibleWidgetState<CollapsibleDmListWidget> {
  @override
  Widget buildCollapsedIcon(BuildContext context) {
    return FloatingActionButton(
      onPressed: toggleExpanded,
      tooltip: 'Direct Messages',
      child: const Icon(Icons.message),
    );
  }

  @override
  Widget buildExpandedContent(BuildContext context) {
    return DmListContent(
      opacity: opacityValue,
      onClose: toggleExpanded,
    );
  }
}
