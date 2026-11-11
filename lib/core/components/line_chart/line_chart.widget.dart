import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

import 'line_chart.props.dart';
import 'line_chart.styles.dart';

/// A Carbon Design System line chart widget.
///
/// Visualizes trends over time or continuous intervals for one or more
/// data series. Supports configurable gridlines, axes, data markers,
/// legends, and interactive hover tooltips adhering to Carbon tokens and styles.
class CLineChart extends StatefulWidget {
  const CLineChart({super.key, required this.props});

  /// Convenience factory for inline configuration without constructing [CLineChartProps].
  factory CLineChart.inline({
    Key? key,
    required List<CLineChartSeries> series,
    String? title,
    List<String> xAxisLabels = const <String>[],
    String? yAxisLabel,
    bool showLegend = true,
    bool showGridLines = true,
    bool showDataPoints = true,
    double height = 240,
  }) {
    return CLineChart(
      key: key,
      props: CLineChartProps(
        series: series,
        title: title,
        xAxisLabels: xAxisLabels,
        yAxisLabel: yAxisLabel,
        showLegend: showLegend,
        showGridLines: showGridLines,
        showDataPoints: showDataPoints,
        height: height,
      ),
    );
  }

  /// Configuration and data of the line chart.
  final CLineChartProps props;

  @override
  State<CLineChart> createState() => _CLineChartState();
}

class _CLineChartState extends State<CLineChart> {
  _HoveredPoint? _hoveredPoint;

  void _onHover(Offset localPosition, Size canvasSize, List<Color> palette) {
    final chartRect = _calculateChartRect(canvasSize);
    if (!chartRect.contains(localPosition)) {
      if (_hoveredPoint != null) {
        setState(() => _hoveredPoint = null);
      }
      return;
    }

    final bounds = _calculateBounds(widget.props.series);
    if (bounds == null) return;

    _HoveredPoint? closest;
    double minDistance = double.infinity;

    for (int sIdx = 0; sIdx < widget.props.series.length; sIdx++) {
      final s = widget.props.series[sIdx];
      final color = s.color ?? palette[sIdx % palette.length];

      for (int pIdx = 0; pIdx < s.points.length; pIdx++) {
        final p = s.points[pIdx];
        final canvasPos = _pointToCanvas(p, bounds, chartRect);
        final distance = (canvasPos - localPosition).distance;

        if (distance < minDistance && distance <= 32.0) {
          minDistance = distance;
          closest = _HoveredPoint(
            seriesName: s.name,
            point: p,
            seriesColor: color,
            canvasPosition: canvasPos,
            pointIndex: pIdx,
          );
        }
      }
    }

    if (closest != _hoveredPoint) {
      setState(() => _hoveredPoint = closest);
    }
  }

  void _onExit() {
    if (_hoveredPoint != null) {
      setState(() => _hoveredPoint = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = CLineChartStyles.categoricalPalette(tokens);

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
                    onTapDown: (details) =>
                        _onHover(details.localPosition, chartSize, palette),
                    onPanUpdate: (details) =>
                        _onHover(details.localPosition, chartSize, palette),
                    onPanEnd: (_) => _onExit(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: chartSize,
                          painter: _LineChartPainter(
                            props: widget.props,
                            tokens: tokens,
                            palette: palette,
                            hoveredPoint: _hoveredPoint,
                          ),
                        ),
                        if (_hoveredPoint != null)
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
      spacing: CLineChartStyles.legendSpacing,
      runSpacing: Spacing.v8px05remSpacing03,
      children: [
        for (int i = 0; i < widget.props.series.length; i++) ...[
          _LegendItem(
            name: widget.props.series[i].name,
            color: widget.props.series[i].color ?? palette[i % palette.length],
            textColor: tokens.textSecondary,
          ),
        ],
      ],
    );
  }

  Widget _buildTooltip(AppThemeTokens tokens, Size canvasSize) {
    final hp = _hoveredPoint!;
    final pos = hp.canvasPosition;

    // Position tooltip 12px above the data point, centered horizontally
    const tooltipWidth = 140.0;
    const tooltipHeight = 56.0;

    double left = pos.dx - (tooltipWidth / 2);
    double top = pos.dy - tooltipHeight - 12;

    // Clamp inside canvas bounds
    if (left < 8) left = 8;
    if (left + tooltipWidth > canvasSize.width - 8) {
      left = canvasSize.width - tooltipWidth - 8;
    }
    if (top < 0) {
      top = pos.dy + 14; // Flip below if near the top
    }

    final xLabel =
        hp.point.label ??
        (widget.props.xAxisLabels.length > hp.pointIndex
            ? widget.props.xAxisLabels[hp.pointIndex]
            : _formatValue(hp.point.x));

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        child: Container(
          width: tooltipWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: tokens.backgroundInverse,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                offset: const Offset(0, 2),
                blurRadius: 6,
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
                      color: hp.seriesColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hp.seriesName,
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
              const SizedBox(height: 2),
              Text(
                '$xLabel: ${_formatValue(hp.point.y)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
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
  });

  final String name;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: CLineChartStyles.legendSwatchSize,
          height: CLineChartStyles.legendSwatchSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: CLineChartStyles.legendSwatchSpacing),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _HoveredPoint {
  const _HoveredPoint({
    required this.seriesName,
    required this.point,
    required this.seriesColor,
    required this.canvasPosition,
    required this.pointIndex,
  });

  final String seriesName;
  final CLineChartPoint point;
  final Color seriesColor;
  final Offset canvasPosition;
  final int pointIndex;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HoveredPoint &&
          runtimeType == other.runtimeType &&
          seriesName == other.seriesName &&
          point.x == other.point.x &&
          point.y == other.point.y &&
          pointIndex == other.pointIndex;

  @override
  int get hashCode => Object.hash(seriesName, point.x, point.y, pointIndex);
}

class _ChartBounds {
  const _ChartBounds({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
}

_ChartBounds? _calculateBounds(List<CLineChartSeries> series) {
  if (series.isEmpty) return null;

  double? minX;
  double? maxX;
  double? minY;
  double? maxY;

  for (final s in series) {
    for (final p in s.points) {
      minX = minX == null ? p.x : math.min(minX, p.x);
      maxX = maxX == null ? p.x : math.max(maxX, p.x);
      minY = minY == null ? p.y : math.min(minY, p.y);
      maxY = maxY == null ? p.y : math.max(maxY, p.y);
    }
  }

  if (minX == null || maxX == null || minY == null || maxY == null) {
    return null;
  }

  // Baseline zero if all values are non-negative
  if (minY >= 0) {
    minY = 0;
  }

  // If min and max coincide, give sensible spread
  if (minX == maxX) {
    minX -= 1;
    maxX += 1;
  }
  if (minY == maxY) {
    maxY = minY + 10;
  }

  // 8% top padding headroom for maxY
  final ySpan = maxY - minY;
  maxY += ySpan * 0.08;

  return _ChartBounds(minX: minX, maxX: maxX, minY: minY, maxY: maxY);
}

Rect _calculateChartRect(Size size) {
  const topPadding = 16.0;
  const rightPadding = 16.0;
  return Rect.fromLTRB(
    CLineChartStyles.yAxisGutter,
    topPadding,
    math.max(CLineChartStyles.yAxisGutter + 20, size.width - rightPadding),
    math.max(topPadding + 20, size.height - CLineChartStyles.xAxisGutter),
  );
}

Offset _pointToCanvas(CLineChartPoint p, _ChartBounds bounds, Rect chartRect) {
  final dx =
      chartRect.left +
      ((p.x - bounds.minX) / (bounds.maxX - bounds.minX)) * chartRect.width;
  final dy =
      chartRect.bottom -
      ((p.y - bounds.minY) / (bounds.maxY - bounds.minY)) * chartRect.height;
  return Offset(dx, dy);
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

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({
    required this.props,
    required this.tokens,
    required this.palette,
    required this.hoveredPoint,
  });

  final CLineChartProps props;
  final AppThemeTokens tokens;
  final List<Color> palette;
  final _HoveredPoint? hoveredPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = _calculateChartRect(size);
    final bounds = _calculateBounds(props.series);

    // Empty state if no data
    if (bounds == null) {
      _paintEmptyState(canvas, chartRect);
      return;
    }

    // 1. Draw horizontal grid lines and Y-axis labels
    _paintYAxisAndGrid(canvas, chartRect, bounds);

    // 2. Draw X-axis line and labels
    _paintXAxis(canvas, chartRect, bounds);

    // 3. Draw Y-axis title if present
    if (props.yAxisLabel != null && props.yAxisLabel!.isNotEmpty) {
      _paintYAxisLabel(canvas, chartRect);
    }

    // 4. Draw Series Lines
    for (int sIdx = 0; sIdx < props.series.length; sIdx++) {
      final s = props.series[sIdx];
      if (s.points.isEmpty) continue;

      final color = s.color ?? palette[sIdx % palette.length];
      _paintSeriesLine(canvas, chartRect, bounds, s, color);
    }

    // 5. Draw Data Points
    if (props.showDataPoints) {
      for (int sIdx = 0; sIdx < props.series.length; sIdx++) {
        final s = props.series[sIdx];
        final color = s.color ?? palette[sIdx % palette.length];
        _paintSeriesPoints(canvas, chartRect, bounds, s, color);
      }
    }

    // 6. Draw Hover Guideline and Highlight
    if (hoveredPoint != null) {
      _paintHoverHighlight(canvas, chartRect);
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

  void _paintYAxisAndGrid(Canvas canvas, Rect chartRect, _ChartBounds bounds) {
    final gridPaint = Paint()
      ..color = tokens.borderSubtle01
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final gridCount = CLineChartStyles.gridLineCount;

    for (int i = 0; i <= gridCount; i++) {
      final t = i / gridCount;
      final yPos = chartRect.bottom - (t * chartRect.height);
      final value = bounds.minY + (t * (bounds.maxY - bounds.minY));

      if (props.showGridLines) {
        canvas.drawLine(
          Offset(chartRect.left, yPos),
          Offset(chartRect.right, yPos),
          gridPaint,
        );
      }

      // Y-axis tick label
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
  }

  void _paintXAxis(Canvas canvas, Rect chartRect, _ChartBounds bounds) {
    final axisPaint = Paint()
      ..color = tokens.borderStrong01
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Bottom baseline
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );

    // Left axis line
    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );

    // X-axis tick labels
    if (props.xAxisLabels.isNotEmpty) {
      final labelCount = props.xAxisLabels.length;
      for (int i = 0; i < labelCount; i++) {
        final t = labelCount > 1 ? i / (labelCount - 1) : 0.5;
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
      // Automatic 4 ticks based on bounds.minX and bounds.maxX
      const xTickCount = 4;
      for (int i = 0; i <= xTickCount; i++) {
        final t = i / xTickCount;
        final xPos = chartRect.left + (t * chartRect.width);
        final val = bounds.minX + (t * (bounds.maxX - bounds.minX));

        final textPainter = TextPainter(
          text: TextSpan(
            text: _formatValue(val),
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

  void _paintYAxisLabel(Canvas canvas, Rect chartRect) {
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

  void _paintSeriesLine(
    Canvas canvas,
    Rect chartRect,
    _ChartBounds bounds,
    CLineChartSeries series,
    Color color,
  ) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = CLineChartStyles.lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final path = Path();
    for (int i = 0; i < series.points.length; i++) {
      final pos = _pointToCanvas(series.points[i], bounds, chartRect);
      if (i == 0) {
        path.moveTo(pos.dx, pos.dy);
      } else {
        path.lineTo(pos.dx, pos.dy);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  void _paintSeriesPoints(
    Canvas canvas,
    Rect chartRect,
    _ChartBounds bounds,
    CLineChartSeries series,
    Color color,
  ) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final borderPaint = Paint()
      ..color = tokens.layer01
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (final p in series.points) {
      final pos = _pointToCanvas(p, bounds, chartRect);
      canvas.drawCircle(pos, CLineChartStyles.pointRadius, fillPaint);
      canvas.drawCircle(pos, CLineChartStyles.pointRadius, borderPaint);
    }
  }

  void _paintHoverHighlight(Canvas canvas, Rect chartRect) {
    final hp = hoveredPoint!;
    final pos = hp.canvasPosition;

    // Vertical guideline
    final guidePaint = Paint()
      ..color = tokens.borderInteractive.withOpacity(0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(pos.dx, chartRect.top),
      Offset(pos.dx, chartRect.bottom),
      guidePaint,
    );

    // Outer halo
    final haloPaint = Paint()
      ..color = hp.seriesColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, CLineChartStyles.pointRadius + 4.0, haloPaint);

    // Active center dot
    final activePaint = Paint()
      ..color = hp.seriesColor
      ..style = PaintingStyle.fill;
    final ringPaint = Paint()
      ..color = tokens.layer01
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(pos, CLineChartStyles.pointRadius + 1.5, activePaint);
    canvas.drawCircle(pos, CLineChartStyles.pointRadius + 1.5, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.props != props ||
        oldDelegate.tokens != tokens ||
        oldDelegate.palette != palette ||
        oldDelegate.hoveredPoint != hoveredPoint;
  }
}
