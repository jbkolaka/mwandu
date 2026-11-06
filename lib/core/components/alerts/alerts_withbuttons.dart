import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Supported alert types for [AlertsWithButtons].
enum AlertVariant {
  neutral,
  positive,
  negative,
  warning;

  bool get isNeutral => this == AlertVariant.neutral;
  bool get isPositive => this == AlertVariant.positive;
  bool get isNegative => this == AlertVariant.negative;
  bool get isWarning => this == AlertVariant.warning;
}

/// An alert component with buttons placed below the message,
/// styled strictly using theme tokens.
///
/// Starts with an icon in a circle container followed by
/// the alert message ("This is a neutral alert" by default),
/// with action button(s) placed below (down) not in the top row.
/// The secondary button is optional via [showSecondaryButton].
class AlertsWithButtons extends StatelessWidget {
  const AlertsWithButtons({
    super.key,
    this.message = 'This is a neutral alert',
    this.title,
    this.variant = AlertVariant.neutral,
    this.icon,
    this.primaryButtonText = 'Action',
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
    this.onClose,
    this.buttonsBelow = true,
  });

  /// The text displayed in the alert. Defaults to "This is a neutral alert".
  final String message;

  /// Optional bold title displayed above the message.
  final String? title;

  /// Variant of the alert (neutral, positive, negative, warning).
  /// Defaults to [AlertVariant.neutral].
  final AlertVariant variant;

  /// The icon displayed inside the circle container.
  /// If null, defaults according to [variant] (e.g. [Icons.info_outline] for neutral).
  final IconData? icon;

  /// Label for the primary button. Defaults to "Action".
  /// Set to null if only custom [actions] are used.
  final String? primaryButtonText;

  /// Callback when primary button is tapped.
  final VoidCallback? onPrimaryPressed;

  /// Whether to display a secondary action button. Defaults to false.
  /// Set to true to include the secondary button.
  final bool showSecondaryButton;

  /// Label for the secondary button. Defaults to "Dismiss".
  final String? secondaryButtonText;

  /// Callback when secondary button is tapped.
  final VoidCallback? onSecondaryPressed;

  /// Custom action buttons. If provided, replaces the default primary/secondary buttons.
  final List<Widget>? actions;

  /// Optional override for the circle container background color.
  final Color? circleColor;

  /// Optional override for the icon color.
  final Color? iconColor;

  /// Optional override for the message text color.
  final Color? textColor;

  /// Optional override for the container background color.
  final Color? backgroundColor;

  /// Optional override for the border color.
  final Color? borderColor;

  /// Optional callback invoked when the close icon button is tapped.
  final VoidCallback? onClose;

  /// Whether action buttons should be placed below the message instead of in the same row.
  /// Defaults to true.
  final bool buttonsBelow;

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
    final effectiveCircleColor = _resolveCircleColor(tokens);
    final effectiveIconColor = iconColor ?? tokens.iconOnColor;
    final effectiveTextColor = textColor ?? tokens.textPrimary;
    final effectiveIcon = _resolveIcon();
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
                if (buttonWidgets.isNotEmpty) ...[
                  const SizedBox(width: Spacing.v16px1remSpacing05),
                  Wrap(
                    spacing: Spacing.v8px05remSpacing03,
                    runSpacing: Spacing.v8px05remSpacing03,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: buttonWidgets,
                  ),
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

/// Alias for [AlertsWithButtons] for singular naming convention.
typedef AlertWithButtons = AlertsWithButtons;

// ============================================================================
// HOW TO USE AlertsWithButtons:
// ============================================================================
//
// 1. Basic Alert with Primary Button Only (Down Below):
//    AlertsWithButtons(
//      message: 'This is a neutral alert with a single action.',
//      primaryButtonText: 'Action',
//      showSecondaryButton: false, // Default is false
//      onPrimaryPressed: () => print('Action clicked'),
//    )
//
// 2. Alert with Both Primary and Secondary Buttons:
//    AlertsWithButtons(
//      title: 'Confirmation Required',
//      message: 'Do you want to apply these changes to your project?',
//      primaryButtonText: 'Confirm',
//      onPrimaryPressed: () => print('Confirmed'),
//      showSecondaryButton: true, // Enables secondary button
//      secondaryButtonText: 'Dismiss',
//      onSecondaryPressed: () => print('Dismissed'),
//      onClose: () => print('Closed'),
//    )
//
// 3. Different Variants (neutral, positive, negative, warning):
//    AlertsWithButtons(
//      variant: AlertVariant.positive,
//      message: 'Payment completed successfully.',
//      primaryButtonText: 'View Receipt',
//      onPrimaryPressed: () => print('Opening receipt'),
//    )
//
// 4. Custom Action Widgets:
//    AlertsWithButtons(
//      message: 'Custom button bar.',
//      actions: [
//        TextButton(onPressed: () {}, child: const Text('Custom Action')),
//      ],
//    )
// ============================================================================
