import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'search.props.dart';

/// Styling metrics and token resolvers for Carbon Search components.
abstract final class CSearchStyles {
  /// Input height for each [CSearchSize].
  static double height(CSearchSize size) => switch (size) {
    CSearchSize.sm => Spacing.v32px2remSpacing07, // 32.0
    CSearchSize.md => Spacing.v40px25remSpacing08, // 40.0
    CSearchSize.lg => Spacing.v48px3remSpacing09, // 48.0
  };

  /// Leading search icon dimension.
  static double searchIconSize(CSearchSize size) => switch (size) {
    CSearchSize.sm => 16.0,
    CSearchSize.md => 16.0,
    CSearchSize.lg => 20.0,
  };

  /// Trailing clear icon dimension.
  static double clearIconSize(CSearchSize size) => switch (size) {
    CSearchSize.sm => 16.0,
    CSearchSize.md => 16.0,
    CSearchSize.lg => 16.0,
  };

  /// Font size for query input and placeholder text.
  static double fontSize(CSearchSize size) => switch (size) {
    CSearchSize.sm => 12.0,
    CSearchSize.md => 14.0,
    CSearchSize.lg => 16.0,
  };

  /// Horizontal padding inside the search container.
  static double horizontalPadding(CSearchSize size) => switch (size) {
    CSearchSize.sm => Spacing.v8px05remSpacing03, // 8.0
    CSearchSize.md => Spacing.v16px1remSpacing05, // 16.0
    CSearchSize.lg => Spacing.v16px1remSpacing05, // 16.0
  };

  /// Gap between icons and the text input field.
  static double iconGap(CSearchSize size) => switch (size) {
    CSearchSize.sm => Spacing.v4px025remSpacing02, // 4.0
    CSearchSize.md => Spacing.v8px05remSpacing03, // 8.0
    CSearchSize.lg => Spacing.v8px05remSpacing03, // 8.0
  };

  /// Animation duration and curve for expandable search transitions.
  static const Duration expandDuration = Duration(milliseconds: 150);
  static const Curve expandCurve = Curves.easeInOut;

  /// Resolves the container background color.
  static Color background({
    required AppThemeTokens tokens,
    required bool disabled,
    required bool hovered,
  }) {
    if (disabled) {
      return tokens.field01.withValues(alpha: 0.5);
    }
    return hovered ? tokens.fieldHover01 : tokens.field01;
  }

  /// Resolves the search container border according to state.
  static Border border({
    required AppThemeTokens tokens,
    required bool disabled,
    required bool focused,
  }) {
    if (disabled) {
      return Border(
        bottom: BorderSide(color: tokens.borderSubtle01, width: 1.0),
      );
    }
    if (focused) {
      return Border.all(color: tokens.focus, width: 2.0);
    }
    return Border(bottom: BorderSide(color: tokens.borderStrong01, width: 1.0));
  }

  /// Resolves the input text color.
  static Color textColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textPrimary;
  }

  /// Resolves the placeholder hint text color.
  static Color placeholderColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textPlaceholder;
  }

  /// Resolves the leading search icon color.
  static Color iconColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.iconPrimary;
  }

  /// Resolves the trailing clear button icon color.
  static Color clearIconColor({
    required AppThemeTokens tokens,
    required bool hovered,
  }) {
    return hovered ? tokens.iconPrimary : tokens.iconSecondary;
  }
}
