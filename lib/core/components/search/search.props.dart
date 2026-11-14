import 'package:flutter/widgets.dart';

/// Density variants for Carbon Search.
enum CSearchSize {
  /// Small size (height 32px).
  sm,

  /// Medium size (height 40px, default).
  md,

  /// Large size (height 48px).
  lg,
}

/// Configuration properties for [CSearch].
class CSearchProps {
  const CSearchProps({
    this.id,
    this.label,
    this.labelText,
    this.placeholder = 'Search',
    this.size = CSearchSize.md,
    this.enable = true,
    this.readOnly = false,
    this.autoFocus = false,
    this.value,
    this.controller,
    this.focusNode,
    this.closeButtonLabelText = 'Clear search input',
    this.isExpandable = false,
    this.expanded,
    this.defaultExpanded = false,
    this.defaultWidth,
    this.minWidth,
    this.onExpand,
    this.onChange,
    this.onSubmit,
    this.onClear,
  });

  /// Identifier for this search element.
  final String? id;

  /// Accessible label or caption for the search field.
  final String? label;

  /// Alias for [label] matching Carbon React spec.
  final String? labelText;

  /// Effective label text.
  String? get effectiveLabel => label ?? labelText;

  /// Placeholder hint text displayed when the field is empty.
  final String placeholder;

  /// Height and sizing variant.
  final CSearchSize size;

  /// Whether the search field is interactive.
  final bool enable;

  /// Whether the input is in a read-only state.
  final bool readOnly;

  /// Whether to autofocus the text input when mounted.
  final bool autoFocus;

  /// Initial or controlled text content.
  final String? value;

  /// Optional external controller for text editing.
  final TextEditingController? controller;

  /// Optional external focus node.
  final FocusNode? focusNode;

  /// Accessible label for the clear button.
  final String closeButtonLabelText;

  /// Whether this search field starts collapsed and expands when triggered.
  final bool isExpandable;

  /// Controlled expansion state for expandable search.
  final bool? expanded;

  /// Initial expansion state for uncontrolled expandable search.
  final bool defaultExpanded;

  /// Expanded width (or standard width) in logical pixels.
  final double? defaultWidth;

  /// Collapsed icon width for expandable search.
  final double? minWidth;

  /// Called when expansion state changes.
  final ValueChanged<bool>? onExpand;

  /// Called whenever the search query changes.
  final ValueChanged<String>? onChange;

  /// Called when the search query is submitted (e.g. on Enter).
  final ValueChanged<String>? onSubmit;

  /// Called when the clear button is activated.
  final VoidCallback? onClear;
}
