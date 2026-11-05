import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// A neutral alert component styled strictly using theme tokens.
///
/// Starts with an icon in a circle container followed by
/// the alert message ("This is a neutral alert" by default),
/// and action button(s) placed below (down) not in the row.
/// The secondary button is optional via [showSecondaryButton].
class AlertsNeutral extends StatelessWidget {
  const AlertsNeutral({
    super.key,
    this.message = 'This is a neutral alert',
    this.title,
    this.icon = Icons.info_outline,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.showSecondaryButton = false,
    this.secondaryButtonText = 'Dismiss',
    this.onSecondaryPressed,
    this.actions,
    this.circleColor,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.trailing,
    this.onClose,
    this.buttonsBelow = true,
  });

  /// The text displayed in the alert. Defaults to "This is a neutral alert".
  final String message;

  /// Optional bold title displayed above the message.
  final String? title;

  /// The icon displayed inside the circle container. Defaults to [Icons.info_outline].
  final IconData icon;

  /// Optional label for a primary action button.
  final String? primaryButtonText;

  /// Optional callback when primary action button is tapped.
  final VoidCallback? onPrimaryPressed;

  /// Whether to display a secondary action button. Defaults to false.
  final bool showSecondaryButton;

  /// Optional label for a secondary action button. Defaults to "Dismiss".
  final String? secondaryButtonText;

  /// Optional callback when secondary action button is tapped.
  final VoidCallback? onSecondaryPressed;

  /// Optional custom action buttons.
  final List<Widget>? actions;

  /// Optional override for the circle container background color.
  /// Defaults to [AppThemeTokens.supportInfo].
  final Color? circleColor;

  /// Optional override for the icon color.
  /// Defaults to [AppThemeTokens.iconOnColor].
  final Color? iconColor;

  /// Optional override for the message text color.
  /// Defaults to [AppThemeTokens.textPrimary].
  final Color? textColor;

  /// Optional override for the container background color.
  /// Defaults to [AppThemeTokens.layer01].
  final Color? backgroundColor;

  /// Optional override for the border color.
  /// Defaults to [AppThemeTokens.borderSubtle01].
  final Color? borderColor;

  /// Optional trailing widget, such as an action or button.
  final Widget? trailing;

  /// Optional callback invoked when the close icon button is tapped.
  final VoidCallback? onClose;

  /// Whether buttons should appear below the message instead of in the same row.
  /// Defaults to true.
  final bool buttonsBelow;

  List<Widget> _buildButtons(BuildContext context, AppThemeTokens tokens) {
    if (actions != null) {
      return actions!;
    }

    final buttons = <Widget>[];

    // Primary button
    if (primaryButtonText != null) {
      buttons.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: tokens.buttonPrimary,
            foregroundColor: tokens.textOnColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.v16px1remSpacing05,
              vertical: Spacing.v8px05remSpacing03,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: onPrimaryPressed ?? () {},
          child: Text(
            primaryButtonText!,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    // Secondary button (shown only if showSecondaryButton is true)
    if (showSecondaryButton && secondaryButtonText != null) {
      buttons.add(
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: tokens.buttonSecondary,
            side: BorderSide(color: tokens.borderStrong01),
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.v16px1remSpacing05,
              vertical: Spacing.v8px05remSpacing03,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: onSecondaryPressed ?? () {},
          child: Text(
            secondaryButtonText!,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final effectiveBgColor = backgroundColor ?? tokens.layer01;
    final effectiveBorderColor = borderColor ?? tokens.borderSubtle01;
    final effectiveCircleColor = circleColor ?? tokens.supportInfo;
    final effectiveIconColor = iconColor ?? tokens.iconOnColor;
    final effectiveTextColor = textColor ?? tokens.textPrimary;
    final buttonWidgets = _buildButtons(context, tokens);

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
      child: buttonsBelow
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
                        icon,
                        size: Spacing.v16px1remSpacing05,
                        color: effectiveIconColor,
                      ),
                    ),
                    const SizedBox(width: Spacing.v12px075remSpacing04),
                    // Alert message
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
                    if (trailing != null) ...[
                      const SizedBox(width: Spacing.v8px05remSpacing03),
                      trailing!,
                    ],
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
                if (buttonWidgets.isNotEmpty) ...[
                  const SizedBox(height: Spacing.v12px075remSpacing04),
                  Padding(
                    padding: const EdgeInsets.only(
                      left:
                          Spacing.v24px15remSpacing06 +
                          Spacing.v12px075remSpacing04,
                    ),
                    child: Wrap(
                      spacing: Spacing.v8px05remSpacing03,
                      runSpacing: Spacing.v8px05remSpacing03,
                      children: buttonWidgets,
                    ),
                  ),
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon in a circle container
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
                const SizedBox(width: Spacing.v12px075remSpacing04),
                // Alert message
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
                if (buttonWidgets.isNotEmpty) ...[
                  const SizedBox(width: Spacing.v16px1remSpacing05),
                  Wrap(
                    spacing: Spacing.v8px05remSpacing03,
                    runSpacing: Spacing.v8px05remSpacing03,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: buttonWidgets,
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(width: Spacing.v8px05remSpacing03),
                  trailing!,
                ],
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

/// Alias for [AlertsNeutral] for singular naming convention.
typedef AlertNeutral = AlertsNeutral;


// ============================================================================
// HOW TO USE AlertsNeutral:
// ============================================================================
//
// 1. Basic Neutral Alert:
//    const AlertsNeutral()
//
// 2. Custom Title and Message:
//    AlertsNeutral(
//      title: 'Information',
//      message: 'This is a neutral alert explaining background system status.',
//      onClose: () => print('Alert dismissed'),
//    )
//
// 3. With Action Button placed down below:
//    AlertsNeutral(
//      message: 'A newer version of your dataset is available.',
//      primaryButtonText: 'Sync Now',
//      onPrimaryPressed: () => print('Syncing...'),
//    )
//
// 4. With Primary and Secondary Action Buttons:
//    AlertsNeutral(
//      title: 'Preferences Updated',
//      message: 'Your notification preferences have been saved to the cloud.',
//      primaryButtonText: 'View Settings',
//      onPrimaryPressed: () => print('Open settings'),
//      showSecondaryButton: true,
//      secondaryButtonText: 'Dismiss',
//      onSecondaryPressed: () => print('Dismissed'),
//    )
// ============================================================================
