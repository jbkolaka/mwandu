import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'bar_chart.props.dart';
import 'bar_chart.styles.dart';

/// A Carbon Design System Bar Chart widget.
///
/// Supports Simple, Grouped, and Stacked bar visualizations in both vertical
/// and horizontal orientations. Built using Carbon Design System layout spacing,
/// typography, categorical color palettes, interactive legends, and hover/touch tooltips.
class CBarChart extends StatefulWidget {
  const CBarChart({super.key, required this.props});

  /// Convenience factory for inline configuration without constructing [CBarChartProps].
  factory CBarChart.inline({
    Key? key,
    required List<CBarChartSeries> series,
    CBarChartVariant variant = CBarChartVariant.grouped,
    CBarChartOrientation orientation = CBarChartOrientation.vertical,
    List<String> categories = const <String>[],
    String? title,
    String? xAxisLabel,
    String? yAxisLabel,
    bool showLegend = true,
    bool showGridLines = true,
    bool showAxes = true,
    double barCornerRadius = 0.0,
    double height = 320.0,
    void Function(CBarChartSeries series, CBarChartItem item)? onBarTap,
  }) {
    return CBarChart(
      key: key,
      props: CBarChartProps(
        series: series,
        variant: variant,
        orientation: orientation,
        categories: categories,
        title: title,
        xAxisLabel: xAxisLabel,
        yAxisLabel: yAxisLabel,
        showLegend: showLegend,
        showGridLines: showGridLines,
        showAxes: showAxes,
        barCornerRadius: barCornerRadius,
        height: height,
        onBarTap: onBarTap,
      ),
    );
  }

  /// Configuration and data of the bar chart.
  final CBarChartProps props;

  @override
  State<CBarChart> createState() => _CBarChartState();
}

class _CBarChartState extends State<CBarChart> {
  _HoveredBar? _hoveredBar;
  final Set<String> _hiddenSeries = <String>{};

  List<CBoundBar> _cachedBars = const [];

  List<CBarChartSeries> get _visibleSeries => widget.props.series
      .where((s) => !_hiddenSeries.contains(s.name))
      .toList();

  List<String> get _resolvedCategories {
    if (widget.props.categories.isNotEmpty) {
      return widget.props.categories;
    }
    final seen = <String>{};
    final ordered = <String>[];
    for (final s in widget.props.series) {
      for (final item in s.items) {
        if (seen.add(item.category)) {
          ordered.add(item.category);
        }
      }
    }
    return ordered;
  }

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
      _hoveredBar = null;
    });
  }

  void _onHover(Offset localPosition, Rect chartRect) {
    if (!chartRect.contains(localPosition)) {
      if (_hoveredBar != null) {
        setState(() => _hoveredBar = null);
      }
      return;
    }

    _HoveredBar? match;
    for (final bar in _cachedBars) {
      if (bar.rect.contains(localPosition)) {
        match = _HoveredBar(
          series: bar.series,
          item: bar.item,
          seriesColor: bar.color,
          barRect: bar.rect,
        );
        break;
      }
    }

    if (match != _hoveredBar) {
      setState(() => _hoveredBar = match);
    }
  }

  void _onExit() {
    if (_hoveredBar != null) {
      setState(() => _hoveredBar = null);
    }
  }

  void _onTap() {
    if (_hoveredBar != null) {
      widget.props.onBarTap?.call(_hoveredBar!.series, _hoveredBar!.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = CBarChartStyles.categoricalPalette(tokens);
    final categories = _resolvedCategories;
    final activeSeries = _visibleSeries;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 400.0;
        final chartSize = Size(chartWidth, widget.props.height);
        final chartRect = _calculateChartRect(
          chartSize,
          widget.props.orientation,
          categories,
        );

        // Pre-compute bar geometries for painting and hit-testing
        _cachedBars = _computeBars(
          props: widget.props,
          visibleSeries: activeSeries,
          categories: categories,
          chartRect: chartRect,
          palette: palette,
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
                  onHover: (event) => _onHover(event.localPosition, chartRect),
                  onExit: (_) => _onExit(),
                  child: GestureDetector(
                    onTapDown: (details) {
                      _onHover(details.localPosition, chartRect);
                      _onTap();
                    },
                    onPanUpdate: (details) =>
                        _onHover(details.localPosition, chartRect),
                    onPanEnd: (_) => _onExit(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: chartSize,
                          painter: _BarChartPainter(
                            props: widget.props,
                            visibleSeries: activeSeries,
                            categories: categories,
                            chartRect: chartRect,
                            bars: _cachedBars,
                            tokens: tokens,
                            hoveredBar: _hoveredBar,
                          ),
                        ),
                        if (_hoveredBar != null)
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
      spacing: CBarChartStyles.legendSpacing,
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
    final hb = _hoveredBar!;
    final rect = hb.barRect;

    const tooltipWidth = 150.0;
    const tooltipHeight = 72.0;

    double left;
    double top;

    if (widget.props.orientation == CBarChartOrientation.vertical) {
      left = rect.center.dx - (tooltipWidth / 2);
      top = rect.top - tooltipHeight - 8;
      if (top < 0) {
        top = rect.bottom + 8;
      }
    } else {
      left = rect.right + 8;
      top = rect.center.dy - (tooltipHeight / 2);
      if (left + tooltipWidth > canvasSize.width - 8) {
        left = rect.left - tooltipWidth - 8;
      }
    }

    // Canvas boundary clamping
    if (left < 8) left = 8;
    if (left + tooltipWidth > canvasSize.width - 8) {
      left = canvasSize.width - tooltipWidth - 8;
    }
    if (top < 0) top = 0;
    if (top + tooltipHeight > canvasSize.height - 8) {
      top = canvasSize.height - tooltipHeight - 8;
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
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(1),
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
                'Category: ${hb.item.category}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: tokens.textOnColor,
                ),
              ),
              Text(
                'Value: ${_formatValue(hb.item.value)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: tokens.textOnColor,
                ),
              ),
              if (hb.item.label != null && hb.item.label!.isNotEmpty) ...[
                Text(
                  hb.item.label!,
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
              width: CBarChartStyles.legendSwatchSize,
              height: CBarChartStyles.legendSwatchSize,
              decoration: BoxDecoration(
                color: isDisabled ? color.withValues(alpha: 0.25) : color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: CBarChartStyles.legendSwatchSpacing),
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

class CBoundBar {
  const CBoundBar({
    required this.rect,
    required this.color,
    required this.series,
    required this.item,
  });

  final Rect rect;
  final Color color;
  final CBarChartSeries series;
  final CBarChartItem item;
}

class _HoveredBar {
  const _HoveredBar({
    required this.series,
    required this.item,
    required this.seriesColor,
    required this.barRect,
  });

  final CBarChartSeries series;
  final CBarChartItem item;
  final Color seriesColor;
  final Rect barRect;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HoveredBar &&
          runtimeType == other.runtimeType &&
          series.name == other.series.name &&
          item.category == other.item.category &&
          item.value == other.item.value &&
          barRect == other.barRect;

  @override
  int get hashCode =>
      Object.hash(series.name, item.category, item.value, barRect);
}

class _NumericBounds {
  const _NumericBounds({required this.minVal, required this.maxVal});

  final double minVal;
  final double maxVal;
}

_NumericBounds _calculateValueBounds(
  List<CBarChartSeries> seriesList,
  List<String> categories,
  CBarChartVariant variant,
) {
  if (seriesList.isEmpty || categories.isEmpty) {
    return const _NumericBounds(minVal: 0, maxVal: 10);
  }

  double minVal = 0.0;
  double maxVal = 0.0;

  if (variant == CBarChartVariant.stacked) {
    for (final cat in categories) {
      double posSum = 0.0;
      double negSum = 0.0;
      for (final s in seriesList) {
        for (final item in s.items) {
          if (item.category == cat) {
            if (item.value >= 0) {
              posSum += item.value;
            } else {
              negSum += item.value;
            }
          }
        }
      }
      maxVal = math.max(maxVal, posSum);
      minVal = math.min(minVal, negSum);
    }
  } else {
    for (final s in seriesList) {
      for (final item in s.items) {
        maxVal = math.max(maxVal, item.value);
        minVal = math.min(minVal, item.value);
      }
    }
  }

  if (minVal >= 0) {
    minVal = 0;
  }
  if (maxVal == minVal) {
    maxVal = minVal + 10;
  }

  // Top padding headroom
  final span = maxVal - minVal;
  maxVal += span * 0.08;

  return _NumericBounds(minVal: minVal, maxVal: maxVal);
}

Rect _calculateChartRect(
  Size size,
  CBarChartOrientation orientation,
  List<String> categories,
) {
  const topPadding = 20.0;
  const rightPadding = 20.0;

  double leftGutter = CBarChartStyles.yAxisGutter;
  if (orientation == CBarChartOrientation.horizontal && categories.isNotEmpty) {
    // Reserve extra gutter for category labels if needed
    leftGutter = math.max(leftGutter, 70.0);
  }

  return Rect.fromLTRB(
    leftGutter,
    topPadding,
    math.max(leftGutter + 20, size.width - rightPadding),
    math.max(topPadding + 20, size.height - CBarChartStyles.xAxisGutter),
  );
}

List<CBoundBar> _computeBars({
  required CBarChartProps props,
  required List<CBarChartSeries> visibleSeries,
  required List<String> categories,
  required Rect chartRect,
  required List<Color> palette,
}) {
  if (visibleSeries.isEmpty || categories.isEmpty) return const [];

  final bounds = _calculateValueBounds(
    visibleSeries,
    categories,
    props.variant,
  );
  final isVertical = props.orientation == CBarChartOrientation.vertical;
  final bars = <CBoundBar>[];

  if (isVertical) {
    final slotWidth = chartRect.width / categories.length;
    final groupWidth = slotWidth * (1.0 - CBarChartStyles.groupPaddingRatio);
    final baselineY =
        chartRect.bottom -
        ((0 - bounds.minVal) / (bounds.maxVal - bounds.minVal)) *
            chartRect.height;

    for (int cIdx = 0; cIdx < categories.length; cIdx++) {
      final category = categories[cIdx];
      final slotLeft = chartRect.left + (cIdx * slotWidth);
      final groupLeft = slotLeft + (slotWidth - groupWidth) / 2;

      if (props.variant == CBarChartVariant.stacked) {
        final barWidth = groupWidth.clamp(
          CBarChartStyles.minBarThickness,
          CBarChartStyles.maxBarThickness,
        );
        final barLeft = groupLeft + (groupWidth - barWidth) / 2;

        double currentPositiveY = baselineY;
        double currentNegativeY = baselineY;

        for (int sIdx = 0; sIdx < visibleSeries.length; sIdx++) {
          final s = visibleSeries[sIdx];
          final color = s.color ?? palette[sIdx % palette.length];
          final item = s.items.firstWhere(
            (it) => it.category == category,
            orElse: () => CBarChartItem(category: category, value: 0),
          );

          if (item.value == 0) continue;

          final valHeight =
              (item.value.abs() / (bounds.maxVal - bounds.minVal)) *
              chartRect.height;

          Rect rect;
          if (item.value > 0) {
            rect = Rect.fromLTRB(
              barLeft,
              currentPositiveY - valHeight,
              barLeft + barWidth,
              currentPositiveY,
            );
            currentPositiveY -= valHeight;
          } else {
            rect = Rect.fromLTRB(
              barLeft,
              currentNegativeY,
              barLeft + barWidth,
              currentNegativeY + valHeight,
            );
            currentNegativeY += valHeight;
          }

          bars.add(CBoundBar(rect: rect, color: color, series: s, item: item));
        }
      } else {
        // Simple or Grouped
        final barCount = visibleSeries.length;
        final totalPadding = (barCount - 1) * CBarChartStyles.barPadding;
        final rawBarWidth = (groupWidth - totalPadding) / barCount;
        final barWidth = rawBarWidth.clamp(
          CBarChartStyles.minBarThickness,
          CBarChartStyles.maxBarThickness,
        );

        for (int sIdx = 0; sIdx < barCount; sIdx++) {
          final s = visibleSeries[sIdx];
          final color = s.color ?? palette[sIdx % palette.length];
          final item = s.items.firstWhere(
            (it) => it.category == category,
            orElse: () => CBarChartItem(category: category, value: 0),
          );

          final barLeft =
              groupLeft + sIdx * (barWidth + CBarChartStyles.barPadding);
          final valY =
              chartRect.bottom -
              ((item.value - bounds.minVal) / (bounds.maxVal - bounds.minVal)) *
                  chartRect.height;

          final topY = math.min(baselineY, valY);
          final bottomY = math.max(baselineY, valY);
          final rect = Rect.fromLTRB(
            barLeft,
            topY,
            barLeft + barWidth,
            bottomY,
          );

          bars.add(CBoundBar(rect: rect, color: color, series: s, item: item));
        }
      }
    }
  } else {
    // Horizontal orientation
    final slotHeight = chartRect.height / categories.length;
    final groupHeight = slotHeight * (1.0 - CBarChartStyles.groupPaddingRatio);
    final baselineX =
        chartRect.left +
        ((0 - bounds.minVal) / (bounds.maxVal - bounds.minVal)) *
            chartRect.width;

    for (int cIdx = 0; cIdx < categories.length; cIdx++) {
      final category = categories[cIdx];
      final slotTop = chartRect.top + (cIdx * slotHeight);
      final groupTop = slotTop + (slotHeight - groupHeight) / 2;

      if (props.variant == CBarChartVariant.stacked) {
        final barHeight = groupHeight.clamp(
          CBarChartStyles.minBarThickness,
          CBarChartStyles.maxBarThickness,
        );
        final barTop = groupTop + (groupHeight - barHeight) / 2;

        double currentPositiveX = baselineX;
        double currentNegativeX = baselineX;

        for (int sIdx = 0; sIdx < visibleSeries.length; sIdx++) {
          final s = visibleSeries[sIdx];
          final color = s.color ?? palette[sIdx % palette.length];
          final item = s.items.firstWhere(
            (it) => it.category == category,
            orElse: () => CBarChartItem(category: category, value: 0),
          );

          if (item.value == 0) continue;

          final valWidth =
              (item.value.abs() / (bounds.maxVal - bounds.minVal)) *
              chartRect.width;

          Rect rect;
          if (item.value > 0) {
            rect = Rect.fromLTRB(
              currentPositiveX,
              barTop,
              currentPositiveX + valWidth,
              barTop + barHeight,
            );
            currentPositiveX += valWidth;
          } else {
            rect = Rect.fromLTRB(
              currentNegativeX - valWidth,
              barTop,
              currentNegativeX,
              barTop + barHeight,
            );
            currentNegativeX -= valWidth;
          }

          bars.add(CBoundBar(rect: rect, color: color, series: s, item: item));
        }
      } else {
        // Simple or Grouped
        final barCount = visibleSeries.length;
        final totalPadding = (barCount - 1) * CBarChartStyles.barPadding;
        final rawBarHeight = (groupHeight - totalPadding) / barCount;
        final barHeight = rawBarHeight.clamp(
          CBarChartStyles.minBarThickness,
          CBarChartStyles.maxBarThickness,
        );

        for (int sIdx = 0; sIdx < barCount; sIdx++) {
          final s = visibleSeries[sIdx];
          final color = s.color ?? palette[sIdx % palette.length];
          final item = s.items.firstWhere(
            (it) => it.category == category,
            orElse: () => CBarChartItem(category: category, value: 0),
          );

          final barTop =
              groupTop + sIdx * (barHeight + CBarChartStyles.barPadding);
          final valX =
              chartRect.left +
              ((item.value - bounds.minVal) / (bounds.maxVal - bounds.minVal)) *
                  chartRect.width;

          final leftX = math.min(baselineX, valX);
          final rightX = math.max(baselineX, valX);
          final rect = Rect.fromLTRB(leftX, barTop, rightX, barTop + barHeight);

          bars.add(CBoundBar(rect: rect, color: color, series: s, item: item));
        }
      }
    }
  }

  return bars;
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

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({
    required this.props,
    required this.visibleSeries,
    required this.categories,
    required this.chartRect,
    required this.bars,
    required this.tokens,
    required this.hoveredBar,
  });

  final CBarChartProps props;
  final List<CBarChartSeries> visibleSeries;
  final List<String> categories;
  final Rect chartRect;
  final List<CBoundBar> bars;
  final AppThemeTokens tokens;
  final _HoveredBar? hoveredBar;

  @override
  void paint(Canvas canvas, Size size) {
    if (visibleSeries.isEmpty || categories.isEmpty) {
      _paintEmptyState(canvas, chartRect);
      return;
    }

    final bounds = _calculateValueBounds(
      visibleSeries,
      categories,
      props.variant,
    );
    final isVertical = props.orientation == CBarChartOrientation.vertical;

    // 1. Gridlines and Axis lines
    if (props.showGridLines) {
      _paintGrid(canvas, bounds, isVertical);
    }
    if (props.showAxes) {
      _paintAxes(canvas, bounds, isVertical);
    }

    // 2. Titles
    if (props.yAxisLabel != null && props.yAxisLabel!.isNotEmpty) {
      _paintYAxisTitle(canvas);
    }
    if (props.xAxisLabel != null && props.xAxisLabel!.isNotEmpty) {
      _paintXAxisTitle(canvas);
    }

    // 3. Render Bars
    for (final bar in bars) {
      final isHovered =
          hoveredBar != null &&
          hoveredBar!.series.name == bar.series.name &&
          hoveredBar!.item.category == bar.item.category &&
          hoveredBar!.item.value == bar.item.value;

      final paint = Paint()
        ..color = isHovered ? bar.color.withValues(alpha: 0.88) : bar.color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      if (props.barCornerRadius > 0) {
        final rrect = RRect.fromRectAndRadius(
          bar.rect,
          Radius.circular(props.barCornerRadius),
        );
        canvas.drawRRect(rrect, paint);
        if (isHovered) {
          final strokePaint = Paint()
            ..color = tokens.textPrimary
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
          canvas.drawRRect(rrect, strokePaint);
        }
      } else {
        canvas.drawRect(bar.rect, paint);
        if (isHovered) {
          final strokePaint = Paint()
            ..color = tokens.textPrimary
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
          canvas.drawRect(bar.rect, strokePaint);
        }
      }
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

  void _paintGrid(Canvas canvas, _NumericBounds bounds, bool isVertical) {
    final gridPaint = Paint()
      ..color = tokens.borderSubtle01
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final gridCount = CBarChartStyles.gridLineCount;

    if (isVertical) {
      for (int i = 0; i <= gridCount; i++) {
        final t = i / gridCount;
        final yPos = chartRect.bottom - (t * chartRect.height);
        canvas.drawLine(
          Offset(chartRect.left, yPos),
          Offset(chartRect.right, yPos),
          gridPaint,
        );
      }
    } else {
      for (int i = 0; i <= gridCount; i++) {
        final t = i / gridCount;
        final xPos = chartRect.left + (t * chartRect.width);
        canvas.drawLine(
          Offset(xPos, chartRect.top),
          Offset(xPos, chartRect.bottom),
          gridPaint,
        );
      }
    }
  }

  void _paintAxes(Canvas canvas, _NumericBounds bounds, bool isVertical) {
    final axisPaint = Paint()
      ..color = tokens.borderStrong01
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Baselines
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );

    final gridCount = CBarChartStyles.gridLineCount;

    if (isVertical) {
      // Numerical Y-axis ticks
      for (int i = 0; i <= gridCount; i++) {
        final t = i / gridCount;
        final yPos = chartRect.bottom - (t * chartRect.height);
        final val = bounds.minVal + (t * (bounds.maxVal - bounds.minVal));

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

      // Categorical X-axis ticks
      final slotWidth = chartRect.width / categories.length;
      for (int i = 0; i < categories.length; i++) {
        final xPos = chartRect.left + (i * slotWidth) + (slotWidth / 2);

        final textPainter = TextPainter(
          text: TextSpan(
            text: categories[i],
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
      // Numerical X-axis ticks
      for (int i = 0; i <= gridCount; i++) {
        final t = i / gridCount;
        final xPos = chartRect.left + (t * chartRect.width);
        final val = bounds.minVal + (t * (bounds.maxVal - bounds.minVal));

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

      // Categorical Y-axis ticks
      final slotHeight = chartRect.height / categories.length;
      for (int i = 0; i < categories.length; i++) {
        final yPos = chartRect.top + (i * slotHeight) + (slotHeight / 2);

        final textPainter = TextPainter(
          text: TextSpan(
            text: categories[i],
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
  }

  void _paintYAxisTitle(Canvas canvas) {
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

  void _paintXAxisTitle(Canvas canvas) {
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

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.props != props ||
        oldDelegate.visibleSeries != visibleSeries ||
        oldDelegate.categories != categories ||
        oldDelegate.chartRect != chartRect ||
        oldDelegate.bars != bars ||
        oldDelegate.tokens != tokens ||
        oldDelegate.hoveredBar != hoveredBar;
  }
}
