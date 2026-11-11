import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Layout metrics and theme token bindings for [CDataTable].
abstract final class CDataTableStyles {
  static const double headerHeight = DataTableSizeMD.cellSpecsMinHeight;
  static const double defaultRowHeight = DataTableSizeMD.cellSpecsMinHeight;
  static const double cellHorizontalPadding =
      DataTableSizeMD.cellSpecsLeftPadding;
  static const double cellRightPadding =
      DataTableSizeMD.cellSpecsRightPadding;
  static const double titleFontSize = 16;
  static const double descriptionFontSize = 14;
  static const double headerFontSize = 14;
  static const double cellFontSize = 14;
  static const double borderWidth = 1;

  static Color backgroundColor(AppThemeTokens tokens) => tokens.layer01;
  static Color headerBackgroundColor(AppThemeTokens tokens) => tokens.layer02;
  static Color borderColor(AppThemeTokens tokens) => tokens.borderSubtle01;
  static Color hoverColor(AppThemeTokens tokens) => tokens.layerHover01;
}
