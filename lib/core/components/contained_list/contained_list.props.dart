import 'package:flutter/widgets.dart';

/// Presentation kind of the Contained List.
enum CContainedListKind {
  /// Standard list inset on the page with subtle border definition.
  onPage,

  /// Inset within cards, drawers, modals, or secondary surfaces.
  disclosed,
}

/// Size variant controlling item heights and typography.
enum CContainedListSize {
  /// Small compact list (32px single-line height).
  sm,

  /// Medium default list (48px single-line height).
  md,

  /// Large list (64px single-line height).
  lg,
}

/// A single item entry in a [CContainedList].
class CContainedListItem {
  const CContainedListItem({
    required this.label,
    this.description,
    this.icon,
    this.action,
    this.disabled = false,
    this.clickable = true,
    this.onTap,
    this.value,
  });

  /// Primary headline text of the item.
  final String label;

  /// Optional secondary supporting text beneath the label.
  final String? description;

  /// Optional leading visual (icon, avatar, status indicator).
  final Widget? icon;

  /// Optional trailing widget (action button, badge, tag, chevron).
  final Widget? action;

  /// Whether the item is in a disabled non-interactive state.
  final bool disabled;

  /// Whether the item responds to tap gestures when [onTap] is provided.
  final bool clickable;

  /// Callback executed when the item is tapped.
  final VoidCallback? onTap;

  /// Optional arbitrary payload value.
  final dynamic value;
}

/// Configuration properties for [CContainedList].
class CContainedListProps {
  const CContainedListProps({
    required this.items,
    this.label,
    this.action,
    this.kind = CContainedListKind.onPage,
    this.size = CContainedListSize.md,
    this.isSearchable = false,
    this.searchPlaceholder = 'Search list',
    this.emptyText = 'No items found',
    this.maxHeight,
    this.onItemTap,
  });

  /// List of items to display.
  final List<CContainedListItem> items;

  /// Optional header title for the contained list.
  final String? label;

  /// Optional action widget displayed on the right side of the header.
  final Widget? action;

  /// Inset kind (on-page or disclosed).
  final CContainedListKind kind;

  /// Size variant controlling row heights.
  final CContainedListSize size;

  /// Whether to render a live search filter input in the header.
  final bool isSearchable;

  /// Placeholder text for the search input.
  final String searchPlaceholder;

  /// Text displayed when the list or search results are empty.
  final String emptyText;

  /// Optional maximum height for scrollable contained lists.
  final double? maxHeight;

  /// Callback invoked when any item is clicked.
  final ValueChanged<CContainedListItem>? onItemTap;
}
