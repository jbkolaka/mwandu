import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'tabs.props.dart';

/// Sizing and semantic color bindings for [CTabs].
abstract final class CTabsStyles {
  static const double smallTabHeight = Spacing.v40px25remSpacing08;
  static const double mediumTabHeight = Spacing.v48px3remSpacing09;
  static const double largeTabHeight = Spacing.v64px4remSpacing10;
  static const double tabHorizontalPadding = Spacing.v16px1remSpacing05;
  static const double tabVerticalPadding = Spacing.v8px05remSpacing03;
  static const double iconSize = Spacing.v16px1remSpacing05;
  static const double iconGap = Spacing.v8px05remSpacing03;
  static const double indicatorWidth = Spacing.v2px0125remSpacing01;
  static const double separatorWidth = 1;
  static const double labelFontSize = 14;

  static double tabHeight(CTabsSize size) => switch (size) {
    CTabsSize.sm => smallTabHeight,
    CTabsSize.md => mediumTabHeight,
    CTabsSize.lg => largeTabHeight,
  };

  static Color background(AppThemeTokens tokens) => tokens.layer01;
  static Color text(AppThemeTokens tokens) => tokens.textPrimary;
  static Color inactiveText(AppThemeTokens tokens) => tokens.textSecondary;
  static Color disabledText(AppThemeTokens tokens) => tokens.textDisabled;
  static Color indicator(AppThemeTokens tokens) => tokens.linkPrimary;
  static Color separator(AppThemeTokens tokens) => tokens.borderSubtle01;
  static Color hover(AppThemeTokens tokens) => tokens.layerHover01;
  static Color focus(AppThemeTokens tokens) => tokens.focus;
}
