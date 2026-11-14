import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Styling metrics and token resolvers for Carbon Structured List.
abstract final class CStructuredListStyles {
  /// Vertical padding for standard density rows.
  static const double standardVerticalPadding =
      Spacing.v16px1remSpacing05; // 16.0

  /// Vertical padding for condensed rows.
  static const double condensedVerticalPadding =
      Spacing.v8px05remSpacing03; // 8.0

  /// Horizontal padding between cell content and column borders.
  static const double cellHorizontalPadding =
      Spacing.v16px1remSpacing05; // 16.0

  /// Checkmark icon size in selectable rows.
  static const double selectionIconSize = Spacing.v16px1remSpacing05; // 16.0

  /// Width of the dedicated selection column.
  static const double selectionColumnWidth = Spacing.v48px3remSpacing09; // 48.0

  /// Font size for column header titles.
  static const double headFontSize = 12.0;

  /// Font weight for column header titles.
  static const FontWeight headFontWeight = FontWeight.w600;

  /// Font size for body row cell text.
  static const double bodyFontSize = 14.0;

  /// Font weight for body row cell text.
  static const FontWeight bodyFontWeight = FontWeight.w400;

  /// Dividing border stroke width between rows.
  static const double borderWidth = 1.0;

  /// Resolves cell padding based on condensed mode and flush mode.
  static EdgeInsets cellPadding({
    required bool isCondensed,
    required bool isFlush,
    required bool isFirst,
    required bool isLast,
  }) {
    final double v = isCondensed
        ? condensedVerticalPadding
        : standardVerticalPadding;
    final double left = (isFlush && isFirst) ? 0.0 : cellHorizontalPadding;
    final double right = (isFlush && isLast) ? 0.0 : cellHorizontalPadding;

    return EdgeInsets.only(top: v, bottom: v, left: left, right: right);
  }

  /// Resolves the dividing border color.
  static Color borderColor(AppThemeTokens tokens) => tokens.borderSubtle01;

  /// Resolves the header text color.
  static Color headTextColor(AppThemeTokens tokens) => tokens.textPrimary;

  /// Resolves the body cell text color.
  static Color bodyTextColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textPrimary;
  }

  /// Resolves row background color based on selection, hover, and disabled state.
  static Color rowBackgroundColor({
    required AppThemeTokens tokens,
    required bool selected,
    required bool hovered,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.background;
    }
    if (selected) {
      return tokens.layerSelected01;
    }
    if (hovered) {
      return tokens.layerHover01;
    }
    return tokens.background;
  }

  /// Resolves selection checkmark icon color.
  static Color checkmarkColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.interactive;
  }
}
