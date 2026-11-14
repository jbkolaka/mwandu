import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'select.props.dart';

/// Styling tokens and metric resolvers for Carbon Select.
abstract final class CSelectStyles {
  /// Field height for each [CSelectSize].
  static double fieldHeight(CSelectSize size) => switch (size) {
    CSelectSize.sm => Spacing.v32px2remSpacing07, // 32.0
    CSelectSize.md => Spacing.v40px25remSpacing08, // 40.0
    CSelectSize.lg => Spacing.v48px3remSpacing09, // 48.0
  };

  /// Font size for selected text and options.
  static double fontSize(CSelectSize size) => switch (size) {
    CSelectSize.sm => 12.0,
    CSelectSize.md => 14.0,
    CSelectSize.lg => 16.0,
  };

  /// Trailing chevron dimension.
  static const double chevronSize = 16.0;

  /// Primary label font size.
  static const double labelFontSize = 12.0;

  /// Helper and status message font size.
  static const double helperFontSize = 12.0;

  /// Horizontal padding inside the select field.
  static const double horizontalPadding = Spacing.v16px1remSpacing05; // 16.0

  /// Gap between label and field in inline layout.
  static const double inlineSpacing = Spacing.v16px1remSpacing05; // 16.0

  /// Margin below primary label.
  static const double labelMarginBottom = Spacing.v8px05remSpacing03; // 8.0

  /// Margin above status / validation messages.
  static const double messageMarginTop = Spacing.v4px025remSpacing02; // 4.0

  /// Maximum height of dropdown options overlay.
  static const double maxMenuHeight = 240.0;

  /// Resolves the field background color.
  static Color fieldBackground({
    required AppThemeTokens tokens,
    required bool disabled,
    required bool isHovered,
  }) {
    if (disabled) {
      return tokens.field01.withValues(alpha: 0.5);
    }
    return isHovered ? tokens.fieldHover01 : tokens.field01;
  }

  /// Resolves the field border based on active interactive and validation state.
  static Border fieldBorder({
    required AppThemeTokens tokens,
    required bool disabled,
    required bool isFocused,
    required bool isOpen,
    required bool isInvalid,
    required bool isWarn,
  }) {
    if (disabled) {
      return Border(
        bottom: BorderSide(color: tokens.borderSubtle01, width: 1.0),
      );
    }
    if (isInvalid) {
      return Border.all(color: tokens.supportError, width: 2.0);
    }
    if (isWarn) {
      return Border.all(color: tokens.supportWarning, width: 1.0);
    }
    if (isFocused || isOpen) {
      return Border.all(color: tokens.focus, width: 2.0);
    }
    return Border(bottom: BorderSide(color: tokens.borderStrong01, width: 1.0));
  }

  /// Resolves selected option text color.
  static Color textColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textPrimary;
  }

  /// Resolves placeholder prompt color.
  static Color placeholderColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textPlaceholder;
  }

  /// Resolves chevron icon color.
  static Color chevronColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.iconPrimary;
  }

  /// Resolves label text color.
  static Color labelColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textSecondary;
  }

  /// Resolves helper / validation message color.
  static Color messageColor({
    required AppThemeTokens tokens,
    required bool isInvalid,
    required bool isWarn,
  }) {
    if (isInvalid) {
      return tokens.textError;
    }
    if (isWarn) {
      return tokens.supportWarning;
    }
    return tokens.textHelper;
  }
}
