import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'pagination.props.dart';

/// Sizing and semantic theme bindings for [CPagination].
abstract final class CPaginationStyles {
  static const double smallControlHeight =
      DataTableSizeSM.cellSpecsMinHeight;
  static const double mediumControlHeight =
      DataTableSizeMD.cellSpecsMinHeight;
  static const double largeControlHeight = DataTableSizeLG.cellSpecsMinHeight;
  static const double extraLargeControlHeight =
      DataTableSize.cellSpecsMinHeight;
  static const double iconSize = 20;
  static const double pageFieldWidth = 56;
  static const double borderWidth = 1;
  static const double labelFontSize = 14;
  static const double controlSpacing = Spacing.v8px05remSpacing03;
  static const double groupSpacing = Spacing.v16px1remSpacing05;

  static double controlHeight(CPaginationSize size) => switch (size) {
    CPaginationSize.sm => smallControlHeight,
    CPaginationSize.md => mediumControlHeight,
    CPaginationSize.lg => largeControlHeight,
    CPaginationSize.xl => extraLargeControlHeight,
  };

  static Color background(AppThemeTokens tokens) => tokens.layer01;
  static Color border(AppThemeTokens tokens) => tokens.borderSubtle01;
  static Color primaryText(AppThemeTokens tokens) => tokens.textPrimary;
  static Color secondaryText(AppThemeTokens tokens) => tokens.textSecondary;
  static Color icon(AppThemeTokens tokens) => tokens.iconPrimary;
  static Color hover(AppThemeTokens tokens) => tokens.layerHover01;
  static Color active(AppThemeTokens tokens) => tokens.layerActive01;
  static Color focus(AppThemeTokens tokens) => tokens.focus;
}
