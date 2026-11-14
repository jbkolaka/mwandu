/// Placement alignment for Carbon Tooltip relative to its target element.
enum CTooltipAlignment {
  /// Centered above the target.
  top,

  /// Above the target, aligned to the leading edge.
  topStart,

  /// Above the target, aligned to the trailing edge.
  topEnd,

  /// Centered below the target.
  bottom,

  /// Below the target, aligned to the leading edge.
  bottomStart,

  /// Below the target, aligned to the trailing edge.
  bottomEnd,

  /// Centered to the left of the target.
  left,

  /// To the left of the target, aligned to the top edge.
  leftStart,

  /// To the left of the target, aligned to the bottom edge.
  leftEnd,

  /// Centered to the right of the target.
  right,

  /// To the right of the target, aligned to the top edge.
  rightStart,

  /// To the right of the target, aligned to the bottom edge.
  rightEnd,
}

/// Configuration properties for [CTooltip].
class CTooltipProps {
  const CTooltipProps({
    required this.label,
    this.align = CTooltipAlignment.bottom,
    this.enterDelay = const Duration(milliseconds: 100),
    this.leaveDelay = const Duration(milliseconds: 300),
    this.autoAlign = true,
    this.closeOnActivation = true,
    this.highContrast = true,
    this.caret = true,
    this.enable = true,
  });

  /// Informational tooltip text label to display.
  final String label;

  /// Directional placement of the tooltip surface relative to the target.
  final CTooltipAlignment align;

  /// Delay duration before displaying the tooltip on hover or focus.
  final Duration enterDelay;

  /// Delay duration before hiding the tooltip once mouse leaves or focus is lost.
  final Duration leaveDelay;

  /// Whether to automatically adjust placement if the tooltip would bleed off screen.
  final bool autoAlign;

  /// Whether clicking / activating the target closes the tooltip immediately.
  final bool closeOnActivation;

  /// Whether to use Carbon high-contrast styling (standard for tooltips).
  final bool highContrast;

  /// Whether to render a triangular caret pointer directed at the target element.
  final bool caret;

  /// Whether the tooltip is enabled and can be shown.
  final bool enable;
}
