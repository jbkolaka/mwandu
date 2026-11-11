import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Layout and theme token bindings for [CFileUpload].
abstract final class CFileUploadStyles {
  static const double outerPadding = Spacing.v16px1remSpacing05;
  static const double sectionGap = Spacing.v8px05remSpacing03;
  static const double fileRowHeight = Spacing.v48px3remSpacing09;
  static const double iconSize = Spacing.v24px15remSpacing06;
  static const double borderWidth = 1;
  static const double titleFontSize = 16;
  static const double bodyFontSize = 14;
  static const double captionFontSize = 12;

  static Color background(AppThemeTokens tokens) => tokens.layer01;
  static Color border(AppThemeTokens tokens) => tokens.borderSubtle01;
  static Color borderStrong(AppThemeTokens tokens) => tokens.borderStrong01;
  static Color text(AppThemeTokens tokens) => tokens.textPrimary;
  static Color secondaryText(AppThemeTokens tokens) => tokens.textSecondary;
  static Color icon(AppThemeTokens tokens) => tokens.iconPrimary;
  static Color hover(AppThemeTokens tokens) => tokens.layerHover01;
  static Color interactive(AppThemeTokens tokens) => tokens.buttonPrimary;
  static Color error(AppThemeTokens tokens) => tokens.supportError;
}
