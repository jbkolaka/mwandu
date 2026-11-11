import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'menu.props.dart';

/// Styling metrics, dimensions, and theme token bindings for [CMenu].
abstract final class CMenuStyles {
  /// Vertical height of a menu item for each [CMenuSize].
  static double itemHeight(CMenuSize size) {
    switch (size) {
      case CMenuSize.sm:
        return Spacing.v32px2remSpacing07; // 32.0
      case CMenuSize.md:
        return Spacing.v40px25remSpacing08; // 40.0
      case CMenuSize.lg:
        return Spacing.v48px3remSpacing09; // 48.0
    }
  }

  /// Font size for each [CMenuSize].
  static double fontSize(CMenuSize size) {
    switch (size) {
      case CMenuSize.sm:
        return 12.0;
      case CMenuSize.md:
        return 14.0;
      case CMenuSize.lg:
        return 16.0;
    }
  }

  /// Horizontal padding inside each menu item.
  static const double horizontalPadding = Spacing.v16px1remSpacing05;

  /// Gap between leading icon and label.
  static const double iconSpacing = Spacing.v12px075remSpacing04;

  /// Gap between label and shortcut text or trailing caret.
  static const double trailingSpacing = Spacing.v16px1remSpacing05;

  /// Size of leading icons in logical pixels.
  static const double iconSize = 16.0;

  /// Caret icon size for submenus.
  static const double caretSize = 16.0;

  /// Thickness of horizontal divider line.
  static const double dividerThickness = 1.0;

  /// Vertical margin around dividers.
  static const double dividerMargin = Spacing.v4px025remSpacing02;

  /// Border width for the menu container.
  static const double borderWidth = 1.0;

  /// Background color of the menu container.
  static Color backgroundColor(AppThemeTokens tokens) => tokens.layer01;

  /// Border color of the menu container.
  static Color borderColor(AppThemeTokens tokens) => tokens.borderSubtle01;

  /// Hover background color for standard items.
  static Color hoverColor(AppThemeTokens tokens) => tokens.layerHover01;

  /// Selected background color for toggle items.
  static Color selectedColor(AppThemeTokens tokens) => tokens.layerSelected01;

  /// Text color for standard items.
  static Color textPrimaryColor(AppThemeTokens tokens) => tokens.textPrimary;

  /// Text color for keyboard shortcut indicators.
  static Color textShortcutColor(AppThemeTokens tokens) => tokens.textHelper;

  /// Text and icon color for disabled items.
  static Color textDisabledColor(AppThemeTokens tokens) => tokens.textDisabled;

  /// Danger / destructive action text color.
  static Color dangerColor(AppThemeTokens tokens) => tokens.supportError;
}
