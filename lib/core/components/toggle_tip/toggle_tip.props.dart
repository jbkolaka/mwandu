import 'package:flutter/widgets.dart';

/// Placement positions for a Carbon Toggletip relative to its trigger button.
enum CToggletipAlignment {
  /// Centered above the trigger.
  top,

  /// Above the trigger, aligned with its leading edge.
  topStart,

  /// Above the trigger, aligned with its trailing edge.
  topEnd,

  /// Centered below the trigger.
  bottom,

  /// Below the trigger, aligned with its leading edge.
  bottomStart,

  /// Below the trigger, aligned with its trailing edge.
  bottomEnd,

  /// Centered to the left of the trigger.
  left,

  /// To the left of the trigger, aligned with its top edge.
  leftStart,

  /// To the left of the trigger, aligned with its bottom edge.
  leftEnd,

  /// Centered to the right of the trigger.
  right,

  /// To the right of the trigger, aligned with its top edge.
  rightStart,

  /// To the right of the trigger, aligned with its bottom edge.
  rightEnd,
}

/// Configuration properties for [CToggletip].
class CToggletipProps {
  const CToggletipProps({
    this.align = CToggletipAlignment.bottom,
    this.defaultOpen = false,
    this.open,
    this.onOpenChange,
    this.label,
    this.labelText,
    this.buttonLabel = 'Show information',
    this.bodyText,
    this.trigger,
    this.content,
    this.actions,
    this.closeOnTapOutside = true,
    this.enable = true,
  });

  /// Placement of the toggletip popover surface relative to the trigger.
  final CToggletipAlignment align;

  /// Initial open state for uncontrolled toggletip.
  final bool defaultOpen;

  /// Controlled open state.
  final bool? open;

  /// Callback invoked when open state changes.
  final ValueChanged<bool>? onOpenChange;

  /// Optional label displayed beside the toggletip trigger button.
  final String? label;

  /// Alias for [label] matching Carbon React spec.
  final String? labelText;

  /// Effective label text.
  String? get effectiveLabel => label ?? labelText;

  /// Accessible label for the trigger button.
  final String buttonLabel;

  /// Convenience text body for simple informational toggletips.
  final String? bodyText;

  /// Custom trigger widget (defaults to standard info icon button).
  final Widget? trigger;

  /// Rich custom content body.
  final Widget? content;

  /// Action controls rendered at the bottom of the toggletip.
  final Widget? actions;

  /// Whether tapping outside the toggletip closes it.
  final bool closeOnTapOutside;

  /// Whether the toggletip trigger is interactive.
  final bool enable;
}
