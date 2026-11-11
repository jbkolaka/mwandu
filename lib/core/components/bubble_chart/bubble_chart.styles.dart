import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Layout, typography, and color tokens for [CBubbleChart].
abstract final class CBubbleChartStyles {
  /// Width reserved for the Y-axis label gutter.
  static const double yAxisGutter = Spacing.v48px3remSpacing09;

  /// Height reserved for the X-axis label gutter.
  static const double xAxisGutter = Spacing.v24px15remSpacing06;

  /// Stroke width for normal bubble outlines.
  static const double bubbleStrokeWidth = Spacing.v2px0125remSpacing01;

  /// Stroke width for highlighted or hovered bubbles.
  static const double bubbleActiveStrokeWidth = 2.5;

  /// Default fill opacity for bubble interiors adhering to Carbon design.
  static const double bubbleFillOpacity = 0.70;

  /// Number of horizontal grid intervals.
  static const int horizontalGridLineCount = 4;

  /// Number of vertical grid intervals.
  static const int verticalGridLineCount = 4;

  /// Spacing between individual legend items.
  static const double legendSpacing = Spacing.v16px1remSpacing05;

  /// Spacing between a legend item's colored swatch and its label.
  static const double legendSwatchSpacing = Spacing.v8px05remSpacing03;

  /// Diameter of the legend circular swatch.
  static const double legendSwatchSize = Spacing.v12px075remSpacing04;

  /// Retrieves the 14-color Carbon categorical chart palette for the active theme.
  ///
  /// Uses [ThemeGray90Theme] when in dark mode and [ThemeWhiteTheme] when in light mode.
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
