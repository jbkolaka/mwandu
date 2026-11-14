import 'package:flutter/widgets.dart';

/// Density and height variants for Carbon Select.
enum CSelectSize {
  /// Small size (height 32px).
  sm,

  /// Medium size (height 40px, default).
  md,

  /// Large size (height 48px).
  lg,
}

/// An individual selectable option within [CSelect].
class CSelectItem<T> {
  const CSelectItem({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  /// The value associated with this choice.
  final T value;

  /// Text displayed for this option.
  final String label;

  /// Whether this option cannot be selected.
  final bool disabled;
}

/// A logical grouping of [CSelectItem] choices under a category header.
class CSelectItemGroup<T> {
  const CSelectItemGroup({
    required this.label,
    required this.items,
    this.disabled = false,
  });

  /// Category heading for the group.
  final String label;

  /// The items contained in this group.
  final List<CSelectItem<T>> items;

  /// Whether all items in this group are disabled.
  final bool disabled;
}

/// Configuration properties for [CSelect].
class CSelectProps<T> {
  const CSelectProps({
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.labelText,
    this.helperText,
    this.invalidText,
    this.warnText,
    this.placeholder = 'Choose an option',
    this.size = CSelectSize.md,
    this.inline = false,
    this.hideLabel = false,
    this.invalid = false,
    this.warn = false,
    this.enable = true,
    this.readOnly = false,
  });

  /// Available choices to pick from.
  final List<CSelectItem<T>> items;

  /// Currently selected item value.
  final T? value;

  /// Called when the selected item changes.
  final ValueChanged<T?>? onChanged;

  /// Label displayed above or beside the select input.
  final String? label;

  /// Alias for [label] matching Carbon React spec.
  final String? labelText;

  /// Effective label text.
  String? get effectiveLabel => label ?? labelText;

  /// Supplementary descriptive text displayed below the field.
  final String? helperText;

  /// Error message shown when [invalid] is true.
  final String? invalidText;

  /// Warning message shown when [warn] is true.
  final String? warnText;

  /// Placeholder prompt when no option is chosen.
  final String placeholder;

  /// Vertical size and density variant.
  final CSelectSize size;

  /// Whether the label is positioned inline to the left of the field.
  final bool inline;

  /// Whether the label is visually hidden.
  final bool hideLabel;

  /// Whether the select is currently in an error state.
  final bool invalid;

  /// Whether the select is currently in a warning state.
  final bool warn;

  /// Whether the select is interactive.
  final bool enable;

  /// Whether the select is in a read-only state.
  final bool readOnly;
}
