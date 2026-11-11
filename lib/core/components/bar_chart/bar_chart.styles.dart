import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Layout and styling tokens for [CBarChart].
abstract final class CBarChartStyles {
  /// Width reserved for the Y-axis label gutter.
  static const double yAxisGutter = Spacing.v48px3remSpacing09;

  /// Height reserved for the X-axis label gutter.
  static const double xAxisGutter = Spacing.v24px15remSpacing06;

  /// Number of numerical value grid intervals.
  static const int gridLineCount = 4;

  /// Fraction of category slot allocated as outer margin/padding (0.0 - 1.0).
  static const double groupPaddingRatio = 0.24;

  /// Spacing between bars within a single grouped category.
  static const double barPadding = Spacing.v2px0125remSpacing01;

  /// Maximum thickness of a bar in logical pixels.
  static const double maxBarThickness = 48.0;

  /// Minimum thickness of a bar in logical pixels.
  static const double minBarThickness = 4.0;

  /// Spacing between individual legend items.
  static const double legendSpacing = Spacing.v16px1remSpacing05;

  /// Spacing between a legend item swatch and its label.
  static const double legendSwatchSpacing = Spacing.v8px05remSpacing03;

  /// Size of the rectangular legend swatch.
  static const double legendSwatchSize = Spacing.v12px075remSpacing04;

  /// Retrieves the 14-color Carbon categorical chart palette for the active theme.
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
