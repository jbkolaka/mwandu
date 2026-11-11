import 'package:flutter/widgets.dart';

/// Node selection behavior for [CTreeView].
enum CTreeViewSelectionMode { none, single, multiple }

/// A node rendered by [CTreeView].
class CTreeViewNode {
  const CTreeViewNode({
    required this.id,
    required this.label,
    this.children = const <CTreeViewNode>[],
    this.icon,
    this.disabled = false,
    this.expandedByDefault = false,
  });

  /// Stable unique identifier for this node.
  final String id;

  /// Text displayed for this node.
  final String label;

  /// Child nodes. A non-empty list makes this node expandable.
  final List<CTreeViewNode> children;

  /// Optional icon displayed before the label.
  final Widget? icon;

  /// Whether the node can be selected or activated.
  final bool disabled;

  /// Whether this branch starts expanded.
  final bool expandedByDefault;
}

/// Configuration for [CTreeView].
class CTreeViewProps {
  const CTreeViewProps({
    this.nodes = const <CTreeViewNode>[],
    this.label = 'Tree view',
    this.emptyText = 'No items available',
    this.selectionMode = CTreeViewSelectionMode.single,
    this.initialSelectedIds = const <String>{},
    this.initialActiveId,
    this.initialExpandedIds = const <String>{},
    this.size = CTreeViewSize.md,
    this.maxHeight,
    this.onSelectionChanged,
    this.onActiveChanged,
    this.onExpandedChanged,
    this.onNodeActivate,
  });

  /// Root nodes to display.
  final List<CTreeViewNode> nodes;

  /// Accessible name for the tree.
  final String label;

  /// Message shown when [nodes] is empty.
  final String emptyText;

  /// Selection behavior for nodes.
  final CTreeViewSelectionMode selectionMode;

  /// Nodes selected on first build.
  final Set<String> initialSelectedIds;

  /// Node to focus when the tree is first built.
  final String? initialActiveId;

  /// Branches expanded on first build, in addition to nodes with
  /// [CTreeViewNode.expandedByDefault].
  final Set<String> initialExpandedIds;

  /// Node row density.
  final CTreeViewSize size;

  /// Optional maximum tree height. Overflowing trees scroll vertically.
  final double? maxHeight;

  /// Called when the set of selected node IDs changes.
  final ValueChanged<Set<String>>? onSelectionChanged;

  /// Called when the active node changes.
  final ValueChanged<String>? onActiveChanged;

  /// Called when a branch expands or collapses.
  final ValueChanged<Set<String>>? onExpandedChanged;

  /// Called when a node is activated by tap, Enter, or Space.
  final ValueChanged<CTreeViewNode>? onNodeActivate;
}

/// Node row density variants.
enum CTreeViewSize { sm, md, lg }
