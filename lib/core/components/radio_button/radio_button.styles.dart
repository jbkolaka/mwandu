import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Styling definitions and token resolvers for Carbon Radio Button components.
abstract final class CRadioButtonStyles {
  /// Outer circle diameter for the radio button (20px standard in Carbon v11).
  static const double outerSize = 20.0;

  /// Inner filled dot diameter when selected (8px in Carbon v11).
  static const double innerDotSize = 8.0;

  /// Default border stroke width for unselected radio circle.
  static const double borderWidth = 1.0;

  /// Border stroke width when focused.
  static const double focusedBorderWidth = 2.0;

  /// Focus outline offset from the outer circle.
  static const double focusOutlineOffset = 2.0;

  /// Spacing between the radio circle and the accompanying label text.
  static const double labelSpacing = Spacing.v8px05remSpacing03; // 8.0

  /// Vertical gap between consecutive radio buttons in a vertical group.
  static const double verticalSpacing = Spacing.v12px075remSpacing04; // 12.0

  /// Horizontal gap between consecutive radio buttons in a horizontal group.
  static const double horizontalSpacing = Spacing.v16px1remSpacing05; // 16.0

  /// Bottom margin beneath the group legend / title.
  static const double legendMarginBottom = Spacing.v8px05remSpacing03; // 8.0

  /// Top margin above the helper/validation message.
  static const double messageMarginTop = Spacing.v4px025remSpacing02; // 4.0

  /// Font size for the radio button option label (14px).
  static const double labelFontSize = 14.0;

  /// Font size for the group legend text (12px).
  static const double legendFontSize = 12.0;

  /// Font size for helper and validation messages (12px).
  static const double messageFontSize = 12.0;

  /// Animation parameters for border state transitions.
  static const Map<String, dynamic> borderAnimation = {
    'duration': Duration(milliseconds: 65),
    'curve': Curves.linear,
  };

  /// Animation parameters for inner dot appearance/expansion.
  static const Map<String, dynamic> dotAnimation = {
    'duration': Duration(milliseconds: 100),
    'curve': Curves.easeInOut,
  };

  /// Resolves the border color for the radio button outer circle.
  static Color borderColor({
    required AppThemeTokens tokens,
    required bool selected,
    required bool disabled,
    required bool focused,
    required bool hovered,
    required bool invalid,
    required bool warn,
  }) {
    if (disabled) {
      return tokens.borderDisabled;
    }
    if (invalid) {
      return tokens.supportError;
    }
    if (warn) {
      return tokens.supportWarning;
    }
    if (focused) {
      return tokens.focus;
    }
    if (selected) {
      return tokens.interactive;
    }
    if (hovered) {
      return tokens.borderInverse;
    }
    return tokens.borderStrong01;
  }

  /// Resolves the color of the inner selected dot.
  static Color dotColor({
    required AppThemeTokens tokens,
    required bool disabled,
    required bool invalid,
    required bool warn,
  }) {
    if (disabled) {
      return tokens.textDisabled;
    }
    if (invalid) {
      return tokens.supportError;
    }
    if (warn) {
      return tokens.supportWarning;
    }
    return tokens.interactive;
  }

  /// Resolves the option label text color.
  static Color labelColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textPrimary;
  }

  /// Resolves the group legend text color.
  static Color legendColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textSecondary;
  }

  /// Resolves the helper text color.
  static Color helperColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textHelper;
  }

  /// Resolves the validation message color.
  static Color validationColor({
    required AppThemeTokens tokens,
    required bool invalid,
    required bool warn,
  }) {
    if (invalid) {
      return tokens.textError;
    }
    if (warn) {
      return tokens.supportWarning;
    }
    return tokens.textHelper;
  }
}
