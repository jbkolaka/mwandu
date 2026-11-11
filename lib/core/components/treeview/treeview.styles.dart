import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'treeview.props.dart';

/// Row dimensions and semantic theme colors for [CTreeView].
abstract final class CTreeViewStyles {
  static const double smallRowHeight = Spacing.v32px2remSpacing07;
  static const double mediumRowHeight = Spacing.v40px25remSpacing08;
  static const double largeRowHeight = Spacing.v48px3remSpacing09;
  static const double rowHorizontalPadding = Spacing.v8px05remSpacing03;
  static const double rowIndent = Spacing.v16px1remSpacing05;
  static const double disclosureSize = Spacing.v24px15remSpacing06;
  static const double iconSize = Spacing.v16px1remSpacing05;
  static const double iconGap = Spacing.v8px05remSpacing03;
  static const double labelFontSize = 14;
  static const double focusWidth = 2;

  static double rowHeight(CTreeViewSize size) => switch (size) {
    CTreeViewSize.sm => smallRowHeight,
    CTreeViewSize.md => mediumRowHeight,
    CTreeViewSize.lg => largeRowHeight,
  };

  static Color background(AppThemeTokens tokens) => tokens.layer01;
  static Color text(AppThemeTokens tokens) => tokens.textPrimary;
  static Color textDisabled(AppThemeTokens tokens) => tokens.textDisabled;
  static Color icon(AppThemeTokens tokens) => tokens.iconPrimary;
  static Color hover(AppThemeTokens tokens) => tokens.layerHover01;
  static Color selected(AppThemeTokens tokens) => tokens.layerSelected01;
  static Color focus(AppThemeTokens tokens) => tokens.focus;
}
