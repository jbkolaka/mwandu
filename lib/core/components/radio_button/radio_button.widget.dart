import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/text/index.dart';

import 'radio_button.props.dart';
import 'radio_button.styles.dart';

typedef _Styles = CRadioButtonStyles;

/// Internal inherited scope to distribute [CRadioButtonGroup] state to child [CRadioButton] widgets.
class _CRadioButtonGroupScope<T> extends InheritedWidget {
  const _CRadioButtonGroupScope({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.enable,
    required this.readOnly,
    required this.invalid,
    required this.warn,
    required this.labelPosition,
    required super.child,
  });

  final T? selectedValue;
  final ValueChanged<T>? onChanged;
  final bool enable;
  final bool readOnly;
  final bool invalid;
  final bool warn;
  final CRadioButtonLabelPosition labelPosition;

  static _CRadioButtonGroupScope<T>? of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_CRadioButtonGroupScope<T>>();
  }

  @override
  bool updateShouldNotify(_CRadioButtonGroupScope<T> oldWidget) {
    return selectedValue != oldWidget.selectedValue ||
        enable != oldWidget.enable ||
        readOnly != oldWidget.readOnly ||
        invalid != oldWidget.invalid ||
        warn != oldWidget.warn ||
        labelPosition != oldWidget.labelPosition;
  }
}

/// Carbon Radio Button Group component.
///
/// Wraps a collection of mutually exclusive [CRadioButton] options and coordinates
/// selection, orientation, validation errors, warnings, and accessibility.
class CRadioButtonGroup<T> extends StatefulWidget {
  CRadioButtonGroup({
    super.key,
    String? legendText,
    String? name,
    T? valueSelected,
    T? defaultSelected,
    CRadioButtonOrientation orientation = CRadioButtonOrientation.vertical,
    CRadioButtonLabelPosition labelPosition = CRadioButtonLabelPosition.right,
    bool enable = true,
    bool readOnly = false,
    bool invalid = false,
    String? invalidText,
    bool warn = false,
    String? warnText,
    String? helperText,
    ValueChanged<T>? onChange,
    List<Widget> children = const [],
  }) : props = CRadioButtonGroupProps<T>(
         legendText: legendText,
         name: name,
         valueSelected: valueSelected,
         defaultSelected: defaultSelected,
         orientation: orientation,
         labelPosition: labelPosition,
         enable: enable,
         readOnly: readOnly,
         invalid: invalid,
         invalidText: invalidText,
         warn: warn,
         warnText: warnText,
         helperText: helperText,
         onChange: onChange,
         children: children,
       );

  final CRadioButtonGroupProps<T> props;

  @override
  State<CRadioButtonGroup<T>> createState() => _CRadioButtonGroupState<T>();
}

class _CRadioButtonGroupState<T> extends State<CRadioButtonGroup<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.props.valueSelected ?? widget.props.defaultSelected;
  }

  @override
  void didUpdateWidget(CRadioButtonGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.valueSelected != null) {
      _selectedValue = widget.props.valueSelected;
    }
  }

  void _handleChanged(T value) {
    if (widget.props.readOnly) return;

    if (widget.props.valueSelected == null) {
      setState(() {
        _selectedValue = value;
      });
    }
    widget.props.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isInheritedEnabled = context.inheritedEnable;
    final isEnabled = isInheritedEnabled && widget.props.enable;

    final String? statusMessage = widget.props.invalid
        ? widget.props.invalidText
        : widget.props.warn
        ? widget.props.warnText
        : widget.props.helperText;

    final Color statusColor = _Styles.validationColor(
      tokens: tokens,
      invalid: widget.props.invalid,
      warn: widget.props.warn,
    );

    Widget optionsWidget;
    if (widget.props.orientation == CRadioButtonOrientation.horizontal) {
      optionsWidget = Wrap(
        spacing: _Styles.horizontalSpacing,
        runSpacing: _Styles.verticalSpacing,
        children: widget.props.children,
      );
    } else {
      optionsWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < widget.props.children.length; i++) ...[
            if (i > 0) const SizedBox(height: _Styles.verticalSpacing),
            widget.props.children[i],
          ],
        ],
      );
    }

    return _CRadioButtonGroupScope<T>(
      selectedValue: widget.props.valueSelected ?? _selectedValue,
      onChanged: _handleChanged,
      enable: isEnabled,
      readOnly: widget.props.readOnly,
      invalid: widget.props.invalid,
      warn: widget.props.warn,
      labelPosition: widget.props.labelPosition,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.props.legendText != null &&
              widget.props.legendText!.isNotEmpty) ...[
            CText(
              data: widget.props.legendText!,
              enable: isEnabled,
              style: TextStyle(
                fontSize: _Styles.legendFontSize,
                fontWeight: FontWeight.w400,
                color: _Styles.legendColor(
                  tokens: tokens,
                  disabled: !isEnabled,
                ),
              ),
            ),
            const SizedBox(height: _Styles.legendMarginBottom),
          ],
          optionsWidget,
          if (statusMessage != null && statusMessage.isNotEmpty) ...[
            const SizedBox(height: _Styles.messageMarginTop),
            CText(
              data: statusMessage,
              enable: isEnabled,
              style: TextStyle(
                fontSize: _Styles.messageFontSize,
                fontWeight: FontWeight.w400,
                color: !isEnabled ? tokens.textDisabled : statusColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Carbon Radio Button component.
///
/// Used for single selection among a group of mutually exclusive choices.
class CRadioButton<T> extends StatefulWidget {
  CRadioButton({
    super.key,
    required T value,
    String? label,
    String? labelText,
    bool enable = true,
    bool hideLabel = false,
    bool readOnly = false,
    CRadioButtonLabelPosition? labelPosition,
    String? id,
    String? helperText,
    bool? selected,
    ValueChanged<T>? onChange,
  }) : props = CRadioButtonProps<T>(
         value: value,
         label: label ?? labelText,
         enable: enable,
         hideLabel: hideLabel,
         readOnly: readOnly,
         labelPosition: labelPosition ?? CRadioButtonLabelPosition.right,
         id: id,
         helperText: helperText,
         selected: selected,
         onChange: onChange,
       );

  final CRadioButtonProps<T> props;

  @override
  State<CRadioButton<T>> createState() => _CRadioButtonState<T>();
}

class _CRadioButtonState<T> extends State<CRadioButton<T>> {
  bool _isFocused = false;
  bool _isHovered = false;

  void _handleTap(
    _CRadioButtonGroupScope<T>? groupScope,
    bool isEnabled,
    bool isReadOnly,
  ) {
    if (!isEnabled || isReadOnly) return;

    if (groupScope != null) {
      groupScope.onChanged?.call(widget.props.value);
    }
    widget.props.onChange?.call(widget.props.value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final groupScope = _CRadioButtonGroupScope.of<T>(context);

    final bool isEnabled =
        context.inheritedEnable &&
        (groupScope?.enable ?? true) &&
        widget.props.enable;
    final bool isReadOnly =
        (groupScope?.readOnly ?? false) || widget.props.readOnly;
    final bool isInvalid = groupScope?.invalid ?? false;
    final bool isWarn = groupScope?.warn ?? false;
    final CRadioButtonLabelPosition labelPosition =
        groupScope?.labelPosition ?? widget.props.labelPosition;

    final bool isSelected = groupScope != null
        ? groupScope.selectedValue == widget.props.value
        : (widget.props.selected ?? false);

    final Color outerBorderColor = _Styles.borderColor(
      tokens: tokens,
      selected: isSelected,
      disabled: !isEnabled,
      focused: _isFocused,
      hovered: _isHovered,
      invalid: isInvalid,
      warn: isWarn,
    );

    final Color innerDotColor = _Styles.dotColor(
      tokens: tokens,
      disabled: !isEnabled,
      invalid: isInvalid,
      warn: isWarn,
    );

    final Widget radioCircle = AnimatedContainer(
      duration: _Styles.borderAnimation['duration'] as Duration,
      curve: _Styles.borderAnimation['curve'] as Curve,
      width: _Styles.outerSize,
      height: _Styles.outerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: outerBorderColor,
          width: _isFocused ? _Styles.focusedBorderWidth : _Styles.borderWidth,
        ),
      ),
      child: AnimatedScale(
        scale: isSelected ? 1.0 : 0.0,
        duration: _Styles.dotAnimation['duration'] as Duration,
        curve: _Styles.dotAnimation['curve'] as Curve,
        child: Container(
          width: _Styles.innerDotSize,
          height: _Styles.innerDotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: innerDotColor,
          ),
        ),
      ),
    );

    Widget? labelWidget;
    final String? labelText = widget.props.label;
    if (!widget.props.hideLabel && labelText != null && labelText.isNotEmpty) {
      labelWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CText(
            data: labelText,
            enable: isEnabled,
            style: TextStyle(
              fontSize: _Styles.labelFontSize,
              color: _Styles.labelColor(tokens: tokens, disabled: !isEnabled),
            ),
          ),
          if (widget.props.helperText != null &&
              widget.props.helperText!.isNotEmpty) ...[
            const SizedBox(height: 2.0),
            CText(
              data: widget.props.helperText!,
              enable: isEnabled,
              style: TextStyle(
                fontSize: _Styles.messageFontSize,
                color: _Styles.helperColor(
                  tokens: tokens,
                  disabled: !isEnabled,
                ),
              ),
            ),
          ],
        ],
      );
    }

    final List<Widget> children = [];
    if (labelPosition == CRadioButtonLabelPosition.left &&
        labelWidget != null) {
      children.add(Flexible(child: labelWidget));
      children.add(const SizedBox(width: _Styles.labelSpacing));
      children.add(radioCircle);
    } else {
      children.add(radioCircle);
      if (labelWidget != null) {
        children.add(const SizedBox(width: _Styles.labelSpacing));
        children.add(Flexible(child: labelWidget));
      }
    }

    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: isSelected,
      enabled: isEnabled,
      label: widget.props.label,
      child: FocusableActionDetector(
        enabled: isEnabled && !isReadOnly,
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        mouseCursor: isEnabled && !isReadOnly
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: () => _handleTap(groupScope, isEnabled, isReadOnly),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
