import 'package:flutter/widgets.dart';

/// Available sizes for the Carbon Menu matching Carbon Design System specifications.
enum CMenuSize {
  /// Small compact menu (32px item height).
  sm,

  /// Medium default menu (40px item height).
  md,

  /// Large menu (48px item height).
  lg,
}

/// Visual style / intent of a menu item.
enum CMenuItemKind {
  /// Standard action item.
  primary,

  /// Destructive action with danger coloring.
  danger,
}

/// Abstract base class for any entry rendered in a [CMenu].
abstract class CMenuEntry {
  const CMenuEntry();
}

/// A standard clickable action item in a Carbon Menu.
class CMenuItem extends CMenuEntry {
  const CMenuItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.kind = CMenuItemKind.primary,
    this.disabled = false,
    this.onTap,
    this.value,
  });

  /// The text displayed for this menu item.
  final String label;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional keyboard shortcut label (e.g. '⌘C', 'Ctrl+V').
  final String? shortcut;

  /// Semantic visual style (primary or danger).
  final CMenuItemKind kind;

  /// Whether this item is non-interactive.
  final bool disabled;

  /// Callback executed when the item is tapped.
  final VoidCallback? onTap;

  /// Optional arbitrary value associated with this item.
  final dynamic value;
}

/// A selectable toggle / checkbox item in a Carbon Menu.
class CMenuSelectableItem extends CMenuEntry {
  const CMenuSelectableItem({
    required this.label,
    required this.selected,
    this.icon,
    this.shortcut,
    this.disabled = false,
    this.onChanged,
    this.value,
  });

  /// The text displayed for this item.
  final String label;

  /// Whether this item is currently checked / selected.
  final bool selected;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional keyboard shortcut label.
  final String? shortcut;

  /// Whether this item is disabled.
  final bool disabled;

  /// Callback executed when selection toggles.
  final ValueChanged<bool>? onChanged;

  /// Optional arbitrary value.
  final dynamic value;
}

/// A visual horizontal divider separating groups of items.
class CMenuDivider extends CMenuEntry {
  const CMenuDivider();
}

/// A menu item that cascades into a nested submenu.
class CSubmenu extends CMenuEntry {
  const CSubmenu({
    required this.label,
    required this.items,
    this.icon,
    this.disabled = false,
  });

  /// The text displayed for this submenu trigger.
  final String label;

  /// Child entries displayed in the nested cascading menu.
  final List<CMenuEntry> items;

  /// Optional leading icon.
  final Widget? icon;

  /// Whether this submenu trigger is disabled.
  final bool disabled;
}

/// Configuration properties for a [CMenu].
class CMenuProps {
  const CMenuProps({
    required this.items,
    this.size = CMenuSize.md,
    this.minWidth = 160.0,
    this.maxWidth = 320.0,
    this.elevation = 4.0,
    this.closeOnSelect = true,
    this.onSelect,
  });

  /// The list of items, selectable items, dividers, or submenus.
  final List<CMenuEntry> items;

  /// Size variant controlling height and font sizing.
  final CMenuSize size;

  /// Minimum width of the menu panel in logical pixels.
  final double minWidth;

  /// Maximum width of the menu panel in logical pixels.
  final double maxWidth;

  /// Elevation shadow depth for floating menus.
  final double elevation;

  /// Whether the menu automatically dismisses when an action item is tapped.
  final bool closeOnSelect;

  /// Callback invoked when any value is selected.
  final ValueChanged<dynamic>? onSelect;
}
