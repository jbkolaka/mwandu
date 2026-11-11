import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'dropdown.props.dart';
import 'dropdown.styles.dart';

/// A Carbon Design System Dropdown widget.
///
/// Supports Default and Inline presentation layouts, single-select options,
/// clearable selections, search filtering, invalid/warning validation states,
/// and Carbon token styling.
class CDropdown<T> extends StatefulWidget {
  const CDropdown({super.key, required this.props});

  /// The configuration and data of this dropdown.
  final CDropdownProps<T> props;

  @override
  State<CDropdown<T>> createState() => _CDropdownState<T>();
}

class _CDropdownState<T> extends State<CDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isHovered = false;
  bool _isFocused = false;

  CDropdownItem<T>? _selectedItem;
  String _filterText = '';

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.props.selectedItem;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props.selectedItem != widget.props.selectedItem) {
      _selectedItem = widget.props.selectedItem;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _toggleDropdown() {
    if (widget.props.disabled || widget.props.readOnly) return;
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_overlayEntry != null ||
        widget.props.disabled ||
        widget.props.readOnly) {
      return;
    }

    _filterText = '';
    _searchController.clear();

    final renderBox = context.findRenderObject() as RenderBox?;
    final fieldWidth = renderBox?.size.width ?? 240.0;
    final fieldHeight = CDropdownStyles.fieldHeight(widget.props.size);

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            // Barrier to dismiss on tap outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.opaque,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            // Floating options menu anchored beneath the field
            Positioned(
              width: fieldWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, fieldHeight),
                child: _buildMenuOverlay(ctx),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _focusNode.requestFocus();
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  void _selectItem(CDropdownItem<T> item) {
    if (item.disabled) return;
    setState(() => _selectedItem = item);
    widget.props.onChanged?.call(item);
    _closeDropdown();
  }

  void _clearSelection() {
    setState(() => _selectedItem = null);
    widget.props.onChanged?.call(null);
  }

  List<CDropdownItem<T>> get _filteredItems {
    if (!widget.props.filterable || _filterText.isEmpty) {
      return widget.props.items;
    }
    return widget.props.items
        .where(
          (it) => it.label.toLowerCase().contains(_filterText.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    if (widget.props.type == CDropdownType.inline) {
      return _buildInlineLayout(tokens);
    }
    return _buildDefaultLayout(tokens);
  }

  Widget _buildDefaultLayout(AppThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.props.label != null &&
            widget.props.label!.isNotEmpty &&
            !widget.props.hideLabel) ...[
          Text(
            widget.props.label!,
            style: TextStyle(
              fontSize: CDropdownStyles.labelFontSize,
              color: widget.props.disabled
                  ? tokens.textDisabled
                  : tokens.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: Spacing.v4px025remSpacing02),
        ],
        if (widget.props.helperText != null &&
            widget.props.helperText!.isNotEmpty &&
            !widget.props.isInvalid &&
            !widget.props.isWarn) ...[
          Text(
            widget.props.helperText!,
            style: TextStyle(
              fontSize: CDropdownStyles.helperFontSize,
              color: widget.props.disabled
                  ? tokens.textDisabled
                  : tokens.textHelper,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
        ],
        CompositedTransformTarget(link: _layerLink, child: _buildField(tokens)),
        _buildValidationMessage(tokens),
      ],
    );
  }

  Widget _buildInlineLayout(AppThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.props.label != null &&
                widget.props.label!.isNotEmpty &&
                !widget.props.hideLabel) ...[
              Text(
                widget.props.label!,
                style: TextStyle(
                  fontSize: CDropdownStyles.labelFontSize,
                  color: widget.props.disabled
                      ? tokens.textDisabled
                      : tokens.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: CDropdownStyles.inlineSpacing),
            ],
            Expanded(
              child: CompositedTransformTarget(
                link: _layerLink,
                child: _buildField(tokens),
              ),
            ),
          ],
        ),
        _buildValidationMessage(tokens),
      ],
    );
  }

  Widget _buildField(AppThemeTokens tokens) {
    final height = CDropdownStyles.fieldHeight(widget.props.size);
    final fontSize = CDropdownStyles.fontSize(widget.props.size);
    final bgColor = CDropdownStyles.fieldBackground(
      tokens: tokens,
      disabled: widget.props.disabled,
      isHovered: _isHovered,
    );
    final border = CDropdownStyles.fieldBorder(
      tokens: tokens,
      disabled: widget.props.disabled,
      isFocused: _isFocused,
      isOpen: _isOpen,
      isInvalid: widget.props.isInvalid,
      isWarn: widget.props.isWarn,
    );

    final hasSelection = _selectedItem != null;

    Color textColor;
    if (widget.props.disabled) {
      textColor = tokens.textDisabled;
    } else if (hasSelection) {
      textColor = tokens.textPrimary;
    } else {
      textColor = tokens.textPlaceholder;
    }

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event.logicalKey.keyLabel == 'Enter' ||
            event.logicalKey.keyLabel == ' ') {
          _toggleDropdown();
          return KeyEventResult.handled;
        } else if (event.logicalKey.keyLabel == 'Escape') {
          _closeDropdown();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        onEnter: (_) {
          if (!widget.props.disabled) setState(() => _isHovered = true);
        },
        onExit: (_) {
          if (!widget.props.disabled) setState(() => _isHovered = false);
        },
        cursor: widget.props.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _toggleDropdown,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: height,
            decoration: BoxDecoration(color: bgColor, border: border),
            padding: const EdgeInsets.symmetric(
              horizontal: CDropdownStyles.horizontalPadding,
            ),
            child: Row(
              children: [
                if (hasSelection && _selectedItem!.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: CDropdownStyles.iconSize,
                      color: textColor,
                    ),
                    child: _selectedItem!.icon!,
                  ),
                  const SizedBox(width: CDropdownStyles.iconSpacing),
                ],
                Expanded(
                  child: widget.props.filterable && _isOpen
                      ? TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: tokens.textPrimary,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: hasSelection
                                ? _selectedItem!.label
                                : widget.props.placeholder,
                            hintStyle: TextStyle(
                              fontSize: fontSize,
                              color: tokens.textPlaceholder,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() => _filterText = val);
                            _overlayEntry?.markNeedsBuild();
                          },
                        )
                      : Text(
                          hasSelection
                              ? _selectedItem!.label
                              : widget.props.placeholder,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                // Status validation icon
                if (widget.props.isInvalid) ...[
                  Icon(
                    Icons.error,
                    size: CDropdownStyles.iconSize,
                    color: tokens.supportError,
                  ),
                  const SizedBox(width: CDropdownStyles.iconSpacing),
                ] else if (widget.props.isWarn) ...[
                  Icon(
                    Icons.warning,
                    size: CDropdownStyles.iconSize,
                    color: tokens.supportWarning,
                  ),
                  const SizedBox(width: CDropdownStyles.iconSpacing),
                ],
                // Clear selection button
                if (widget.props.isClearable &&
                    hasSelection &&
                    !widget.props.disabled) ...[
                  GestureDetector(
                    onTap: _clearSelection,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.close,
                        size: CDropdownStyles.iconSize - 2,
                        color: tokens.iconPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: CDropdownStyles.iconSpacing),
                ],
                // Dropdown caret chevron
                Icon(
                  _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: CDropdownStyles.iconSize,
                  color: widget.props.disabled
                      ? tokens.textDisabled
                      : tokens.iconPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationMessage(AppThemeTokens tokens) {
    if (widget.props.isInvalid) {
      return Padding(
        padding: const EdgeInsets.only(top: Spacing.v4px025remSpacing02),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: CDropdownStyles.helperFontSize,
              color: tokens.supportError,
            ),
            const SizedBox(width: 4),
            Text(
              widget.props.invalidText!,
              style: TextStyle(
                fontSize: CDropdownStyles.helperFontSize,
                color: tokens.supportError,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    } else if (widget.props.isWarn) {
      return Padding(
        padding: const EdgeInsets.only(top: Spacing.v4px025remSpacing02),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              size: CDropdownStyles.helperFontSize,
              color: tokens.supportWarning,
            ),
            const SizedBox(width: 4),
            Text(
              widget.props.warnText!,
              style: TextStyle(
                fontSize: CDropdownStyles.helperFontSize,
                color: tokens.supportWarning,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMenuOverlay(BuildContext context) {
    final tokens = context.tokens;
    final items = _filteredItems;
    final itemHeight = CDropdownStyles.fieldHeight(widget.props.size);

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: CDropdownStyles.maxMenuHeight,
        ),
        decoration: BoxDecoration(
          color: tokens.layer01,
          border: Border.all(color: tokens.borderSubtle01, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: items.isEmpty
            ? Container(
                height: itemHeight,
                padding: const EdgeInsets.symmetric(
                  horizontal: CDropdownStyles.horizontalPadding,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'No options found',
                  style: TextStyle(
                    fontSize: CDropdownStyles.fontSize(widget.props.size),
                    color: tokens.textPlaceholder,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  final isSelected = _selectedItem == item;
                  return _CDropdownOptionWidget<T>(
                    item: item,
                    isSelected: isSelected,
                    size: widget.props.size,
                    tokens: tokens,
                    onTap: () => _selectItem(item),
                  );
                },
              ),
      ),
    );
  }
}

class _CDropdownOptionWidget<T> extends StatefulWidget {
  const _CDropdownOptionWidget({
    required this.item,
    required this.isSelected,
    required this.size,
    required this.tokens,
    required this.onTap,
  });

  final CDropdownItem<T> item;
  final bool isSelected;
  final CDropdownSize size;
  final AppThemeTokens tokens;
  final VoidCallback onTap;

  @override
  State<_CDropdownOptionWidget<T>> createState() =>
      _CDropdownOptionWidgetState<T>();
}

class _CDropdownOptionWidgetState<T> extends State<_CDropdownOptionWidget<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final height = CDropdownStyles.fieldHeight(widget.size);
    final fontSize = CDropdownStyles.fontSize(widget.size);

    Color bgColor = Colors.transparent;
    if (!widget.item.disabled) {
      if (_isHovered) {
        bgColor = widget.tokens.layerHover01;
      } else if (widget.isSelected) {
        bgColor = widget.tokens.layerSelected01.withValues(alpha: 0.4);
      }
    }

    final textColor = widget.item.disabled
        ? widget.tokens.textDisabled
        : widget.tokens.textPrimary;

    return MouseRegion(
      onEnter: (_) {
        if (!widget.item.disabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!widget.item.disabled) setState(() => _isHovered = false);
      },
      cursor: widget.item.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.disabled ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: height,
          color: bgColor,
          padding: const EdgeInsets.symmetric(
            horizontal: CDropdownStyles.horizontalPadding,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: CDropdownStyles.iconSize,
                    color: textColor,
                  ),
                  child: widget.item.icon!,
                ),
                const SizedBox(width: CDropdownStyles.iconSpacing),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isSelected) ...[
                Icon(
                  Icons.check,
                  size: CDropdownStyles.iconSize,
                  color: widget.tokens.iconPrimary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
