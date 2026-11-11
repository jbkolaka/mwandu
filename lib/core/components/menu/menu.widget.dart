import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'menu.props.dart';
import 'menu.styles.dart';

/// A Carbon Design System Menu widget.
///
/// Can be used as a standalone inline menu panel, or displayed as an anchored
/// floating dropdown or context menu using [CMenu.showAtPosition] or [CMenuAnchor].
class CMenu extends StatelessWidget {
  const CMenu({super.key, required this.props});

  /// The configuration and entries of this menu.
  final CMenuProps props;

  /// Shows the menu as a floating modal popup anchored at [position].
  static Future<T?> showAtPosition<T>({
    required BuildContext context,
    required Offset position,
    required CMenuProps props,
  }) {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final screenSize = overlay?.size ?? MediaQuery.of(context).size;

    final rect = RelativeRect.fromRect(
      Rect.fromLTWH(position.dx, position.dy, 0, 0),
      Offset.zero & screenSize,
    );

    return showMenu<T>(
      context: context,
      position: rect,
      elevation: props.elevation,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      items: [_PopupCMenuWrapper<T>(props: props)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      constraints: BoxConstraints(
        minWidth: props.minWidth,
        maxWidth: props.maxWidth,
      ),
      decoration: BoxDecoration(
        color: CMenuStyles.backgroundColor(tokens),
        border: Border.all(
          color: CMenuStyles.borderColor(tokens),
          width: CMenuStyles.borderWidth,
        ),
        boxShadow: props.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < props.items.length; i++)
              _buildEntry(context, props.items[i], tokens),
          ],
        ),
      ),
    );
  }

  Widget _buildEntry(
    BuildContext context,
    CMenuEntry entry,
    AppThemeTokens tokens,
  ) {
    if (entry is CMenuDivider) {
      return Container(
        height: CMenuStyles.dividerThickness,
        margin: const EdgeInsets.symmetric(vertical: CMenuStyles.dividerMargin),
        color: CMenuStyles.borderColor(tokens),
      );
    } else if (entry is CMenuItem) {
      return _CMenuItemWidget(
        item: entry,
        size: props.size,
        tokens: tokens,
        onSelect: (val) {
          props.onSelect?.call(val);
          if (props.closeOnSelect) {
            final nav = Navigator.maybeOf(context);
            if (nav != null && nav.canPop()) {
              nav.pop(val);
            }
          }
        },
      );
    } else if (entry is CMenuSelectableItem) {
      return _CMenuSelectableItemWidget(
        item: entry,
        size: props.size,
        tokens: tokens,
        onSelect: (val) {
          props.onSelect?.call(val);
        },
      );
    } else if (entry is CSubmenu) {
      return _CSubmenuWidget(
        submenu: entry,
        size: props.size,
        tokens: tokens,
        onChildSelect: (val) {
          props.onSelect?.call(val);
          if (props.closeOnSelect) {
            final nav = Navigator.maybeOf(context);
            if (nav != null && nav.canPop()) {
              nav.pop(val);
            }
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _CMenuItemWidget extends StatefulWidget {
  const _CMenuItemWidget({
    required this.item,
    required this.size,
    required this.tokens,
    required this.onSelect,
  });

  final CMenuItem item;
  final CMenuSize size;
  final AppThemeTokens tokens;
  final ValueChanged<dynamic> onSelect;

  @override
  State<_CMenuItemWidget> createState() => _CMenuItemWidgetState();
}

class _CMenuItemWidgetState extends State<_CMenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDanger = widget.item.kind == CMenuItemKind.danger;
    final isDisabled = widget.item.disabled;

    Color textColor;
    if (isDisabled) {
      textColor = CMenuStyles.textDisabledColor(widget.tokens);
    } else if (isDanger) {
      textColor = CMenuStyles.dangerColor(widget.tokens);
    } else {
      textColor = CMenuStyles.textPrimaryColor(widget.tokens);
    }

    Color bgColor = Colors.transparent;
    if (!isDisabled && _isHovered) {
      bgColor = isDanger
          ? widget.tokens.supportError.withValues(alpha: 0.12)
          : CMenuStyles.hoverColor(widget.tokens);
    }

    final height = CMenuStyles.itemHeight(widget.size);
    final fontSize = CMenuStyles.fontSize(widget.size);

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                widget.item.onTap?.call();
                widget.onSelect(widget.item.value);
              },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: height,
          color: bgColor,
          padding: const EdgeInsets.symmetric(
            horizontal: CMenuStyles.horizontalPadding,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: CMenuStyles.iconSize,
                    color: textColor,
                  ),
                  child: widget.item.icon!,
                ),
                const SizedBox(width: CMenuStyles.iconSpacing),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.shortcut != null &&
                  widget.item.shortcut!.isNotEmpty) ...[
                const SizedBox(width: CMenuStyles.trailingSpacing),
                Text(
                  widget.item.shortcut!,
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    color: isDisabled
                        ? CMenuStyles.textDisabledColor(widget.tokens)
                        : CMenuStyles.textShortcutColor(widget.tokens),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CMenuSelectableItemWidget extends StatefulWidget {
  const _CMenuSelectableItemWidget({
    required this.item,
    required this.size,
    required this.tokens,
    required this.onSelect,
  });

  final CMenuSelectableItem item;
  final CMenuSize size;
  final AppThemeTokens tokens;
  final ValueChanged<dynamic> onSelect;

  @override
  State<_CMenuSelectableItemWidget> createState() =>
      _CMenuSelectableItemWidgetState();
}

class _CMenuSelectableItemWidgetState
    extends State<_CMenuSelectableItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.item.disabled;
    final isSelected = widget.item.selected;

    Color textColor;
    if (isDisabled) {
      textColor = CMenuStyles.textDisabledColor(widget.tokens);
    } else {
      textColor = CMenuStyles.textPrimaryColor(widget.tokens);
    }

    Color bgColor = Colors.transparent;
    if (!isDisabled) {
      if (_isHovered) {
        bgColor = CMenuStyles.hoverColor(widget.tokens);
      } else if (isSelected) {
        bgColor = CMenuStyles.selectedColor(widget.tokens)
            .withValues(alpha: 0.4);
      }
    }

    final height = CMenuStyles.itemHeight(widget.size);
    final fontSize = CMenuStyles.fontSize(widget.size);

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                widget.item.onChanged?.call(!isSelected);
                widget.onSelect(widget.item.value);
              },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: height,
          color: bgColor,
          padding: const EdgeInsets.symmetric(
            horizontal: CMenuStyles.horizontalPadding,
          ),
          child: Row(
            children: [
              SizedBox(
                width: CMenuStyles.iconSize,
                height: CMenuStyles.iconSize,
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: CMenuStyles.iconSize,
                        color: textColor,
                      )
                    : null,
              ),
              const SizedBox(width: CMenuStyles.iconSpacing),
              if (widget.item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: CMenuStyles.iconSize,
                    color: textColor,
                  ),
                  child: widget.item.icon!,
                ),
                const SizedBox(width: CMenuStyles.iconSpacing),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.shortcut != null &&
                  widget.item.shortcut!.isNotEmpty) ...[
                const SizedBox(width: CMenuStyles.trailingSpacing),
                Text(
                  widget.item.shortcut!,
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    color: isDisabled
                        ? CMenuStyles.textDisabledColor(widget.tokens)
                        : CMenuStyles.textShortcutColor(widget.tokens),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CSubmenuWidget extends StatefulWidget {
  const _CSubmenuWidget({
    required this.submenu,
    required this.size,
    required this.tokens,
    required this.onChildSelect,
  });

  final CSubmenu submenu;
  final CMenuSize size;
  final AppThemeTokens tokens;
  final ValueChanged<dynamic> onChildSelect;

  @override
  State<_CSubmenuWidget> createState() => _CSubmenuWidgetState();
}

class _CSubmenuWidgetState extends State<_CSubmenuWidget> {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showSubmenu() {
    if (_overlayEntry != null || widget.submenu.disabled) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(196, 0),
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => _hideSubmenu(),
              child: CMenu(
                props: CMenuProps(
                  items: widget.submenu.items,
                  size: widget.size,
                  onSelect: (val) {
                    _hideSubmenu();
                    widget.onChildSelect(val);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSubmenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isHovered = false);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.submenu.disabled;

    final textColor = isDisabled
        ? CMenuStyles.textDisabledColor(widget.tokens)
        : CMenuStyles.textPrimaryColor(widget.tokens);

    final bgColor = (!isDisabled && _isHovered)
        ? CMenuStyles.hoverColor(widget.tokens)
        : Colors.transparent;

    final height = CMenuStyles.itemHeight(widget.size);
    final fontSize = CMenuStyles.fontSize(widget.size);

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          if (!isDisabled) {
            setState(() => _isHovered = true);
            _showSubmenu();
          }
        },
        onExit: (_) {
          if (!isDisabled) {
            // Delay slightly to give time to enter overlay
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted && !_isHovered) {
                _hideSubmenu();
              }
            });
          }
        },
        cursor: isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: isDisabled ? null : _showSubmenu,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: height,
            color: bgColor,
            padding: const EdgeInsets.symmetric(
              horizontal: CMenuStyles.horizontalPadding,
            ),
            child: Row(
              children: [
                if (widget.submenu.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: CMenuStyles.iconSize,
                      color: textColor,
                    ),
                    child: widget.submenu.icon!,
                  ),
                  const SizedBox(width: CMenuStyles.iconSpacing),
                ],
                Expanded(
                  child: Text(
                    widget.submenu.label,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: CMenuStyles.caretSize,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An interactive wrapper widget that anchors a [CMenu] to any target trigger.
class CMenuAnchor extends StatelessWidget {
  const CMenuAnchor({super.key, required this.props, required this.builder});

  /// Menu properties.
  final CMenuProps props;

  /// Trigger builder taking context and an `openMenu` callback.
  final Widget Function(BuildContext context, VoidCallback openMenu) builder;

  void _open(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset(0, renderBox.size.height));
    CMenu.showAtPosition(context: context, position: position, props: props);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) => builder(ctx, () => _open(ctx)));
  }
}

class _PopupCMenuWrapper<T> extends PopupMenuEntry<T> {
  const _PopupCMenuWrapper({required this.props});

  final CMenuProps props;

  @override
  double get height => 10.0;

  @override
  bool represents(T? value) => false;

  @override
  State<_PopupCMenuWrapper<T>> createState() => _PopupCMenuWrapperState<T>();
}

class _PopupCMenuWrapperState<T> extends State<_PopupCMenuWrapper<T>> {
  @override
  Widget build(BuildContext context) {
    return CMenu(props: widget.props);
  }
}
