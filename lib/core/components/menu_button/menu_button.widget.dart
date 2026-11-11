import 'package:flutter/material.dart';
import 'package:mwandu/core/components/menu/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'menu_button.props.dart';
import 'menu_button.styles.dart';

/// A Carbon Design System Menu Button widget.
///
/// Supports both [CMenuButtonVariant.standard] (unified menu trigger button)
/// and [CMenuButtonVariant.combo] (split button with primary action and dropdown trigger),
/// across all standard Carbon button kinds and sizes.
class CMenuButton extends StatefulWidget {
  const CMenuButton({super.key, required this.props});

  /// Configuration and menu items of this button.
  final CMenuButtonProps props;

  @override
  State<CMenuButton> createState() => _CMenuButtonState();
}

class _CMenuButtonState extends State<CMenuButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isHovered = false;
  bool _isPrimaryHovered = false;

  void _toggleMenu() {
    if (widget.props.disabled) {
      return;
    }
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (_overlayEntry != null || widget.props.disabled) {
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    final buttonWidth = renderBox?.size.width ?? 160.0;
    final buttonHeight = renderBox?.size.height ?? 40.0;
    final menuWidth = widget.props.menuWidth ?? buttonWidth;

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            // Fullscreen transparent barrier to dismiss on tap outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeMenu,
                behavior: HitTestBehavior.opaque,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            // Positioned floating CMenu anchored beneath the button
            Positioned(
              width: menuWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, buttonHeight),
                child: CMenu(
                  props: CMenuProps(
                    items: widget.props.items,
                    size: widget.props.size,
                    elevation: 6.0,
                    minWidth: menuWidth,
                    onSelect: (val) {
                      _closeMenu();
                      widget.props.onSelect?.call(val);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    widget.props.onMenuOpen?.call();
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isOpen = false);
      widget.props.onMenuClose?.call();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final height = CMenuButtonStyles.height(widget.props.size);
    final border = CMenuButtonStyles.border(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.props.variant == CMenuButtonVariant.combo
          ? _buildComboButton(tokens, height, border)
          : _buildStandardButton(tokens, height, border),
    );
  }

  Widget _buildStandardButton(
    AppThemeTokens tokens,
    double height,
    Border? border,
  ) {
    final bgColor = CMenuButtonStyles.backgroundColor(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
      isHovered: _isHovered,
      isOpen: _isOpen,
    );
    final contentColor = CMenuButtonStyles.contentColor(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
      isHovered: _isHovered,
      isOpen: _isOpen,
    );
    final fontSize = CMenuButtonStyles.fontSize(widget.props.size);
    final padding = CMenuButtonStyles.horizontalPadding(widget.props.size);

    return MouseRegion(
      onEnter: (_) {
        if (!widget.props.disabled) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (!widget.props.disabled) {
          setState(() => _isHovered = false);
        }
      },
      cursor: widget.props.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _toggleMenu,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: padding),
          decoration: BoxDecoration(color: bgColor, border: border),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.props.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: CMenuButtonStyles.iconSize,
                    color: contentColor,
                  ),
                  child: widget.props.icon!,
                ),
                const SizedBox(width: CMenuButtonStyles.iconSpacing),
              ],
              Text(
                widget.props.label,
                style: TextStyle(
                  fontSize: fontSize,
                  color: contentColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: CMenuButtonStyles.trailingCaretSpacing),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: CMenuButtonStyles.caretSize,
                color: contentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComboButton(
    AppThemeTokens tokens,
    double height,
    Border? border,
  ) {
    final triggerWidth = CMenuButtonStyles.triggerWidth(widget.props.size);
    final fontSize = CMenuButtonStyles.fontSize(widget.props.size);
    final padding = CMenuButtonStyles.horizontalPadding(widget.props.size);

    final primaryBgColor = CMenuButtonStyles.backgroundColor(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
      isHovered: _isPrimaryHovered,
      isOpen: false,
    );
    final primaryContentColor = CMenuButtonStyles.contentColor(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
      isHovered: _isPrimaryHovered,
      isOpen: false,
    );

    final triggerBgColor = CMenuButtonStyles.backgroundColor(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
      isHovered: _isHovered,
      isOpen: _isOpen,
    );
    final triggerContentColor = CMenuButtonStyles.contentColor(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
      isHovered: _isHovered,
      isOpen: _isOpen,
    );

    final separatorColor = CMenuButtonStyles.separatorColor(
      kind: widget.props.kind,
      tokens: tokens,
      disabled: widget.props.disabled,
    );

    return Container(
      height: height,
      decoration: BoxDecoration(border: border),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Primary action button
          MouseRegion(
            onEnter: (_) {
              if (!widget.props.disabled) {
                setState(() => _isPrimaryHovered = true);
              }
            },
            onExit: (_) {
              if (!widget.props.disabled) {
                setState(() => _isPrimaryHovered = false);
              }
            },
            cursor: widget.props.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.props.disabled ? null : widget.props.onPrimaryTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: primaryBgColor,
                padding: EdgeInsets.symmetric(horizontal: padding),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.props.icon != null) ...[
                      IconTheme(
                        data: IconThemeData(
                          size: CMenuButtonStyles.iconSize,
                          color: primaryContentColor,
                        ),
                        child: widget.props.icon!,
                      ),
                      const SizedBox(width: CMenuButtonStyles.iconSpacing),
                    ],
                    Text(
                      widget.props.label,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: primaryContentColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Vertical 1px separator
          Container(
            width: CMenuButtonStyles.separatorWidth,
            color: separatorColor,
          ),
          // Dropdown trigger chevron button
          MouseRegion(
            onEnter: (_) {
              if (!widget.props.disabled) {
                setState(() => _isHovered = true);
              }
            },
            onExit: (_) {
              if (!widget.props.disabled) {
                setState(() => _isHovered = false);
              }
            },
            cursor: widget.props.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _toggleMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: triggerWidth,
                color: triggerBgColor,
                alignment: Alignment.center,
                child: Icon(
                  _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: CMenuButtonStyles.caretSize,
                  color: triggerContentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
