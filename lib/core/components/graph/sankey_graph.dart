import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// A single flow from a [source] node to a [target] node carrying [value].
class SankeyFlow {
  const SankeyFlow({
    required this.source,
    required this.target,
    required this.value,
    this.color,
  });

  /// Label of the node the flow originates from.
  final String source;

  /// Label of the node the flow terminates at.
  final String target;

  /// Magnitude of the flow — determines band thickness.
  final double value;

  /// Optional color override; otherwise a categorical chart token is assigned.
  final Color? color;
}

/// A Sankey diagram widget styled with Carbon design tokens.
///
/// Nodes are arranged in columns left-to-right. Flow bands are drawn as cubic
/// bezier ribbons whose thickness is proportional to [SankeyFlow.value]. Colors
/// are pulled from the theme's `chartsCategoricalFullChartColor*` variables and
/// all text/background/border styling uses [AppThemeTokens].
class SankeyGraph extends StatelessWidget {
  const SankeyGraph({
    super.key,
    required this.flows,
    this.nodePadding = Spacing.v8px05remSpacing03,
    this.nodeWidth = Spacing.v16px1remSpacing05,
    this.title,
    this.height = 320,
  });

  /// The list of source → target flows to render.
  final List<SankeyFlow> flows;

  /// Vertical gap between adjacent nodes in the same column.
  final double nodePadding;

  /// Thickness of each node bar.
  final double nodeWidth;

  /// Optional chart title rendered above the diagram.
  final String? title;

  /// Canvas height for the diagram area.
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final chartColors = _extractChartColors(tokens);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle00),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.v8px05remSpacing03),
          ],
          SizedBox(
            height: height,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _SankeyLayout.compute(
                  flows: flows,
                  maxWidth: constraints.maxWidth,
                  maxHeight: height,
                  nodeWidth: nodeWidth,
                  nodePadding: nodePadding,
                  chartColors: chartColors,
                );
                return CustomPaint(
                  painter: _SankeyPainter(
                    layout: layout,
                    tokens: tokens,
                    nodeWidth: nodeWidth,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Pulls the 14 categorical chart colors from the theme's raw token class.
  ///
  /// These live on the generated theme classes (e.g. [ThemeWhiteTheme]) rather
  /// than on [AppThemeTokens], so we read them from the White theme module
  /// directly — they are identical across all four themes.
  List<Color> _extractChartColors(AppThemeTokens tokens) {
    return [
      ThemeWhiteTheme.chartsCategoricalFullChartColor01,
      ThemeWhiteTheme.chartsCategoricalFullChartColor02,
      ThemeWhiteTheme.chartsCategoricalFullChartColor03,
      ThemeWhiteTheme.chartsCategoricalFullChartColor04,
      ThemeWhiteTheme.chartsCategoricalFullChartColor05,
      ThemeWhiteTheme.chartsCategoricalFullChartColor06,
      ThemeWhiteTheme.chartsCategoricalFullChartColor07,
      ThemeWhiteTheme.chartsCategoricalFullChartColor08,
      ThemeWhiteTheme.chartsCategoricalFullChartColor09,
      ThemeWhiteTheme.chartsCategoricalFullChartColor10,
      ThemeWhiteTheme.chartsCategoricalFullChartColor11,
      ThemeWhiteTheme.chartsCategoricalFullChartColor12,
      ThemeWhiteTheme.chartsCategoricalFullChartColor13,
      ThemeWhiteTheme.chartsCategoricalFullChartColor14,
    ];
  }
}

// ---------------------------------------------------------------------------
// Layout engine
// ---------------------------------------------------------------------------

/// Internal computed position of a single node.
class _NodePosition {
  const _NodePosition({
    required this.label,
    required this.column,
    required this.x,
    required this.top,
    required this.height,
    required this.color,
  });

  final String label;
  final int column;
  final double x;
  final double top;
  final double height;
  final Color color;
}

/// Internal computed position of a single flow band.
class _FlowPosition {
  const _FlowPosition({
    required this.sourceY0,
    required this.sourceY1,
    required this.targetY0,
    required this.targetY1,
    required this.sourceX,
    required this.targetX,
    required this.color,
  });

  final double sourceY0;
  final double sourceY1;
  final double targetY0;
  final double targetY1;
  final double sourceX;
  final double targetX;
  final Color color;
}

/// Resolved layout containing all node and flow positions.
class _SankeyLayout {
  const _SankeyLayout({required this.nodes, required this.flows});

  final List<_NodePosition> nodes;
  final List<_FlowPosition> flows;

  /// Computes node columns and flow band geometry.
  static _SankeyLayout compute({
    required List<SankeyFlow> flows,
    required double maxWidth,
    required double maxHeight,
    required double nodeWidth,
    required double nodePadding,
    required List<Color> chartColors,
  }) {
    if (flows.isEmpty) {
      return const _SankeyLayout(nodes: [], flows: []);
    }

    // 1 — Assign every unique label a column based on longest chain depth.
    final columns = <String, int>{};
    for (final f in flows) {
      _assignColumn(f.source, 0, columns, flows);
      final srcCol = columns[f.source]!;
      _assignColumn(f.target, srcCol + 1, columns, flows);
    }

    final maxColumn = columns.values.fold(0, math.max);
    final columnCount = maxColumn + 1;

    // 2 — Collect nodes per column with their total in/out throughput.
    final nodesByColumn = <int, Map<String, double>>{};
    for (int c = 0; c < columnCount; c++) {
      nodesByColumn[c] = {};
    }
    for (final f in flows) {
      final sc = columns[f.source]!;
      final tc = columns[f.target]!;
      nodesByColumn[sc]![f.source] =
          (nodesByColumn[sc]![f.source] ?? 0) + f.value;
      nodesByColumn[tc]![f.target] =
          (nodesByColumn[tc]![f.target] ?? 0) + f.value;
    }

    // 3 — Scale: find the column with the largest total throughput.
    double maxColumnTotal = 0;
    for (final col in nodesByColumn.values) {
      final total = col.values.fold(0.0, (a, b) => a + b);
      if (total > maxColumnTotal) maxColumnTotal = total;
    }

    final columnSpacing = nodeWidth * 3;
    final totalColumnsWidth =
        columnCount * nodeWidth + (columnCount - 1) * columnSpacing;
    // If there's more horizontal room than needed, widen the gaps.
    final gapWidth = maxWidth > totalColumnsWidth
        ? (maxWidth - columnCount * nodeWidth) / (columnCount - 1)
        : columnSpacing;

    final usableHeight = maxHeight;
    final totalPadding = nodesByColumn.values
        .map((c) => (c.length - 1) * nodePadding)
        .fold(0.0, (a, b) => math.max(a, b));
    final scale = maxColumnTotal > 0
        ? (usableHeight - totalPadding) / maxColumnTotal
        : 1.0;

    // 4 — Position nodes vertically.
    final nodePositions = <String, _NodePosition>{};
    int colorIdx = 0;
    for (int c = 0; c < columnCount; c++) {
      final colNodes = nodesByColumn[c]!;
      final labels = colNodes.keys.toList();
      final colTotal = colNodes.values.fold(0.0, (a, b) => a + b);
      double y = (usableHeight - totalPadding - colTotal * scale) / 2;
      if (y < 0) y = 0;

      for (final label in labels) {
        final h = colNodes[label]! * scale;
        final x = c * (nodeWidth + gapWidth);
        nodePositions[label] = _NodePosition(
          label: label,
          column: c,
          x: x,
          top: y,
          height: h,
          color: chartColors[colorIdx % chartColors.length],
        );
        colorIdx++;
        y += h + nodePadding;
      }
    }

    // 5 — Position flow bands.
    // Track how much of each node's edge has been consumed.
    final sourceConsumed = <String, double>{};
    final targetConsumed = <String, double>{};
    final flowPositions = <_FlowPosition>[];

    for (final f in flows) {
      final src = nodePositions[f.source]!;
      final tgt = nodePositions[f.target]!;
      final bandH = f.value * scale;

      final sY0 = src.top + (sourceConsumed[f.source] ?? 0);
      final sY1 = sY0 + bandH;
      sourceConsumed[f.source] = (sourceConsumed[f.source] ?? 0) + bandH;

      final tY0 = tgt.top + (targetConsumed[f.target] ?? 0);
      final tY1 = tY0 + bandH;
      targetConsumed[f.target] = (targetConsumed[f.target] ?? 0) + bandH;

      flowPositions.add(
        _FlowPosition(
          sourceY0: sY0,
          sourceY1: sY1,
          targetY0: tY0,
          targetY1: tY1,
          sourceX: src.x + nodeWidth,
          targetX: tgt.x,
          color: f.color ?? src.color,
        ),
      );
    }

    return _SankeyLayout(
      nodes: nodePositions.values.toList(),
      flows: flowPositions,
    );
  }

  static void _assignColumn(
    String label,
    int col,
    Map<String, int> columns,
    List<SankeyFlow> flows,
  ) {
    if (columns.containsKey(label) && columns[label]! >= col) return;
    columns[label] = col;
    // Propagate to targets.
    for (final f in flows) {
      if (f.source == label) {
        _assignColumn(f.target, col + 1, columns, flows);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _SankeyPainter extends CustomPainter {
  const _SankeyPainter({
    required this.layout,
    required this.tokens,
    required this.nodeWidth,
  });

  final _SankeyLayout layout;
  final AppThemeTokens tokens;
  final double nodeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Flow bands first (behind nodes).
    for (final flow in layout.flows) {
      _drawFlowBand(canvas, flow);
    }

    // Nodes on top.
    for (final node in layout.nodes) {
      _drawNode(canvas, node);
    }

    // Labels.
    for (final node in layout.nodes) {
      _drawNodeLabel(canvas, node);
    }
  }

  void _drawFlowBand(Canvas canvas, _FlowPosition flow) {
    final path = Path();
    // Top edge: source → target (cubic bezier).
    path.moveTo(flow.sourceX, flow.sourceY0);
    final midX = (flow.sourceX + flow.targetX) / 2;
    path.cubicTo(
      midX,
      flow.sourceY0,
      midX,
      flow.targetY0,
      flow.targetX,
      flow.targetY0,
    );
    // Bottom edge: target → source (cubic bezier reversed).
    path.lineTo(flow.targetX, flow.targetY1);
    path.cubicTo(
      midX,
      flow.targetY1,
      midX,
      flow.sourceY1,
      flow.sourceX,
      flow.sourceY1,
    );
    path.close();

    final paint = Paint()
      ..color = flow.color.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  void _drawNode(Canvas canvas, _NodePosition node) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(node.x, node.top, nodeWidth, node.height),
      ui.Radius.circular(2),
    );
    final paint = Paint()
      ..color = node.color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, paint);

    // Subtle border.
    final borderPaint = Paint()
      ..color = tokens.borderSubtle01
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(rect, borderPaint);
  }

  void _drawNodeLabel(Canvas canvas, _NodePosition node) {
    final tp = TextPainter(
      text: TextSpan(
        text: node.label,
        style: TextStyle(
          color: tokens.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    );
    tp.layout();

    final isLeftColumn = node.column == 0;
    double lx;
    if (isLeftColumn) {
      lx = node.x - tp.width - Spacing.v8px05remSpacing03;
    } else {
      lx = node.x + nodeWidth + Spacing.v8px05remSpacing03;
    }
    final ly = node.top + node.height / 2 - tp.height / 2;
    tp.paint(canvas, Offset(lx, ly));
  }

  @override
  bool shouldRepaint(covariant _SankeyPainter oldDelegate) =>
      layout != oldDelegate.layout || tokens != oldDelegate.tokens;
}
