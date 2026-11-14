import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'progress_indicator.props.dart';

/// Styling metrics and token resolvers for Carbon Progress Indicator.
abstract final class CProgressIndicatorStyles {
  /// Diameter of the step status indicator icon.
  static const double iconSize = Spacing.v16px1remSpacing05; // 16.0

  /// Stroke width of the connecting line between steps.
  static const double lineThickness = 1.0;

  /// Minimum horizontal width for a progress step item.
  static const double minStepWidth = 120.0;

  /// Vertical minimum spacing between steps in vertical orientation.
  static const double verticalStepGap = Spacing.v32px2remSpacing07; // 32.0

  /// Horizontal gap between the step icon and the step text content.
  static const double iconTextGap = Spacing.v8px05remSpacing03; // 8.0

  /// Vertical gap between label and optional secondary label.
  static const double labelSecondaryGap = Spacing.v4px025remSpacing02; // 4.0

  /// Primary label font size.
  static const double labelFontSize = 14.0;

  /// Secondary/helper label font size.
  static const double secondaryLabelFontSize = 12.0;

  /// Resolves the step icon color based on its state.
  static Color iconColor({
    required AppThemeTokens tokens,
    required CProgressStepState state,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.textDisabled;
    }
    return switch (state) {
      CProgressStepState.complete => tokens.interactive,
      CProgressStepState.current => tokens.interactive,
      CProgressStepState.invalid => tokens.supportError,
      CProgressStepState.incomplete => tokens.iconPrimary,
    };
  }

  /// Resolves the connecting divider line color between steps.
  static Color lineColor({
    required AppThemeTokens tokens,
    required bool isActive,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.borderSubtle01;
    }
    return isActive ? tokens.borderInteractive : tokens.borderSubtle01;
  }

  /// Resolves the primary label text color.
  static Color labelColor({
    required AppThemeTokens tokens,
    required CProgressStepState state,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.textDisabled;
    }
    return switch (state) {
      CProgressStepState.incomplete => tokens.textSecondary,
      _ => tokens.textPrimary,
    };
  }

  /// Resolves font weight for the primary label.
  static FontWeight labelFontWeight(CProgressStepState state) {
    return state == CProgressStepState.current
        ? FontWeight.w600
        : FontWeight.w400;
  }

  /// Resolves the secondary label text color.
  static Color secondaryLabelColor({
    required AppThemeTokens tokens,
    required CProgressStepState state,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.textDisabled;
    }
    if (state == CProgressStepState.invalid) {
      return tokens.textError;
    }
    return tokens.textSecondary;
  }
}
