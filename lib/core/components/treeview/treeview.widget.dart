import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'treeview.props.dart';
import 'treeview.styles.dart';

/// Theme-aware, keyboard-navigable tree view.
class CTreeView extends StatefulWidget {
  const CTreeView({super.key, required this.props});

  final CTreeViewProps props;

  @override
  State<CTreeView> createState() => _CTreeViewState();
}

class _CTreeViewState extends State<CTreeView> {
  late final FocusNode _focusNode;
  late Set<String> _expandedIds;
  late Set<String> _selectedIds;
  String? _activeId;
  String? _hoveredId;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: widget.props.label);
    _expandedIds = _defaultExpandedIds(widget.props);
    _selectedIds = _normalizeSelectedIds(widget.props.initialSelectedIds);
    _activeId = _validActiveId(widget.props.initialActiveId) ??
        (_selectedIds.isNotEmpty ? _selectedIds.first : _firstEnabledId);
  }

  @override
  void didUpdateWidget(covariant CTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _expandedIds = _expandedIds
      ..removeWhere((id) => !_isExpandable(id))
      ..addAll(_defaultExpandedIds(widget.props));
    _selectedIds = _normalizeSelectedIds(_selectedIds);
    if (_activeId != null && !_isEnabled(_activeId!)) {
      _activeId = _firstEnabledId;
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
    final children = widget.props.nodes.isEmpty
        ? [
            Padding(
              padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
              child: Text(
                widget.props.emptyText,
                style: TextStyle(
                  color: tokens.textSecondary,
                  fontSize: CTreeViewStyles.labelFontSize,
                ),
              ),
            ),
          ]
        : [for (final node in widget.props.nodes) _buildNode(node, 0, tokens)];

    Widget tree = Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.props.label,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: (_) => setState(() {}),
        onKeyEvent: _handleKeyEvent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CTreeViewStyles.background(tokens),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? CTreeViewStyles.focus(tokens)
                  : Colors.transparent,
              width: CTreeViewStyles.focusWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );

    if (widget.props.maxHeight != null) {
      tree = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.props.maxHeight!),
        child: SingleChildScrollView(child: tree),
      );
    }
    return tree;
  }

  Widget _buildNode(CTreeViewNode node, int depth, AppThemeTokens tokens) {
    final hasChildren = node.children.isNotEmpty;
    final expanded = _expandedIds.contains(node.id);
    final active = _activeId == node.id;
    final selected = _selectedIds.contains(node.id);
    final hovered = _hoveredId == node.id;
    final rowHeight = CTreeViewStyles.rowHeight(widget.props.size);

    final rowChildren = <Widget>[
      SizedBox(width: depth * CTreeViewStyles.rowIndent),
      if (hasChildren)
        _buildDisclosure(node, expanded, tokens)
      else
        const SizedBox(width: CTreeViewStyles.disclosureSize),
      if (widget.props.selectionMode == CTreeViewSelectionMode.multiple)
        _buildCheckbox(node, selected, tokens),
      if (node.icon != null) ...[
        IconTheme(
          data: IconThemeData(
            size: CTreeViewStyles.iconSize,
            color: node.disabled
                ? CTreeViewStyles.textDisabled(tokens)
                : CTreeViewStyles.icon(tokens),
          ),
          child: node.icon!,
        ),
        const SizedBox(width: CTreeViewStyles.iconGap),
      ],
      Expanded(
        child: Text(
          node.label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: node.disabled
                ? CTreeViewStyles.textDisabled(tokens)
                : CTreeViewStyles.text(tokens),
            fontSize: CTreeViewStyles.labelFontSize,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    ];

    final row = Semantics(
      container: true,
      button: true,
      enabled: !node.disabled,
      selected: selected,
      focused: active && _focusNode.hasFocus,
      checked: widget.props.selectionMode == CTreeViewSelectionMode.multiple
          ? selected
          : null,
      expanded: hasChildren ? expanded : null,
      label: node.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredId = node.id),
        onExit: (_) => setState(() {
          if (_hoveredId == node.id) _hoveredId = null;
        }),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: node.disabled
              ? null
              : () {
                  _focusNode.requestFocus();
                  _activate(node);
                },
          child: Container(
            height: rowHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: CTreeViewStyles.rowHorizontalPadding,
            ),
            decoration: BoxDecoration(
              color: active || selected
                  ? CTreeViewStyles.selected(tokens)
                  : hovered
                  ? CTreeViewStyles.hover(tokens)
                  : Colors.transparent,
            ),
            child: Row(children: rowChildren),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        row,
        if (hasChildren && expanded)
          for (final child in node.children)
            _buildNode(child, depth + 1, tokens),
      ],
    );
  }

  Widget _buildDisclosure(
    CTreeViewNode node,
    bool expanded,
    AppThemeTokens tokens,
  ) {
    return Semantics(
      button: true,
      label: expanded ? 'Collapse ${node.label}' : 'Expand ${node.label}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: node.disabled ? null : () => _toggleExpanded(node.id),
        child: SizedBox(
          width: CTreeViewStyles.disclosureSize,
          height: CTreeViewStyles.rowHeight(widget.props.size),
          child: Icon(
            expanded ? Icons.expand_more : Icons.chevron_right,
            size: CTreeViewStyles.iconSize,
            color: node.disabled
                ? CTreeViewStyles.textDisabled(tokens)
                : CTreeViewStyles.icon(tokens),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    CTreeViewNode node,
    bool checked,
    AppThemeTokens tokens,
  ) {
    return Semantics(
      button: true,
      checked: checked,
      label: 'Select ${node.label}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: node.disabled ? null : () => _toggleSelected(node),
        child: SizedBox(
          width: CTreeViewStyles.disclosureSize,
          height: CTreeViewStyles.rowHeight(widget.props.size),
          child: Center(
            child: Container(
              width: Spacing.v16px1remSpacing05,
              height: Spacing.v16px1remSpacing05,
              decoration: BoxDecoration(
                color: checked ? tokens.buttonPrimary : Colors.transparent,
                border: Border.all(
                  color: node.disabled
                      ? tokens.borderDisabled
                      : checked
                      ? tokens.buttonPrimary
                      : tokens.borderStrong01,
                ),
              ),
              child: checked
                  ? Icon(Icons.check, size: 12, color: tokens.textOnColor)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final visible = _visibleNodes();
    if (visible.isEmpty) return KeyEventResult.ignored;
    final currentIndex = visible.indexWhere((entry) => entry.node.id == _activeId);
    final index = currentIndex < 0 ? 0 : currentIndex;
    final active = visible[index];

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _moveActive(visible, index + 1, 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _moveActive(visible, index - 1, -1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        if (active.node.children.isNotEmpty) {
          if (_expandedIds.contains(active.node.id)) {
            _setActive(active.node.children.firstWhere(
              (child) => !child.disabled,
              orElse: () => active.node.children.first,
            ).id);
          } else {
            _toggleExpanded(active.node.id);
          }
        }
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        if (_expandedIds.contains(active.node.id)) {
          _toggleExpanded(active.node.id);
        } else if (active.parentId != null) {
          _setActive(active.parentId!);
        }
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        if (!active.node.disabled) _activate(active.node);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  List<_VisibleTreeNode> _visibleNodes() {
    final visible = <_VisibleTreeNode>[];
    void visit(List<CTreeViewNode> nodes, String? parentId) {
      for (final node in nodes) {
        visible.add(_VisibleTreeNode(node: node, parentId: parentId));
        if (_expandedIds.contains(node.id)) visit(node.children, node.id);
      }
    }

    visit(widget.props.nodes, null);
    return visible;
  }

  void _moveActive(List<_VisibleTreeNode> visible, int start, int direction) {
    for (var index = start;
        index >= 0 && index < visible.length;
        index += direction) {
      if (!visible[index].node.disabled) {
        _setActive(visible[index].node.id);
        break;
      }
    }
  }

  void _activate(CTreeViewNode node) {
    _setActive(node.id);
    if (widget.props.selectionMode != CTreeViewSelectionMode.none) {
      _toggleSelected(node);
    }
    widget.props.onNodeActivate?.call(node);
  }

  void _setActive(String id) {
    if (_activeId == id || !_isEnabled(id)) return;
    setState(() => _activeId = id);
    widget.props.onActiveChanged?.call(id);
  }

  void _toggleSelected(CTreeViewNode node) {
    if (node.disabled ||
        widget.props.selectionMode == CTreeViewSelectionMode.none) {
      return;
    }
    final next = Set<String>.of(_selectedIds);
    if (widget.props.selectionMode == CTreeViewSelectionMode.single) {
      next
        ..clear()
        ..add(node.id);
    } else if (next.contains(node.id)) {
      next.remove(node.id);
    } else {
      next.add(node.id);
    }
    if (next.length == _selectedIds.length && next.containsAll(_selectedIds)) {
      return;
    }
    setState(() => _selectedIds = next);
    widget.props.onSelectionChanged?.call(Set<String>.unmodifiable(next));
  }

  void _toggleExpanded(String id) {
    if (!_isExpandable(id)) return;
    final next = Set<String>.of(_expandedIds);
    if (!next.add(id)) next.remove(id);
    setState(() => _expandedIds = next);
    widget.props.onExpandedChanged?.call(Set<String>.unmodifiable(next));
  }

  Set<String> _defaultExpandedIds(CTreeViewProps props) {
    final ids = Set<String>.of(props.initialExpandedIds);
    void visit(List<CTreeViewNode> nodes) {
      for (final node in nodes) {
        if (node.expandedByDefault) ids.add(node.id);
        visit(node.children);
      }
    }

    visit(props.nodes);
    return ids.where(_isExpandable).toSet();
  }

  Set<String> _validIds(Set<String> ids) =>
      ids.where(_isEnabled).toSet();

  Set<String> _normalizeSelectedIds(Set<String> ids) {
    final validIds = _validIds(ids);
    if (widget.props.selectionMode == CTreeViewSelectionMode.single &&
        validIds.length > 1) {
      return <String>{validIds.first};
    }
    if (widget.props.selectionMode == CTreeViewSelectionMode.none) {
      return <String>{};
    }
    return validIds;
  }

  String? _validActiveId(String? id) =>
      id != null && _isEnabled(id) ? id : null;

  String? get _firstEnabledId {
    for (final entry in _allNodes()) {
      if (!entry.disabled) return entry.id;
    }
    return null;
  }

  List<CTreeViewNode> _allNodes() {
    final nodes = <CTreeViewNode>[];
    void visit(List<CTreeViewNode> entries) {
      for (final node in entries) {
        nodes.add(node);
        visit(node.children);
      }
    }

    visit(widget.props.nodes);
    return nodes;
  }

  bool _isEnabled(String id) =>
      _allNodes().any((node) => node.id == id && !node.disabled);

  bool _isExpandable(String id) =>
      _allNodes().any((node) => node.id == id && node.children.isNotEmpty);
}

class _VisibleTreeNode {
  const _VisibleTreeNode({required this.node, required this.parentId});

  final CTreeViewNode node;
  final String? parentId;
}
