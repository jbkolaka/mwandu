import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

import 'ui_shell.props.dart';
import 'ui_shell.styles.dart';

/// A UI shell with a fixed left navigation panel and a content area.
///
/// The left panel can be collapsed down to an icon rail, and collapses
/// automatically on narrow viewports. All colors come from the active
/// theme tokens and all spacing from the design system variables.
class CUiShell extends StatefulWidget {
  const CUiShell({
    super.key,
    required this.props,
    required this.child,
  });

  /// Configuration of the left panel.
  final CUiShellProps props;

  /// The content shown next to the left panel.
  final Widget child;

  @override
  State<CUiShell> createState() => _CUiShellState();
}

class _CUiShellState extends State<CUiShell> {
  late bool _collapsed = widget.props.collapsed;

  @override
  void didUpdateWidget(covariant CUiShell oldWidget) {
    if (oldWidget.props.collapsed != widget.props.collapsed) {
      _collapsed = widget.props.collapsed;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _toggleCollapsed() {
    setState(() => _collapsed = !_collapsed);
    widget.props.onToggleCollapsed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < CUiShellStyles.narrowViewport;
        final collapsed = _collapsed || isNarrow;

        return Scaffold(
          backgroundColor: tokens.background,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CUiShellLeftPanel(
                props: widget.props,
                collapsed: collapsed,
                onToggle: _toggleCollapsed,
              ),
              Expanded(child: widget.child),
            ],
          ),
        );
      },
    );
  }
}

/// The fixed left navigation panel of the [CUiShell].
class CUiShellLeftPanel extends StatelessWidget {
  const CUiShellLeftPanel({
    super.key,
    required this.props,
    required this.collapsed,
    required this.onToggle,
  });

  /// Configuration of the panel.
  final CUiShellProps props;

  /// Whether the panel is shown as an icon only rail.
  final bool collapsed;

  /// Called when the collapse toggle is pressed.
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      width: collapsed ? CUiShellStyles.railWidth : CUiShellStyles.panelWidth,
      color: tokens.layer01,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, tokens),
          _buildNavigation(context, tokens),
          _buildFooter(context, tokens),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppThemeTokens tokens) {
    return Container(
      height: CUiShellStyles.headerHeight,
      padding: EdgeInsets.symmetric(
        horizontal: collapsed
            ? Spacing.v8px05remSpacing03
            : Spacing.v16px1remSpacing05,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.borderSubtle00)),
      ),
      child: Row(
        children: [
          if (props.titleIcon != null) ...[
            Icon(
              props.titleIcon,
              size: CUiShellStyles.iconSize,
              color: tokens.iconPrimary,
            ),
            const SizedBox(width: Spacing.v8px05remSpacing03),
          ],
          if (!collapsed && props.title != null)
            Expanded(
              child: Text(
                props.title!,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigation(BuildContext context, AppThemeTokens tokens) {
    return Expanded(
      child: ListView.builder(
        padding: CUiShellStyles.listPadding,
        itemCount: props.items.length,
        itemBuilder: (context, index) {
          final item = props.items[index];
          final isSelected = index == props.selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(
              bottom: Spacing.v2px0125remSpacing01,
            ),
            child: Material(
              color: isSelected ? tokens.layerSelected01 : Colors.transparent,
              child: InkWell(
                onTap: () => props.onSelect?.call(index),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: collapsed
                        ? Spacing.v8px05remSpacing03
                        : Spacing.v12px075remSpacing04,
                    vertical: Spacing.v8px05remSpacing03,
                  ),
                  child: Row(
                    mainAxisAlignment: collapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(
                        item.icon,
                        size: CUiShellStyles.iconSize,
                        color: isSelected
                            ? tokens.linkPrimary
                            : tokens.iconSecondary,
                      ),
                      if (!collapsed) ...[
                        const SizedBox(width: Spacing.v12px075remSpacing04),
                        Expanded(
                          child: Text(
                            item.label,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? tokens.linkPrimary
                                      : tokens.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AppThemeTokens tokens) {
    return Container(
      padding: EdgeInsets.all(
        collapsed
            ? Spacing.v8px05remSpacing03
            : Spacing.v12px075remSpacing04,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.borderSubtle00)),
      ),
      child: Align(
        alignment: collapsed ? Alignment.center : Alignment.centerLeft,
        child: IconButton(
          onPressed: onToggle,
          tooltip: collapsed ? 'Expand panel' : 'Collapse panel',
          icon: Icon(
            collapsed ? CIcons.chevronRight : CIcons.chevronLeft,
            size: CUiShellStyles.iconSize,
            color: tokens.iconSecondary,
          ),
        ),
      ),
    );
  }
}
