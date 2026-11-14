import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'progress_bar.props.dart';

/// Styling tokens and metric resolvers for Carbon ProgressBar.
abstract final class CProgressBarStyles {
  /// Track thickness for small variant (4px).
  static const double smallTrackHeight = Spacing.v4px025remSpacing02; // 4.0

  /// Track thickness for big variant (8px).
  static const double bigTrackHeight = Spacing.v8px05remSpacing03; // 8.0

  /// Height of the progress track based on [CProgressBarSize].
  static double trackHeight(CProgressBarSize size) => switch (size) {
    CProgressBarSize.small => smallTrackHeight,
    CProgressBarSize.big => bigTrackHeight,
  };

  /// Primary label font size (12px).
  static const double labelFontSize = 12.0;

  /// Helper and status text font size (12px).
  static const double helperFontSize = 12.0;

  /// Bottom margin below the top label.
  static const double labelMarginBottom = Spacing.v4px025remSpacing02; // 4.0

  /// Top margin above the bottom helper text.
  static const double helperMarginTop = Spacing.v4px025remSpacing02; // 4.0

  /// Horizontal gap between track and text in inline variant.
  static const double inlineGap = Spacing.v16px1remSpacing05; // 16.0

  /// Animation duration for determinate progress transitions.
  static const Duration fillAnimationDuration = Duration(milliseconds: 200);

  /// Animation curve for determinate progress transitions.
  static const Curve fillAnimationCurve = Curves.easeOut;

  /// Full cycle duration for indeterminate looping animation.
  static const Duration indeterminateCycleDuration = Duration(
    milliseconds: 2000,
  );

  /// Resolves the progress track background color.
  static Color trackColor(AppThemeTokens tokens) => tokens.borderSubtle01;

  /// Resolves the progress fill color based on the current status.
  static Color barColor(AppThemeTokens tokens, CProgressBarStatus status) =>
      switch (status) {
        CProgressBarStatus.active => tokens.interactive,
        CProgressBarStatus.finished => tokens.supportSuccess,
        CProgressBarStatus.error => tokens.supportError,
      };

  /// Resolves the primary label text color.
  static Color labelColor(AppThemeTokens tokens) => tokens.textPrimary;

  /// Resolves the helper text color according to status.
  static Color helperColor(AppThemeTokens tokens, CProgressBarStatus status) =>
      switch (status) {
        CProgressBarStatus.active => tokens.textHelper,
        CProgressBarStatus.finished => tokens.textSecondary,
        CProgressBarStatus.error => tokens.textError,
      };
}
