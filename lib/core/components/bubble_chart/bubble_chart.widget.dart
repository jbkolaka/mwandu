import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

import 'bubble_chart.props.dart';
import 'bubble_chart.styles.dart';

/// A Carbon Design System Bubble Chart widget.
///
/// Visualizes 3-dimensional data points (X coordinate, Y coordinate, and magnitude/radius)
/// across categorical groups. Adheres to Carbon Design System tokens, typography,
/// Cartesian gridlines, axes, interactive legends, and hover/touch tooltips.
class CBubbleChart extends StatefulWidget {
  const CBubbleChart({super.key, required this.props});

  /// Convenience factory for inline configuration without constructing [CBubbleChartProps].
  factory CBubbleChart.inline({
    Key? key,
    required List<CBubbleChartSeries> series,
    String? title,
    String? xAxisLabel,
    String? yAxisLabel,
    List<String> xAxisLabels = const <String>[],
    bool showLegend = true,
    bool showGridLines = true,
    bool showAxes = true,
    double minRadius = 6.0,
    double maxRadius = 28.0,
    double bubbleOpacity = 0.70,
    double height = 320.0,
    void Function(CBubbleChartSeries series, CBubbleChartPoint point)?
    onBubbleTap,
  }) {
    return CBubbleChart(
      key: key,
      props: CBubbleChartProps(
        series: series,
        title: title,
        xAxisLabel: xAxisLabel,
        yAxisLabel: yAxisLabel,
        xAxisLabels: xAxisLabels,
        showLegend: showLegend,
        showGridLines: showGridLines,
        showAxes: showAxes,
        minRadius: minRadius,
        maxRadius: maxRadius,
        bubbleOpacity: bubbleOpacity,
        height: height,
        onBubbleTap: onBubbleTap,
      ),
    );
  }

  /// Configuration and data of the bubble chart.
  final CBubbleChartProps props;

  @override
  State<CBubbleChart> createState() => _CBubbleChartState();
}

class _CBubbleChartState extends State<CBubbleChart> {
  _HoveredBubble? _hoveredBubble;
  final Set<String> _hiddenSeries = <String>{};

  List<CBubbleChartSeries> get _visibleSeries => widget.props.series
      .where((s) => !_hiddenSeries.contains(s.name))
      .toList();

  void _toggleSeries(String seriesName) {
    setState(() {
      if (_hiddenSeries.contains(seriesName)) {
        _hiddenSeries.remove(seriesName);
      } else {
        // Prevent hiding every series
        if (_hiddenSeries.length + 1 < widget.props.series.length) {
          _hiddenSeries.add(seriesName);
        } else {
          _hiddenSeries.clear();
        }
      }
      _hoveredBubble = null;
    });
  }

  void _onHover(Offset localPosition, Size canvasSize, List<Color> palette) {
    final chartRect = _calculateChartRect(canvasSize);
    if (!chartRect.contains(localPosition)) {
      if (_hoveredBubble != null) {
        setState(() => _hoveredBubble = null);
      }
      return;
    }

    final activeSeries = _visibleSeries;
    final bounds = _calculateBounds(activeSeries);
    if (bounds == null) return;

    _HoveredBubble? closest;
    double minCenterDist = double.infinity;

    for (int sIdx = 0; sIdx < activeSeries.length; sIdx++) {
      final s = activeSeries[sIdx];
      final color = s.color ?? palette[sIdx % palette.length];

      for (int pIdx = 0; pIdx < s.points.length; pIdx++) {
        final p = s.points[pIdx];
        final center = _pointToCanvas(p, bounds, chartRect);
        final radius = _calculateRadius(
          p.value,
          bounds.minValue,
          bounds.maxValue,
          widget.props.minRadius,
          widget.props.maxRadius,
        );

        final dist = (center - localPosition).distance;
        // Hit-test within bubble radius plus small grace area
        if (dist <= radius + 4.0 && dist < minCenterDist) {
          minCenterDist = dist;
          closest = _HoveredBubble(
            series: s,
            point: p,
            seriesColor: color,
            canvasPosition: center,
            radius: radius,
            pointIndex: pIdx,
          );
        }
      }
    }

    if (closest != _hoveredBubble) {
      setState(() => _hoveredBubble = closest);
    }
  }

  void _onExit() {
    if (_hoveredBubble != null) {
      setState(() => _hoveredBubble = null);
    }
  }

  void _onTap() {
    if (_hoveredBubble != null) {
      widget.props.onBubbleTap?.call(
        _hoveredBubble!.series,
        _hoveredBubble!.point,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = CBubbleChartStyles.categoricalPalette(tokens);

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 400.0;
        final chartSize = Size(chartWidth, widget.props.height);

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
              if (widget.props.showLegend &&
                  widget.props.series.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.v12px075remSpacing04,
                  ),
                  child: _buildLegend(tokens, palette),
                ),
              ],
              SizedBox(
                height: widget.props.height,
                width: chartWidth,
                child: MouseRegion(
                  onHover: (event) =>
                      _onHover(event.localPosition, chartSize, palette),
                  onExit: (_) => _onExit(),
                  child: GestureDetector(
                    onTapDown: (details) {
                      _onHover(details.localPosition, chartSize, palette);
                      _onTap();
                    },
                    onPanUpdate: (details) =>
                        _onHover(details.localPosition, chartSize, palette),
                    onPanEnd: (_) => _onExit(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: chartSize,
                          painter: _BubbleChartPainter(
                            props: widget.props,
                            visibleSeries: _visibleSeries,
                            tokens: tokens,
                            palette: palette,
                            hoveredBubble: _hoveredBubble,
                          ),
                        ),
                        if (_hoveredBubble != null)
                          _buildTooltip(tokens, chartSize),
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

  Widget _buildLegend(AppThemeTokens tokens, List<Color> palette) {
    return Wrap(
      spacing: CBubbleChartStyles.legendSpacing,
      runSpacing: Spacing.v8px05remSpacing03,
      children: [
        for (int i = 0; i < widget.props.series.length; i++) ...[
          _LegendItem(
            name: widget.props.series[i].name,
            color: widget.props.series[i].color ?? palette[i % palette.length],
            textColor: tokens.textSecondary,
            isDisabled: _hiddenSeries.contains(widget.props.series[i].name),
            onTap: () => _toggleSeries(widget.props.series[i].name),
          ),
        ],
      ],
    );
  }

  Widget _buildTooltip(AppThemeTokens tokens, Size canvasSize) {
    final hb = _hoveredBubble!;
    final pos = hb.canvasPosition;

    const tooltipWidth = 160.0;
    const tooltipHeight = 84.0;

    double left = pos.dx - (tooltipWidth / 2);
    double top = pos.dy - hb.radius - tooltipHeight - 10;

    // Boundary clamping
    if (left < 8) left = 8;
    if (left + tooltipWidth > canvasSize.width - 8) {
      left = canvasSize.width - tooltipWidth - 8;
    }
    if (top < 0) {
      top = pos.dy + hb.radius + 10; // Flip below
    }

    final xLabel =
        hb.point.label ??
        (widget.props.xAxisLabels.length > hb.pointIndex
            ? widget.props.xAxisLabels[hb.pointIndex]
            : _formatValue(hb.point.x));

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
                color: Colors.black.withValues(alpha: 0.22),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: hb.seriesColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hb.series.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: tokens.textOnColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'X: $xLabel',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: tokens.textOnColor,
                ),
              ),
              Text(
                'Y: ${_formatValue(hb.point.y)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: tokens.textOnColor,
                ),
              ),
              Text(
                'Size: ${_formatValue(hb.point.value)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: tokens.textOnColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.name,
    required this.color,
    required this.textColor,
    required this.isDisabled,
    required this.onTap,
  });

  final String name;
  final Color color;
  final Color textColor;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: CBubbleChartStyles.legendSwatchSize,
              height: CBubbleChartStyles.legendSwatchSize,
              decoration: BoxDecoration(
                color: isDisabled ? color.withValues(alpha: 0.25) : color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: CBubbleChartStyles.legendSwatchSpacing),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                color: isDisabled
                    ? textColor.withValues(alpha: 0.4)
                    : textColor,
                fontWeight: FontWeight.w400,
                decoration: isDisabled ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoveredBubble {
  const _HoveredBubble({
    required this.series,
    required this.point,
    required this.seriesColor,
    required this.canvasPosition,
    required this.radius,
    required this.pointIndex,
  });

  final CBubbleChartSeries series;
  final CBubbleChartPoint point;
  final Color seriesColor;
  final Offset canvasPosition;
  final double radius;
  final int pointIndex;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HoveredBubble &&
          runtimeType == other.runtimeType &&
          series.name == other.series.name &&
          point.x == other.point.x &&
          point.y == other.point.y &&
          point.value == other.point.value &&
          pointIndex == other.pointIndex;

  @override
  int get hashCode =>
      Object.hash(series.name, point.x, point.y, point.value, pointIndex);
}

class _BubbleBounds {
  const _BubbleBounds({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.minValue,
    required this.maxValue,
  });

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final double minValue;
  final double maxValue;
}

_BubbleBounds? _calculateBounds(List<CBubbleChartSeries> seriesList) {
  if (seriesList.isEmpty) return null;

  double? minX;
  double? maxX;
  double? minY;
  double? maxY;
  double? minVal;
  double? maxVal;

  for (final s in seriesList) {
    for (final p in s.points) {
      minX = minX == null ? p.x : math.min(minX, p.x);
      maxX = maxX == null ? p.x : math.max(maxX, p.x);
      minY = minY == null ? p.y : math.min(minY, p.y);
      maxY = maxY == null ? p.y : math.max(maxY, p.y);
      minVal = minVal == null ? p.value : math.min(minVal, p.value);
      maxVal = maxVal == null ? p.value : math.max(maxVal, p.value);
    }
  }

  if (minX == null ||
      maxX == null ||
      minY == null ||
      maxY == null ||
      minVal == null ||
      maxVal == null) {
    return null;
  }

  // Margin spread for coordinates so outer bubbles don't clip
  if (minX == maxX) {
    minX -= 1;
    maxX += 1;
  } else {
    final span = maxX - minX;
    minX -= span * 0.08;
    maxX += span * 0.08;
  }

  if (minY >= 0) {
    minY = 0;
  } else {
    final span = maxY - minY;
    minY -= span * 0.08;
  }

  if (minY == maxY) {
    maxY = minY + 10;
  } else {
    final span = maxY - minY;
    maxY += span * 0.10;
  }

  return _BubbleBounds(
    minX: minX,
    maxX: maxX,
    minY: minY,
    maxY: maxY,
    minValue: minVal,
    maxValue: maxVal,
  );
}

Rect _calculateChartRect(Size size) {
  const topPadding = 20.0;
  const rightPadding = 20.0;
  return Rect.fromLTRB(
    CBubbleChartStyles.yAxisGutter,
    topPadding,
    math.max(CBubbleChartStyles.yAxisGutter + 20, size.width - rightPadding),
    math.max(topPadding + 20, size.height - CBubbleChartStyles.xAxisGutter),
  );
}

Offset _pointToCanvas(
  CBubbleChartPoint p,
  _BubbleBounds bounds,
  Rect chartRect,
) {
  final dx =
      chartRect.left +
      ((p.x - bounds.minX) / (bounds.maxX - bounds.minX)) * chartRect.width;
  final dy =
      chartRect.bottom -
      ((p.y - bounds.minY) / (bounds.maxY - bounds.minY)) * chartRect.height;
  return Offset(dx, dy);
}

double _calculateRadius(
  double value,
  double minValue,
  double maxValue,
  double minRadius,
  double maxRadius,
) {
  if (maxValue <= minValue) {
    return (minRadius + maxRadius) / 2;
  }
  // Area proportional scaling (radius ~ sqrt(normalized_value))
  final normalized = math.sqrt(
    math.max(0.0, value - minValue) / (maxValue - minValue),
  );
  return minRadius + normalized * (maxRadius - minRadius);
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

class _BubbleDrawable {
  const _BubbleDrawable({
    required this.center,
    required this.radius,
    required this.color,
    required this.point,
    required this.series,
  });

  final Offset center;
  final double radius;
  final Color color;
  final CBubbleChartPoint point;
  final CBubbleChartSeries series;
}

class _BubbleChartPainter extends CustomPainter {
  const _BubbleChartPainter({
    required this.props,
    required this.visibleSeries,
    required this.tokens,
    required this.palette,
    required this.hoveredBubble,
  });

  final CBubbleChartProps props;
  final List<CBubbleChartSeries> visibleSeries;
  final AppThemeTokens tokens;
  final List<Color> palette;
  final _HoveredBubble? hoveredBubble;

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = _calculateChartRect(size);
    final bounds = _calculateBounds(visibleSeries);

    if (bounds == null) {
      _paintEmptyState(canvas, chartRect);
      return;
    }

    // 1. Cartesian Grid & Axes
    if (props.showGridLines) {
      _paintGrid(canvas, chartRect, bounds);
    }

    if (props.showAxes) {
      _paintAxes(canvas, chartRect, bounds);
    }

    // 2. Axis Titles
    if (props.yAxisLabel != null && props.yAxisLabel!.isNotEmpty) {
      _paintYAxisTitle(canvas, chartRect);
    }
    if (props.xAxisLabel != null && props.xAxisLabel!.isNotEmpty) {
      _paintXAxisTitle(canvas, chartRect);
    }

    // 3. Collect and sort all bubbles by radius descending
    final drawables = <_BubbleDrawable>[];
    for (int sIdx = 0; sIdx < visibleSeries.length; sIdx++) {
      final s = visibleSeries[sIdx];
      final color = s.color ?? palette[sIdx % palette.length];

      for (final p in s.points) {
        final center = _pointToCanvas(p, bounds, chartRect);
        final radius = _calculateRadius(
          p.value,
          bounds.minValue,
          bounds.maxValue,
          props.minRadius,
          props.maxRadius,
        );
        drawables.add(
          _BubbleDrawable(
            center: center,
            radius: radius,
            color: color,
            point: p,
            series: s,
          ),
        );
      }
    }

    // Draw larger bubbles first so smaller bubbles are drawn on top
    drawables.sort((a, b) => b.radius.compareTo(a.radius));

    // 4. Render bubbles
    for (final b in drawables) {
      _paintBubble(canvas, b);
    }

    // 5. Active Hover Highlights
    if (hoveredBubble != null) {
      _paintHoverGuidelineAndHalo(canvas, chartRect);
    }
  }

  void _paintEmptyState(Canvas canvas, Rect chartRect) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'No data to display',
        style: TextStyle(
          color: tokens.textPlaceholder,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        chartRect.center.dx - (textPainter.width / 2),
        chartRect.center.dy - (textPainter.height / 2),
      ),
    );
  }

  void _paintGrid(Canvas canvas, Rect chartRect, _BubbleBounds bounds) {
    final gridPaint = Paint()
      ..color = tokens.borderSubtle01
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Horizontal gridlines
    final hCount = CBubbleChartStyles.horizontalGridLineCount;
    for (int i = 0; i <= hCount; i++) {
      final t = i / hCount;
      final yPos = chartRect.bottom - (t * chartRect.height);
      canvas.drawLine(
        Offset(chartRect.left, yPos),
        Offset(chartRect.right, yPos),
        gridPaint,
      );
    }

    // Vertical gridlines
    final vCount = CBubbleChartStyles.verticalGridLineCount;
    for (int i = 0; i <= vCount; i++) {
      final t = i / vCount;
      final xPos = chartRect.left + (t * chartRect.width);
      canvas.drawLine(
        Offset(xPos, chartRect.top),
        Offset(xPos, chartRect.bottom),
        gridPaint,
      );
    }
  }

  void _paintAxes(Canvas canvas, Rect chartRect, _BubbleBounds bounds) {
    final axisPaint = Paint()
      ..color = tokens.borderStrong01
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Baseline (bottom X-axis)
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );

    // Left Y-axis
    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );

    // Y-axis tick labels
    final hCount = CBubbleChartStyles.horizontalGridLineCount;
    for (int i = 0; i <= hCount; i++) {
      final t = i / hCount;
      final yPos = chartRect.bottom - (t * chartRect.height);
      final value = bounds.minY + (t * (bounds.maxY - bounds.minY));

      final textPainter = TextPainter(
        text: TextSpan(
          text: _formatValue(value),
          style: TextStyle(
            color: tokens.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          chartRect.left - textPainter.width - 8,
          yPos - (textPainter.height / 2),
        ),
      );
    }

    // X-axis tick labels
    if (props.xAxisLabels.isNotEmpty) {
      final count = props.xAxisLabels.length;
      for (int i = 0; i < count; i++) {
        final t = count > 1 ? i / (count - 1) : 0.5;
        final xPos = chartRect.left + (t * chartRect.width);

        final textPainter = TextPainter(
          text: TextSpan(
            text: props.xAxisLabels[i],
            style: TextStyle(
              color: tokens.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(xPos - (textPainter.width / 2), chartRect.bottom + 6),
        );
      }
    } else {
      final vCount = CBubbleChartStyles.verticalGridLineCount;
      for (int i = 0; i <= vCount; i++) {
        final t = i / vCount;
        final xPos = chartRect.left + (t * chartRect.width);
        final value = bounds.minX + (t * (bounds.maxX - bounds.minX));

        final textPainter = TextPainter(
          text: TextSpan(
            text: _formatValue(value),
            style: TextStyle(
              color: tokens.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(xPos - (textPainter.width / 2), chartRect.bottom + 6),
        );
      }
    }
  }

  void _paintYAxisTitle(Canvas canvas, Rect chartRect) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: props.yAxisLabel!,
        style: TextStyle(
          color: tokens.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(chartRect.left, chartRect.top - textPainter.height - 4),
    );
  }

  void _paintXAxisTitle(Canvas canvas, Rect chartRect) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: props.xAxisLabel!,
        style: TextStyle(
          color: tokens.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(chartRect.right - textPainter.width, chartRect.bottom + 18),
    );
  }

  void _paintBubble(Canvas canvas, _BubbleDrawable b) {
    final isHovered =
        hoveredBubble != null &&
        hoveredBubble!.series.name == b.series.name &&
        hoveredBubble!.point.x == b.point.x &&
        hoveredBubble!.point.y == b.point.y;

    final fillPaint = Paint()
      ..color = b.color.withValues(
        alpha: isHovered
            ? math.min(1.0, props.bubbleOpacity + 0.2)
            : props.bubbleOpacity,
      )
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = b.color
      ..strokeWidth = isHovered
          ? CBubbleChartStyles.bubbleActiveStrokeWidth
          : CBubbleChartStyles.bubbleStrokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    canvas.drawCircle(b.center, b.radius, fillPaint);
    canvas.drawCircle(b.center, b.radius, strokePaint);
  }

  void _paintHoverGuidelineAndHalo(Canvas canvas, Rect chartRect) {
    final hb = hoveredBubble!;
    final pos = hb.canvasPosition;

    // Crosshair guidelines
    final guidePaint = Paint()
      ..color = tokens.borderInteractive.withValues(alpha: 0.40)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Vertical line down to X-axis
    canvas.drawLine(
      Offset(pos.dx, chartRect.top),
      Offset(pos.dx, chartRect.bottom),
      guidePaint,
    );

    // Horizontal line to Y-axis
    canvas.drawLine(
      Offset(chartRect.left, pos.dy),
      Offset(chartRect.right, pos.dy),
      guidePaint,
    );

    // Outer halo
    final haloPaint = Paint()
      ..color = hb.seriesColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, hb.radius + 6.0, haloPaint);

    // Contrast ring
    final ringPaint = Paint()
      ..color = tokens.layer01
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(pos, hb.radius + 1.5, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _BubbleChartPainter oldDelegate) {
    return oldDelegate.props != props ||
        oldDelegate.visibleSeries != visibleSeries ||
        oldDelegate.tokens != tokens ||
        oldDelegate.palette != palette ||
        oldDelegate.hoveredBubble != hoveredBubble;
  }
}
