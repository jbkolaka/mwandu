import 'package:flutter/widgets.dart';

/// Placement positions for a Carbon Popover relative to its anchor trigger.
enum CPopoverAlignment {
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

/// Configuration properties for [CPopover].
class CPopoverProps {
  const CPopoverProps({
    this.open = false,
    this.align = CPopoverAlignment.bottom,
    this.caret = true,
    this.dropShadow = true,
    this.highContrast = false,
    this.autoAlign = true,
    this.closeOnTapOutside = true,
    this.offset = 4.0,
    this.onRequestClose,
    this.trigger,
    this.content,
    this.triggerBuilder,
  });

  /// Whether the popover is currently open and visible.
  final bool open;

  /// Placement of the popover relative to the trigger.
  final CPopoverAlignment align;

  /// Whether to render a triangular caret pointer toward the trigger.
  final bool caret;

  /// Whether to render a drop shadow beneath the popover container.
  final bool dropShadow;

  /// If true, applies inverse high-contrast theme styling.
  final bool highContrast;

  /// Whether to automatically reposition the popover to prevent viewport overflow.
  final bool autoAlign;

  /// Whether tapping outside the popover requests it to close.
  final bool closeOnTapOutside;

  /// Distance in logical pixels between trigger and popover container.
  final double offset;

  /// Callback invoked when a close is requested (e.g. tap outside).
  final VoidCallback? onRequestClose;

  /// Trigger widget that anchors the popover.
  final Widget? trigger;

  /// Content rendered inside the floating popover surface.
  final Widget? content;

  /// Builder for dynamic or toggleable trigger widgets.
  final Widget Function(BuildContext context, VoidCallback toggle, bool isOpen)?
  triggerBuilder;
}
