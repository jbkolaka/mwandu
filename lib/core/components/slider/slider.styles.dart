import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Styling metrics and token resolvers for Carbon Slider.
abstract final class CSliderStyles {
  /// Height of the horizontal slider track.
  static const double trackHeight = Spacing.v4px025remSpacing02; // 4.0

  /// Diameter of the draggable circular thumb handle.
  static const double thumbSize = Spacing.v16px1remSpacing05; // 16.0

  /// Focus outline width around the thumb handle.
  static const double focusRingWidth = 2.0;

  /// Height of the companion numeric input field.
  static const double inputHeight = Spacing.v32px2remSpacing07; // 32.0

  /// Width of the companion numeric input field.
  static const double inputWidth = 64.0;

  /// Gap between slider bar and companion numeric input.
  static const double inputGap = Spacing.v16px1remSpacing05; // 16.0

  /// Horizontal spacing between track ends and min/max labels.
  static const double minMaxLabelSpacing = Spacing.v8px05remSpacing03; // 8.0

  /// Bottom margin below the top label text.
  static const double labelMarginBottom = Spacing.v8px05remSpacing03; // 8.0

  /// Top margin above status / helper messages.
  static const double messageMarginTop = Spacing.v4px025remSpacing02; // 4.0

  /// Font size for the primary label.
  static const double labelFontSize = 14.0;

  /// Font size for boundary min/max labels.
  static const double rangeFontSize = 12.0;

  /// Font size for status and validation messages.
  static const double messageFontSize = 12.0;

  /// Resolves the unfilled track background color.
  static Color trackBackgroundColor(AppThemeTokens tokens) =>
      tokens.borderSubtle01;

  /// Resolves the filled track and thumb handle color.
  static Color activeTrackColor({
    required AppThemeTokens tokens,
    required bool disabled,
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
    return tokens.interactive;
  }

  /// Resolves the thumb focus ring color.
  static Color focusRingColor(AppThemeTokens tokens) => tokens.focus;

  /// Resolves primary label text color.
  static Color labelColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textPrimary;
  }

  /// Resolves min and max boundary text color.
  static Color rangeLabelColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textSecondary;
  }

  /// Resolves numeric input field background color.
  static Color inputBackgroundColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.field01.withValues(alpha: 0.5) : tokens.field01;
  }

  /// Resolves numeric input field border color.
  static Color inputBorderColor({
    required AppThemeTokens tokens,
    required bool focused,
    required bool invalid,
    required bool warn,
  }) {
    if (invalid) {
      return tokens.supportError;
    }
    if (warn) {
      return tokens.supportWarning;
    }
    if (focused) {
      return tokens.focus;
    }
    return tokens.borderStrong01;
  }

  /// Resolves validation status message color.
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
