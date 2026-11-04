import 'package:flutter/material.dart';

import 'variables/theme_gray10.dart';
import 'variables/theme_gray90.dart';
import 'variables/theme_gray100.dart';
import 'variables/theme_white.dart';

/// Semantic token bundle for the application themes.
///
/// Implements [ThemeExtension] so all tokens are accessible via:
/// ```dart
/// context.tokens.background
/// context.tokens.textPrimary
/// Theme.of(context).extension<AppThemeTokens>()!.layer01
/// ```
@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.name,
    required this.isDark,
    // Backgrounds
    required this.background,
    required this.backgroundActive,
    required this.backgroundHover,
    required this.backgroundSelected,
    required this.backgroundSelectedHover,
    required this.backgroundBrand,
    required this.backgroundInverse,
    required this.backgroundInverseHover,
    // Layers
    required this.layer01,
    required this.layer02,
    required this.layer03,
    required this.layerHover01,
    required this.layerHover02,
    required this.layerHover03,
    required this.layerActive01,
    required this.layerActive02,
    required this.layerActive03,
    required this.layerSelected01,
    required this.layerSelected02,
    required this.layerSelected03,
    required this.layerAccent01,
    required this.layerAccent02,
    required this.layerAccent03,
    // Fields
    required this.field01,
    required this.field02,
    required this.field03,
    required this.fieldHover01,
    // Borders
    required this.borderSubtle00,
    required this.borderSubtle01,
    required this.borderSubtle02,
    required this.borderSubtle03,
    required this.borderStrong01,
    required this.borderStrong02,
    required this.borderInteractive,
    required this.borderDisabled,
    required this.borderInverse,
    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textPlaceholder,
    required this.textOnColor,
    required this.textOnColorDisabled,
    required this.textHelper,
    required this.textError,
    required this.textInverse,
    required this.textDisabled,
    // Buttons
    required this.buttonPrimary,
    required this.buttonPrimaryHover,
    required this.buttonPrimaryActive,
    required this.buttonSecondary,
    required this.buttonSecondaryHover,
    required this.buttonSecondaryActive,
    required this.buttonTertiary,
    required this.buttonDangerPrimary,
    required this.buttonDangerHover,
    required this.buttonDangerActive,
    required this.buttonDisabled,
    // Support
    required this.supportError,
    required this.supportSuccess,
    required this.supportWarning,
    required this.supportInfo,
    required this.supportErrorInverse,
    required this.supportSuccessInverse,
    required this.supportWarningInverse,
    required this.supportInfoInverse,
    // Focus
    required this.focus,
    required this.focusInset,
    required this.focusInverse,
    // Icons
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconOnColor,
    required this.iconInteractive,
    // Links
    required this.linkPrimary,
    required this.linkSecondary,
    required this.linkInverse,
    // Miscellaneous
    required this.interactive,
    required this.highlight,
    required this.overlay,
  });

  /// Factory for White Theme (Light)
  factory AppThemeTokens.white() {
    return const AppThemeTokens(
      name: 'White',
      isDark: false,
      background: ThemeWhiteTheme.backgroundBackground,
      backgroundActive: ThemeWhiteTheme.backgroundBackgroundActive,
      backgroundHover: ThemeWhiteTheme.backgroundBackgroundHover,
      backgroundSelected: ThemeWhiteTheme.backgroundBackgroundSelected,
      backgroundSelectedHover:
          ThemeWhiteTheme.backgroundBackgroundSelectedHover,
      backgroundBrand: ThemeWhiteTheme.backgroundBackgroundBrand,
      backgroundInverse: ThemeWhiteTheme.backgroundBackgroundInverse,
      backgroundInverseHover: ThemeWhiteTheme.backgroundBackgroundInverseHover,
      layer01: ThemeWhiteTheme.layerLayer01,
      layer02: ThemeWhiteTheme.layerLayer02,
      layer03: ThemeWhiteTheme.layerLayer03,
      layerHover01: ThemeWhiteTheme.layerLayerHover01,
      layerHover02: ThemeWhiteTheme.layerLayerHover02,
      layerHover03: ThemeWhiteTheme.layerLayerHover03,
      layerActive01: ThemeWhiteTheme.layerLayerActive01,
      layerActive02: ThemeWhiteTheme.layerLayerActive02,
      layerActive03: ThemeWhiteTheme.layerLayerActive03,
      layerSelected01: ThemeWhiteTheme.layerLayerSelected01,
      layerSelected02: ThemeWhiteTheme.layerLayerSelected02,
      layerSelected03: ThemeWhiteTheme.layerLayerSelected03,
      layerAccent01: ThemeWhiteTheme.layerAccentLayerAccent01,
      layerAccent02: ThemeWhiteTheme.layerAccentLayerAccent02,
      layerAccent03: ThemeWhiteTheme.layerAccentLayerAccent03,
      field01: ThemeWhiteTheme.fieldField01,
      field02: ThemeWhiteTheme.fieldField02,
      field03: ThemeWhiteTheme.fieldField03,
      fieldHover01: ThemeWhiteTheme.fieldFieldHover01,
      borderSubtle00: ThemeWhiteTheme.borderBorderSubtle00,
      borderSubtle01: ThemeWhiteTheme.borderBorderSubtle01,
      borderSubtle02: ThemeWhiteTheme.borderBorderSubtle02,
      borderSubtle03: ThemeWhiteTheme.borderBorderSubtle03,
      borderStrong01: ThemeWhiteTheme.borderBorderStrong01,
      borderStrong02: ThemeWhiteTheme.borderBorderStrong02,
      borderInteractive: ThemeWhiteTheme.borderBorderInteractive,
      borderDisabled: ThemeWhiteTheme.borderBorderDisabled,
      borderInverse: ThemeWhiteTheme.borderBorderInverse,
      textPrimary: ThemeWhiteTheme.textTextPrimary,
      textSecondary: ThemeWhiteTheme.textTextSecondary,
      textPlaceholder: ThemeWhiteTheme.textTextPlaceholder,
      textOnColor: ThemeWhiteTheme.textTextOnColor,
      textOnColorDisabled: ThemeWhiteTheme.textTextOnColorDisabled,
      textHelper: ThemeWhiteTheme.textTextHelper,
      textError: ThemeWhiteTheme.textTextError,
      textInverse: ThemeWhiteTheme.textTextInverse,
      textDisabled: ThemeWhiteTheme.textTextDisabled,
      buttonPrimary: ThemeWhiteTheme.buttonButtonPrimary,
      buttonPrimaryHover: ThemeWhiteTheme.buttonButtonPrimaryHover,
      buttonPrimaryActive: ThemeWhiteTheme.buttonButtonPrimaryActive,
      buttonSecondary: ThemeWhiteTheme.buttonButtonSecondary,
      buttonSecondaryHover: ThemeWhiteTheme.buttonButtonSecondaryHover,
      buttonSecondaryActive: ThemeWhiteTheme.buttonButtonSecondaryActive,
      buttonTertiary: ThemeWhiteTheme.buttonButtonTertiary,
      buttonDangerPrimary: ThemeWhiteTheme.buttonButtonDangerPrimary,
      buttonDangerHover: ThemeWhiteTheme.buttonButtonDangerHover,
      buttonDangerActive: ThemeWhiteTheme.buttonButtonDangerActive,
      buttonDisabled: ThemeWhiteTheme.buttonButtonDisabled,
      supportError: ThemeWhiteTheme.supportSupportError,
      supportSuccess: ThemeWhiteTheme.supportSupportSuccess,
      supportWarning: ThemeWhiteTheme.supportSupportWarning,
      supportInfo: ThemeWhiteTheme.supportSupportInfo,
      supportErrorInverse: ThemeWhiteTheme.supportSupportErrorInverse,
      supportSuccessInverse: ThemeWhiteTheme.supportSupportSuccessInverse,
      supportWarningInverse: ThemeWhiteTheme.supportSupportWarningInverse,
      supportInfoInverse: ThemeWhiteTheme.supportSupportInfoInverse,
      focus: ThemeWhiteTheme.focusFocus,
      focusInset: ThemeWhiteTheme.focusFocusInset,
      focusInverse: ThemeWhiteTheme.focusFocusInverse,
      iconPrimary: ThemeWhiteTheme.iconIconPrimary,
      iconSecondary: ThemeWhiteTheme.iconIconSecondary,
      iconOnColor: ThemeWhiteTheme.iconIconOnColor,
      iconInteractive: ThemeWhiteTheme.iconIconInteractive,
      linkPrimary: ThemeWhiteTheme.linkLinkPrimary,
      linkSecondary: ThemeWhiteTheme.linkLinkSecondary,
      linkInverse: ThemeWhiteTheme.linkLinkInverse,
      interactive: ThemeWhiteTheme.miscellaneousInteractive,
      highlight: ThemeWhiteTheme.miscellaneousHighlight,
      overlay: ThemeWhiteTheme.miscellaneousOverlay,
    );
  }

  /// Factory for Gray 10 Theme (Light)
  factory AppThemeTokens.gray10() {
    return const AppThemeTokens(
      name: 'Gray 10',
      isDark: false,
      background: ThemeGray10Theme.backgroundBackground,
      backgroundActive: ThemeGray10Theme.backgroundBackgroundActive,
      backgroundHover: ThemeGray10Theme.backgroundBackgroundHover,
      backgroundSelected: ThemeGray10Theme.backgroundBackgroundSelected,
      backgroundSelectedHover:
          ThemeGray10Theme.backgroundBackgroundSelectedHover,
      backgroundBrand: ThemeGray10Theme.backgroundBackgroundBrand,
      backgroundInverse: ThemeGray10Theme.backgroundBackgroundInverse,
      backgroundInverseHover: ThemeGray10Theme.backgroundBackgroundInverseHover,
      layer01: ThemeGray10Theme.layerLayer01,
      layer02: ThemeGray10Theme.layerLayer02,
      layer03: ThemeGray10Theme.layerLayer03,
      layerHover01: ThemeGray10Theme.layerLayerHover01,
      layerHover02: ThemeGray10Theme.layerLayerHover02,
      layerHover03: ThemeGray10Theme.layerLayerHover03,
      layerActive01: ThemeGray10Theme.layerLayerActive01,
      layerActive02: ThemeGray10Theme.layerLayerActive02,
      layerActive03: ThemeGray10Theme.layerLayerActive03,
      layerSelected01: ThemeGray10Theme.layerLayerSelected01,
      layerSelected02: ThemeGray10Theme.layerLayerSelected02,
      layerSelected03: ThemeGray10Theme.layerLayerSelected03,
      layerAccent01: ThemeGray10Theme.layerAccentLayerAccent01,
      layerAccent02: ThemeGray10Theme.layerAccentLayerAccent02,
      layerAccent03: ThemeGray10Theme.layerAccentLayerAccent03,
      field01: ThemeGray10Theme.fieldField01,
      field02: ThemeGray10Theme.fieldField02,
      field03: ThemeGray10Theme.fieldField03,
      fieldHover01: ThemeGray10Theme.fieldFieldHover01,
      borderSubtle00: ThemeGray10Theme.borderBorderSubtle00,
      borderSubtle01: ThemeGray10Theme.borderBorderSubtle01,
      borderSubtle02: ThemeGray10Theme.borderBorderSubtle02,
      borderSubtle03: ThemeGray10Theme.borderBorderSubtle03,
      borderStrong01: ThemeGray10Theme.borderBorderStrong01,
      borderStrong02: ThemeGray10Theme.borderBorderStrong02,
      borderInteractive: ThemeGray10Theme.borderBorderInteractive,
      borderDisabled: ThemeGray10Theme.borderBorderDisabled,
      borderInverse: ThemeGray10Theme.borderBorderInverse,
      textPrimary: ThemeGray10Theme.textTextPrimary,
      textSecondary: ThemeGray10Theme.textTextSecondary,
      textPlaceholder: ThemeGray10Theme.textTextPlaceholder,
      textOnColor: ThemeGray10Theme.textTextOnColor,
      textOnColorDisabled: ThemeGray10Theme.textTextOnColorDisabled,
      textHelper: ThemeGray10Theme.textTextHelper,
      textError: ThemeGray10Theme.textTextError,
      textInverse: ThemeGray10Theme.textTextInverse,
      textDisabled: ThemeGray10Theme.textTextDisabled,
      buttonPrimary: ThemeGray10Theme.buttonButtonPrimary,
      buttonPrimaryHover: ThemeGray10Theme.buttonButtonPrimaryHover,
      buttonPrimaryActive: ThemeGray10Theme.buttonButtonPrimaryActive,
      buttonSecondary: ThemeGray10Theme.buttonButtonSecondary,
      buttonSecondaryHover: ThemeGray10Theme.buttonButtonSecondaryHover,
      buttonSecondaryActive: ThemeGray10Theme.buttonButtonSecondaryActive,
      buttonTertiary: ThemeGray10Theme.buttonButtonTertiary,
      buttonDangerPrimary: ThemeGray10Theme.buttonButtonDangerPrimary,
      buttonDangerHover: ThemeGray10Theme.buttonButtonDangerHover,
      buttonDangerActive: ThemeGray10Theme.buttonButtonDangerActive,
      buttonDisabled: ThemeGray10Theme.buttonButtonDisabled,
      supportError: ThemeGray10Theme.supportSupportError,
      supportSuccess: ThemeGray10Theme.supportSupportSuccess,
      supportWarning: ThemeGray10Theme.supportSupportWarning,
      supportInfo: ThemeGray10Theme.supportSupportInfo,
      supportErrorInverse: ThemeGray10Theme.supportSupportErrorInverse,
      supportSuccessInverse: ThemeGray10Theme.supportSupportSuccessInverse,
      supportWarningInverse: ThemeGray10Theme.supportSupportWarningInverse,
      supportInfoInverse: ThemeGray10Theme.supportSupportInfoInverse,
      focus: ThemeGray10Theme.focusFocus,
      focusInset: ThemeGray10Theme.focusFocusInset,
      focusInverse: ThemeGray10Theme.focusFocusInverse,
      iconPrimary: ThemeGray10Theme.iconIconPrimary,
      iconSecondary: ThemeGray10Theme.iconIconSecondary,
      iconOnColor: ThemeGray10Theme.iconIconOnColor,
      iconInteractive: ThemeGray10Theme.iconIconInteractive,
      linkPrimary: ThemeGray10Theme.linkLinkPrimary,
      linkSecondary: ThemeGray10Theme.linkLinkSecondary,
      linkInverse: ThemeGray10Theme.linkLinkInverse,
      interactive: ThemeGray10Theme.miscellaneousInteractive,
      highlight: ThemeGray10Theme.miscellaneousHighlight,
      overlay: ThemeGray10Theme.miscellaneousOverlay,
    );
  }

  /// Factory for Gray 90 Theme (Dark)
  factory AppThemeTokens.gray90() {
    return const AppThemeTokens(
      name: 'Gray 90',
      isDark: true,
      background: ThemeGray90Theme.backgroundBackground,
      backgroundActive: ThemeGray90Theme.backgroundBackgroundActive,
      backgroundHover: ThemeGray90Theme.backgroundBackgroundHover,
      backgroundSelected: ThemeGray90Theme.backgroundBackgroundSelected,
      backgroundSelectedHover:
          ThemeGray90Theme.backgroundBackgroundSelectedHover,
      backgroundBrand: ThemeGray90Theme.backgroundBackgroundBrand,
      backgroundInverse: ThemeGray90Theme.backgroundBackgroundInverse,
      backgroundInverseHover: ThemeGray90Theme.backgroundBackgroundInverseHover,
      layer01: ThemeGray90Theme.layerLayer01,
      layer02: ThemeGray90Theme.layerLayer02,
      layer03: ThemeGray90Theme.layerLayer03,
      layerHover01: ThemeGray90Theme.layerLayerHover01,
      layerHover02: ThemeGray90Theme.layerLayerHover02,
      layerHover03: ThemeGray90Theme.layerLayerHover03,
      layerActive01: ThemeGray90Theme.layerLayerActive01,
      layerActive02: ThemeGray90Theme.layerLayerActive02,
      layerActive03: ThemeGray90Theme.layerLayerActive03,
      layerSelected01: ThemeGray90Theme.layerLayerSelected01,
      layerSelected02: ThemeGray90Theme.layerLayerSelected02,
      layerSelected03: ThemeGray90Theme.layerLayerSelected03,
      layerAccent01: ThemeGray90Theme.layerAccentLayerAccent01,
      layerAccent02: ThemeGray90Theme.layerAccentLayerAccent02,
      layerAccent03: ThemeGray90Theme.layerAccentLayerAccent03,
      field01: ThemeGray90Theme.fieldField01,
      field02: ThemeGray90Theme.fieldField02,
      field03: ThemeGray90Theme.fieldField03,
      fieldHover01: ThemeGray90Theme.fieldFieldHover01,
      borderSubtle00: ThemeGray90Theme.borderBorderSubtle00,
      borderSubtle01: ThemeGray90Theme.borderBorderSubtle01,
      borderSubtle02: ThemeGray90Theme.borderBorderSubtle02,
      borderSubtle03: ThemeGray90Theme.borderBorderSubtle03,
      borderStrong01: ThemeGray90Theme.borderBorderStrong01,
      borderStrong02: ThemeGray90Theme.borderBorderStrong02,
      borderInteractive: ThemeGray90Theme.borderBorderInteractive,
      borderDisabled: ThemeGray90Theme.borderBorderDisabled,
      borderInverse: ThemeGray90Theme.borderBorderInverse,
      textPrimary: ThemeGray90Theme.textTextPrimary,
      textSecondary: ThemeGray90Theme.textTextSecondary,
      textPlaceholder: ThemeGray90Theme.textTextPlaceholder,
      textOnColor: ThemeGray90Theme.textTextOnColor,
      textOnColorDisabled: ThemeGray90Theme.textTextOnColorDisabled,
      textHelper: ThemeGray90Theme.textTextHelper,
      textError: ThemeGray90Theme.textTextError,
      textInverse: ThemeGray90Theme.textTextInverse,
      textDisabled: ThemeGray90Theme.textTextDisabled,
      buttonPrimary: ThemeGray90Theme.buttonButtonPrimary,
      buttonPrimaryHover: ThemeGray90Theme.buttonButtonPrimaryHover,
      buttonPrimaryActive: ThemeGray90Theme.buttonButtonPrimaryActive,
      buttonSecondary: ThemeGray90Theme.buttonButtonSecondary,
      buttonSecondaryHover: ThemeGray90Theme.buttonButtonSecondaryHover,
      buttonSecondaryActive: ThemeGray90Theme.buttonButtonSecondaryActive,
      buttonTertiary: ThemeGray90Theme.buttonButtonTertiary,
      buttonDangerPrimary: ThemeGray90Theme.buttonButtonDangerPrimary,
      buttonDangerHover: ThemeGray90Theme.buttonButtonDangerHover,
      buttonDangerActive: ThemeGray90Theme.buttonButtonDangerActive,
      buttonDisabled: ThemeGray90Theme.buttonButtonDisabled,
      supportError: ThemeGray90Theme.supportSupportError,
      supportSuccess: ThemeGray90Theme.supportSupportSuccess,
      supportWarning: ThemeGray90Theme.supportSupportWarning,
      supportInfo: ThemeGray90Theme.supportSupportInfo,
      supportErrorInverse: ThemeGray90Theme.supportSupportErrorInverse,
      supportSuccessInverse: ThemeGray90Theme.supportSupportSuccessInverse,
      supportWarningInverse: ThemeGray90Theme.supportSupportWarningInverse,
      supportInfoInverse: ThemeGray90Theme.supportSupportInfoInverse,
      focus: ThemeGray90Theme.focusFocus,
      focusInset: ThemeGray90Theme.focusFocusInset,
      focusInverse: ThemeGray90Theme.focusFocusInverse,
      iconPrimary: ThemeGray90Theme.iconIconPrimary,
      iconSecondary: ThemeGray90Theme.iconIconSecondary,
      iconOnColor: ThemeGray90Theme.iconIconOnColor,
      iconInteractive: ThemeGray90Theme.iconIconInteractive,
      linkPrimary: ThemeGray90Theme.linkLinkPrimary,
      linkSecondary: ThemeGray90Theme.linkLinkSecondary,
      linkInverse: ThemeGray90Theme.linkLinkInverse,
      interactive: ThemeGray90Theme.miscellaneousInteractive,
      highlight: ThemeGray90Theme.miscellaneousHighlight,
      overlay: ThemeGray90Theme.miscellaneousOverlay,
    );
  }

  /// Factory for Gray 100 Theme (Dark)
  factory AppThemeTokens.gray100() {
    return const AppThemeTokens(
      name: 'Gray 100',
      isDark: true,
      background: ThemeGray100Theme.backgroundBackground,
      backgroundActive: ThemeGray100Theme.backgroundBackgroundActive,
      backgroundHover: ThemeGray100Theme.backgroundBackgroundHover,
      backgroundSelected: ThemeGray100Theme.backgroundBackgroundSelected,
      backgroundSelectedHover:
          ThemeGray100Theme.backgroundBackgroundSelectedHover,
      backgroundBrand: ThemeGray100Theme.backgroundBackgroundBrand,
      backgroundInverse: ThemeGray100Theme.backgroundBackgroundInverse,
      backgroundInverseHover:
          ThemeGray100Theme.backgroundBackgroundInverseHover,
      layer01: ThemeGray100Theme.layerLayer01,
      layer02: ThemeGray100Theme.layerLayer02,
      layer03: ThemeGray100Theme.layerLayer03,
      layerHover01: ThemeGray100Theme.layerLayerHover01,
      layerHover02: ThemeGray100Theme.layerLayerHover02,
      layerHover03: ThemeGray100Theme.layerLayerHover03,
      layerActive01: ThemeGray100Theme.layerLayerActive01,
      layerActive02: ThemeGray100Theme.layerLayerActive02,
      layerActive03: ThemeGray100Theme.layerLayerActive03,
      layerSelected01: ThemeGray100Theme.layerLayerSelected01,
      layerSelected02: ThemeGray100Theme.layerLayerSelected02,
      layerSelected03: ThemeGray100Theme.layerLayerSelected03,
      layerAccent01: ThemeGray100Theme.layerAccentLayerAccent01,
      layerAccent02: ThemeGray100Theme.layerAccentLayerAccent02,
      layerAccent03: ThemeGray100Theme.layerAccentLayerAccent03,
      field01: ThemeGray100Theme.fieldField01,
      field02: ThemeGray100Theme.fieldField02,
      field03: ThemeGray100Theme.fieldField03,
      fieldHover01: ThemeGray100Theme.fieldFieldHover01,
      borderSubtle00: ThemeGray100Theme.borderBorderSubtle00,
      borderSubtle01: ThemeGray100Theme.borderBorderSubtle01,
      borderSubtle02: ThemeGray100Theme.borderBorderSubtle02,
      borderSubtle03: ThemeGray100Theme.borderBorderSubtle03,
      borderStrong01: ThemeGray100Theme.borderBorderStrong01,
      borderStrong02: ThemeGray100Theme.borderBorderStrong02,
      borderInteractive: ThemeGray100Theme.borderBorderInteractive,
      borderDisabled: ThemeGray100Theme.borderBorderDisabled,
      borderInverse: ThemeGray100Theme.borderBorderInverse,
      textPrimary: ThemeGray100Theme.textTextPrimary,
      textSecondary: ThemeGray100Theme.textTextSecondary,
      textPlaceholder: ThemeGray100Theme.textTextPlaceholder,
      textOnColor: ThemeGray100Theme.textTextOnColor,
      textOnColorDisabled: ThemeGray100Theme.textTextOnColorDisabled,
      textHelper: ThemeGray100Theme.textTextHelper,
      textError: ThemeGray100Theme.textTextError,
      textInverse: ThemeGray100Theme.textTextInverse,
      textDisabled: ThemeGray100Theme.textTextDisabled,
      buttonPrimary: ThemeGray100Theme.buttonButtonPrimary,
      buttonPrimaryHover: ThemeGray100Theme.buttonButtonPrimaryHover,
      buttonPrimaryActive: ThemeGray100Theme.buttonButtonPrimaryActive,
      buttonSecondary: ThemeGray100Theme.buttonButtonSecondary,
      buttonSecondaryHover: ThemeGray100Theme.buttonButtonSecondaryHover,
      buttonSecondaryActive: ThemeGray100Theme.buttonButtonSecondaryActive,
      buttonTertiary: ThemeGray100Theme.buttonButtonTertiary,
      buttonDangerPrimary: ThemeGray100Theme.buttonButtonDangerPrimary,
      buttonDangerHover: ThemeGray100Theme.buttonButtonDangerHover,
      buttonDangerActive: ThemeGray100Theme.buttonButtonDangerActive,
      buttonDisabled: ThemeGray100Theme.buttonButtonDisabled,
      supportError: ThemeGray100Theme.supportSupportError,
      supportSuccess: ThemeGray100Theme.supportSupportSuccess,
      supportWarning: ThemeGray100Theme.supportSupportWarning,
      supportInfo: ThemeGray100Theme.supportSupportInfo,
      supportErrorInverse: ThemeGray100Theme.supportSupportErrorInverse,
      supportSuccessInverse: ThemeGray100Theme.supportSupportSuccessInverse,
      supportWarningInverse: ThemeGray100Theme.supportSupportWarningInverse,
      supportInfoInverse: ThemeGray100Theme.supportSupportInfoInverse,
      focus: ThemeGray100Theme.focusFocus,
      focusInset: ThemeGray100Theme.focusFocusInset,
      focusInverse: ThemeGray100Theme.focusFocusInverse,
      iconPrimary: ThemeGray100Theme.iconIconPrimary,
      iconSecondary: ThemeGray100Theme.iconIconSecondary,
      iconOnColor: ThemeGray100Theme.iconIconOnColor,
      iconInteractive: ThemeGray100Theme.iconIconInteractive,
      linkPrimary: ThemeGray100Theme.linkLinkPrimary,
      linkSecondary: ThemeGray100Theme.linkLinkSecondary,
      linkInverse: ThemeGray100Theme.linkLinkInverse,
      interactive: ThemeGray100Theme.miscellaneousInteractive,
      highlight: ThemeGray100Theme.miscellaneousHighlight,
      overlay: ThemeGray100Theme.miscellaneousOverlay,
    );
  }

  final String name;
  final bool isDark;

  // Background
  final Color background;
  final Color backgroundActive;
  final Color backgroundHover;
  final Color backgroundSelected;
  final Color backgroundSelectedHover;
  final Color backgroundBrand;
  final Color backgroundInverse;
  final Color backgroundInverseHover;

  // Layers
  final Color layer01;
  final Color layer02;
  final Color layer03;
  final Color layerHover01;
  final Color layerHover02;
  final Color layerHover03;
  final Color layerActive01;
  final Color layerActive02;
  final Color layerActive03;
  final Color layerSelected01;
  final Color layerSelected02;
  final Color layerSelected03;
  final Color layerAccent01;
  final Color layerAccent02;
  final Color layerAccent03;

  // Fields
  final Color field01;
  final Color field02;
  final Color field03;
  final Color fieldHover01;

  // Borders
  final Color borderSubtle00;
  final Color borderSubtle01;
  final Color borderSubtle02;
  final Color borderSubtle03;
  final Color borderStrong01;
  final Color borderStrong02;
  final Color borderInteractive;
  final Color borderDisabled;
  final Color borderInverse;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textPlaceholder;
  final Color textOnColor;
  final Color textOnColorDisabled;
  final Color textHelper;
  final Color textError;
  final Color textInverse;
  final Color textDisabled;

  // Buttons
  final Color buttonPrimary;
  final Color buttonPrimaryHover;
  final Color buttonPrimaryActive;
  final Color buttonSecondary;
  final Color buttonSecondaryHover;
  final Color buttonSecondaryActive;
  final Color buttonTertiary;
  final Color buttonDangerPrimary;
  final Color buttonDangerHover;
  final Color buttonDangerActive;
  final Color buttonDisabled;

  // Support
  final Color supportError;
  final Color supportSuccess;
  final Color supportWarning;
  final Color supportInfo;
  final Color supportErrorInverse;
  final Color supportSuccessInverse;
  final Color supportWarningInverse;
  final Color supportInfoInverse;

  // Focus
  final Color focus;
  final Color focusInset;
  final Color focusInverse;

  // Icons
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconOnColor;
  final Color iconInteractive;

  // Links
  final Color linkPrimary;
  final Color linkSecondary;
  final Color linkInverse;

  // Miscellaneous
  final Color interactive;
  final Color highlight;
  final Color overlay;

  // Backwards compatibility / full token name aliases:
  Color get backgroundBackground => background;
  Color get backgroundBackgroundBrand => backgroundBrand;
  Color get backgroundBackgroundInverse => backgroundInverse;
  Color get layerLayer01 => layer01;
  Color get layerLayer02 => layer02;
  Color get layerLayer03 => layer03;
  Color get textTextPrimary => textPrimary;
  Color get textTextSecondary => textSecondary;
  Color get textTextOnColor => textOnColor;
  Color get textTextError => textError;
  Color get buttonButtonPrimary => buttonPrimary;
  Color get buttonButtonSecondary => buttonSecondary;
  Color get buttonButtonTertiary => buttonTertiary;
  Color get buttonButtonDangerPrimary => buttonDangerPrimary;
  Color get borderBorderSubtle00 => borderSubtle00;
  Color get borderBorderSubtle01 => borderSubtle01;
  Color get borderBorderStrong01 => borderStrong01;
  Color get supportSupportSuccess => supportSuccess;
  Color get supportSupportError => supportError;
  Color get supportSupportWarning => supportWarning;
  Color get supportSupportInfo => supportInfo;

  @override
  AppThemeTokens copyWith({
    String? name,
    bool? isDark,
    Color? background,
    Color? backgroundActive,
    Color? backgroundHover,
    Color? backgroundSelected,
    Color? backgroundSelectedHover,
    Color? backgroundBrand,
    Color? backgroundInverse,
    Color? backgroundInverseHover,
    Color? layer01,
    Color? layer02,
    Color? layer03,
    Color? layerHover01,
    Color? layerHover02,
    Color? layerHover03,
    Color? layerActive01,
    Color? layerActive02,
    Color? layerActive03,
    Color? layerSelected01,
    Color? layerSelected02,
    Color? layerSelected03,
    Color? layerAccent01,
    Color? layerAccent02,
    Color? layerAccent03,
    Color? field01,
    Color? field02,
    Color? field03,
    Color? fieldHover01,
    Color? borderSubtle00,
    Color? borderSubtle01,
    Color? borderSubtle02,
    Color? borderSubtle03,
    Color? borderStrong01,
    Color? borderStrong02,
    Color? borderInteractive,
    Color? borderDisabled,
    Color? borderInverse,
    Color? textPrimary,
    Color? textSecondary,
    Color? textPlaceholder,
    Color? textOnColor,
    Color? textOnColorDisabled,
    Color? textHelper,
    Color? textError,
    Color? textInverse,
    Color? textDisabled,
    Color? buttonPrimary,
    Color? buttonPrimaryHover,
    Color? buttonPrimaryActive,
    Color? buttonSecondary,
    Color? buttonSecondaryHover,
    Color? buttonSecondaryActive,
    Color? buttonTertiary,
    Color? buttonDangerPrimary,
    Color? buttonDangerHover,
    Color? buttonDangerActive,
    Color? buttonDisabled,
    Color? supportError,
    Color? supportSuccess,
    Color? supportWarning,
    Color? supportInfo,
    Color? supportErrorInverse,
    Color? supportSuccessInverse,
    Color? supportWarningInverse,
    Color? supportInfoInverse,
    Color? focus,
    Color? focusInset,
    Color? focusInverse,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconOnColor,
    Color? iconInteractive,
    Color? linkPrimary,
    Color? linkSecondary,
    Color? linkInverse,
    Color? interactive,
    Color? highlight,
    Color? overlay,
  }) {
    return AppThemeTokens(
      name: name ?? this.name,
      isDark: isDark ?? this.isDark,
      background: background ?? this.background,
      backgroundActive: backgroundActive ?? this.backgroundActive,
      backgroundHover: backgroundHover ?? this.backgroundHover,
      backgroundSelected: backgroundSelected ?? this.backgroundSelected,
      backgroundSelectedHover:
          backgroundSelectedHover ?? this.backgroundSelectedHover,
      backgroundBrand: backgroundBrand ?? this.backgroundBrand,
      backgroundInverse: backgroundInverse ?? this.backgroundInverse,
      backgroundInverseHover:
          backgroundInverseHover ?? this.backgroundInverseHover,
      layer01: layer01 ?? this.layer01,
      layer02: layer02 ?? this.layer02,
      layer03: layer03 ?? this.layer03,
      layerHover01: layerHover01 ?? this.layerHover01,
      layerHover02: layerHover02 ?? this.layerHover02,
      layerHover03: layerHover03 ?? this.layerHover03,
      layerActive01: layerActive01 ?? this.layerActive01,
      layerActive02: layerActive02 ?? this.layerActive02,
      layerActive03: layerActive03 ?? this.layerActive03,
      layerSelected01: layerSelected01 ?? this.layerSelected01,
      layerSelected02: layerSelected02 ?? this.layerSelected02,
      layerSelected03: layerSelected03 ?? this.layerSelected03,
      layerAccent01: layerAccent01 ?? this.layerAccent01,
      layerAccent02: layerAccent02 ?? this.layerAccent02,
      layerAccent03: layerAccent03 ?? this.layerAccent03,
      field01: field01 ?? this.field01,
      field02: field02 ?? this.field02,
      field03: field03 ?? this.field03,
      fieldHover01: fieldHover01 ?? this.fieldHover01,
      borderSubtle00: borderSubtle00 ?? this.borderSubtle00,
      borderSubtle01: borderSubtle01 ?? this.borderSubtle01,
      borderSubtle02: borderSubtle02 ?? this.borderSubtle02,
      borderSubtle03: borderSubtle03 ?? this.borderSubtle03,
      borderStrong01: borderStrong01 ?? this.borderStrong01,
      borderStrong02: borderStrong02 ?? this.borderStrong02,
      borderInteractive: borderInteractive ?? this.borderInteractive,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      borderInverse: borderInverse ?? this.borderInverse,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      textOnColor: textOnColor ?? this.textOnColor,
      textOnColorDisabled: textOnColorDisabled ?? this.textOnColorDisabled,
      textHelper: textHelper ?? this.textHelper,
      textError: textError ?? this.textError,
      textInverse: textInverse ?? this.textInverse,
      textDisabled: textDisabled ?? this.textDisabled,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonPrimaryHover: buttonPrimaryHover ?? this.buttonPrimaryHover,
      buttonPrimaryActive: buttonPrimaryActive ?? this.buttonPrimaryActive,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      buttonSecondaryHover: buttonSecondaryHover ?? this.buttonSecondaryHover,
      buttonSecondaryActive:
          buttonSecondaryActive ?? this.buttonSecondaryActive,
      buttonTertiary: buttonTertiary ?? this.buttonTertiary,
      buttonDangerPrimary: buttonDangerPrimary ?? this.buttonDangerPrimary,
      buttonDangerHover: buttonDangerHover ?? this.buttonDangerHover,
      buttonDangerActive: buttonDangerActive ?? this.buttonDangerActive,
      buttonDisabled: buttonDisabled ?? this.buttonDisabled,
      supportError: supportError ?? this.supportError,
      supportSuccess: supportSuccess ?? this.supportSuccess,
      supportWarning: supportWarning ?? this.supportWarning,
      supportInfo: supportInfo ?? this.supportInfo,
      supportErrorInverse: supportErrorInverse ?? this.supportErrorInverse,
      supportSuccessInverse:
          supportSuccessInverse ?? this.supportSuccessInverse,
      supportWarningInverse:
          supportWarningInverse ?? this.supportWarningInverse,
      supportInfoInverse: supportInfoInverse ?? this.supportInfoInverse,
      focus: focus ?? this.focus,
      focusInset: focusInset ?? this.focusInset,
      focusInverse: focusInverse ?? this.focusInverse,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconOnColor: iconOnColor ?? this.iconOnColor,
      iconInteractive: iconInteractive ?? this.iconInteractive,
      linkPrimary: linkPrimary ?? this.linkPrimary,
      linkSecondary: linkSecondary ?? this.linkSecondary,
      linkInverse: linkInverse ?? this.linkInverse,
      interactive: interactive ?? this.interactive,
      highlight: highlight ?? this.highlight,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) {
      return this;
    }
    return AppThemeTokens(
      name: t < 0.5 ? name : other.name,
      isDark: t < 0.5 ? isDark : other.isDark,
      background: Color.lerp(background, other.background, t)!,
      backgroundActive: Color.lerp(
        backgroundActive,
        other.backgroundActive,
        t,
      )!,
      backgroundHover: Color.lerp(backgroundHover, other.backgroundHover, t)!,
      backgroundSelected: Color.lerp(
        backgroundSelected,
        other.backgroundSelected,
        t,
      )!,
      backgroundSelectedHover: Color.lerp(
        backgroundSelectedHover,
        other.backgroundSelectedHover,
        t,
      )!,
      backgroundBrand: Color.lerp(backgroundBrand, other.backgroundBrand, t)!,
      backgroundInverse: Color.lerp(
        backgroundInverse,
        other.backgroundInverse,
        t,
      )!,
      backgroundInverseHover: Color.lerp(
        backgroundInverseHover,
        other.backgroundInverseHover,
        t,
      )!,
      layer01: Color.lerp(layer01, other.layer01, t)!,
      layer02: Color.lerp(layer02, other.layer02, t)!,
      layer03: Color.lerp(layer03, other.layer03, t)!,
      layerHover01: Color.lerp(layerHover01, other.layerHover01, t)!,
      layerHover02: Color.lerp(layerHover02, other.layerHover02, t)!,
      layerHover03: Color.lerp(layerHover03, other.layerHover03, t)!,
      layerActive01: Color.lerp(layerActive01, other.layerActive01, t)!,
      layerActive02: Color.lerp(layerActive02, other.layerActive02, t)!,
      layerActive03: Color.lerp(layerActive03, other.layerActive03, t)!,
      layerSelected01: Color.lerp(layerSelected01, other.layerSelected01, t)!,
      layerSelected02: Color.lerp(layerSelected02, other.layerSelected02, t)!,
      layerSelected03: Color.lerp(layerSelected03, other.layerSelected03, t)!,
      layerAccent01: Color.lerp(layerAccent01, other.layerAccent01, t)!,
      layerAccent02: Color.lerp(layerAccent02, other.layerAccent02, t)!,
      layerAccent03: Color.lerp(layerAccent03, other.layerAccent03, t)!,
      field01: Color.lerp(field01, other.field01, t)!,
      field02: Color.lerp(field02, other.field02, t)!,
      field03: Color.lerp(field03, other.field03, t)!,
      fieldHover01: Color.lerp(fieldHover01, other.fieldHover01, t)!,
      borderSubtle00: Color.lerp(borderSubtle00, other.borderSubtle00, t)!,
      borderSubtle01: Color.lerp(borderSubtle01, other.borderSubtle01, t)!,
      borderSubtle02: Color.lerp(borderSubtle02, other.borderSubtle02, t)!,
      borderSubtle03: Color.lerp(borderSubtle03, other.borderSubtle03, t)!,
      borderStrong01: Color.lerp(borderStrong01, other.borderStrong01, t)!,
      borderStrong02: Color.lerp(borderStrong02, other.borderStrong02, t)!,
      borderInteractive: Color.lerp(
        borderInteractive,
        other.borderInteractive,
        t,
      )!,
      borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t)!,
      borderInverse: Color.lerp(borderInverse, other.borderInverse, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      textOnColor: Color.lerp(textOnColor, other.textOnColor, t)!,
      textOnColorDisabled: Color.lerp(
        textOnColorDisabled,
        other.textOnColorDisabled,
        t,
      )!,
      textHelper: Color.lerp(textHelper, other.textHelper, t)!,
      textError: Color.lerp(textError, other.textError, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      buttonPrimaryHover: Color.lerp(
        buttonPrimaryHover,
        other.buttonPrimaryHover,
        t,
      )!,
      buttonPrimaryActive: Color.lerp(
        buttonPrimaryActive,
        other.buttonPrimaryActive,
        t,
      )!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
      buttonSecondaryHover: Color.lerp(
        buttonSecondaryHover,
        other.buttonSecondaryHover,
        t,
      )!,
      buttonSecondaryActive: Color.lerp(
        buttonSecondaryActive,
        other.buttonSecondaryActive,
        t,
      )!,
      buttonTertiary: Color.lerp(buttonTertiary, other.buttonTertiary, t)!,
      buttonDangerPrimary: Color.lerp(
        buttonDangerPrimary,
        other.buttonDangerPrimary,
        t,
      )!,
      buttonDangerHover: Color.lerp(
        buttonDangerHover,
        other.buttonDangerHover,
        t,
      )!,
      buttonDangerActive: Color.lerp(
        buttonDangerActive,
        other.buttonDangerActive,
        t,
      )!,
      buttonDisabled: Color.lerp(buttonDisabled, other.buttonDisabled, t)!,
      supportError: Color.lerp(supportError, other.supportError, t)!,
      supportSuccess: Color.lerp(supportSuccess, other.supportSuccess, t)!,
      supportWarning: Color.lerp(supportWarning, other.supportWarning, t)!,
      supportInfo: Color.lerp(supportInfo, other.supportInfo, t)!,
      supportErrorInverse: Color.lerp(
        supportErrorInverse,
        other.supportErrorInverse,
        t,
      )!,
      supportSuccessInverse: Color.lerp(
        supportSuccessInverse,
        other.supportSuccessInverse,
        t,
      )!,
      supportWarningInverse: Color.lerp(
        supportWarningInverse,
        other.supportWarningInverse,
        t,
      )!,
      supportInfoInverse: Color.lerp(
        supportInfoInverse,
        other.supportInfoInverse,
        t,
      )!,
      focus: Color.lerp(focus, other.focus, t)!,
      focusInset: Color.lerp(focusInset, other.focusInset, t)!,
      focusInverse: Color.lerp(focusInverse, other.focusInverse, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconOnColor: Color.lerp(iconOnColor, other.iconOnColor, t)!,
      iconInteractive: Color.lerp(iconInteractive, other.iconInteractive, t)!,
      linkPrimary: Color.lerp(linkPrimary, other.linkPrimary, t)!,
      linkSecondary: Color.lerp(linkSecondary, other.linkSecondary, t)!,
      linkInverse: Color.lerp(linkInverse, other.linkInverse, t)!,
      interactive: Color.lerp(interactive, other.interactive, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}
