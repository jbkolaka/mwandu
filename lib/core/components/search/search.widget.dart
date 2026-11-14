import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/components/text/index.dart';

import 'search.props.dart';
import 'search.styles.dart';

typedef _Styles = CSearchStyles;

/// Carbon Search component.
///
/// Provides a single-line search input with leading search icon,
/// dynamic clear button, state-aware theme styling, and optional expandable mode.
class CSearch extends StatefulWidget {
  CSearch({
    super.key,
    String? id,
    String? label,
    String? labelText,
    String placeholder = 'Search',
    CSearchSize size = CSearchSize.md,
    bool enable = true,
    bool readOnly = false,
    bool autoFocus = false,
    String? value,
    TextEditingController? controller,
    FocusNode? focusNode,
    String closeButtonLabelText = 'Clear search input',
    bool isExpandable = false,
    bool? expanded,
    bool defaultExpanded = false,
    double? defaultWidth,
    double? minWidth,
    ValueChanged<bool>? onExpand,
    ValueChanged<String>? onChange,
    ValueChanged<String>? onSubmit,
    VoidCallback? onClear,
  }) : props = CSearchProps(
         id: id,
         label: label,
         labelText: labelText,
         placeholder: placeholder,
         size: size,
         enable: enable,
         readOnly: readOnly,
         autoFocus: autoFocus,
         value: value,
         controller: controller,
         focusNode: focusNode,
         closeButtonLabelText: closeButtonLabelText,
         isExpandable: isExpandable,
         expanded: expanded,
         defaultExpanded: defaultExpanded,
         defaultWidth: defaultWidth,
         minWidth: minWidth,
         onExpand: onExpand,
         onChange: onChange,
         onSubmit: onSubmit,
         onClear: onClear,
       );

  final CSearchProps props;

  @override
  State<CSearch> createState() => _CSearchState();
}

class _CSearchState extends State<CSearch> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  bool _isFocused = false;
  bool _isHovered = false;
  bool _isClearHovered = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.props.controller != null) {
      _controller = widget.props.controller!;
    } else {
      _controller = TextEditingController(text: widget.props.value ?? '');
      _ownsController = true;
    }

    if (widget.props.focusNode != null) {
      _focusNode = widget.props.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _isExpanded = widget.props.expanded ?? widget.props.defaultExpanded;

    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.controller != null &&
        widget.props.controller != _controller) {
      if (_ownsController) {
        _controller.removeListener(_handleTextChange);
        _controller.dispose();
        _ownsController = false;
      }
      _controller = widget.props.controller!;
      _controller.addListener(_handleTextChange);
    } else if (widget.props.value != null &&
        widget.props.value != _controller.text) {
      _controller.text = widget.props.value!;
    }

    if (widget.props.expanded != null) {
      _isExpanded = widget.props.expanded!;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (!_focusNode.hasFocus &&
          widget.props.isExpandable &&
          _controller.text.isEmpty &&
          widget.props.expanded == null) {
        setState(() {
          _isExpanded = false;
        });
        widget.props.onExpand?.call(false);
      }
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.props.onChange?.call('');
    widget.props.onClear?.call();
    _focusNode.requestFocus();
  }

  void _toggleExpand() {
    final bool nextState = !_isExpanded;
    if (widget.props.expanded == null) {
      setState(() {
        _isExpanded = nextState;
      });
    }
    widget.props.onExpand?.call(nextState);
    if (nextState) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bool isEnabled = context.inheritedEnable && widget.props.enable;
    final double height = _Styles.height(widget.props.size);
    final double iconSize = _Styles.searchIconSize(widget.props.size);
    final double clearIconSize = _Styles.clearIconSize(widget.props.size);
    final double fontSize = _Styles.fontSize(widget.props.size);
    final double padding = _Styles.horizontalPadding(widget.props.size);
    final double gap = _Styles.iconGap(widget.props.size);

    final bool isExpanded = widget.props.isExpandable ? _isExpanded : true;
    final double? defaultWidth = widget.props.defaultWidth;
    final double minWidth = widget.props.minWidth ?? height;

    final Widget searchField = AnimatedContainer(
      duration: _Styles.expandDuration,
      curve: _Styles.expandCurve,
      height: height,
      width: widget.props.isExpandable
          ? (isExpanded ? (defaultWidth ?? 300.0) : minWidth)
          : defaultWidth,
      decoration: BoxDecoration(
        color: _Styles.background(
          tokens: tokens,
          disabled: !isEnabled,
          hovered: _isHovered,
        ),
        border: _Styles.border(
          tokens: tokens,
          disabled: !isEnabled,
          focused: _isFocused,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: isEnabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading search icon or expandable toggle button
            if (widget.props.isExpandable && !isExpanded)
              Expanded(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: minWidth,
                    height: height,
                  ),
                  icon: Icon(
                    CIcons.search,
                    size: iconSize,
                    color: _Styles.iconColor(
                      tokens: tokens,
                      disabled: !isEnabled,
                    ),
                  ),
                  tooltip:
                      widget.props.effectiveLabel ?? widget.props.placeholder,
                  onPressed: isEnabled ? _toggleExpand : null,
                ),
              )
            else ...[
              Padding(
                padding: EdgeInsets.only(left: padding, right: gap),
                child: Icon(
                  CIcons.search,
                  size: iconSize,
                  color: _Styles.iconColor(
                    tokens: tokens,
                    disabled: !isEnabled,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: isEnabled,
                  readOnly: widget.props.readOnly,
                  autofocus: widget.props.autoFocus,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: _Styles.textColor(
                      tokens: tokens,
                      disabled: !isEnabled,
                    ),
                  ),
                  cursorColor: tokens.focus,
                  cursorWidth: 1.0,
                  decoration: InputDecoration(
                    hintText: widget.props.placeholder,
                    hintStyle: TextStyle(
                      fontSize: fontSize,
                      color: _Styles.placeholderColor(
                        tokens: tokens,
                        disabled: !isEnabled,
                      ),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) => widget.props.onChange?.call(val),
                  onSubmitted: (val) => widget.props.onSubmit?.call(val),
                ),
              ),
              if (_controller.text.isNotEmpty &&
                  isEnabled &&
                  !widget.props.readOnly)
                MouseRegion(
                  onEnter: (_) => setState(() => _isClearHovered = true),
                  onExit: (_) => setState(() => _isClearHovered = false),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tightFor(
                      width: height,
                      height: height,
                    ),
                    icon: Icon(
                      CIcons.close,
                      size: clearIconSize,
                      color: _Styles.clearIconColor(
                        tokens: tokens,
                        hovered: _isClearHovered,
                      ),
                    ),
                    tooltip: widget.props.closeButtonLabelText,
                    onPressed: _handleClear,
                  ),
                )
              else
                SizedBox(width: padding),
            ],
          ],
        ),
      ),
    );

    final String? label = widget.props.effectiveLabel;
    if (label != null && label.isNotEmpty && !widget.props.isExpandable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CText(
            data: label,
            enable: isEnabled,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: isEnabled ? tokens.textSecondary : tokens.textDisabled,
            ),
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
          searchField,
        ],
      );
    }

    return searchField;
  }
}

/// Convenience class for an expandable Carbon Search variant.
class CExpandableSearch extends CSearch {
  CExpandableSearch({
    super.key,
    super.id,
    super.label,
    super.labelText,
    super.placeholder,
    super.size,
    super.enable,
    super.readOnly,
    super.autoFocus,
    super.value,
    super.controller,
    super.focusNode,
    super.closeButtonLabelText,
    super.expanded,
    super.defaultExpanded,
    super.defaultWidth = 300.0,
    super.minWidth,
    super.onExpand,
    super.onChange,
    super.onSubmit,
    super.onClear,
  }) : super(isExpandable: true);
}
