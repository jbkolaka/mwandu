import 'package:flutter/widgets.dart';

/// Available sizes for the Carbon Dropdown component.
enum CDropdownSize {
  /// Small compact dropdown (32px field height).
  sm,

  /// Medium default dropdown (40px field height).
  md,

  /// Large dropdown (48px field height).
  lg,
}

/// Visual layout presentation of the dropdown and its label.
enum CDropdownType {
  /// Standard vertical layout with label positioned above the field.
  defaultType,

  /// Horizontal inline layout with label positioned beside the field.
  inline,
}

/// A selectable item in a Carbon Dropdown.
class CDropdownItem<T> {
  const CDropdownItem({
    required this.value,
    required this.label,
    this.disabled = false,
    this.icon,
  });

  /// The underlying value represented by this item.
  final T value;

  /// Human-readable label displayed in the field and menu.
  final String label;

  /// Whether this option is non-selectable.
  final bool disabled;

  /// Optional leading icon.
  final Widget? icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CDropdownItem &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => Object.hash(value, label);
}

/// Configuration properties for [CDropdown].
class CDropdownProps<T> {
  const CDropdownProps({
    required this.items,
    this.selectedItem,
    this.label,
    this.helperText,
    this.placeholder = 'Select an option',
    this.invalidText,
    this.warnText,
    this.size = CDropdownSize.md,
    this.type = CDropdownType.defaultType,
    this.disabled = false,
    this.readOnly = false,
    this.isClearable = false,
    this.filterable = false,
    this.hideLabel = false,
    this.onChanged,
  });

  /// Available selectable items.
  final List<CDropdownItem<T>> items;

  /// Currently selected item, if any.
  final CDropdownItem<T>? selectedItem;

  /// Descriptive title label for the dropdown.
  final String? label;

  /// Supplementary guidance text beneath the label or field.
  final String? helperText;

  /// Placeholder text displayed when no option is selected.
  final String placeholder;

  /// Error message placing the dropdown in an invalid state.
  final String? invalidText;

  /// Warning message placing the dropdown in a warn state.
  final String? warnText;

  /// Height and typography scale variant.
  final CDropdownSize size;

  /// Layout presentation mode (default stacked or inline).
  final CDropdownType type;

  /// Whether the entire dropdown control is disabled.
  final bool disabled;

  /// Whether the dropdown is read-only.
  final bool readOnly;

  /// Whether a clear icon appears when an item is selected.
  final bool isClearable;

  /// Whether users can filter/search options by typing.
  final bool filterable;

  /// Whether to visually hide the label while keeping it accessible.
  final bool hideLabel;

  /// Callback invoked when selection changes or is cleared.
  final ValueChanged<CDropdownItem<T>?>? onChanged;

  /// Whether the dropdown is currently in an invalid error state.
  bool get isInvalid => invalidText != null && invalidText!.isNotEmpty;

  /// Whether the dropdown is currently in a warning state.
  bool get isWarn => !isInvalid && warnText != null && warnText!.isNotEmpty;
}
