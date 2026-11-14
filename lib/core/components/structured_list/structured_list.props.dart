import 'package:flutter/widgets.dart';

/// Configuration properties for Carbon Structured List.
class CStructuredListProps {
  const CStructuredListProps({
    this.selection = false,
    this.isCondensed = false,
    this.isFlush = false,
    this.selectedIndex,
    this.initialSelectedIndex,
    this.onSelectionChange,
    this.enable = true,
    this.ariaLabel,
    this.children = const [],
  });

  /// Whether rows in the structured list can be selected.
  final bool selection;

  /// Whether rows use condensed vertical spacing.
  final bool isCondensed;

  /// Whether outer cell padding aligns flush with the container edge.
  final bool isFlush;

  /// Controlled index of the currently selected row.
  final int? selectedIndex;

  /// Initial selected row index for uncontrolled usage.
  final int? initialSelectedIndex;

  /// Called when the selected row changes.
  final ValueChanged<int>? onSelectionChange;

  /// Whether the structured list is interactive.
  final bool enable;

  /// Accessible label for screen readers.
  final String? ariaLabel;

  /// Child structured list elements ([CStructuredListHead], [CStructuredListBody], or [CStructuredListRow]).
  final List<Widget> children;
}

/// Properties for an individual row within a structured list.
class CStructuredListRowProps {
  const CStructuredListRowProps({
    this.head = false,
    this.selection = false,
    this.selected = false,
    this.disabled = false,
    this.value,
    this.onTap,
    this.children = const [],
  });

  /// Whether this row is a column header row.
  final bool head;

  /// Whether this row displays a selection indicator column.
  final bool selection;

  /// Whether this row is currently selected.
  final bool selected;

  /// Whether this row is disabled.
  final bool disabled;

  /// Optional value associated with this row for data binding.
  final dynamic value;

  /// Called when this row is tapped.
  final VoidCallback? onTap;

  /// Cells contained within this row.
  final List<Widget> children;
}

/// Properties for an individual cell within a structured list row.
class CStructuredListCellProps {
  const CStructuredListCellProps({
    this.head = false,
    this.noWrap = false,
    this.flex = 1,
    this.width,
    this.alignment = Alignment.centerLeft,
  });

  /// Whether this cell behaves as a column header.
  final bool head;

  /// Whether text within this cell should be restricted to a single line without wrapping.
  final bool noWrap;

  /// Flex weight when cells share available horizontal width.
  final int flex;

  /// Explicit fixed width in logical pixels.
  final double? width;

  /// Alignment of content inside the cell.
  final AlignmentGeometry alignment;
}
