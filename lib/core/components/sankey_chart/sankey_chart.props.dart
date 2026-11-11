import 'package:flutter/widgets.dart';

/// A single node in a Sankey diagram network.
class CSankeyNode {
  const CSankeyNode({
    required this.id,
    required this.label,
    this.color,
    this.column,
  });

  /// Unique identifier of the node.
  final String id;

  /// Human-readable label displayed next to or on the node.
  final String label;

  /// Optional override for the node color. When omitted, the active
  /// Carbon categorical chart palette is assigned.
  final Color? color;

  /// Optional manual column assignment (0-indexed from left to right).
  /// If omitted, column position is automatically computed.
  final int? column;
}

/// A directed flow link between two [CSankeyNode] instances.
class CSankeyLink {
  const CSankeyLink({
    required this.sourceId,
    required this.targetId,
    required this.value,
    this.color,
    this.label,
  });

  /// Identifier of the source [CSankeyNode].
  final String sourceId;

  /// Identifier of the target [CSankeyNode].
  final String targetId;

  /// Numerical weight/magnitude of the flow.
  final double value;

  /// Optional color override for the ribbon.
  final Color? color;

  /// Optional descriptive label for tooltips.
  final String? label;
}

/// A simplified flow definition between two named endpoints.
class CSankeyFlow {
  const CSankeyFlow({
    required this.source,
    required this.target,
    required this.value,
    this.color,
  });

  /// Label of the originating node.
  final String source;

  /// Label of the terminating node.
  final String target;

  /// Numerical magnitude of the flow.
  final double value;

  /// Optional color override.
  final Color? color;
}

/// Configuration and data properties for [CSankeyChart].
class CSankeyChartProps {
  const CSankeyChartProps({
    required this.nodes,
    required this.links,
    this.title,
    this.height = 360,
    this.nodeWidth = 16.0,
    this.nodePadding = 12.0,
    this.showLabels = true,
    this.showValues = true,
    this.showTooltips = true,
    this.showLegend = false,
  });

  /// Convenience factory to build properties directly from high-level [CSankeyFlow]s.
  factory CSankeyChartProps.fromFlows({
    required List<CSankeyFlow> flows,
    String? title,
    double height = 360,
    double nodeWidth = 16.0,
    double nodePadding = 12.0,
    bool showLabels = true,
    bool showValues = true,
    bool showTooltips = true,
    bool showLegend = false,
  }) {
    final nodeMap = <String, CSankeyNode>{};
    final links = <CSankeyLink>[];

    for (final flow in flows) {
      nodeMap.putIfAbsent(
        flow.source,
        () =>
            CSankeyNode(id: flow.source, label: flow.source, color: flow.color),
      );
      nodeMap.putIfAbsent(
        flow.target,
        () => CSankeyNode(id: flow.target, label: flow.target),
      );
      links.add(
        CSankeyLink(
          sourceId: flow.source,
          targetId: flow.target,
          value: flow.value,
          color: flow.color,
        ),
      );
    }

    return CSankeyChartProps(
      nodes: nodeMap.values.toList(),
      links: links,
      title: title,
      height: height,
      nodeWidth: nodeWidth,
      nodePadding: nodePadding,
      showLabels: showLabels,
      showValues: showValues,
      showTooltips: showTooltips,
      showLegend: showLegend,
    );
  }

  /// The nodes in the diagram.
  final List<CSankeyNode> nodes;

  /// The directed links representing flows between nodes.
  final List<CSankeyLink> links;

  /// Optional chart title rendered above the diagram.
  final String? title;

  /// Canvas height of the diagram.
  final double height;

  /// Width of each node bar.
  final double nodeWidth;

  /// Vertical gap between adjacent nodes in the same column.
  final double nodePadding;

  /// Whether node text labels are rendered.
  final bool showLabels;

  /// Whether numerical values are displayed alongside node labels.
  final bool showValues;

  /// Whether interactive hover tooltips are enabled.
  final bool showTooltips;

  /// Whether a node legend is displayed above the chart.
  final bool showLegend;
}
