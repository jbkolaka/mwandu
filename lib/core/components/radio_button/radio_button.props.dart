import 'package:flutter/widgets.dart';

/// Layout orientation for radio button groups.
enum CRadioButtonOrientation {
  /// Radio buttons are arranged horizontally side-by-side.
  horizontal,

  /// Radio buttons are stacked vertically.
  vertical,
}

/// Placement of the label relative to the radio circle.
enum CRadioButtonLabelPosition {
  /// The label appears to the right of the radio circle (standard).
  right,

  /// The label appears to the left of the radio circle.
  left,
}

/// Properties for an individual [CRadioButton].
class CRadioButtonProps<T> {
  const CRadioButtonProps({
    required this.value,
    this.label,
    this.enable = true,
    this.hideLabel = false,
    this.readOnly = false,
    this.labelPosition = CRadioButtonLabelPosition.right,
    this.id,
    this.helperText,
    this.selected,
    this.onChange,
  });

  /// The value represented by this radio button.
  final T value;

  /// Text displayed alongside the radio button.
  final String? label;

  /// Alias for [label] matching Carbon React spec.
  String? get labelText => label;

  /// Whether this individual radio button is interactive.
  final bool enable;

  /// If true, visually hides the label while retaining semantic accessibility.
  final bool hideLabel;

  /// If true, the radio button cannot be altered by the user.
  final bool readOnly;

  /// Placement of the label relative to the radio button.
  final CRadioButtonLabelPosition labelPosition;

  /// Identifier for the radio button.
  final String? id;

  /// Supplementary descriptive text for this specific option.
  final String? helperText;

  /// Explicitly controls selection state when used outside a [CRadioButtonGroup].
  final bool? selected;

  /// Called when this radio button is selected.
  final ValueChanged<T>? onChange;
}

/// Properties for [CRadioButtonGroup].
class CRadioButtonGroupProps<T> {
  const CRadioButtonGroupProps({
    this.legendText,
    this.name,
    this.valueSelected,
    this.defaultSelected,
    this.orientation = CRadioButtonOrientation.vertical,
    this.labelPosition = CRadioButtonLabelPosition.right,
    this.enable = true,
    this.readOnly = false,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.helperText,
    this.onChange,
    this.children = const [],
  });

  /// Group title or legend displayed above the radio options.
  final String? legendText;

  /// HTML-style group name for form identification.
  final String? name;

  /// The currently selected value for controlled usage.
  final T? valueSelected;

  /// Initial selected value for uncontrolled usage.
  final T? defaultSelected;

  /// Arrangement of radio buttons within the group.
  final CRadioButtonOrientation orientation;

  /// Default placement of the label for children in this group.
  final CRadioButtonLabelPosition labelPosition;

  /// Whether the entire group is enabled.
  final bool enable;

  /// Whether the group is read-only.
  final bool readOnly;

  /// Whether the group is currently in an invalid error state.
  final bool invalid;

  /// Error message shown when [invalid] is true.
  final String? invalidText;

  /// Whether the group is currently in a warning state.
  final bool warn;

  /// Warning message shown when [warn] is true.
  final String? warnText;

  /// Helper text displayed beneath the group options.
  final String? helperText;

  /// Callback fired whenever a radio option in the group is chosen.
  final ValueChanged<T>? onChange;

  /// The list of [CRadioButton] widgets that belong to this group.
  final List<Widget> children;
}
