import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'alerts_withbuttons.dart' show AlertVariant;

/// An alert component featuring an interactive text link, styled strictly using theme tokens.
///
/// Starts with an icon in a circle container followed by
/// the alert message ("This is a neutral alert" by default),
/// and an interactive text link (without an arrow icon).
class AlertsWithLink extends StatelessWidget {
  const AlertsWithLink({
    super.key,
    this.message = 'This is a neutral alert',
    this.title,
    this.linkText = 'Action link',
    this.onLinkTap,
    this.variant = AlertVariant.neutral,
    this.icon,
    this.circleColor,
    this.iconColor,
    this.textColor,
    this.linkColor,
    this.backgroundColor,
    this.borderColor,
    this.onClose,
    this.linkBelow = false,
  });

  /// The text displayed in the alert. Defaults to "This is a neutral alert".
  final String message;

  /// Optional bold title displayed above the message.
  final String? title;

  /// The text for the interactive link. Defaults to "Action link".
  final String linkText;

  /// Callback when the link is tapped.
  final VoidCallback? onLinkTap;

  /// Variant of the alert (neutral, positive, negative, warning).
  /// Defaults to [AlertVariant.neutral].
  final AlertVariant variant;

  /// The icon displayed inside the circle container.
  /// If null, defaults according to [variant] (e.g. [Icons.info_outline] for neutral).
  final IconData? icon;

  /// Optional override for the circle container background color.
  /// Defaults to [AppThemeTokens.supportInfo].
  final Color? circleColor;

  /// Optional override for the icon color.
  /// Defaults to [AppThemeTokens.iconOnColor].
  final Color? iconColor;

  /// Optional override for the message text color.
  /// Defaults to [AppThemeTokens.textPrimary].
  final Color? textColor;

  /// Optional override for the link color.
  /// Defaults to [AppThemeTokens.linkPrimary].
  final Color? linkColor;

  /// Optional override for the container background color.
  /// Defaults to [AppThemeTokens.layer01].
  final Color? backgroundColor;

  /// Optional override for the border color.
  /// Defaults to [AppThemeTokens.borderSubtle01].
  final Color? borderColor;

  /// Optional callback invoked when the close icon button is tapped.
  final VoidCallback? onClose;

  /// Whether the link should appear below the message rather than inline.
  /// Defaults to false.
  final bool linkBelow;

  Color _resolveCircleColor(AppThemeTokens tokens) {
    if (circleColor != null) return circleColor!;
    switch (variant) {
      case AlertVariant.neutral:
        return tokens.supportInfo;
      case AlertVariant.positive:
        return tokens.supportSuccess;
      case AlertVariant.negative:
        return tokens.supportError;
      case AlertVariant.warning:
        return tokens.supportWarning;
    }
  }

  IconData _resolveIcon() {
    if (icon != null) return icon!;
    switch (variant) {
      case AlertVariant.neutral:
        return Icons.info_outline;
      case AlertVariant.positive:
        return Icons.check_circle_outline;
      case AlertVariant.negative:
        return Icons.error_outline;
      case AlertVariant.warning:
        return Icons.warning_amber_rounded;
    }
  }

  Widget _buildLink(BuildContext context, Color effectiveLinkColor) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onLinkTap,
        child: Text(
          linkText,
          style: TextStyle(
            color: effectiveLinkColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            decorationColor: effectiveLinkColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final effectiveBgColor = backgroundColor ?? tokens.layer01;
    final effectiveBorderColor = borderColor ?? tokens.borderSubtle01;
    final effectiveCircleColor = _resolveCircleColor(tokens);
    final effectiveIconColor = iconColor ?? tokens.iconOnColor;
    final effectiveTextColor = textColor ?? tokens.textPrimary;
    final effectiveLinkColor = linkColor ?? tokens.linkPrimary;
    final effectiveIcon = _resolveIcon();

    final linkWidget = _buildLink(context, effectiveLinkColor);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v16px1remSpacing05,
        vertical: Spacing.v12px075remSpacing04,
      ),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        border: Border.all(color: effectiveBorderColor, width: 1),
      ),
      child: linkBelow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon in circle container
                    Container(
                      width: Spacing.v24px15remSpacing06,
                      height: Spacing.v24px15remSpacing06,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: effectiveCircleColor,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        effectiveIcon,
                        size: Spacing.v16px1remSpacing05,
                        color: effectiveIconColor,
                      ),
                    ),
                    const SizedBox(width: Spacing.v12px075remSpacing04),
                    // Message
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null) ...[
                            Text(
                              title!,
                              style: TextStyle(
                                color: effectiveTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: Spacing.v4px025remSpacing02),
                          ],
                          Text(
                            message,
                            style: TextStyle(
                              color: effectiveTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onClose != null) ...[
                      const SizedBox(width: Spacing.v8px05remSpacing03),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          size: Spacing.v16px1remSpacing05,
                          color: tokens.iconPrimary,
                        ),
                        onPressed: onClose,
                        tooltip: 'Close',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: Spacing.v8px05remSpacing03),
                Padding(
                  padding: const EdgeInsets.only(
                    left:
                        Spacing.v24px15remSpacing06 +
                        Spacing.v12px075remSpacing04,
                  ),
                  child: linkWidget,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon in circle container
                Container(
                  width: Spacing.v24px15remSpacing06,
                  height: Spacing.v24px15remSpacing06,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: effectiveCircleColor,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    effectiveIcon,
                    size: Spacing.v16px1remSpacing05,
                    color: effectiveIconColor,
                  ),
                ),
                const SizedBox(width: Spacing.v12px075remSpacing04),
                // Message + Inline link
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) ...[
                        Text(
                          title!,
                          style: TextStyle(
                            color: effectiveTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: Spacing.v4px025remSpacing02),
                      ],
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: Spacing.v8px05remSpacing03,
                        children: [
                          Text(
                            message,
                            style: TextStyle(
                              color: effectiveTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          linkWidget,
                        ],
                      ),
                    ],
                  ),
                ),
                if (onClose != null) ...[
                  const SizedBox(width: Spacing.v8px05remSpacing03),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close,
                      size: Spacing.v16px1remSpacing05,
                      color: tokens.iconPrimary,
                    ),
                    onPressed: onClose,
                    tooltip: 'Close',
                  ),
                ],
              ],
            ),
    );
  }
}

/// Alias for [AlertWithLink] for plural naming convention.
typedef AlertWithLink = AlertsWithLink;

// ============================================================================
// HOW TO USE AlertsWithLink:
// ============================================================================
//
// 1. Basic Alert with Inline Link:
//    AlertsWithLink(
//      message: 'This is a neutral alert with an action link.',
//      linkText: 'Action link',
//      onLinkTap: () => print('Link tapped!'),
//    )
//
// 2. Alert with Link Placed Below the Message:
//    AlertsWithLink(
//      title: 'System Notice',
//      message: 'Your workspace settings have been synchronized across all devices.',
//      linkText: 'View account settings',
//      linkBelow: true,
//      onLinkTap: () => print('Opening settings'),
//      onClose: () => print('Alert dismissed'),
//    )
//
// 3. Custom Token Overrides:
//    AlertsWithLink(
//      message: 'Read the privacy policy update.',
//      linkText: 'Read policy',
//      onLinkTap: () => print('Opening policy'),
//      linkColor: context.tokens.linkPrimary,
//      backgroundColor: context.tokens.layer01,
//      borderColor: context.tokens.borderSubtle01,
//    )
// ============================================================================
