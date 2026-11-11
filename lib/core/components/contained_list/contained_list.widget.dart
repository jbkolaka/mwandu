import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'contained_list.props.dart';
import 'contained_list.styles.dart';

/// A Carbon Design System Contained List widget.
///
/// Presents a header with an optional title, action, and search input,
/// followed by rows of items supporting two-line content, leading icons,
/// trailing actions, hover/tap interactions, and disabled states.
class CContainedList extends StatefulWidget {
  const CContainedList({super.key, required this.props});

  /// Configuration and items of this contained list.
  final CContainedListProps props;

  @override
  State<CContainedList> createState() => _CContainedListState();
}

class _CContainedListState extends State<CContainedList> {
  final TextEditingController _searchController = TextEditingController();
  String _filterText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CContainedListItem> get _filteredItems {
    if (!widget.props.isSearchable || _filterText.isEmpty) {
      return widget.props.items;
    }
    return widget.props.items
        .where(
          (it) =>
              it.label.toLowerCase().contains(_filterText.toLowerCase()) ||
              (it.description?.toLowerCase().contains(
                    _filterText.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bgColor = CContainedListStyles.backgroundColor(
      tokens,
      widget.props.kind,
    );
    final borderColor = CContainedListStyles.borderColor(tokens);
    final filtered = _filteredItems;

    Widget listContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header (always shown if label or action is set, or searchable)
        if (widget.props.label != null ||
            widget.props.action != null ||
            widget.props.isSearchable)
          _buildHeader(tokens, borderColor),

        // Items or empty state
        if (filtered.isEmpty)
          _buildEmptyState(tokens)
        else
          ...List.generate(
            filtered.length,
            (i) => _CContainedListItemWidget(
              item: filtered[i],
              size: widget.props.size,
              bgColor: bgColor,
              tokens: tokens,
              showDivider: i < filtered.length - 1,
              onTap: () {
                filtered[i].onTap?.call();
                widget.props.onItemTap?.call(filtered[i]);
              },
            ),
          ),
      ],
    );

    if (widget.props.maxHeight != null) {
      listContent = SingleChildScrollView(child: listContent);
    }

    return Container(
      constraints: widget.props.maxHeight != null
          ? BoxConstraints(maxHeight: widget.props.maxHeight!)
          : null,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: borderColor,
          width: CContainedListStyles.borderWidth,
        ),
      ),
      child: listContent,
    );
  }

  Widget _buildHeader(AppThemeTokens tokens, Color borderColor) {
    if (widget.props.isSearchable) {
      return Container(
        height: CContainedListStyles.headerHeight,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: CContainedListStyles.dividerThickness,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: CContainedListStyles.horizontalPadding,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: CContainedListStyles.iconSize - 4,
              color: tokens.iconPrimary,
            ),
            const SizedBox(width: CContainedListStyles.iconSpacing),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  fontSize: CContainedListStyles.headerFontSize,
                  color: tokens.textPrimary,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: widget.props.searchPlaceholder,
                  hintStyle: TextStyle(
                    fontSize: CContainedListStyles.headerFontSize,
                    color: tokens.textPlaceholder,
                  ),
                ),
                onChanged: (val) => setState(() => _filterText = val),
              ),
            ),
            if (_filterText.isNotEmpty) ...[
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _filterText = '');
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.close,
                    size: CContainedListStyles.iconSize - 4,
                    color: tokens.iconPrimary,
                  ),
                ),
              ),
            ] else if (widget.props.action != null) ...[
              widget.props.action!,
            ],
          ],
        ),
      );
    }

    // Standard header
    return Container(
      height: CContainedListStyles.headerHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: CContainedListStyles.dividerThickness,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CContainedListStyles.horizontalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.props.label ?? '',
              style: TextStyle(
                fontSize: CContainedListStyles.headerFontSize,
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
                letterSpacing: 0.1,
              ),
            ),
          ),
          if (widget.props.action != null) widget.props.action!,
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppThemeTokens tokens) {
    return Container(
      height: CContainedListStyles.itemHeight(widget.props.size, false),
      padding: const EdgeInsets.symmetric(
        horizontal: CContainedListStyles.horizontalPadding,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.props.emptyText,
        style: TextStyle(
          fontSize: CContainedListStyles.labelFontSize(widget.props.size),
          color: tokens.textPlaceholder,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _CContainedListItemWidget extends StatefulWidget {
  const _CContainedListItemWidget({
    required this.item,
    required this.size,
    required this.bgColor,
    required this.tokens,
    required this.showDivider,
    required this.onTap,
  });

  final CContainedListItem item;
  final CContainedListSize size;
  final Color bgColor;
  final AppThemeTokens tokens;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  State<_CContainedListItemWidget> createState() =>
      _CContainedListItemWidgetState();
}

class _CContainedListItemWidgetState extends State<_CContainedListItemWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final tokens = widget.tokens;
    final isClickable = !item.disabled && item.clickable && item.onTap != null;
    final hasDescription =
        item.description != null && item.description!.isNotEmpty;
    final height = CContainedListStyles.itemHeight(widget.size, hasDescription);
    final fontSize = CContainedListStyles.labelFontSize(widget.size);

    Color rowBg;
    if (item.disabled) {
      rowBg = widget.bgColor;
    } else if (_isPressed) {
      rowBg = CContainedListStyles.activeColor(tokens);
    } else if (_isHovered && isClickable) {
      rowBg = CContainedListStyles.hoverColor(tokens);
    } else {
      rowBg = widget.bgColor;
    }

    final labelColor = item.disabled ? tokens.textDisabled : tokens.textPrimary;
    final descriptionColor = item.disabled
        ? tokens.textDisabled
        : tokens.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) {
            if (isClickable) setState(() => _isHovered = true);
          },
          onExit: (_) {
            if (isClickable) setState(() => _isHovered = false);
          },
          cursor: isClickable
              ? SystemMouseCursors.click
              : item.disabled
              ? SystemMouseCursors.forbidden
              : MouseCursor.defer,
          child: GestureDetector(
            onTapDown: isClickable
                ? (_) => setState(() => _isPressed = true)
                : null,
            onTapUp: isClickable
                ? (_) {
                    setState(() => _isPressed = false);
                    widget.onTap();
                  }
                : null,
            onTapCancel: isClickable
                ? () => setState(() => _isPressed = false)
                : null,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: height,
              color: rowBg,
              padding: const EdgeInsets.symmetric(
                horizontal: CContainedListStyles.horizontalPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading icon / avatar
                  if (item.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        size: CContainedListStyles.iconSize,
                        color: item.disabled
                            ? tokens.textDisabled
                            : tokens.iconPrimary,
                      ),
                      child: item.icon!,
                    ),
                    const SizedBox(width: CContainedListStyles.iconSpacing),
                  ],
                  // Text column
                  Expanded(
                    child: hasDescription
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: labelColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.description!,
                                style: TextStyle(
                                  fontSize:
                                      CContainedListStyles.descriptionFontSize,
                                  color: descriptionColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        : Text(
                            item.label,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: labelColor,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  // Trailing action widget (badge, button, chevron, tag)
                  if (item.action != null) ...[
                    const SizedBox(width: CContainedListStyles.iconSpacing),
                    item.action!,
                  ] else if (isClickable) ...[
                    Icon(
                      Icons.chevron_right,
                      size: CContainedListStyles.iconSize,
                      color: item.disabled
                          ? tokens.textDisabled
                          : tokens.iconPrimary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Row divider
        if (widget.showDivider)
          Divider(
            height: CContainedListStyles.dividerThickness,
            thickness: CContainedListStyles.dividerThickness,
            color: CContainedListStyles.borderColor(tokens),
          ),
      ],
    );
  }
}
