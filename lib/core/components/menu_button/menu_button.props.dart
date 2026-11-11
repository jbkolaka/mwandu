import 'package:flutter/widgets.dart';
import 'package:mwandu/core/components/menu/index.dart';

/// Visual style / intent of a Carbon Menu Button.
enum CMenuButtonKind {
  /// Primary solid accent button.
  primary,

  /// Secondary neutral dark button.
  secondary,

  /// Tertiary outlined button.
  tertiary,

  /// Ghost transparent background button.
  ghost,
}

/// Structural variant of the Menu Button.
enum CMenuButtonVariant {
  /// Standard: Clicking anywhere on the button opens the dropdown menu.
  standard,

  /// Combo (Split): Left portion executes a primary action; right chevron toggles the menu.
  combo,
}

/// Configuration properties for [CMenuButton].
class CMenuButtonProps {
  const CMenuButtonProps({
    required this.label,
    required this.items,
    this.kind = CMenuButtonKind.primary,
    this.variant = CMenuButtonVariant.standard,
    this.size = CMenuSize.md,
    this.disabled = false,
    this.icon,
    this.onPrimaryTap,
    this.onMenuOpen,
    this.onMenuClose,
    this.onSelect,
    this.menuWidth,
  });

  /// Button label text.
  final String label;

  /// Menu entries displayed in the dropdown menu panel.
  final List<CMenuEntry> items;

  /// Visual hierarchy kind (primary, secondary, tertiary, or ghost).
  final CMenuButtonKind kind;

  /// Structural mode (standard unified button or combo split button).
  final CMenuButtonVariant variant;

  /// Size variant controlling height, padding, and font size.
  final CMenuSize size;

  /// Whether the button and menu trigger are disabled.
  final bool disabled;

  /// Optional leading icon displayed before the label.
  final Widget? icon;

  /// Action executed when the primary portion of a combo button is tapped.
  final VoidCallback? onPrimaryTap;

  /// Callback invoked when the menu panel opens.
  final VoidCallback? onMenuOpen;

  /// Callback invoked when the menu panel closes.
  final VoidCallback? onMenuClose;

  /// Callback invoked when an item in the menu is selected.
  final ValueChanged<dynamic>? onSelect;

  /// Optional width override for the opened menu panel.
  final double? menuWidth;
}
