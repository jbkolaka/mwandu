import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'line_chart.props.dart';
import 'line_chart.styles.dart';

/// A Carbon Design System line chart widget.
///
/// Visualizes trends over continuous or categorical intervals supporting:
/// - Simple single-series line
/// - Grouped / Multi-series overlaid lines
/// - Stacked line / area charts
/// - Filled area under lines
/// - Smooth curves or linear segments
/// - Interactive legend with series toggling
/// - Carbon hover and touch tooltips adhering to Carbon tokens
class CLineChart extends StatefulWidget {
  const CLineChart({super.key, required this.props});

  /// Convenience factory for inline configuration without constructing [CLineChartProps].
  factory CLineChart.inline({
    Key? key,
    required List<CLineChartSeries> series,
    CLineChartVariant variant = CLineChartVariant.grouped,
    bool filledArea = false,
    double areaOpacity = 0.20,
    String? title,
    String? xAxisLabel,
    List<String> xAxisLabels = const <String>[],
    String? yAxisLabel,
    bool showLegend = true,
    bool showGridLines = true,
    bool showAxes = true,
    bool showDataPoints = true,
    bool curveSmooth = false,
    double height = 300,
    void Function(CLineChartSeries series, CLineChartPoint point)? onPointTap,
  }) {
    return CLineChart(
      key: key,
      props: CLineChartProps(
        series: series,
        variant: variant,
        filledArea: filledArea,
        areaOpacity: areaOpacity,
        title: title,
        xAxisLabel: xAxisLabel,
        xAxisLabels: xAxisLabels,
        yAxisLabel: yAxisLabel,
        showLegend: showLegend,
        showGridLines: showGridLines,
        showAxes: showAxes,
        showDataPoints: showDataPoints,
        curveSmooth: curveSmooth,
        height: height,
        onPointTap: onPointTap,
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
  final Set<String> _hiddenSeries = <String>{};

  List<CLineChartSeries> get _visibleSeries => widget.props.series
      .where((s) => !_hiddenSeries.contains(s.name))
      .toList();

  void _toggleSeries(String seriesName) {
    setState(() {
      if (_hiddenSeries.contains(seriesName)) {
        _hiddenSeries.remove(seriesName);
      } else {
        if (_hiddenSeries.length + 1 < widget.props.series.length) {
          _hiddenSeries.add(seriesName);
        } else {
          _hiddenSeries.clear();
        }
      }
      _hoveredPoint = null;
    });
  }

  void _onHover(Offset localPosition, Size canvasSize, List<Color> palette) {
    final chartRect = _calculateChartRect(canvasSize);
    if (!chartRect.contains(localPosition)) {
      if (_hoveredPoint != null) {
        setState(() => _hoveredPoint = null);
      }
      return;
    }

    final activeSeries = _visibleSeries;
    final processed = _processSeries(activeSeries, widget.props.variant);
    final bounds = _calculateBounds(processed);
    if (bounds == null) return;

    _HoveredPoint? closest;
    double minDistance = double.infinity;

    for (int sIdx = 0; sIdx < processed.length; sIdx++) {
      final s = processed[sIdx];
      final color = s.originalSeries.color ?? palette[sIdx % palette.length];

      for (int pIdx = 0; pIdx < s.renderPoints.length; pIdx++) {
        final rp = s.renderPoints[pIdx];
        final canvasPos = _pointToCanvas(rp.x, rp.renderY, bounds, chartRect);
        final distance = (canvasPos - localPosition).distance;

        if (distance < minDistance && distance <= 32.0) {
          minDistance = distance;
          closest = _HoveredPoint(
            series: s.originalSeries,
            point: rp.originalPoint,
            renderedY: rp.renderY,
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

  void _onTap() {
    if (_hoveredPoint != null) {
      widget.props.onPointTap?.call(
        _hoveredPoint!.series,
        _hoveredPoint!.point,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = CLineChartStyles.categoricalPalette(tokens);
    final activeSeries = _visibleSeries;

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
                          painter: _LineChartPainter(
                            props: widget.props,
                            visibleSeries: activeSeries,
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
            isDisabled: _hiddenSeries.contains(widget.props.series[i].name),
            onTap: () => _toggleSeries(widget.props.series[i].name),
          ),
        ],
      ],
    );
  }

  Widget _buildTooltip(AppThemeTokens tokens, Size canvasSize) {
    final hp = _hoveredPoint!;
    final pos = hp.canvasPosition;

    const tooltipWidth = 150.0;
    const tooltipHeight = 68.0;

    double left = pos.dx - (tooltipWidth / 2);
    double top = pos.dy - tooltipHeight - 12;

    if (left < 8) left = 8;
    if (left + tooltipWidth > canvasSize.width - 8) {
      left = canvasSize.width - tooltipWidth - 8;
    }
    if (top < 0) {
      top = pos.dy + 14;
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
                      color: hp.seriesColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hp.series.name,
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
                'Y: ${_formatValue(hp.point.y)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: tokens.textOnColor,
                ),
              ),
              if (widget.props.variant == CLineChartVariant.stacked) ...[
                Text(
                  'Cumulative: ${_formatValue(hp.renderedY)}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: tokens.textOnColor.withValues(alpha: 0.85),
                  ),
                ),
              ],
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
              width: CLineChartStyles.legendSwatchSize,
              height: CLineChartStyles.legendSwatchSize,
              decoration: BoxDecoration(
                color: isDisabled ? color.withValues(alpha: 0.25) : color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: CLineChartStyles.legendSwatchSpacing),
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

class _HoveredPoint {
  const _HoveredPoint({
    required this.series,
    required this.point,
    required this.renderedY,
    required this.seriesColor,
    required this.canvasPosition,
    required this.pointIndex,
  });

  final CLineChartSeries series;
  final CLineChartPoint point;
  final double renderedY;
  final Color seriesColor;
  final Offset canvasPosition;
  final int pointIndex;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HoveredPoint &&
          runtimeType == other.runtimeType &&
          series.name == other.series.name &&
          point.x == other.point.x &&
          point.y == other.point.y &&
          pointIndex == other.pointIndex;

  @override
  int get hashCode => Object.hash(series.name, point.x, point.y, pointIndex);
}

class _ProcessedPoint {
  const _ProcessedPoint({
    required this.x,
    required this.baselineY,
    required this.renderY,
    required this.originalPoint,
  });

  final double x;
  final double baselineY;
  final double renderY;
  final CLineChartPoint originalPoint;
}

class _ProcessedSeries {
  const _ProcessedSeries({
    required this.originalSeries,
    required this.renderPoints,
  });

  final CLineChartSeries originalSeries;
  final List<_ProcessedPoint> renderPoints;
}

List<_ProcessedSeries> _processSeries(
  List<CLineChartSeries> seriesList,
  CLineChartVariant variant,
) {
  if (seriesList.isEmpty) return const [];

  if (variant != CLineChartVariant.stacked) {
    return seriesList.map((s) {
      final sortedPoints = List<CLineChartPoint>.from(s.points)
        ..sort((a, b) => a.x.compareTo(b.x));
      return _ProcessedSeries(
        originalSeries: s,
        renderPoints: sortedPoints
            .map(
              (p) => _ProcessedPoint(
                x: p.x,
                baselineY: 0.0,
                renderY: p.y,
                originalPoint: p,
              ),
            )
            .toList(),
      );
    }).toList();
  }

  // Stacked variant: align points across shared X coordinates
  final uniqueX = <double>{};
  for (final s in seriesList) {
    for (final p in s.points) {
      uniqueX.add(p.x);
    }
  }
  final sortedX = uniqueX.toList()..sort();

  final cumulativeY = {for (final x in sortedX) x: 0.0};
  final result = <_ProcessedSeries>[];

  for (final s in seriesList) {
    final pointMap = {for (final p in s.points) p.x: p};
    final renderPoints = <_ProcessedPoint>[];

    for (final x in sortedX) {
      final origPoint = pointMap[x] ?? CLineChartPoint(x: x, y: 0.0);
      final prevCum = cumulativeY[x]!;
      final nextCum = prevCum + origPoint.y;
      cumulativeY[x] = nextCum;

      renderPoints.add(
        _ProcessedPoint(
          x: x,
          baselineY: prevCum,
          renderY: nextCum,
          originalPoint: origPoint,
        ),
      );
    }

    result.add(_ProcessedSeries(originalSeries: s, renderPoints: renderPoints));
  }

  return result;
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

_ChartBounds? _calculateBounds(List<_ProcessedSeries> series) {
  if (series.isEmpty) return null;

  double? minX;
  double? maxX;
  double? minY;
  double? maxY;

  for (final s in series) {
    for (final p in s.renderPoints) {
      minX = minX == null ? p.x : math.min(minX, p.x);
      maxX = maxX == null ? p.x : math.max(maxX, p.x);
      minY = minY == null ? p.renderY : math.min(minY, p.renderY);
      minY = math.min(minY, p.baselineY);
      maxY = maxY == null ? p.renderY : math.max(maxY, p.renderY);
    }
  }

  if (minX == null || maxX == null || minY == null || maxY == null) {
    return null;
  }

  if (minY >= 0) {
    minY = 0;
  }
  if (minX == maxX) {
    minX -= 1;
    maxX += 1;
  }
  if (minY == maxY) {
    maxY = minY + 10;
  }

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

Offset _pointToCanvas(double x, double y, _ChartBounds bounds, Rect chartRect) {
  final dx =
      chartRect.left +
      ((x - bounds.minX) / (bounds.maxX - bounds.minX)) * chartRect.width;
  final dy =
      chartRect.bottom -
      ((y - bounds.minY) / (bounds.maxY - bounds.minY)) * chartRect.height;
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
    required this.visibleSeries,
    required this.tokens,
    required this.palette,
    required this.hoveredPoint,
  });

  final CLineChartProps props;
  final List<CLineChartSeries> visibleSeries;
  final AppThemeTokens tokens;
  final List<Color> palette;
  final _HoveredPoint? hoveredPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = _calculateChartRect(size);
    final processed = _processSeries(visibleSeries, props.variant);
    final bounds = _calculateBounds(processed);

    if (bounds == null) {
      _paintEmptyState(canvas, chartRect);
      return;
    }

    // 1. Gridlines
    if (props.showGridLines) {
      _paintYAxisAndGrid(canvas, chartRect, bounds);
    }

    // 2. Axes
    if (props.showAxes) {
      _paintAxes(canvas, chartRect, bounds);
    }

    // 3. Axis Titles
    if (props.yAxisLabel != null && props.yAxisLabel!.isNotEmpty) {
      _paintYAxisLabel(canvas, chartRect);
    }
    if (props.xAxisLabel != null && props.xAxisLabel!.isNotEmpty) {
      _paintXAxisLabel(canvas, chartRect);
    }

    // 4. Draw Filled Areas (under lines / between stacks)
    final shouldFill =
        props.filledArea || props.variant == CLineChartVariant.stacked;
    if (shouldFill) {
      for (int sIdx = 0; sIdx < processed.length; sIdx++) {
        final s = processed[sIdx];
        if (s.renderPoints.isEmpty) continue;
        final color = s.originalSeries.color ?? palette[sIdx % palette.length];
        _paintSeriesArea(canvas, chartRect, bounds, s, color);
      }
    }

    // 5. Draw Series Lines
    for (int sIdx = 0; sIdx < processed.length; sIdx++) {
      final s = processed[sIdx];
      if (s.renderPoints.isEmpty) continue;
      final color = s.originalSeries.color ?? palette[sIdx % palette.length];
      _paintSeriesLine(canvas, chartRect, bounds, s, color);
    }

    // 6. Draw Data Point Markers
    if (props.showDataPoints) {
      for (int sIdx = 0; sIdx < processed.length; sIdx++) {
        final s = processed[sIdx];
        final color = s.originalSeries.color ?? palette[sIdx % palette.length];
        _paintSeriesPoints(canvas, chartRect, bounds, s, color);
      }
    }

    // 7. Hover Guideline & Highlight Halo
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

      canvas.drawLine(
        Offset(chartRect.left, yPos),
        Offset(chartRect.right, yPos),
        gridPaint,
      );

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

  void _paintAxes(Canvas canvas, Rect chartRect, _ChartBounds bounds) {
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

  void _paintXAxisLabel(Canvas canvas, Rect chartRect) {
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

  void _paintSeriesArea(
    Canvas canvas,
    Rect chartRect,
    _ChartBounds bounds,
    _ProcessedSeries series,
    Color color,
  ) {
    final fillPaint = Paint()
      ..color = color.withValues(alpha: props.areaOpacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final topOffsets = series.renderPoints
        .map((p) => _pointToCanvas(p.x, p.renderY, bounds, chartRect))
        .toList();
    final bottomOffsets = series.renderPoints
        .map((p) => _pointToCanvas(p.x, p.baselineY, bounds, chartRect))
        .toList();

    final path = Path();
    if (props.curveSmooth && topOffsets.length > 2) {
      _buildSmoothCurve(path, topOffsets, startNew: true);
      for (int i = bottomOffsets.length - 1; i >= 0; i--) {
        path.lineTo(bottomOffsets[i].dx, bottomOffsets[i].dy);
      }
    } else {
      path.moveTo(topOffsets.first.dx, topOffsets.first.dy);
      for (int i = 1; i < topOffsets.length; i++) {
        path.lineTo(topOffsets[i].dx, topOffsets[i].dy);
      }
      for (int i = bottomOffsets.length - 1; i >= 0; i--) {
        path.lineTo(bottomOffsets[i].dx, bottomOffsets[i].dy);
      }
    }
    path.close();

    canvas.drawPath(path, fillPaint);
  }

  void _paintSeriesLine(
    Canvas canvas,
    Rect chartRect,
    _ChartBounds bounds,
    _ProcessedSeries series,
    Color color,
  ) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = CLineChartStyles.lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final offsets = series.renderPoints
        .map((p) => _pointToCanvas(p.x, p.renderY, bounds, chartRect))
        .toList();

    final path = Path();
    if (props.curveSmooth && offsets.length > 2) {
      _buildSmoothCurve(path, offsets, startNew: true);
    } else {
      for (int i = 0; i < offsets.length; i++) {
        if (i == 0) {
          path.moveTo(offsets[i].dx, offsets[i].dy);
        } else {
          path.lineTo(offsets[i].dx, offsets[i].dy);
        }
      }
    }

    canvas.drawPath(path, linePaint);
  }

  void _buildSmoothCurve(
    Path path,
    List<Offset> points, {
    bool startNew = false,
  }) {
    if (startNew) {
      path.moveTo(points.first.dx, points.first.dy);
    } else {
      path.lineTo(points.first.dx, points.first.dy);
    }

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : p2;

      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
  }

  void _paintSeriesPoints(
    Canvas canvas,
    Rect chartRect,
    _ChartBounds bounds,
    _ProcessedSeries series,
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

    for (final p in series.renderPoints) {
      final pos = _pointToCanvas(p.x, p.renderY, bounds, chartRect);
      canvas.drawCircle(pos, CLineChartStyles.pointRadius, fillPaint);
      canvas.drawCircle(pos, CLineChartStyles.pointRadius, borderPaint);
    }
  }

  void _paintHoverHighlight(Canvas canvas, Rect chartRect) {
    final hp = hoveredPoint!;
    final pos = hp.canvasPosition;

    // Vertical guideline
    final guidePaint = Paint()
      ..color = tokens.borderInteractive.withValues(alpha: 0.40)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(pos.dx, chartRect.top),
      Offset(pos.dx, chartRect.bottom),
      guidePaint,
    );

    // Outer halo
    final haloPaint = Paint()
      ..color = hp.seriesColor.withValues(alpha: 0.20)
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
        oldDelegate.visibleSeries != visibleSeries ||
        oldDelegate.tokens != tokens ||
        oldDelegate.palette != palette ||
        oldDelegate.hoveredPoint != hoveredPoint;
  }
}
