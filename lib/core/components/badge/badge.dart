import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Visual variants for [Badge], each mapped to Carbon support-color tokens.
enum BadgeType {
  /// Neutral / informational badge — uses [AppThemeTokens.supportInfo].
  neutral,

  /// Success badge — uses [AppThemeTokens.supportSuccess].
  success,

  /// Warning badge — uses [AppThemeTokens.supportWarning].
  warning,

  /// Error / critical badge — uses [AppThemeTokens.supportError].
  error,
}

/// A compact, theme-aware badge styled strictly using Carbon design tokens.
///
/// The badge starts with an icon inside a circular container, followed by the
/// message text — matching the Carbon badge layout where the icon leads and
/// the message follows.
///
/// Colors are resolved from [AppThemeTokens] based on the [type] unless
/// individual overrides are supplied.
class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.type = BadgeType.neutral,
    this.title,
    this.circleColor,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.semanticLabel,
  });

  /// The text displayed after the icon. Required.
  final String message;

  /// The icon displayed inside the circular container.
  /// Defaults to [Icons.info_outline].
  final IconData icon;

  /// Visual variant controlling the default colors. Defaults to [BadgeType.neutral].
  final BadgeType type;

  /// Optional bold title displayed above the message.
  final String? title;

  /// Override for the circle container background color.
  /// Defaults to the support token for the given [type].
  final Color? circleColor;

  /// Override for the icon color.
  /// Defaults to [AppThemeTokens.iconOnColor].
  final Color? iconColor;

  /// Override for the message text color.
  /// Defaults to [AppThemeTokens.textPrimary].
  final Color? textColor;

  /// Override for the badge background color.
  /// Defaults to [AppThemeTokens.layer01].
  final Color? backgroundColor;

  /// Override for the badge border color.
  /// Defaults to [AppThemeTokens.borderSubtle01].
  final Color? borderColor;

  /// Accessible description for the badge. If omitted, the icon is decorative.
  final String? semanticLabel;

  /// Resolves the support color token for this badge's [type].
  Color _supportColor(AppThemeTokens tokens) {
    switch (type) {
      case BadgeType.neutral:
        return tokens.supportInfo;
      case BadgeType.success:
        return tokens.supportSuccess;
      case BadgeType.warning:
        return tokens.supportWarning;
      case BadgeType.error:
        return tokens.supportError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final supportColor = _supportColor(tokens);
    final effectiveCircleColor = circleColor ?? supportColor;
    final effectiveIconColor = iconColor ?? tokens.iconOnColor;
    final effectiveTextColor = textColor ?? tokens.textPrimary;
    final effectiveBgColor = backgroundColor ?? tokens.layer01;
    final effectiveBorderColor = borderColor ?? tokens.borderSubtle01;

    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.v12px075remSpacing04,
          vertical: Spacing.v8px05remSpacing03,
        ),
        decoration: BoxDecoration(
          color: effectiveBgColor,
          border: Border.all(color: effectiveBorderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon in a circular container — comes first.
            Container(
              width: Spacing.v24px15remSpacing06,
              height: Spacing.v24px15remSpacing06,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: effectiveCircleColor,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: Spacing.v16px1remSpacing05,
                color: effectiveIconColor,
              ),
            ),
            const SizedBox(width: Spacing.v8px05remSpacing03),
            // Message — follows the icon.
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: TextStyle(
                        color: effectiveTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: Spacing.v2px0125remSpacing01),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      color: effectiveTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HOW TO USE Badge:
// ============================================================================
//
// 1. Basic Neutral Badge:
//    const Badge(message: 'Scheduled')
//
// 2. Success Badge with a custom icon:
//    Badge(
//      message: 'Deployed successfully',
//      icon: Icons.check_circle_outline,
//      type: BadgeType.success,
//    )
//
// 3. Error Badge with a title:
//    Badge(
//      title: 'Failed',
//      message: 'Build failed on step 3',
//      icon: Icons.error_outline,
//      type: BadgeType.error,
//    )
//
// 4. Warning Badge with custom colors:
//    Badge(
//      message: 'Storage 85% full',
//      icon: Icons.warning_amber,
//      type: BadgeType.warning,
//      circleColor: Colors.orange,
//    )
// ============================================================================
