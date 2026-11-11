import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'dropdown.props.dart';

/// Styling tokens and metric resolvers for [CDropdown].
abstract final class CDropdownStyles {
  /// Field height for each [CDropdownSize].
  static double fieldHeight(CDropdownSize size) {
    switch (size) {
      case CDropdownSize.sm:
        return Spacing.v32px2remSpacing07; // 32.0
      case CDropdownSize.md:
        return Spacing.v40px25remSpacing08; // 40.0
      case CDropdownSize.lg:
        return Spacing.v48px3remSpacing09; // 48.0
    }
  }

  /// Font size for selected text and menu options.
  static double fontSize(CDropdownSize size) {
    switch (size) {
      case CDropdownSize.sm:
        return 12.0;
      case CDropdownSize.md:
        return 14.0;
      case CDropdownSize.lg:
        return 16.0;
    }
  }

  /// Label font size.
  static const double labelFontSize = 12.0;

  /// Helper and validation text font size.
  static const double helperFontSize = 12.0;

  /// Horizontal padding inside the field.
  static const double horizontalPadding = Spacing.v16px1remSpacing05;

  /// Gap between label and field in inline layout.
  static const double inlineSpacing = Spacing.v16px1remSpacing05;

  /// Gap between icons and text.
  static const double iconSpacing = Spacing.v8px05remSpacing03;

  /// Standard icon dimension in logical pixels.
  static const double iconSize = 16.0;

  /// Maximum height of the dropdown option overlay menu.
  static const double maxMenuHeight = 240.0;

  /// Resolves the field background color based on interactive state.
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

  /// Resolves the field border based on focus, error, and warning states.
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
}
