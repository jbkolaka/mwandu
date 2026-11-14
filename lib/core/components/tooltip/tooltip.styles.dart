import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Styling metrics and token resolvers for Carbon Tooltip.
abstract final class CTooltipStyles {
  /// Base width of the triangular caret.
  static const double caretWidth = 8.0;

  /// Height / depth of the triangular caret.
  static const double caretHeight = 4.0;

  /// Gap distance between the target element and tooltip surface.
  static const double defaultOffset = Spacing.v4px025remSpacing02; // 4.0

  /// Inner padding for tooltip label text.
  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: Spacing.v8px05remSpacing03, // 8.0
    vertical: Spacing.v4px025remSpacing02, // 4.0
  );

  /// Maximum allowed width for a tooltip box (288px / 18rem).
  static const double maxWidth = 288.0;

  /// Font size for tooltip content.
  static const double fontSize = 12.0;

  /// Font weight for tooltip content.
  static const FontWeight fontWeight = FontWeight.w400;

  /// Carbon crisp corner radius (0px).
  static const BorderRadius borderRadius = BorderRadius.zero;

  /// Border width when outline is present.
  static const double borderWidth = 1.0;

  /// Elevation shadow for floating tooltip surface.
  static List<BoxShadow> dropShadow() => const [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      offset: Offset(0, 2),
      blurRadius: 6.0,
    ),
  ];

  /// Resolves the tooltip background color.
  static Color backgroundColor({
    required AppThemeTokens tokens,
    required bool highContrast,
  }) {
    return highContrast ? tokens.backgroundInverse : tokens.layer01;
  }

  /// Resolves the tooltip text color.
  static Color textColor({
    required AppThemeTokens tokens,
    required bool highContrast,
  }) {
    return highContrast ? tokens.textInverse : tokens.textPrimary;
  }

  /// Resolves the tooltip border color.
  static Color borderColor({
    required AppThemeTokens tokens,
    required bool highContrast,
  }) {
    return highContrast ? tokens.backgroundInverse : tokens.borderSubtle01;
  }
}
