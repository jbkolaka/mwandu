import 'package:flutter/widgets.dart';

/// Layout direction of the tab list.
enum CTabsOrientation { horizontal, vertical }

/// Controls whether arrow-key navigation also selects a tab.
enum CTabsActivationMode { automatic, manual }

/// Tab row density.
enum CTabsSize { sm, md, lg }

/// One tab and its associated panel.
class CTabItem {
  const CTabItem({
    required this.id,
    required this.label,
    required this.content,
    this.icon,
    this.disabled = false,
  });

  /// Stable identifier for this tab.
  final String id;

  /// Text shown in the tab list.
  final String label;

  /// Content displayed when this tab is selected.
  final Widget content;

  /// Optional leading icon.
  final Widget? icon;

  /// Whether the tab cannot be focused or selected.
  final bool disabled;
}

/// Configuration for [CTabs].
class CTabsProps {
  const CTabsProps({
    required this.tabs,
    this.label = 'Tabs',
    this.initialIndex = 0,
    this.orientation = CTabsOrientation.horizontal,
    this.activationMode = CTabsActivationMode.automatic,
    this.size = CTabsSize.md,
    this.fullWidth = false,
    this.contentPadding = EdgeInsets.zero,
    this.onChanged,
  });

  /// Tabs to render. Each tab supplies its own panel content.
  final List<CTabItem> tabs;

  /// Accessible label for the tab list.
  final String label;

  /// Initially selected tab index.
  final int initialIndex;

  /// Horizontal or vertical tab list.
  final CTabsOrientation orientation;

  /// Arrow keys select immediately or wait for Enter/Space.
  final CTabsActivationMode activationMode;

  /// Tab row density.
  final CTabsSize size;

  /// Gives horizontal tabs equal width and fills the available row.
  final bool fullWidth;

  /// Padding around the active panel content.
  final EdgeInsetsGeometry contentPadding;

  /// Called when the selected tab changes.
  final ValueChanged<int>? onChanged;
}
