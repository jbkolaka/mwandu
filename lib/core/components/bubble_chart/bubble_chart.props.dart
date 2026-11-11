import 'package:flutter/widgets.dart';

/// A single data point in a Carbon Bubble Chart.
///
/// Represents a 3-dimensional data point:
/// - [x]: Cartesian coordinate along the horizontal axis.
/// - [y]: Cartesian coordinate along the vertical axis.
/// - [value]: Numerical magnitude determining the size/area of the bubble.
/// - [label]: Optional descriptive label displayed in tooltips.
class CBubbleChartPoint {
  const CBubbleChartPoint({
    required this.x,
    required this.y,
    required this.value,
    this.label,
  });

  /// Position of the point on the X axis.
  final double x;

  /// Position of the point on the Y axis.
  final double y;

  /// Magnitude of the point, mapped proportionally to bubble area.
  final double value;

  /// Optional label shown for this point in tooltips or callouts.
  final String? label;
}

/// A named categorical group/series of bubbles in [CBubbleChart].
class CBubbleChartSeries {
  const CBubbleChartSeries({
    required this.name,
    required this.points,
    this.color,
  });

  /// Name of the series, displayed in the legend and tooltips.
  final String name;

  /// The data points belonging to this series.
  final List<CBubbleChartPoint> points;

  /// Optional color override. When null, the active theme's categorical
  /// palette is used.
  final Color? color;
}

/// Configuration and data properties for [CBubbleChart].
class CBubbleChartProps {
  const CBubbleChartProps({
    required this.series,
    this.title,
    this.xAxisLabel,
    this.yAxisLabel,
    this.xAxisLabels = const <String>[],
    this.showLegend = true,
    this.showGridLines = true,
    this.showAxes = true,
    this.minRadius = 6.0,
    this.maxRadius = 28.0,
    this.bubbleOpacity = 0.70,
    this.height = 320.0,
    this.onBubbleTap,
  });

  /// The series rendered in the chart.
  final List<CBubbleChartSeries> series;

  /// Optional chart title rendered above the canvas.
  final String? title;

  /// Optional descriptive title for the X axis.
  final String? xAxisLabel;

  /// Optional descriptive title for the Y axis.
  final String? yAxisLabel;

  /// Optional discrete labels for the X axis ticks.
  final List<String> xAxisLabels;

  /// Whether the series legend is rendered.
  final bool showLegend;

  /// Whether Cartesian grid lines are drawn.
  final bool showGridLines;

  /// Whether coordinate axes and tick marks are drawn.
  final bool showAxes;

  /// Minimum rendered bubble radius in logical pixels.
  final double minRadius;

  /// Maximum rendered bubble radius in logical pixels.
  final double maxRadius;

  /// Opacity applied to the bubble fill color (0.0 - 1.0).
  final double bubbleOpacity;

  /// Canvas height of the chart.
  final double height;

  /// Callback invoked when a bubble is tapped.
  final void Function(CBubbleChartSeries series, CBubbleChartPoint point)?
  onBubbleTap;
}
