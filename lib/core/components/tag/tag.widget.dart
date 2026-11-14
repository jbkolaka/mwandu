import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/icon/index.dart';

import 'tag.props.dart';
import 'tag.styles.dart';

typedef _Styles = CTagStyles;

/// Carbon Tag component.
///
/// Used for labeling, categorizing, or organizing items using keywords.
/// Supports read-only, selectable, dismissible (filter), and operational modes.
class CTag extends StatefulWidget {
  CTag({
    super.key,
    required String text,
    CTagType type = CTagType.gray,
    CTagSize size = CTagSize.md,
    bool disabled = false,
    bool filter = false,
    bool selectable = false,
    bool selected = false,
    Widget? renderIcon,
    VoidCallback? onTap,
    VoidCallback? onClose,
    ValueChanged<bool>? onSelectionChange,
    String dismissTooltip = 'Dismiss tag',
  }) : props = CTagProps(
         text: text,
         type: type,
         size: size,
         disabled: disabled,
         filter: filter,
         selectable: selectable,
         selected: selected,
         renderIcon: renderIcon,
         onTap: onTap,
         onClose: onClose,
         onSelectionChange: onSelectionChange,
         dismissTooltip: dismissTooltip,
       );

  final CTagProps props;

  @override
  State<CTag> createState() => _CTagState();
}

class _CTagState extends State<CTag> {
  bool _isHovered = false;
  bool _isCloseHovered = false;
  bool _isFocused = false;
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.props.selected;
  }

  @override
  void didUpdateWidget(CTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.selected != oldWidget.props.selected) {
      _selected = widget.props.selected;
    }
  }

  void _handleTap() {
    if (widget.props.selectable) {
      final next = !_selected;
      setState(() {
        _selected = next;
      });
      widget.props.onSelectionChange?.call(next);
    }
    widget.props.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bool isEnabled = context.inheritedEnable && !widget.props.disabled;
    final double height = _Styles.height(widget.props.size);
    final double fontSize = _Styles.fontSize(widget.props.size);
    final double iconSize = _Styles.iconSize(widget.props.size);

    final bool isInteractive =
        isEnabled && (widget.props.selectable || widget.props.onTap != null);

    final Color bgColor = _Styles.backgroundColor(
      tokens: tokens,
      type: widget.props.type,
      disabled: !isEnabled,
      isHovered: _isHovered && isInteractive,
      isSelected: _selected,
    );

    final Color fgColor = _Styles.textColor(
      tokens: tokens,
      type: widget.props.type,
      disabled: !isEnabled,
    );

    final Border? border = _Styles.border(
      tokens: tokens,
      type: widget.props.type,
      disabled: !isEnabled,
      isSelected: _selected,
    );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.props.renderIcon != null) ...[
          IconTheme(
            data: IconThemeData(size: iconSize, color: fgColor),
            child: widget.props.renderIcon!,
          ),
          const SizedBox(width: _Styles.iconGap),
        ],
        Text(
          widget.props.text,
          style: TextStyle(
            fontSize: fontSize,
            color: fgColor,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.props.filter) ...[
          const SizedBox(width: _Styles.iconGap),
          MouseRegion(
            onEnter: isEnabled
                ? (_) => setState(() => _isCloseHovered = true)
                : null,
            onExit: isEnabled
                ? (_) => setState(() => _isCloseHovered = false)
                : null,
            child: GestureDetector(
              onTap: isEnabled ? widget.props.onClose : null,
              behavior: HitTestBehavior.opaque,
              child: Tooltip(
                message: widget.props.dismissTooltip,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    CIcons.close,
                    size: iconSize,
                    color: _isCloseHovered ? tokens.textPrimary : fgColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );

    Widget tagSurface = AnimatedContainer(
      duration: const Duration(milliseconds: 70),
      height: height,
      padding: _Styles.padding(
        widget.props.size,
        hasLeadingIcon: widget.props.renderIcon != null,
        hasCloseIcon: widget.props.filter,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: _Styles.borderRadius,
        border:
            border ??
            (_isFocused ? Border.all(color: tokens.focus, width: 2.0) : null),
      ),
      child: content,
    );

    if (isInteractive) {
      tagSurface = FocusableActionDetector(
        enabled: isEnabled,
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        mouseCursor: isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: tagSurface,
        ),
      );
    }

    return Semantics(
      label: widget.props.text,
      button: isInteractive || widget.props.filter,
      selected: widget.props.selectable ? _selected : null,
      enabled: isEnabled,
      child: tagSurface,
    );
  }
}

/// Convenience class for a selectable Carbon Tag.
class CSelectableTag extends CTag {
  CSelectableTag({
    super.key,
    required super.text,
    super.type,
    super.size,
    super.disabled,
    super.selected,
    super.renderIcon,
    super.onSelectionChange,
    super.onTap,
  }) : super(selectable: true);
}

/// Convenience class for a dismissible filter Carbon Tag.
class CDismissibleTag extends CTag {
  CDismissibleTag({
    super.key,
    required super.text,
    super.type,
    super.size,
    super.disabled,
    super.renderIcon,
    super.onClose,
    super.dismissTooltip,
  }) : super(filter: true);
}

/// Convenience class for an operational clickable Carbon Tag.
class COperationalTag extends CTag {
  COperationalTag({
    super.key,
    required super.text,
    super.type,
    super.size,
    super.disabled,
    super.renderIcon,
    required super.onTap,
  });
}
