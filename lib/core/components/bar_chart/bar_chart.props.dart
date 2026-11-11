import 'package:flutter/widgets.dart';

/// Variant style of the bar chart.
enum CBarChartVariant {
  /// Single or independent series of bars.
  simple,

  /// Clustered bars side-by-side for each category.
  grouped,

  /// Bars stacked on top of or next to each other per category.
  stacked,
}

/// Rendering orientation of the bars.
enum CBarChartOrientation {
  /// Bars extend vertically from the bottom baseline.
  vertical,

  /// Bars extend horizontally from the left baseline.
  horizontal,
}

/// A single datum in a bar chart series.
class CBarChartItem {
  const CBarChartItem({
    required this.category,
    required this.value,
    this.label,
  });

  /// Category or interval key (e.g., 'Q1', '2024', 'Engineering').
  final String category;

  /// Numerical value of the bar.
  final double value;

  /// Optional custom label shown in tooltips.
  final String? label;
}

/// A named series of bar data points.
class CBarChartSeries {
  const CBarChartSeries({required this.name, required this.items, this.color});

  /// Name of the series, shown in the legend and tooltips.
  final String name;

  /// The data items in this series.
  final List<CBarChartItem> items;

  /// Optional color override. When omitted, the theme categorical palette is used.
  final Color? color;
}

/// Configuration and data properties for [CBarChart].
class CBarChartProps {
  const CBarChartProps({
    required this.series,
    this.variant = CBarChartVariant.grouped,
    this.orientation = CBarChartOrientation.vertical,
    this.categories = const <String>[],
    this.title,
    this.xAxisLabel,
    this.yAxisLabel,
    this.showLegend = true,
    this.showGridLines = true,
    this.showAxes = true,
    this.barCornerRadius = 0.0,
    this.height = 320.0,
    this.onBarTap,
  });

  /// The series rendered in the chart.
  final List<CBarChartSeries> series;

  /// Chart layout variant (simple, grouped, or stacked).
  final CBarChartVariant variant;

  /// Orientation of the bars (vertical or horizontal).
  final CBarChartOrientation orientation;

  /// Explicit category list preserving order. If omitted, categories are
  /// inferred from the series in order of discovery.
  final List<String> categories;

  /// Optional chart title rendered above the canvas.
  final String? title;

  /// Optional label for the horizontal axis.
  final String? xAxisLabel;

  /// Optional label for the vertical axis.
  final String? yAxisLabel;

  /// Whether the series legend is rendered.
  final bool showLegend;

  /// Whether background grid lines are rendered.
  final bool showGridLines;

  /// Whether coordinate axes are rendered.
  final bool showAxes;

  /// Optional corner radius for the outer tip of each bar.
  final double barCornerRadius;

  /// Canvas height of the chart.
  final double height;

  /// Callback invoked when a bar is tapped.
  final void Function(CBarChartSeries series, CBarChartItem item)? onBarTap;
}
