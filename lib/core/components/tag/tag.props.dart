import 'package:flutter/widgets.dart';

/// Density and height variants for Carbon Tag.
enum CTagSize {
  /// Small tag (height 18px).
  sm,

  /// Medium tag (height 24px, default).
  md,

  /// Large tag (height 32px).
  lg,
}

/// Color theme variants for Carbon Tag.
enum CTagType {
  red,
  magenta,
  purple,
  blue,
  cyan,
  teal,
  green,
  gray,
  coolGray,
  warmGray,
  highContrast,
  outline,
}

/// Configuration properties for [CTag].
class CTagProps {
  const CTagProps({
    required this.text,
    this.type = CTagType.gray,
    this.size = CTagSize.md,
    this.disabled = false,
    this.filter = false,
    this.selectable = false,
    this.selected = false,
    this.renderIcon,
    this.onTap,
    this.onClose,
    this.onSelectionChange,
    this.dismissTooltip = 'Dismiss tag',
  });

  /// The text content displayed inside the tag.
  final String text;

  /// Visual color type of the tag.
  final CTagType type;

  /// Height and sizing variant.
  final CTagSize size;

  /// Whether the tag is disabled.
  final bool disabled;

  /// Whether this is a dismissible filter tag displaying a close button.
  final bool filter;

  /// Whether this tag is an interactive selectable toggle tag.
  final bool selectable;

  /// Whether the selectable tag is currently selected.
  final bool selected;

  /// Optional leading icon rendered before the text.
  final Widget? renderIcon;

  /// Callback when the tag body is tapped (operational).
  final VoidCallback? onTap;

  /// Callback when the dismiss/close button is pressed on a filter tag.
  final VoidCallback? onClose;

  /// Callback when the selection state of a selectable tag toggles.
  final ValueChanged<bool>? onSelectionChange;

  /// Tooltip / accessibility label for the dismiss close button.
  final String dismissTooltip;
}
