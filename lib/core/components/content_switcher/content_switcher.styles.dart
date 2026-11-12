import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'content_switcher.props.dart';

/// Sizing and theme token bindings for [CContentSwitcher].
abstract final class CContentSwitcherStyles {
  static const double smallHeight = Spacing.v32px2remSpacing07;
  static const double mediumHeight = Spacing.v40px25remSpacing08;
  static const double largeHeight = Spacing.v48px3remSpacing09;
  static const double iconSize = Spacing.v16px1remSpacing05;
  static const double iconGap = Spacing.v8px05remSpacing03;
  static const double horizontalPadding = Spacing.v16px1remSpacing05;
  static const double borderWidth = 1;

  static double height(CContentSwitcherSize size) => switch (size) {
    CContentSwitcherSize.sm => smallHeight,
    CContentSwitcherSize.md => mediumHeight,
    CContentSwitcherSize.lg => largeHeight,
  };

  static Color background(AppThemeTokens tokens) => tokens.isDark
      ? ContentSwitcherGray90Theme.contentSwitcherBackground
      : ContentSwitcher.contentSwitcherBackground;

  static Color selectedBackground(AppThemeTokens tokens) => tokens.isDark
      ? ContentSwitcherGray90Theme.contentSwitcherSelected
      : ContentSwitcher.contentSwitcherSelected;

  static Color selectedBorder(AppThemeTokens tokens) => tokens.borderStrong01;

  static Color foreground(AppThemeTokens tokens) => tokens.textPrimary;

  static Color inactiveForeground(AppThemeTokens tokens) =>
      tokens.textSecondary;
}
