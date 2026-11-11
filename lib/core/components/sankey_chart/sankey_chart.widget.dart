import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'sankey_chart.props.dart';
import 'sankey_chart.styles.dart';

/// An interactive Sankey diagram widget styled with Carbon Design System tokens.
///
/// Visualizes multi-stage flows and resource transfers across network nodes.
/// Supports configurable node geometry, categorical palettes, interactive
/// hover highlights, and Carbon tooltips.
class CSankeyChart extends StatefulWidget {
  const CSankeyChart({super.key, required this.props});

  /// Convenience factory for building a [CSankeyChart] directly from [CSankeyFlow]s.
  factory CSankeyChart.fromFlows({
    Key? key,
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
    return CSankeyChart(
      key: key,
      props: CSankeyChartProps.fromFlows(
        flows: flows,
        title: title,
        height: height,
        nodeWidth: nodeWidth,
        nodePadding: nodePadding,
        showLabels: showLabels,
        showValues: showValues,
        showTooltips: showTooltips,
        showLegend: showLegend,
      ),
    );
  }

  /// Configuration and data of the Sankey chart.
  final CSankeyChartProps props;

  @override
  State<CSankeyChart> createState() => _CSankeyChartState();
}

class _CSankeyChartState extends State<CSankeyChart> {
  _HoveredElement? _hovered;

  void _onHover(
    Offset localPosition,
    Size canvasSize,
    _ComputedLayout? layout,
  ) {
    if (layout == null || !widget.props.showTooltips) return;

    // 1. Check if hovering over any node rect
    for (final node in layout.nodes) {
      if (node.rect.contains(localPosition)) {
        if (_hovered is! _HoveredNode ||
            (_hovered as _HoveredNode).node.id != node.id) {
          setState(() {
            _hovered = _HoveredNode(
              node: node,
              position: Offset(node.rect.center.dx, node.rect.top),
            );
          });
        }
        return;
      }
    }

    // 2. Check if hovering over any link ribbon path
    for (final link in layout.links) {
      if (link.path.contains(localPosition)) {
        if (_hovered is! _HoveredLink ||
            (_hovered as _HoveredLink).link.sourceId != link.sourceId ||
            (_hovered as _HoveredLink).link.targetId != link.targetId) {
          setState(() {
            _hovered = _HoveredLink(link: link, position: localPosition);
          });
        }
        return;
      }
    }

    // 3. Not hovering anything interactive
    if (_hovered != null) {
      setState(() => _hovered = null);
    }
  }

  void _onExit() {
    if (_hovered != null) {
      setState(() => _hovered = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = CSankeyChartStyles.categoricalPalette(tokens);

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 600.0;
        final canvasSize = Size(chartWidth, widget.props.height);

        final layout = _computeLayout(
          props: widget.props,
          canvasSize: canvasSize,
          palette: palette,
          tokens: tokens,
        );

        return Container(
          width: chartWidth,
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.v12px075remSpacing04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.props.title != null &&
                  widget.props.title!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.v8px05remSpacing03,
                  ),
                  child: Text(
                    widget.props.title!,
                    style: TextStyle(
                      color: tokens.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
              if (widget.props.showLegend && widget.props.nodes.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.v12px075remSpacing04,
                  ),
                  child: _buildLegend(layout, tokens),
                ),
              ],
              SizedBox(
                height: widget.props.height,
                width: chartWidth,
                child: MouseRegion(
                  onHover: (event) =>
                      _onHover(event.localPosition, canvasSize, layout),
                  onExit: (_) => _onExit(),
                  child: GestureDetector(
                    onTapDown: (details) =>
                        _onHover(details.localPosition, canvasSize, layout),
                    onPanUpdate: (details) =>
                        _onHover(details.localPosition, canvasSize, layout),
                    onPanEnd: (_) => _onExit(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: canvasSize,
                          painter: _SankeyChartPainter(
                            layout: layout,
                            props: widget.props,
                            tokens: tokens,
                            hovered: _hovered,
                          ),
                        ),
                        if (_hovered != null && widget.props.showTooltips)
                          _buildTooltip(tokens, canvasSize),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend(_ComputedLayout layout, AppThemeTokens tokens) {
    return Wrap(
      spacing: CSankeyChartStyles.legendSpacing,
      runSpacing: Spacing.v8px05remSpacing03,
      children: [
        for (final node in layout.nodes) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: CSankeyChartStyles.legendSwatchSize,
                height: CSankeyChartStyles.legendSwatchSize,
                decoration: BoxDecoration(
                  color: node.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: CSankeyChartStyles.legendSwatchSpacing),
              Text(
                node.label,
                style: TextStyle(
                  fontSize: 12,
                  color: tokens.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTooltip(AppThemeTokens tokens, Size canvasSize) {
    final h = _hovered!;
    const tooltipWidth = 160.0;
    const tooltipHeight = 60.0;

    double left = h.position.dx - (tooltipWidth / 2);
    double top = h.position.dy - tooltipHeight - 12;

    if (left < 8) left = 8;
    if (left + tooltipWidth > canvasSize.width - 8) {
      left = canvasSize.width - tooltipWidth - 8;
    }
    if (top < 0) {
      top = h.position.dy + 14;
    }

    Widget content;
    if (h is _HoveredNode) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: h.node.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  h.node.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.textOnColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Total: ${_formatValue(h.node.value)}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: tokens.textOnColor,
            ),
          ),
        ],
      );
    } else {
      final link = (h as _HoveredLink).link;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${link.sourceLabel} → ${link.targetLabel}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tokens.textOnColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Flow: ${_formatValue(link.value)}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: tokens.textOnColor,
            ),
          ),
        ],
      );
    }

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        child: Container(
          width: tooltipWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: tokens.backgroundInverse,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Layout Computation Data Models & Pipeline
// -----------------------------------------------------------------------------

sealed class _HoveredElement {
  Offset get position;
}

class _HoveredNode extends _HoveredElement {
  _HoveredNode({required this.node, required this.position});
  final _LayoutNode node;
  @override
  final Offset position;
}

class _HoveredLink extends _HoveredElement {
  _HoveredLink({required this.link, required this.position});
  final _LayoutLink link;
  @override
  final Offset position;
}

class _LayoutNode {
  _LayoutNode({
    required this.id,
    required this.label,
    required this.color,
    required this.column,
    required this.value,
  });

  final String id;
  final String label;
  final Color color;
  final int column;
  final double value;

  late Rect rect;
  double currentOutY = 0;
  double currentInY = 0;
}

class _LayoutLink {
  _LayoutLink({
    required this.sourceId,
    required this.targetId,
    required this.sourceLabel,
    required this.targetLabel,
    required this.value,
    required this.color,
    required this.path,
  });

  final String sourceId;
  final String targetId;
  final String sourceLabel;
  final String targetLabel;
  final double value;
  final Color color;
  final Path path;
}

class _ComputedLayout {
  _ComputedLayout({
    required this.nodes,
    required this.links,
    required this.totalColumns,
  });

  final List<_LayoutNode> nodes;
  final List<_LayoutLink> links;
  final int totalColumns;
}

_ComputedLayout _computeLayout({
  required CSankeyChartProps props,
  required Size canvasSize,
  required List<Color> palette,
  required AppThemeTokens tokens,
}) {
  if (props.nodes.isEmpty) {
    return _ComputedLayout(nodes: [], links: [], totalColumns: 0);
  }

  // 1. Map raw nodes & accumulate link connectivity
  final nodeMap = <String, CSankeyNode>{};
  final outgoingMap = <String, List<CSankeyLink>>{};
  final incomingMap = <String, List<CSankeyLink>>{};

  for (final n in props.nodes) {
    nodeMap[n.id] = n;
    outgoingMap[n.id] = [];
    incomingMap[n.id] = [];
  }

  for (final l in props.links) {
    if (nodeMap.containsKey(l.sourceId) && nodeMap.containsKey(l.targetId)) {
      outgoingMap[l.sourceId]!.add(l);
      incomingMap[l.targetId]!.add(l);
    }
  }

  // 2. Assign column per node
  final columnMap = <String, int>{};

  // Pre-seed explicitly configured columns
  for (final n in props.nodes) {
    if (n.column != null) {
      columnMap[n.id] = n.column!;
    }
  }

  // Topological / BFS depth assignment
  void assignColumns() {
    final visited = <String>{};

    void visit(String id, int depth) {
      if (visited.contains(id)) return;
      visited.add(id);

      final current = columnMap[id] ?? 0;
      if (depth > current && nodeMap[id]?.column == null) {
        columnMap[id] = depth;
      }

      for (final out in outgoingMap[id]!) {
        visit(out.targetId, (columnMap[id] ?? depth) + 1);
      }
      visited.remove(id);
    }

    // Start with root nodes (in-degree == 0)
    final rootNodes = props.nodes
        .where((n) => incomingMap[n.id]!.isEmpty)
        .toList();
    if (rootNodes.isEmpty && props.nodes.isNotEmpty) {
      rootNodes.add(props.nodes.first);
    }

    for (final root in rootNodes) {
      visit(root.id, columnMap[root.id] ?? 0);
    }

    // Any remaining unvisited nodes
    for (final n in props.nodes) {
      columnMap.putIfAbsent(n.id, () => 0);
    }
  }

  assignColumns();

  final maxCol = columnMap.values.fold<int>(0, math.max);
  final totalColumns = maxCol + 1;

  // 3. Compute node values and instantiate layout nodes
  final layoutNodes = <_LayoutNode>[];
  final layoutNodeMap = <String, _LayoutNode>{};

  for (int i = 0; i < props.nodes.length; i++) {
    final n = props.nodes[i];
    final outSum = outgoingMap[n.id]!.fold<double>(
      0,
      (sum, l) => sum + l.value,
    );
    final inSum = incomingMap[n.id]!.fold<double>(0, (sum, l) => sum + l.value);
    final val = math.max(outSum, inSum);
    final finalVal = val > 0 ? val : 1.0;

    final color = n.color ?? palette[i % palette.length];
    final col = columnMap[n.id] ?? 0;

    final ln = _LayoutNode(
      id: n.id,
      label: n.label,
      color: color,
      column: col,
      value: finalVal,
    );
    layoutNodes.add(ln);
    layoutNodeMap[n.id] = ln;
  }

  // 4. Calculate node geometry on canvas
  const leftMargin = 72.0;
  const rightMargin = 72.0;
  const topMargin = 20.0;
  const bottomMargin = 24.0;

  final chartWidth = math.max(
    100.0,
    canvasSize.width - leftMargin - rightMargin,
  );
  final chartHeight = math.max(
    60.0,
    canvasSize.height - topMargin - bottomMargin,
  );

  // Group nodes by column
  final columnGroups = <int, List<_LayoutNode>>{};
  for (int c = 0; c < totalColumns; c++) {
    columnGroups[c] = [];
  }
  for (final n in layoutNodes) {
    columnGroups[n.column]!.add(n);
  }

  // Find max column sum for proportional vertical scaling
  double maxColumnValueSum = 0;
  for (final group in columnGroups.values) {
    final colVal = group.fold<double>(0, (sum, n) => sum + n.value);
    if (colVal > maxColumnValueSum) {
      maxColumnValueSum = colVal;
    }
  }
  if (maxColumnValueSum <= 0) maxColumnValueSum = 1.0;

  final nodeWidth = props.nodeWidth;
  final nodePadding = props.nodePadding;

  for (int c = 0; c < totalColumns; c++) {
    final group = columnGroups[c]!;
    if (group.isEmpty) continue;

    final colX = totalColumns <= 1
        ? leftMargin + (chartWidth / 2) - (nodeWidth / 2)
        : leftMargin + (c / (totalColumns - 1)) * (chartWidth - nodeWidth);

    final totalGaps = (group.length - 1) * nodePadding;
    final availableHeight = math.max(20.0, chartHeight - totalGaps);
    final scale = availableHeight / maxColumnValueSum;

    double totalRenderedHeight = totalGaps;
    for (final n in group) {
      totalRenderedHeight += math.max(
        CSankeyChartStyles.minNodeHeight,
        n.value * scale,
      );
    }

    // Center column vertically
    double curY =
        topMargin + math.max(0, (chartHeight - totalRenderedHeight) / 2);

    for (final n in group) {
      final h = math.max(CSankeyChartStyles.minNodeHeight, n.value * scale);
      n.rect = Rect.fromLTWH(colX, curY, nodeWidth, h);
      n.currentInY = curY;
      n.currentOutY = curY;
      curY += h + nodePadding;
    }
  }

  // 5. Generate smooth link ribbon paths
  final layoutLinks = <_LayoutLink>[];

  for (final l in props.links) {
    final sNode = layoutNodeMap[l.sourceId];
    final tNode = layoutNodeMap[l.targetId];
    if (sNode == null || tNode == null) continue;

    final sThickness = sNode.value > 0
        ? (l.value / sNode.value) * sNode.rect.height
        : 0.0;
    final tThickness = tNode.value > 0
        ? (l.value / tNode.value) * tNode.rect.height
        : 0.0;

    final x0 = sNode.rect.right;
    final y0Top = sNode.currentOutY;
    final y0Bot = y0Top + sThickness;

    final x1 = tNode.rect.left;
    final y1Top = tNode.currentInY;
    final y1Bot = y1Top + tThickness;

    sNode.currentOutY = y0Bot;
    tNode.currentInY = y1Bot;

    final dx = x1 - x0;
    final curvature = dx / 2;

    final path = Path()
      ..moveTo(x0, y0Top)
      ..cubicTo(x0 + curvature, y0Top, x1 - curvature, y1Top, x1, y1Top)
      ..lineTo(x1, y1Bot)
      ..cubicTo(x1 - curvature, y1Bot, x0 + curvature, y0Bot, x0, y0Bot)
      ..close();

    final linkColor = l.color ?? sNode.color;

    layoutLinks.add(
      _LayoutLink(
        sourceId: l.sourceId,
        targetId: l.targetId,
        sourceLabel: sNode.label,
        targetLabel: tNode.label,
        value: l.value,
        color: linkColor,
        path: path,
      ),
    );
  }

  return _ComputedLayout(
    nodes: layoutNodes,
    links: layoutLinks,
    totalColumns: totalColumns,
  );
}

String _formatValue(double val) {
  if (val.abs() >= 1000000) {
    return '${(val / 1000000).toStringAsFixed(1)}M';
  } else if (val.abs() >= 1000) {
    return '${(val / 1000).toStringAsFixed(1)}k';
  }
  if (val == val.roundToDouble()) {
    return val.toInt().toString();
  }
  return val.toStringAsFixed(1);
}

// -----------------------------------------------------------------------------
// CustomPainter
// -----------------------------------------------------------------------------

class _SankeyChartPainter extends CustomPainter {
  const _SankeyChartPainter({
    required this.layout,
    required this.props,
    required this.tokens,
    required this.hovered,
  });

  final _ComputedLayout layout;
  final CSankeyChartProps props;
  final AppThemeTokens tokens;
  final _HoveredElement? hovered;

  @override
  void paint(Canvas canvas, Size size) {
    if (layout.nodes.isEmpty) {
      _paintEmptyState(canvas, size);
      return;
    }

    // 1. Draw Links
    _paintLinks(canvas);

    // 2. Draw Nodes
    _paintNodes(canvas);

    // 3. Draw Labels & Values
    if (props.showLabels) {
      _paintLabels(canvas, size);
    }
  }

  void _paintEmptyState(Canvas canvas, Size size) {
    final tp = TextPainter(
      text: TextSpan(
        text: 'No flow data to display',
        style: TextStyle(
          color: tokens.textPlaceholder,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
    );
  }

  void _paintLinks(Canvas canvas) {
    final hNode = hovered is _HoveredNode
        ? (hovered as _HoveredNode).node
        : null;
    final hLink = hovered is _HoveredLink
        ? (hovered as _HoveredLink).link
        : null;

    for (final l in layout.links) {
      bool isHighlighted = false;
      bool isDimmed = false;

      if (hLink != null) {
        if (hLink.sourceId == l.sourceId && hLink.targetId == l.targetId) {
          isHighlighted = true;
        } else {
          isDimmed = true;
        }
      } else if (hNode != null) {
        if (l.sourceId == hNode.id || l.targetId == hNode.id) {
          isHighlighted = true;
        } else {
          isDimmed = true;
        }
      }

      double opacity = CSankeyChartStyles.linkOpacity;
      if (isHighlighted) {
        opacity = CSankeyChartStyles.hoveredLinkOpacity;
      } else if (isDimmed) {
        opacity = 0.15;
      }

      final paint = Paint()
        ..color = l.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawPath(l.path, paint);

      if (isHighlighted) {
        final borderPaint = Paint()
          ..color = l.color.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawPath(l.path, borderPaint);
      }
    }
  }

  void _paintNodes(Canvas canvas) {
    final hNode = hovered is _HoveredNode
        ? (hovered as _HoveredNode).node
        : null;

    for (final n in layout.nodes) {
      final isHovered = hNode != null && hNode.id == n.id;

      final fillPaint = Paint()
        ..color = n.color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      final rrect = RRect.fromRectAndRadius(n.rect, const Radius.circular(2));
      canvas.drawRRect(rrect, fillPaint);

      // Node border
      final borderPaint = Paint()
        ..color = isHovered ? tokens.borderInteractive : tokens.borderSubtle00
        ..style = PaintingStyle.stroke
        ..strokeWidth = isHovered ? 2.0 : 1.0;

      canvas.drawRRect(rrect, borderPaint);
    }
  }

  void _paintLabels(Canvas canvas, Size size) {
    for (final n in layout.nodes) {
      final isFirstCol = n.column == 0;
      final isLastCol = n.column == layout.totalColumns - 1;

      final textSpan = TextSpan(
        children: [
          TextSpan(
            text: n.label,
            style: TextStyle(
              color: tokens.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (props.showValues) ...[
            TextSpan(
              text: '\n${_formatValue(n.value)}',
              style: TextStyle(
                color: tokens.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      );

      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: isFirstCol ? TextAlign.right : TextAlign.left,
      )..layout(maxWidth: 80);

      double x;
      if (isFirstCol) {
        x = n.rect.left - tp.width - 8;
        if (x < 4) x = n.rect.right + 8;
      } else if (isLastCol) {
        x = n.rect.right + 8;
      } else {
        x = n.rect.right + 6;
      }

      final y = n.rect.center.dy - (tp.height / 2);

      tp.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant _SankeyChartPainter oldDelegate) {
    return oldDelegate.layout != layout ||
        oldDelegate.props != props ||
        oldDelegate.tokens != tokens ||
        oldDelegate.hovered != hovered;
  }
}
