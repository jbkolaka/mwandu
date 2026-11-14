import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Styling metrics and token resolvers for Carbon Popover.
abstract final class CPopoverStyles {
  /// Distance between trigger and popover surface.
  static const double defaultOffset = Spacing.v4px025remSpacing02; // 4.0

  /// Height of the triangular caret tip pointing to the trigger.
  static const double caretHeight = 6.0;

  /// Width / base of the triangular caret tip.
  static const double caretWidth = 12.0;

  /// Default inner padding of popover content.
  static const EdgeInsets defaultPadding = EdgeInsets.all(
    Spacing.v16px1remSpacing05, // 16.0
  );

  /// Border width for popover surface.
  static const double borderWidth = 1.0;

  /// Carbon v11 crisp corner radius (0px).
  static const BorderRadius borderRadius = BorderRadius.zero;

  /// Elevation shadow for floating popover surface.
  static List<BoxShadow> dropShadow() => const [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      offset: Offset(0, 2),
      blurRadius: 6.0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.10),
      offset: Offset(0, 0),
      blurRadius: 1.0,
    ),
  ];

  /// Resolves popover background color.
  static Color backgroundColor({
    required AppThemeTokens tokens,
    required bool highContrast,
  }) {
    return highContrast ? tokens.backgroundInverse : tokens.layer01;
  }

  /// Resolves popover border color.
  static Color borderColor({
    required AppThemeTokens tokens,
    required bool highContrast,
  }) {
    return highContrast ? tokens.borderInverse : tokens.borderSubtle01;
  }

  /// Resolves foreground text color inside the popover.
  static Color textColor({
    required AppThemeTokens tokens,
    required bool highContrast,
  }) {
    return highContrast ? tokens.textInverse : tokens.textPrimary;
  }
}
