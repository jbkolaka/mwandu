import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Layout and color values of the line chart.
abstract final class CLineChartStyles {
  /// Width of the Y-axis label gutter.
  static const double yAxisGutter = Spacing.v48px3remSpacing09;

  /// Height of the X-axis label gutter.
  static const double xAxisGutter = Spacing.v24px15remSpacing06;

  /// Thickness of a series line.
  static const double lineWidth = Spacing.v2px0125remSpacing01;

  /// Radius of a data point marker.
  static const double pointRadius = Spacing.v4px025remSpacing02;

  /// Number of horizontal grid lines.
  static const int gridLineCount = 4;

  /// Number of vertical grid intervals.
  static const int verticalGridLineCount = 4;

  /// Gap between the legend entries.
  static const double legendSpacing = Spacing.v16px1remSpacing05;

  /// Gap between a legend swatch and its label.
  static const double legendSwatchSpacing = Spacing.v8px05remSpacing03;

  /// Size of the legend swatch.
  static const double legendSwatchSize = Spacing.v12px075remSpacing04;

  /// Default opacity for filled area beneath lines.
  static const double defaultAreaOpacity = 0.20;

  /// The categorical chart palette of the active theme (14 colors).
  static List<Color> categoricalPalette(AppThemeTokens tokens) {
    if (tokens.isDark) {
      return const [
        ThemeGray90Theme.chartsCategoricalFullChartColor01,
        ThemeGray90Theme.chartsCategoricalFullChartColor02,
        ThemeGray90Theme.chartsCategoricalFullChartColor03,
        ThemeGray90Theme.chartsCategoricalFullChartColor04,
        ThemeGray90Theme.chartsCategoricalFullChartColor05,
        ThemeGray90Theme.chartsCategoricalFullChartColor06,
        ThemeGray90Theme.chartsCategoricalFullChartColor07,
        ThemeGray90Theme.chartsCategoricalFullChartColor08,
        ThemeGray90Theme.chartsCategoricalFullChartColor09,
        ThemeGray90Theme.chartsCategoricalFullChartColor10,
        ThemeGray90Theme.chartsCategoricalFullChartColor11,
        ThemeGray90Theme.chartsCategoricalFullChartColor12,
        ThemeGray90Theme.chartsCategoricalFullChartColor13,
        ThemeGray90Theme.chartsCategoricalFullChartColor14,
      ];
    }
    return const [
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
