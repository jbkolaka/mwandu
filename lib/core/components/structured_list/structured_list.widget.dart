import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/components/text/index.dart';

import 'structured_list.props.dart';
import 'structured_list.styles.dart';

typedef _Styles = CStructuredListStyles;

/// Internal scope passing configuration down to structured list subcomponents.
class _CStructuredListScope extends InheritedWidget {
  const _CStructuredListScope({
    required this.selection,
    required this.isCondensed,
    required this.isFlush,
    required this.selectedIndex,
    required this.onSelect,
    required this.enable,
    required super.child,
  });

  final bool selection;
  final bool isCondensed;
  final bool isFlush;
  final int? selectedIndex;
  final ValueChanged<int>? onSelect;
  final bool enable;

  static _CStructuredListScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CStructuredListScope>();
  }

  @override
  bool updateShouldNotify(_CStructuredListScope oldWidget) {
    return selection != oldWidget.selection ||
        isCondensed != oldWidget.isCondensed ||
        isFlush != oldWidget.isFlush ||
        selectedIndex != oldWidget.selectedIndex ||
        enable != oldWidget.enable;
  }
}

/// Scope to identify a row's index and header status.
class _CRowScope extends InheritedWidget {
  const _CRowScope({
    required this.head,
    required this.index,
    required super.child,
  });

  final bool head;
  final int index;

  static _CRowScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CRowScope>();
  }

  @override
  bool updateShouldNotify(_CRowScope oldWidget) {
    return head != oldWidget.head || index != oldWidget.index;
  }
}

/// Carbon Structured List component.
///
/// Organizes tabular information into a clean scanning layout with optional row selection,
/// condensed density, and flush alignment.
class CStructuredList extends StatefulWidget {
  CStructuredList({
    super.key,
    bool selection = false,
    bool isCondensed = false,
    bool isFlush = false,
    int? selectedIndex,
    int? initialSelectedIndex,
    ValueChanged<int>? onSelectionChange,
    bool enable = true,
    String? ariaLabel,
    List<Widget> children = const [],
  }) : props = CStructuredListProps(
         selection: selection,
         isCondensed: isCondensed,
         isFlush: isFlush,
         selectedIndex: selectedIndex,
         initialSelectedIndex: initialSelectedIndex,
         onSelectionChange: onSelectionChange,
         enable: enable,
         ariaLabel: ariaLabel,
         children: children,
       );

  final CStructuredListProps props;

  @override
  State<CStructuredList> createState() => _CStructuredListState();
}

class _CStructuredListState extends State<CStructuredList> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.props.selectedIndex ?? widget.props.initialSelectedIndex;
  }

  @override
  void didUpdateWidget(CStructuredList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.selectedIndex != null) {
      _selectedIndex = widget.props.selectedIndex;
    }
  }

  void _handleSelect(int index) {
    if (widget.props.selectedIndex == null) {
      setState(() {
        _selectedIndex = index;
      });
    }
    widget.props.onSelectionChange?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = context.inheritedEnable && widget.props.enable;

    return Semantics(
      label: widget.props.ariaLabel,
      child: _CStructuredListScope(
        selection: widget.props.selection,
        isCondensed: widget.props.isCondensed,
        isFlush: widget.props.isFlush,
        selectedIndex: widget.props.selectedIndex ?? _selectedIndex,
        onSelect: _handleSelect,
        enable: isEnabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: widget.props.children,
        ),
      ),
    );
  }
}

/// Alias for [CStructuredList] matching Carbon React naming.
typedef CStructuredListWrapper = CStructuredList;

/// Header section of a [CStructuredList].
class CStructuredListHead extends StatelessWidget {
  const CStructuredListHead({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _CRowScope(
      head: true,
      index: -1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// Body section of a [CStructuredList].
class CStructuredListBody extends StatelessWidget {
  const CStructuredListBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < children.length; i++)
          _CRowScope(head: false, index: i, child: children[i]),
      ],
    );
  }
}

/// A row within a structured list.
class CStructuredListRow extends StatefulWidget {
  CStructuredListRow({
    super.key,
    bool head = false,
    bool selection = false,
    bool selected = false,
    bool disabled = false,
    dynamic value,
    VoidCallback? onTap,
    List<Widget> children = const [],
  }) : props = CStructuredListRowProps(
         head: head,
         selection: selection,
         selected: selected,
         disabled: disabled,
         value: value,
         onTap: onTap,
         children: children,
       );

  final CStructuredListRowProps props;

  @override
  State<CStructuredListRow> createState() => _CStructuredListRowState();
}

class _CStructuredListRowState extends State<CStructuredListRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final listScope = _CStructuredListScope.of(context);
    final rowScope = _CRowScope.of(context);

    final bool isHead = widget.props.head || (rowScope?.head ?? false);
    final int rowIndex = rowScope?.index ?? 0;
    final bool hasSelection =
        widget.props.selection || (listScope?.selection ?? false);
    final bool isEnabled =
        (listScope?.enable ?? true) && !widget.props.disabled;

    final bool isSelected =
        widget.props.selected ||
        (hasSelection && !isHead && listScope?.selectedIndex == rowIndex);

    final Color bgColor = isHead
        ? tokens.background
        : _Styles.rowBackgroundColor(
            tokens: tokens,
            selected: isSelected,
            hovered: _isHovered,
            disabled: !isEnabled,
          );

    final Color borderColor = isSelected
        ? tokens.borderInteractive
        : _Styles.borderColor(tokens);

    Widget rowContent = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < widget.props.children.length; i++)
          _CCellPositionScope(
            isFirst: i == 0,
            isLast: i == widget.props.children.length - 1 && !hasSelection,
            child: widget.props.children[i],
          ),
        if (hasSelection)
          Container(
            width: _Styles.selectionColumnWidth,
            alignment: Alignment.center,
            child: isHead
                ? const SizedBox.shrink()
                : (isSelected
                      ? Icon(
                          CIcons.checkmarkFilled,
                          size: _Styles.selectionIconSize,
                          color: _Styles.checkmarkColor(
                            tokens: tokens,
                            disabled: !isEnabled,
                          ),
                        )
                      : const SizedBox.shrink()),
          ),
      ],
    );

    final Widget container = Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: isHead ? 2.0 : (isSelected ? 2.0 : _Styles.borderWidth),
          ),
        ),
      ),
      child: rowContent,
    );

    if (isHead || !hasSelection) {
      return container;
    }

    return MouseRegion(
      onEnter: isEnabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: isEnabled ? (_) => setState(() => _isHovered = false) : null,
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isEnabled
            ? () {
                widget.props.onTap?.call();
                listScope?.onSelect?.call(rowIndex);
              }
            : null,
        behavior: HitTestBehavior.opaque,
        child: container,
      ),
    );
  }
}

class _CCellPositionScope extends InheritedWidget {
  const _CCellPositionScope({
    required this.isFirst,
    required this.isLast,
    required super.child,
  });

  final bool isFirst;
  final bool isLast;

  static _CCellPositionScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CCellPositionScope>();
  }

  @override
  bool updateShouldNotify(_CCellPositionScope oldWidget) {
    return isFirst != oldWidget.isFirst || isLast != oldWidget.isLast;
  }
}

/// An individual cell within a [CStructuredListRow].
class CStructuredListCell extends StatelessWidget {
  CStructuredListCell({
    super.key,
    bool head = false,
    bool noWrap = false,
    int flex = 1,
    double? width,
    AlignmentGeometry alignment = Alignment.centerLeft,
    required this.child,
  }) : props = CStructuredListCellProps(
         head: head,
         noWrap: noWrap,
         flex: flex,
         width: width,
         alignment: alignment,
       );

  /// Convenience constructor for text-based cells.
  factory CStructuredListCell.text(
    String text, {
    Key? key,
    bool head = false,
    bool noWrap = false,
    int flex = 1,
    double? width,
    AlignmentGeometry alignment = Alignment.centerLeft,
  }) {
    return CStructuredListCell(
      key: key,
      head: head,
      noWrap: noWrap,
      flex: flex,
      width: width,
      alignment: alignment,
      child: CText(data: text),
    );
  }

  final CStructuredListCellProps props;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final listScope = _CStructuredListScope.of(context);
    final rowScope = _CRowScope.of(context);
    final posScope = _CCellPositionScope.of(context);

    final bool isHead = props.head || (rowScope?.head ?? false);
    final bool isCondensed = listScope?.isCondensed ?? false;
    final bool isFlush = listScope?.isFlush ?? false;

    final EdgeInsets padding = _Styles.cellPadding(
      isCondensed: isCondensed,
      isFlush: isFlush,
      isFirst: posScope?.isFirst ?? false,
      isLast: posScope?.isLast ?? false,
    );

    final TextStyle textStyle = TextStyle(
      fontSize: isHead ? _Styles.headFontSize : _Styles.bodyFontSize,
      fontWeight: isHead ? _Styles.headFontWeight : _Styles.bodyFontWeight,
      color: isHead
          ? _Styles.headTextColor(tokens)
          : _Styles.bodyTextColor(tokens: tokens, disabled: false),
    );

    final Widget cellContent = Container(
      padding: padding,
      alignment: props.alignment,
      child: DefaultTextStyle(
        style: textStyle,
        maxLines: props.noWrap ? 1 : null,
        overflow: props.noWrap ? TextOverflow.ellipsis : TextOverflow.clip,
        child: child,
      ),
    );

    if (props.width != null) {
      return SizedBox(width: props.width, child: cellContent);
    }

    return Expanded(flex: props.flex, child: cellContent);
  }
}
