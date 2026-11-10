import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Layout values of the UI shell, derived from the design system variables.
abstract final class CUiShellStyles {
  /// Width of the expanded left panel (Carbon aside, 256).
  static const double panelWidth = Breakpoint.asideLeftMinWidth;

  /// Width of the collapsed left rail (Carbon 2 column grid, 48).
  static const double railWidth = Breakpoint.wideGrid2ColumnWidth;

  /// Viewport below which the panel is collapsed by default.
  static const double narrowViewport = BreakpointMD672px.viewportSize;

  /// Height of the panel header and footer.
  static const double headerHeight = Spacing.v48px3remSpacing09;

  /// Size of the navigation icons.
  static const double iconSize = Spacing.v16px1remSpacing05;

  /// Padding around the navigation list.
  static const EdgeInsets listPadding = EdgeInsets.symmetric(
    vertical: Spacing.v8px05remSpacing03,
    horizontal: Spacing.v8px05remSpacing03,
  );

  /// Padding around a navigation entry.
  static const EdgeInsets itemPadding = EdgeInsets.symmetric(
    horizontal: Spacing.v12px075remSpacing04,
    vertical: Spacing.v8px05remSpacing03,
  );
}
