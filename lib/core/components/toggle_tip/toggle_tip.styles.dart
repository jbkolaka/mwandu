import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

/// Styling metrics and token resolvers for Carbon Toggletip.
abstract final class CToggletipStyles {
  /// Dimension of the default information trigger button.
  static const double triggerSize = 20.0;

  /// Icon size within the trigger button.
  static const double iconSize = Spacing.v16px1remSpacing05; // 16.0

  /// Height of the triangular caret pointing to the trigger.
  static const double caretHeight = 6.0;

  /// Base width of the triangular caret.
  static const double caretWidth = 12.0;

  /// Distance between trigger button and toggletip container.
  static const double defaultOffset = Spacing.v4px025remSpacing02; // 4.0

  /// Default padding within toggletip content.
  static const EdgeInsets defaultPadding = EdgeInsets.all(
    Spacing.v16px1remSpacing05, // 16.0
  );

  /// Maximum width of the toggletip popover surface (18rem / 288px).
  static const double maxWidth = 288.0;

  /// Top margin separating content text from action buttons.
  static const double actionsMarginTop = Spacing.v12px075remSpacing04; // 12.0

  /// Horizontal spacing between label and trigger button.
  static const double labelSpacing = Spacing.v8px05remSpacing03; // 8.0

  /// Primary body text font size.
  static const double bodyFontSize = 14.0;

  /// External label font size.
  static const double labelFontSize = 12.0;

  /// Carbon v11 crisp corner radius (0px).
  static const BorderRadius borderRadius = BorderRadius.zero;

  /// Border line thickness.
  static const double borderWidth = 1.0;

  /// Elevation box shadows for the floating toggletip.
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

  /// Resolves the toggletip surface background color.
  static Color backgroundColor(AppThemeTokens tokens) => tokens.layer01;

  /// Resolves the toggletip surface border color.
  static Color borderColor(AppThemeTokens tokens) => tokens.borderSubtle01;

  /// Resolves the toggletip body text color.
  static Color textColor(AppThemeTokens tokens) => tokens.textPrimary;

  /// Resolves the trigger button icon color based on active state.
  static Color iconColor({
    required AppThemeTokens tokens,
    required bool isOpen,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.textDisabled;
    }
    return isOpen ? tokens.interactive : tokens.iconPrimary;
  }

  /// Resolves the external label text color.
  static Color labelColor({
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    return disabled ? tokens.textDisabled : tokens.textSecondary;
  }
}
