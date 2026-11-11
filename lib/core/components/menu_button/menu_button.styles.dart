import 'package:flutter/widgets.dart';
import 'package:mwandu/core/components/menu/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'menu_button.props.dart';

/// Styling tokens and metric resolvers for [CMenuButton].
abstract final class CMenuButtonStyles {
  /// Height of the button matching Carbon specifications.
  static double height(CMenuSize size) {
    switch (size) {
      case CMenuSize.sm:
        return Spacing.v32px2remSpacing07; // 32.0
      case CMenuSize.md:
        return Spacing.v40px25remSpacing08; // 40.0
      case CMenuSize.lg:
        return Spacing.v48px3remSpacing09; // 48.0
    }
  }

  /// Font size for the button label.
  static double fontSize(CMenuSize size) {
    switch (size) {
      case CMenuSize.sm:
        return 12.0;
      case CMenuSize.md:
        return 14.0;
      case CMenuSize.lg:
        return 16.0;
    }
  }

  /// Horizontal padding inside the main button body.
  static double horizontalPadding(CMenuSize size) {
    switch (size) {
      case CMenuSize.sm:
        return Spacing.v12px075remSpacing04;
      case CMenuSize.md:
      case CMenuSize.lg:
        return Spacing.v16px1remSpacing05;
    }
  }

  /// Width of the chevron trigger portion in a combo / split button.
  static double triggerWidth(CMenuSize size) {
    return height(size);
  }

  /// Leading icon size.
  static const double iconSize = 16.0;

  /// Caret icon size.
  static const double caretSize = 16.0;

  /// Spacing between leading icon and label.
  static const double iconSpacing = Spacing.v8px05remSpacing03;

  /// Spacing between label and trailing caret in standard mode.
  static const double trailingCaretSpacing = Spacing.v16px1remSpacing05;

  /// Combo button internal separator line thickness.
  static const double separatorWidth = 1.0;

  /// Resolved background color based on button kind and interactive state.
  static Color backgroundColor({
    required CMenuButtonKind kind,
    required AppThemeTokens tokens,
    required bool disabled,
    required bool isHovered,
    required bool isOpen,
  }) {
    if (disabled) {
      return kind == CMenuButtonKind.ghost || kind == CMenuButtonKind.tertiary
          ? const Color(0x00000000)
          : tokens.buttonDisabled;
    }

    switch (kind) {
      case CMenuButtonKind.primary:
        if (isOpen) return tokens.buttonPrimaryActive;
        if (isHovered) return tokens.buttonPrimaryHover;
        return tokens.buttonPrimary;

      case CMenuButtonKind.secondary:
        if (isOpen) return tokens.buttonSecondaryActive;
        if (isHovered) return tokens.buttonSecondaryHover;
        return tokens.buttonSecondary;

      case CMenuButtonKind.tertiary:
        if (isOpen) return tokens.buttonTertiary;
        if (isHovered) return tokens.buttonTertiary.withValues(alpha: 0.15);
        return const Color(0x00000000);

      case CMenuButtonKind.ghost:
        if (isOpen) return tokens.layerSelected01;
        if (isHovered) return tokens.layerHover01;
        return const Color(0x00000000);
    }
  }

  /// Resolved content / text color based on button kind and interactive state.
  static Color contentColor({
    required CMenuButtonKind kind,
    required AppThemeTokens tokens,
    required bool disabled,
    required bool isHovered,
    bool isOpen = false,
  }) {
    if (disabled) {
      return tokens.textDisabled;
    }

    switch (kind) {
      case CMenuButtonKind.primary:
      case CMenuButtonKind.secondary:
        return tokens.textOnColor;

      case CMenuButtonKind.tertiary:
        if (isOpen) return tokens.textInverse;
        return tokens.buttonTertiary;

      case CMenuButtonKind.ghost:
        return tokens.linkPrimary;
    }
  }

  /// Border for tertiary buttons.
  static Border? border({
    required CMenuButtonKind kind,
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    if (kind == CMenuButtonKind.tertiary) {
      return Border.all(
        color: disabled ? tokens.buttonDisabled : tokens.buttonTertiary,
        width: 1.0,
      );
    }
    return null;
  }

  /// Separator line color for combo button divider.
  static Color separatorColor({
    required CMenuButtonKind kind,
    required AppThemeTokens tokens,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.borderSubtle01;
    }
    switch (kind) {
      case CMenuButtonKind.primary:
        return tokens.buttonPrimaryActive;
      case CMenuButtonKind.secondary:
        return tokens.buttonSecondaryActive;
      case CMenuButtonKind.tertiary:
        return tokens.buttonTertiary;
      case CMenuButtonKind.ghost:
        return tokens.borderSubtle01;
    }
  }
}
