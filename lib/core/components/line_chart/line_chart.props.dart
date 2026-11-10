import 'package:flutter/widgets.dart';

/// A single data point of a line chart series.
class CLineChartPoint {
  const CLineChartPoint({required this.x, required this.y, this.label});

  /// Position of the point on the x axis.
  final double x;

  /// Position of the point on the y axis.
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
    this.title,
    this.xAxisLabels = const <String>[],
    this.yAxisLabel,
    this.showLegend = true,
    this.showGridLines = true,
    this.showDataPoints = true,
    this.height = 240,
  });

  /// The series rendered in the chart.
  final List<CLineChartSeries> series;

  /// Optional title rendered above the chart.
  final String? title;

  /// Optional labels for the x axis, in data order.
  final List<String> xAxisLabels;

  /// Optional label for the y axis.
  final String? yAxisLabel;

  /// Whether the series legend is rendered.
  final bool showLegend;

  /// Whether horizontal grid lines are rendered.
  final bool showGridLines;

  /// Whether data points are drawn on the lines.
  final bool showDataPoints;

  /// Height of the chart canvas.
  final double height;
}
