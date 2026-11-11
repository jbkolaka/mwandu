import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'contained_list.props.dart';

/// Styling metrics, dimensions, and token bindings for [CContainedList].
abstract final class CContainedListStyles {
  /// Header bar height.
  static const double headerHeight = Spacing.v48px3remSpacing09; // 48.0

  /// Height for a single-line item based on size.
  static double itemHeight(CContainedListSize size, bool hasDescription) {
    if (hasDescription) {
      switch (size) {
        case CContainedListSize.sm:
          return Spacing.v48px3remSpacing09; // 48.0
        case CContainedListSize.md:
          return Spacing.v64px4remSpacing10; // 64.0
        case CContainedListSize.lg:
          return 80.0;
      }
    }

    switch (size) {
      case CContainedListSize.sm:
        return Spacing.v32px2remSpacing07; // 32.0
      case CContainedListSize.md:
        return Spacing.v48px3remSpacing09; // 48.0
      case CContainedListSize.lg:
        return Spacing.v64px4remSpacing10; // 64.0
    }
  }

  /// Primary label font size.
  static double labelFontSize(CContainedListSize size) {
    switch (size) {
      case CContainedListSize.sm:
        return 12.0;
      case CContainedListSize.md:
        return 14.0;
      case CContainedListSize.lg:
        return 16.0;
    }
  }

  /// Secondary description font size.
  static const double descriptionFontSize = 12.0;

  /// Header title font size.
  static const double headerFontSize = 14.0;

  /// Horizontal inset padding for rows.
  static const double horizontalPadding = Spacing.v16px1remSpacing05;

  /// Gap between leading visual and text column.
  static const double iconSpacing = Spacing.v12px075remSpacing04;

  /// Divider line thickness.
  static const double dividerThickness = 1.0;

  /// Border width of the container.
  static const double borderWidth = 1.0;

  /// Icon dimensions for list item icons.
  static const double iconSize = 20.0;

  /// Resolves the background color based on container kind.
  static Color backgroundColor(AppThemeTokens tokens, CContainedListKind kind) {
    return kind == CContainedListKind.onPage ? tokens.layer01 : tokens.layer02;
  }

  /// Border color for outer container and divider rules.
  static Color borderColor(AppThemeTokens tokens) => tokens.borderSubtle01;

  /// Hover background for clickable items.
  static Color hoverColor(AppThemeTokens tokens) => tokens.layerHover01;

  /// Active pressed background for items.
  static Color activeColor(AppThemeTokens tokens) => tokens.layerActive01;
}
