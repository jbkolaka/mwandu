import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Layout and theme bindings for [CDatePicker].
abstract final class CDatePickerStyles {
  static const double fieldHeight = Spacing.v48px3remSpacing09;
  static const double horizontalPadding = Spacing.v12px075remSpacing04;
  static const double helperTopSpacing = Spacing.v4px025remSpacing02;
  static const double helperFontSize = 12;
  static const double labelFontSize = 14;
  static const double fieldFontSize = 14;
  static const double borderWidth = 1;

  static Color fieldBackground(AppThemeTokens tokens) => tokens.field01;
  static Color fieldHover(AppThemeTokens tokens) => tokens.fieldHover01;
  static Color border(AppThemeTokens tokens) => tokens.borderStrong01;
  static Color focus(AppThemeTokens tokens) => tokens.focus;
  static Color text(AppThemeTokens tokens) => tokens.textPrimary;
  static Color secondaryText(AppThemeTokens tokens) => tokens.textSecondary;
  static Color disabledText(AppThemeTokens tokens) => tokens.textDisabled;
  static Color icon(AppThemeTokens tokens) => tokens.iconPrimary;
}
