import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/components/text/index.dart';

import 'select.props.dart';
import 'select.styles.dart';

typedef _Styles = CSelectStyles;

/// Carbon Select component.
///
/// A styled native-style select field supporting labeled groups, helper text,
/// error/warning validation, inline layout, read-only, and disabled states.
class CSelect<T> extends StatefulWidget {
  CSelect({
    super.key,
    required List<CSelectItem<T>> items,
    T? value,
    ValueChanged<T?>? onChanged,
    String? label,
    String? labelText,
    String? helperText,
    String? invalidText,
    String? warnText,
    String placeholder = 'Choose an option',
    CSelectSize size = CSelectSize.md,
    bool inline = false,
    bool hideLabel = false,
    bool invalid = false,
    bool warn = false,
    bool enable = true,
    bool readOnly = false,
  }) : props = CSelectProps<T>(
         items: items,
         value: value,
         onChanged: onChanged,
         label: label,
         labelText: labelText,
         helperText: helperText,
         invalidText: invalidText,
         warnText: warnText,
         placeholder: placeholder,
         size: size,
         inline: inline,
         hideLabel: hideLabel,
         invalid: invalid,
         warn: warn,
         enable: enable,
         readOnly: readOnly,
       );

  final CSelectProps<T> props;

  @override
  State<CSelect<T>> createState() => _CSelectState<T>();
}

class _CSelectState<T> extends State<CSelect<T>> {
  bool _isOpen = false;
  bool _isHovered = false;
  bool _isFocused = false;
  T? _selectedValue;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.props.value;
  }

  @override
  void didUpdateWidget(CSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _selectedValue = widget.props.value;
    }
  }

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  String get _displayText {
    if (_selectedValue == null) return widget.props.placeholder;
    final match = widget.props.items
        .where((e) => e.value == _selectedValue)
        .firstOrNull;
    return match?.label ?? widget.props.placeholder;
  }

  bool get _isEnabled =>
      context.inheritedEnable && widget.props.enable && !widget.props.readOnly;

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (_overlayEntry != null) return;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final tokens = context.tokens;
    _overlayEntry = OverlayEntry(builder: (ctx) => _buildMenu(ctx, tokens));
    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  void _select(T? value) {
    _closeMenu();
    if (widget.props.value == null) {
      setState(() => _selectedValue = value);
    }
    widget.props.onChanged?.call(value);
  }

  Widget _buildMenu(BuildContext ctx, AppThemeTokens tokens) {
    final double fieldH = _Styles.fieldHeight(widget.props.size);
    final double fontSize = _Styles.fontSize(widget.props.size);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeMenu,
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 2),
          showWhenUnlinked: false,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              constraints: BoxConstraints(maxHeight: _Styles.maxMenuHeight),
              decoration: BoxDecoration(
                color: tokens.layer01,
                border: Border.all(color: tokens.borderSubtle01, width: 1.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                    offset: Offset(0, 4),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.props.items.length,
                itemBuilder: (ctx, i) {
                  final item = widget.props.items[i];
                  final isSelected = item.value == (_selectedValue);
                  final isDisabled = item.disabled;

                  return Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: isDisabled ? null : () => _select(item.value),
                      hoverColor: tokens.layerHover01,
                      child: Container(
                        height: fieldH,
                        padding: const EdgeInsets.symmetric(
                          horizontal: _Styles.horizontalPadding,
                        ),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: tokens.layerSelected01,
                                border: Border(
                                  left: BorderSide(
                                    color: tokens.borderInteractive,
                                    width: 2.0,
                                  ),
                                ),
                              )
                            : null,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: isDisabled
                                ? tokens.textDisabled
                                : tokens.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bool isEnabled = _isEnabled;
    final bool isVisualDisabled =
        !context.inheritedEnable || !widget.props.enable;

    final double fieldH = _Styles.fieldHeight(widget.props.size);
    final double fontSize = _Styles.fontSize(widget.props.size);
    final bool hasValue = _selectedValue != null;

    final Widget field = CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: isEnabled ? (_) => setState(() => _isHovered = true) : null,
        onExit: isEnabled ? (_) => setState(() => _isHovered = false) : null,
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Focus(
          onFocusChange: (v) => setState(() => _isFocused = v),
          child: GestureDetector(
            onTap: isEnabled ? _toggleMenu : null,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 70),
              height: fieldH,
              decoration: BoxDecoration(
                color: _Styles.fieldBackground(
                  tokens: tokens,
                  disabled: isVisualDisabled,
                  isHovered: _isHovered,
                ),
                border: _Styles.fieldBorder(
                  tokens: tokens,
                  disabled: isVisualDisabled,
                  isFocused: _isFocused,
                  isOpen: _isOpen,
                  isInvalid: widget.props.invalid,
                  isWarn: widget.props.warn,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _Styles.horizontalPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _displayText,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: hasValue
                              ? _Styles.textColor(
                                  tokens: tokens,
                                  disabled: isVisualDisabled,
                                )
                              : _Styles.placeholderColor(
                                  tokens: tokens,
                                  disabled: isVisualDisabled,
                                ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        CIcons.chevronDown,
                        size: _Styles.chevronSize,
                        color: _Styles.chevronColor(
                          tokens: tokens,
                          disabled: isVisualDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final String? statusMessage = widget.props.invalid
        ? widget.props.invalidText
        : widget.props.warn
        ? widget.props.warnText
        : widget.props.helperText;

    final Color msgColor = _Styles.messageColor(
      tokens: tokens,
      isInvalid: widget.props.invalid,
      isWarn: widget.props.warn,
    );

    final String? effectiveLabel = widget.props.effectiveLabel;

    Widget labelWidget = const SizedBox.shrink();
    if (!widget.props.hideLabel &&
        effectiveLabel != null &&
        effectiveLabel.isNotEmpty) {
      labelWidget = CText(
        data: effectiveLabel,
        enable: !isVisualDisabled,
        style: TextStyle(
          fontSize: _Styles.labelFontSize,
          fontWeight: FontWeight.w400,
          color: _Styles.labelColor(tokens: tokens, disabled: isVisualDisabled),
        ),
      );
    }

    Widget messageWidget = const SizedBox.shrink();
    if (statusMessage != null && statusMessage.isNotEmpty) {
      messageWidget = Padding(
        padding: const EdgeInsets.only(top: _Styles.messageMarginTop),
        child: CText(
          data: statusMessage,
          enable: !isVisualDisabled,
          style: TextStyle(
            fontSize: _Styles.helperFontSize,
            fontWeight: FontWeight.w400,
            color: isVisualDisabled ? tokens.textDisabled : msgColor,
          ),
        ),
      );
    }

    if (widget.props.inline) {
      return Semantics(
        label: effectiveLabel,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!widget.props.hideLabel &&
                effectiveLabel != null &&
                effectiveLabel.isNotEmpty) ...[
              labelWidget,
              const SizedBox(width: _Styles.inlineSpacing),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [field, messageWidget],
              ),
            ),
          ],
        ),
      );
    }

    return Semantics(
      label: effectiveLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.props.hideLabel &&
              effectiveLabel != null &&
              effectiveLabel.isNotEmpty) ...[
            labelWidget,
            const SizedBox(height: _Styles.labelMarginBottom),
          ],
          field,
          messageWidget,
        ],
      ),
    );
  }
}
