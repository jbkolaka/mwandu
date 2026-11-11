import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Layout and styling constants for [CSankeyChart] adhering to Carbon Design tokens.
abstract final class CSankeyChartStyles {
  /// Default width of a node bar.
  static const double defaultNodeWidth = Spacing.v16px1remSpacing05;

  /// Default vertical gap between nodes in the same column.
  static const double defaultNodePadding = Spacing.v12px075remSpacing04;

  /// Minimum height for any node to remain visually selectable and readable.
  static const double minNodeHeight = Spacing.v8px05remSpacing03;

  /// Default opacity for unhovered flow links.
  static const double linkOpacity = 0.40;

  /// Default opacity for hovered flow links.
  static const double hoveredLinkOpacity = 0.75;

  /// Gap between legend items.
  static const double legendSpacing = Spacing.v16px1remSpacing05;

  /// Size of the color swatch in the legend.
  static const double legendSwatchSize = Spacing.v12px075remSpacing04;

  /// Gap between a legend swatch and its text label.
  static const double legendSwatchSpacing = Spacing.v8px05remSpacing03;

  /// The Carbon 14-color categorical chart palette matching the active theme.
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
