import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'tabs.props.dart';
import 'tabs.styles.dart';

/// Accessible, theme-aware tabs with horizontal and vertical orientations.
class CTabs extends StatefulWidget {
  const CTabs({super.key, required this.props});

  final CTabsProps props;

  @override
  State<CTabs> createState() => _CTabsState();
}

class _CTabsState extends State<CTabs> {
  late final FocusNode _focusNode;
  late int _selectedIndex;
  late int _focusedIndex;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: widget.props.label);
    _selectedIndex = _validIndex(widget.props.initialIndex);
    _focusedIndex = _selectedIndex;
  }

  @override
  void didUpdateWidget(covariant CTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.initialIndex != oldWidget.props.initialIndex) {
      _selectedIndex = _validIndex(widget.props.initialIndex);
      _focusedIndex = _selectedIndex;
    } else {
      _selectedIndex = _validIndex(_selectedIndex);
      _focusedIndex = _validIndex(_focusedIndex);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (widget.props.tabs.isEmpty) return const SizedBox.shrink();

    final tabList = _buildTabList(context, tokens);
    final panel = Semantics(
      container: true,
      explicitChildNodes: true,
      label: '${widget.props.tabs[_selectedIndex].label} panel',
      child: Padding(
        padding: widget.props.contentPadding,
        child: IndexedStack(
          index: _selectedIndex,
          children: [for (final tab in widget.props.tabs) tab.content],
        ),
      ),
    );

    if (widget.props.orientation == CTabsOrientation.vertical) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 200, child: tabList),
          Expanded(child: panel),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [tabList, panel],
    );
  }

  Widget _buildTabList(BuildContext context, AppThemeTokens tokens) {
    final horizontal =
        widget.props.orientation == CTabsOrientation.horizontal;
    final tabs = [
      for (var index = 0; index < widget.props.tabs.length; index++)
        _buildTab(context, tokens, index),
    ];
    final tabRow = widget.props.fullWidth && horizontal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (final tab in tabs) Expanded(child: tab)],
          )
        : horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: tabs)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: tabs,
          );
    final listContent = horizontal && !widget.props.fullWidth
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: tabRow,
          )
        : tabRow;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.props.label,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: (focused) {
          if (focused && _focusedIndex != _selectedIndex) {
            setState(() => _focusedIndex = _selectedIndex);
          }
        },
        onKeyEvent: _handleKeyEvent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CTabsStyles.background(tokens),
            border: horizontal
                ? Border(
                    bottom: BorderSide(color: CTabsStyles.separator(tokens)),
                  )
                : Border(
                    right: BorderSide(color: CTabsStyles.separator(tokens)),
                  ),
          ),
          child: listContent,
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, AppThemeTokens tokens, int index) {
    final tab = widget.props.tabs[index];
    final horizontal =
        widget.props.orientation == CTabsOrientation.horizontal;
    final selected = index == _selectedIndex;
    final focused = _focusNode.hasFocus && index == _focusedIndex;
    final height = CTabsStyles.tabHeight(widget.props.size);

    return Semantics(
      container: true,
      button: true,
      enabled: !tab.disabled,
      selected: selected,
      focused: focused,
      inMutuallyExclusiveGroup: true,
      label: tab.label,
      child: MouseRegion(
        cursor: tab.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            canRequestFocus: false,
            onTap: tab.disabled
                ? null
                : () {
                    _focusNode.requestFocus();
                    _select(index);
                  },
            focusColor: CTabsStyles.focus(tokens),
            hoverColor: CTabsStyles.hover(tokens),
            child: Container(
              constraints: BoxConstraints(minHeight: height),
              padding: EdgeInsets.symmetric(
                horizontal: CTabsStyles.tabHorizontalPadding,
                vertical: CTabsStyles.tabVerticalPadding,
              ),
              decoration: BoxDecoration(
                border: horizontal
                    ? Border(
                        bottom: BorderSide(
                          color: focused
                              ? CTabsStyles.focus(tokens)
                              : selected
                              ? CTabsStyles.indicator(tokens)
                              : Colors.transparent,
                          width: selected || focused
                              ? CTabsStyles.indicatorWidth
                              : 0,
                        ),
                      )
                    : Border(
                        right: BorderSide(
                          color: focused
                              ? CTabsStyles.focus(tokens)
                              : selected
                              ? CTabsStyles.indicator(tokens)
                              : Colors.transparent,
                          width: selected || focused
                              ? CTabsStyles.indicatorWidth
                              : 0,
                        ),
                      ),
              ),
              child: Row(
                mainAxisSize: horizontal ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: horizontal
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (tab.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        size: CTabsStyles.iconSize,
                        color: tab.disabled
                            ? CTabsStyles.disabledText(tokens)
                            : selected
                            ? CTabsStyles.text(tokens)
                            : CTabsStyles.inactiveText(tokens),
                      ),
                      child: tab.icon!,
                    ),
                    const SizedBox(width: CTabsStyles.iconGap),
                  ],
                  Flexible(
                    child: Text(
                      tab.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: tab.disabled
                            ? CTabsStyles.disabledText(tokens)
                            : selected
                            ? CTabsStyles.text(tokens)
                            : CTabsStyles.inactiveText(tokens),
                        fontSize: CTabsStyles.labelFontSize,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _validIndex(int index) {
    final tabs = widget.props.tabs;
    if (tabs.isEmpty) return 0;
    if (index >= 0 && index < tabs.length && !tabs[index].disabled) {
      return index;
    }
    final firstEnabled = tabs.indexWhere((tab) => !tab.disabled);
    return firstEnabled < 0 ? 0 : firstEnabled;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final horizontal =
        widget.props.orientation == CTabsOrientation.horizontal;
    final key = event.logicalKey;
    final forwardKey = horizontal
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowDown;
    final backwardKey = horizontal
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowUp;

    if (key == forwardKey || key == backwardKey) {
      _moveFocus(key == forwardKey ? 1 : -1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.home) {
      _focusEnabledIndex(0, 1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      _focusEnabledIndex(widget.props.tabs.length - 1, -1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _select(_focusedIndex);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _moveFocus(int direction) {
    final tabs = widget.props.tabs;
    if (tabs.isEmpty) return;
    for (var step = 1; step <= tabs.length; step++) {
      final index = (_focusedIndex + direction * step) % tabs.length;
      final wrappedIndex = (index + tabs.length) % tabs.length;
      if (!tabs[wrappedIndex].disabled) {
        setState(() => _focusedIndex = wrappedIndex);
        if (widget.props.activationMode == CTabsActivationMode.automatic) {
          _select(wrappedIndex);
        }
        break;
      }
    }
  }

  void _focusEnabledIndex(int start, int direction) {
    final tabs = widget.props.tabs;
    for (var index = start;
        index >= 0 && index < tabs.length;
        index += direction) {
      if (!tabs[index].disabled) {
        setState(() => _focusedIndex = index);
        if (widget.props.activationMode == CTabsActivationMode.automatic) {
          _select(index);
        }
        break;
      }
    }
  }

  void _select(int index) {
    if (index < 0 ||
        index >= widget.props.tabs.length ||
        widget.props.tabs[index].disabled) {
      return;
    }
    final selectionChanged = _selectedIndex != index;
    if (_focusedIndex == index && !selectionChanged) return;
    setState(() {
      _focusedIndex = index;
      _selectedIndex = index;
    });
    if (selectionChanged) widget.props.onChanged?.call(index);
  }
}
