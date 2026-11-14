import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'tag.props.dart';

/// Sizing and color token resolvers for Carbon Tag.
abstract final class CTagStyles {
  /// Tag height for each [CTagSize].
  static double height(CTagSize size) => switch (size) {
    CTagSize.sm => 18.0,
    CTagSize.md => 24.0,
    CTagSize.lg => 32.0,
  };

  /// Font size for each [CTagSize].
  static double fontSize(CTagSize size) => switch (size) {
    CTagSize.sm => 12.0,
    CTagSize.md => 12.0,
    CTagSize.lg => 14.0,
  };

  /// Leading and close icon dimensions.
  static double iconSize(CTagSize size) => switch (size) {
    CTagSize.sm => 12.0,
    CTagSize.md => 14.0,
    CTagSize.lg => 16.0,
  };

  /// Horizontal inner padding for each [CTagSize].
  static EdgeInsets padding(
    CTagSize size, {
    bool hasLeadingIcon = false,
    bool hasCloseIcon = false,
  }) {
    final double h = size == CTagSize.lg
        ? Spacing
              .v12px075remSpacing04 // 12.0
        : Spacing.v8px05remSpacing03; // 8.0

    return EdgeInsets.only(
      left: hasLeadingIcon ? h * 0.75 : h,
      right: hasCloseIcon ? h * 0.5 : h,
    );
  }

  /// Gap between icons and tag text.
  static const double iconGap = Spacing.v4px025remSpacing02; // 4.0

  /// Carbon rounded pill corner radius.
  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(100.0),
  );

  /// Resolves tag background color.
  static Color backgroundColor({
    required AppThemeTokens tokens,
    required CTagType type,
    required bool disabled,
    required bool isHovered,
    required bool isSelected,
  }) {
    if (disabled) {
      return tokens.isDark ? const Color(0xFF393939) : const Color(0xFFE0E0E0);
    }

    if (type == CTagType.outline) {
      if (isSelected) {
        return tokens.isDark
            ? const Color(0xFF393939)
            : const Color(0xFFE0E0E0);
      }
      return isHovered
          ? (tokens.isDark
                ? ThemeGray100Theme.tagOutlineTagHover
                : ThemeWhiteTheme.tagOutlineTagHover)
          : const Color(0x00000000);
    }

    if (type == CTagType.highContrast) {
      return tokens.backgroundInverse;
    }

    if (tokens.isDark) {
      if (isHovered || isSelected) {
        return switch (type) {
          CTagType.blue => ThemeGray100Theme.tagBlueTagHover,
          CTagType.cyan => ThemeGray100Theme.tagCyanTagHover,
          CTagType.teal => ThemeGray100Theme.tagTealTagHover,
          CTagType.green => ThemeGray100Theme.tagGreenTagHover,
          CTagType.magenta => ThemeGray100Theme.tagMagentaTagHover,
          CTagType.purple => ThemeGray100Theme.tagPurpleTagHover,
          CTagType.red => ThemeGray100Theme.tagRedTagHover,
          CTagType.gray => ThemeGray100Theme.tagGrayTagHover,
          CTagType.coolGray => ThemeGray100Theme.tagCoolGrayTagHover,
          CTagType.warmGray => ThemeGray100Theme.tagWarmGrayTagHover,
          _ => ThemeGray100Theme.tagGrayTagHover,
        };
      }
      return switch (type) {
        CTagType.blue => ThemeGray100Theme.tagBlueTagBackground,
        CTagType.cyan => ThemeGray100Theme.tagCyanTagBackground,
        CTagType.teal => ThemeGray100Theme.tagTealTagBackground,
        CTagType.green => ThemeGray100Theme.tagGreenTagBackground,
        CTagType.magenta => ThemeGray100Theme.tagMagentaTagBackground,
        CTagType.purple => ThemeGray100Theme.tagPurpleTagBackground,
        CTagType.red => ThemeGray100Theme.tagRedTagBackground,
        CTagType.gray => ThemeGray100Theme.tagGrayTagBackground,
        CTagType.coolGray => ThemeGray100Theme.tagCoolGrayTagBackground,
        CTagType.warmGray => ThemeGray100Theme.tagWarmGrayTagBackground,
        _ => ThemeGray100Theme.tagGrayTagBackground,
      };
    } else {
      if (isHovered || isSelected) {
        return switch (type) {
          CTagType.blue => ThemeWhiteTheme.tagBlueTagHover,
          CTagType.cyan => ThemeWhiteTheme.tagCyanTagHover,
          CTagType.teal => ThemeWhiteTheme.tagTealTagHover,
          CTagType.green => ThemeWhiteTheme.tagGreenTagHover,
          CTagType.magenta => ThemeWhiteTheme.tagMagentaTagHover,
          CTagType.purple => ThemeWhiteTheme.tagPurpleTagHover,
          CTagType.red => ThemeWhiteTheme.tagRedTagHover,
          CTagType.gray => ThemeWhiteTheme.tagGrayTagHover,
          CTagType.coolGray => ThemeWhiteTheme.tagCoolGrayTagHover,
          CTagType.warmGray => ThemeWhiteTheme.tagWarmGrayTagHover,
          _ => ThemeWhiteTheme.tagGrayTagHover,
        };
      }
      return switch (type) {
        CTagType.blue => ThemeWhiteTheme.tagBlueTagBackground,
        CTagType.cyan => ThemeWhiteTheme.tagCyanTagBackground,
        CTagType.teal => ThemeWhiteTheme.tagTealTagBackground,
        CTagType.green => ThemeWhiteTheme.tagGreenTagBackground,
        CTagType.magenta => ThemeWhiteTheme.tagMagentaTagBackground,
        CTagType.purple => ThemeWhiteTheme.tagPurpleTagBackground,
        CTagType.red => ThemeWhiteTheme.tagRedTagBackground,
        CTagType.gray => ThemeWhiteTheme.tagGrayTagBackground,
        CTagType.coolGray => ThemeWhiteTheme.tagCoolGrayTagBackground,
        CTagType.warmGray => ThemeWhiteTheme.tagWarmGrayTagBackground,
        _ => ThemeWhiteTheme.tagGrayTagBackground,
      };
    }
  }

  /// Resolves tag foreground text and icon color.
  static Color textColor({
    required AppThemeTokens tokens,
    required CTagType type,
    required bool disabled,
  }) {
    if (disabled) {
      return tokens.textDisabled;
    }

    if (type == CTagType.outline) {
      return tokens.textPrimary;
    }

    if (type == CTagType.highContrast) {
      return tokens.textInverse;
    }

    if (tokens.isDark) {
      return switch (type) {
        CTagType.blue => ThemeGray100Theme.tagBlueTagColor,
        CTagType.cyan => ThemeGray100Theme.tagCyanTagColor,
        CTagType.teal => ThemeGray100Theme.tagTealTagColor,
        CTagType.green => ThemeGray100Theme.tagGreenTagColor,
        CTagType.magenta => ThemeGray100Theme.tagMagentaTagColor,
        CTagType.purple => ThemeGray100Theme.tagPurpleTagColor,
        CTagType.red => ThemeGray100Theme.tagRedTagColor,
        CTagType.gray => ThemeGray100Theme.tagGrayTagColor,
        CTagType.coolGray => ThemeGray100Theme.tagCoolGrayTagColor,
        CTagType.warmGray => ThemeGray100Theme.tagWarmGrayTagColor,
        _ => ThemeGray100Theme.tagGrayTagColor,
      };
    } else {
      return switch (type) {
        CTagType.blue => ThemeWhiteTheme.tagBlueTagColor,
        CTagType.cyan => ThemeWhiteTheme.tagCyanTagColor,
        CTagType.teal => ThemeWhiteTheme.tagTealTagColor,
        CTagType.green => ThemeWhiteTheme.tagGreenTagColor,
        CTagType.magenta => ThemeWhiteTheme.tagMagentaTagColor,
        CTagType.purple => ThemeWhiteTheme.tagPurpleTagColor,
        CTagType.red => ThemeWhiteTheme.tagRedTagColor,
        CTagType.gray => ThemeWhiteTheme.tagGrayTagColor,
        CTagType.coolGray => ThemeWhiteTheme.tagCoolGrayTagColor,
        CTagType.warmGray => ThemeWhiteTheme.tagWarmGrayTagColor,
        _ => ThemeWhiteTheme.tagGrayTagColor,
      };
    }
  }

  /// Resolves tag border color.
  static Border? border({
    required AppThemeTokens tokens,
    required CTagType type,
    required bool disabled,
    required bool isSelected,
  }) {
    if (isSelected) {
      return Border.all(color: tokens.borderInteractive, width: 1.0);
    }
    if (type == CTagType.outline) {
      return Border.all(
        color: disabled ? tokens.borderDisabled : tokens.borderStrong01,
        width: 1.0,
      );
    }
    return null;
  }
}
