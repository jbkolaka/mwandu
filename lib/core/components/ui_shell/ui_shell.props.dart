import 'package:flutter/widgets.dart';

/// A single navigation entry rendered in the UI shell left panel.
class CUiShellNavItem {
  const CUiShellNavItem({
    required this.label,
    required this.icon,
    this.description,
  });

  /// The text shown for this entry.
  final String label;

  /// The icon shown next to the label.
  final IconData icon;

  /// Optional longer description shown in the content area.
  final String? description;
}

/// Configuration of the [CUiShell] left panel.
class CUiShellProps {
  const CUiShellProps({
    required this.items,
    this.title,
    this.titleIcon,
    this.selectedIndex = 0,
    this.collapsed = false,
    this.onSelect,
    this.onToggleCollapsed,
  });

  /// The navigation entries shown in the left panel.
  final List<CUiShellNavItem> items;

  /// Optional panel header title.
  final String? title;

  /// Optional icon shown before the panel header title.
  final IconData? titleIcon;

  /// Index of the currently selected entry.
  final int selectedIndex;

  /// Whether the panel starts collapsed (icon only rail).
  final bool collapsed;

  /// Called with the index of the tapped entry.
  final ValueChanged<int>? onSelect;

  /// Called when the collapse toggle is pressed.
  final VoidCallback? onToggleCollapsed;
}
