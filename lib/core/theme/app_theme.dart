import 'package:flutter/material.dart';

import 'app_theme_tokens.dart';
import '../shared/styles/variables/spacing.style.dart';

/// Available theme modes matching the design system token sets.
enum AppThemeMode {
  white('White (Light)', Brightness.light),
  gray10('Gray 10 (Light)', Brightness.light),
  gray90('Gray 90 (Dark)', Brightness.dark),
  gray100('Gray 100 (Dark)', Brightness.dark);

  const AppThemeMode(this.displayName, this.brightness);

  final String displayName;
  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
}

/// Controller for reacting to and updating the current active theme.
class AppThemeController extends ValueNotifier<AppThemeMode> {
  AppThemeController([super.value = AppThemeMode.white]);

  /// Update active theme mode.
  void setThemeMode(AppThemeMode mode) {
    if (value != mode) {
      value = mode;
    }
  }

  /// Toggle between primary light (White) and primary dark (Gray 100).
  void toggleBrightness() {
    if (value.isDark) {
      value = AppThemeMode.white;
    } else {
      value = AppThemeMode.gray100;
    }
  }
}

/// Inherited scope providing access to [AppThemeController] throughout widget tree.
class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    super.key,
    required AppThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Access the nearest [AppThemeController].
  static AppThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'No AppThemeScope found in context');
    return scope!.notifier!;
  }

  /// Non-listening read of [AppThemeController].
  static AppThemeController read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<AppThemeScope>();
    final scope = element?.widget as AppThemeScope?;
    assert(scope != null, 'No AppThemeScope found in context');
    return scope!.notifier!;
  }
}

/// Factory and catalog of Flutter [ThemeData] mapped to design tokens.
abstract final class AppTheme {
  /// ThemeData for White Theme (Light)
  static ThemeData get whiteTheme => buildThemeData(AppThemeTokens.white());

  /// ThemeData for Gray 10 Theme (Light)
  static ThemeData get gray10Theme => buildThemeData(AppThemeTokens.gray10());

  /// ThemeData for Gray 90 Theme (Dark)
  static ThemeData get gray90Theme => buildThemeData(AppThemeTokens.gray90());

  /// ThemeData for Gray 100 Theme (Dark)
  static ThemeData get gray100Theme => buildThemeData(AppThemeTokens.gray100());

  /// Return [ThemeData] for a specific [AppThemeMode].
  static ThemeData themeDataFor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.white:
        return whiteTheme;
      case AppThemeMode.gray10:
        return gray10Theme;
      case AppThemeMode.gray90:
        return gray90Theme;
      case AppThemeMode.gray100:
        return gray100Theme;
    }
  }

  /// Return [AppThemeTokens] for a specific [AppThemeMode].
  static AppThemeTokens tokensFor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.white:
        return AppThemeTokens.white();
      case AppThemeMode.gray10:
        return AppThemeTokens.gray10();
      case AppThemeMode.gray90:
        return AppThemeTokens.gray90();
      case AppThemeMode.gray100:
        return AppThemeTokens.gray100();
    }
  }

  /// Builds a complete Flutter [ThemeData] tailored with [AppThemeTokens].
  static ThemeData buildThemeData(AppThemeTokens tokens) {
    final brightness = tokens.isDark ? Brightness.dark : Brightness.light;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.buttonPrimary,
      onPrimary: tokens.textOnColor,
      secondary: tokens.buttonSecondary,
      onSecondary: tokens.textOnColor,
      surface: tokens.layer01,
      onSurface: tokens.textPrimary,
      error: tokens.supportError,
      onError: tokens.textOnColor,
      outline: tokens.borderSubtle01,
      outlineVariant: tokens.borderSubtle00,
      shadow: tokens.overlay,
      inverseSurface: tokens.backgroundInverse,
      onInverseSurface: tokens.textInverse,
      inversePrimary: tokens.linkInverse,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.background,
      canvasColor: tokens.layer01,
      cardColor: tokens.layer01,
      dividerColor: tokens.borderSubtle01,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.background,
        foregroundColor: tokens.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: tokens.iconPrimary),
        titleTextStyle: TextStyle(
          color: tokens.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.layer01,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: tokens.borderSubtle00),
          borderRadius: BorderRadius.circular(Radius.none),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.buttonPrimary,
          foregroundColor: tokens.textOnColor,
          disabledBackgroundColor: tokens.buttonDisabled,
          disabledForegroundColor: tokens.textDisabled,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v16px1remSpacing05,
            vertical: Spacing.v12px075remSpacing04,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radius.none),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.buttonPrimary,
          side: BorderSide(color: tokens.buttonPrimary),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v16px1remSpacing05,
            vertical: Spacing.v12px075remSpacing04,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radius.none),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.linkPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v12px075remSpacing04,
            vertical: Spacing.v8px05remSpacing03,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.field01,
        hintStyle: TextStyle(color: tokens.textPlaceholder),
        labelStyle: TextStyle(color: tokens.textSecondary),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: tokens.borderStrong01),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tokens.borderStrong01),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tokens.focus, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tokens.supportError),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.v16px1remSpacing05,
          vertical: Spacing.v12px075remSpacing04,
        ),
      ),
      iconTheme: IconThemeData(color: tokens.iconPrimary, size: 20),
      dividerTheme: DividerThemeData(
        color: tokens.borderSubtle01,
        thickness: 1,
        space: 1,
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }
}

/// Convenience extensions on [BuildContext] for ergonomic access to tokens.
extension AppThemeContextExtension on BuildContext {
  /// The active [AppThemeTokens] from the current theme.
  AppThemeTokens get tokens =>
      Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.white();

  /// Alias for [tokens].
  AppThemeTokens get appTokens => tokens;

  /// The active [AppThemeMode].
  AppThemeMode get themeMode => AppThemeScope.of(this).value;

  /// Switch the active [AppThemeMode].
  void setThemeMode(AppThemeMode mode) =>
      AppThemeScope.of(this).setThemeMode(mode);

  /// Toggle light/dark brightness.
  void toggleBrightness() => AppThemeScope.of(this).toggleBrightness();
}
