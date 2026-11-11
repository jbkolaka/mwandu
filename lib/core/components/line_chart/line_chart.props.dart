import 'package:flutter/widgets.dart';

/// Variant style of the line chart.
enum CLineChartVariant {
  /// Single line series visualization.
  simple,

  /// Multiple independent lines drawn on the same Cartesian plane.
  grouped,

  /// Lines stacked cumulatively on top of preceding series.
  stacked,
}

/// A single data point of a line chart series.
class CLineChartPoint {
  const CLineChartPoint({required this.x, required this.y, this.label});

  /// Position of the point on the X axis.
  final double x;

  /// Position of the point on the Y axis.
  final double y;

  /// Optional label shown for this point.
  final String? label;
}

/// A named series of points rendered as a line.
class CLineChartSeries {
  const CLineChartSeries({
    required this.name,
    required this.points,
    this.color,
  });

  /// Name of the series, shown in the legend.
  final String name;

  /// The points of this series.
  final List<CLineChartPoint> points;

  /// Optional override for the series color. When omitted the categorical
  /// chart palette from the active theme is used.
  final Color? color;
}

/// Configuration of the [CLineChart].
class CLineChartProps {
  const CLineChartProps({
    required this.series,
    this.variant = CLineChartVariant.grouped,
    this.filledArea = false,
    this.areaOpacity = 0.20,
    this.title,
    this.xAxisLabel,
    this.xAxisLabels = const <String>[],
    this.yAxisLabel,
    this.showLegend = true,
    this.showGridLines = true,
    this.showAxes = true,
    this.showDataPoints = true,
    this.curveSmooth = false,
    this.height = 300,
    this.onPointTap,
  });

  /// The series rendered in the chart.
  final List<CLineChartSeries> series;

  /// Line chart layout variant (simple, grouped, or stacked).
  final CLineChartVariant variant;

  /// Whether the area under each line is filled with a translucent tint.
  final bool filledArea;

  /// Opacity of the filled area beneath the line (0.0 - 1.0).
  final double areaOpacity;

  /// Optional title rendered above the chart.
  final String? title;

  /// Optional label for the horizontal X axis.
  final String? xAxisLabel;

  /// Optional labels for the X axis ticks, in data order.
  final List<String> xAxisLabels;

  /// Optional label for the vertical Y axis.
  final String? yAxisLabel;

  /// Whether the series legend is rendered.
  final bool showLegend;

  /// Whether horizontal grid lines are rendered.
  final bool showGridLines;

  /// Whether Cartesian axis lines are drawn.
  final bool showAxes;

  /// Whether data points are drawn on the lines.
  final bool showDataPoints;

  /// Whether lines use smooth cubic bezier curves or straight segments.
  final bool curveSmooth;

  /// Height of the chart canvas.
  final double height;

  /// Callback invoked when a data point marker is tapped.
  final void Function(CLineChartSeries series, CLineChartPoint point)?
  onPointTap;
}
