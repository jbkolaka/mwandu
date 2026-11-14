import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/text/index.dart';

import 'slider.props.dart';
import 'slider.styles.dart';

typedef _Styles = CSliderStyles;

/// Carbon Slider component.
///
/// Allows users to select a single value along a subjective continuous or discrete range,
/// with optional companion numeric input, min/max boundary labels, and validation indicators.
class CSlider extends StatefulWidget {
  CSlider({
    super.key,
    required double value,
    double min = 0.0,
    double max = 100.0,
    double step = 1.0,
    String? label,
    String? labelText,
    bool hideLabel = false,
    bool hideTextInput = false,
    String? minLabel,
    String? maxLabel,
    bool enable = true,
    bool readOnly = false,
    bool invalid = false,
    String? invalidText,
    bool warn = false,
    String? warnText,
    ValueChanged<double>? onChange,
    ValueChanged<double>? onChangeEnd,
    String Function(double value)? formatLabel,
  }) : props = CSliderProps(
         value: value,
         min: min,
         max: max,
         step: step,
         label: label,
         labelText: labelText,
         hideLabel: hideLabel,
         hideTextInput: hideTextInput,
         minLabel: minLabel,
         maxLabel: maxLabel,
         enable: enable,
         readOnly: readOnly,
         invalid: invalid,
         invalidText: invalidText,
         warn: warn,
         warnText: warnText,
         onChange: onChange,
         onChangeEnd: onChangeEnd,
         formatLabel: formatLabel,
       );

  final CSliderProps props;

  @override
  State<CSlider> createState() => _CSliderState();
}

class _CSliderState extends State<CSlider> {
  late double _currentValue;
  late TextEditingController _textController;
  final FocusNode _thumbFocusNode = FocusNode();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isThumbFocused = false;
  bool _isInputFocused = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.props.value.clamp(
      widget.props.min,
      widget.props.max,
    );
    _textController = TextEditingController(text: _formatValue(_currentValue));

    _thumbFocusNode.addListener(() {
      if (mounted) setState(() => _isThumbFocused = _thumbFocusNode.hasFocus);
    });
    _inputFocusNode.addListener(() {
      if (mounted) {
        setState(() => _isInputFocused = _inputFocusNode.hasFocus);
        if (!_inputFocusNode.hasFocus) {
          widget.props.onChangeEnd?.call(_currentValue);
        }
      }
    });
  }

  @override
  void didUpdateWidget(CSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _currentValue = widget.props.value.clamp(
        widget.props.min,
        widget.props.max,
      );
      if (!_inputFocusNode.hasFocus) {
        _textController.text = _formatValue(_currentValue);
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _thumbFocusNode.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  String _formatValue(double val) {
    if (widget.props.formatLabel != null) {
      return widget.props.formatLabel!(val);
    }
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }

  double _snapToStep(double rawVal) {
    final double step = widget.props.step;
    if (step <= 0) return rawVal.clamp(widget.props.min, widget.props.max);
    final double stepped = (rawVal / step).round() * step;
    return stepped.clamp(widget.props.min, widget.props.max);
  }

  void _updateValue(double newValue, {bool fromDrag = false}) {
    final double snapped = _snapToStep(newValue);
    if (snapped != _currentValue) {
      setState(() {
        _currentValue = snapped;
        if (fromDrag) {
          _textController.text = _formatValue(snapped);
        }
      });
      widget.props.onChange?.call(snapped);
    }
  }

  void _handleDrag(Offset localPosition, double trackWidth) {
    if (trackWidth <= 0) return;
    final double ratio = (localPosition.dx / trackWidth).clamp(0.0, 1.0);
    final double rawVal =
        widget.props.min + ratio * (widget.props.max - widget.props.min);
    _updateValue(rawVal, fromDrag: true);
  }

  void _handleInputSubmitted(String text) {
    final double? parsed = double.tryParse(text);
    if (parsed != null) {
      _updateValue(parsed);
      widget.props.onChangeEnd?.call(_currentValue);
    } else {
      _textController.text = _formatValue(_currentValue);
    }
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _updateValue(_currentValue - widget.props.step);
      widget.props.onChangeEnd?.call(_currentValue);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _updateValue(_currentValue + widget.props.step);
      widget.props.onChangeEnd?.call(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bool isEnabled =
        context.inheritedEnable &&
        widget.props.enable &&
        !widget.props.readOnly;
    final bool isVisualDisabled =
        !context.inheritedEnable || !widget.props.enable;

    final Color activeColor = _Styles.activeTrackColor(
      tokens: tokens,
      disabled: isVisualDisabled,
      invalid: widget.props.invalid,
      warn: widget.props.warn,
    );
    final Color trackBgColor = _Styles.trackBackgroundColor(tokens);

    final double ratio =
        ((_currentValue - widget.props.min) /
                (widget.props.max - widget.props.min))
            .clamp(0.0, 1.0);

    final String? statusMessage = widget.props.invalid
        ? widget.props.invalidText
        : widget.props.warn
        ? widget.props.warnText
        : null;

    final Color statusColor = _Styles.validationColor(
      tokens: tokens,
      invalid: widget.props.invalid,
      warn: widget.props.warn,
    );

    final Widget sliderTrack = LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        return GestureDetector(
          onHorizontalDragDown: isEnabled
              ? (d) {
                  _thumbFocusNode.requestFocus();
                  _handleDrag(d.localPosition, width);
                }
              : null,
          onHorizontalDragUpdate: isEnabled
              ? (d) => _handleDrag(d.localPosition, width)
              : null,
          onHorizontalDragEnd: isEnabled
              ? (_) => widget.props.onChangeEnd?.call(_currentValue)
              : null,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 32.0,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background Track
                Container(
                  height: _Styles.trackHeight,
                  width: width,
                  color: trackBgColor,
                ),
                // Filled Active Track
                Container(
                  height: _Styles.trackHeight,
                  width: width * ratio,
                  color: activeColor,
                ),
                // Thumb Handle
                Positioned(
                  left: (width * ratio - _Styles.thumbSize / 2).clamp(
                    0.0,
                    width - _Styles.thumbSize,
                  ),
                  child: KeyboardListener(
                    focusNode: _thumbFocusNode,
                    onKeyEvent: isEnabled ? _handleKey : null,
                    child: Container(
                      width: _Styles.thumbSize,
                      height: _Styles.thumbSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor,
                        border: _isThumbFocused
                            ? Border.all(
                                color: _Styles.focusRingColor(tokens),
                                width: _Styles.focusRingWidth,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    final Widget companionInput = Container(
      width: _Styles.inputWidth,
      height: _Styles.inputHeight,
      decoration: BoxDecoration(
        color: _Styles.inputBackgroundColor(
          tokens: tokens,
          disabled: isVisualDisabled,
        ),
        border: Border.all(
          color: _Styles.inputBorderColor(
            tokens: tokens,
            focused: _isInputFocused,
            invalid: widget.props.invalid,
            warn: widget.props.warn,
          ),
          width: _isInputFocused ? 2.0 : 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.center,
      child: TextField(
        controller: _textController,
        focusNode: _inputFocusNode,
        enabled: isEnabled,
        readOnly: widget.props.readOnly,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          color: isVisualDisabled ? tokens.textDisabled : tokens.textPrimary,
        ),
        cursorColor: tokens.focus,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onSubmitted: _handleInputSubmitted,
      ),
    );

    final String minText =
        widget.props.minLabel ?? _formatValue(widget.props.min);
    final String maxText =
        widget.props.maxLabel ?? _formatValue(widget.props.max);

    return Semantics(
      slider: true,
      label: widget.props.effectiveLabel,
      value: _formatValue(_currentValue),
      enabled: isEnabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.props.hideLabel &&
              widget.props.effectiveLabel != null &&
              widget.props.effectiveLabel!.isNotEmpty) ...[
            CText(
              data: widget.props.effectiveLabel!,
              enable: !isVisualDisabled,
              style: TextStyle(
                fontSize: _Styles.labelFontSize,
                fontWeight: FontWeight.w400,
                color: _Styles.labelColor(
                  tokens: tokens,
                  disabled: isVisualDisabled,
                ),
              ),
            ),
            const SizedBox(height: _Styles.labelMarginBottom),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CText(
                data: minText,
                enable: !isVisualDisabled,
                style: TextStyle(
                  fontSize: _Styles.rangeFontSize,
                  color: _Styles.rangeLabelColor(
                    tokens: tokens,
                    disabled: isVisualDisabled,
                  ),
                ),
              ),
              const SizedBox(width: _Styles.minMaxLabelSpacing),
              Expanded(child: sliderTrack),
              const SizedBox(width: _Styles.minMaxLabelSpacing),
              CText(
                data: maxText,
                enable: !isVisualDisabled,
                style: TextStyle(
                  fontSize: _Styles.rangeFontSize,
                  color: _Styles.rangeLabelColor(
                    tokens: tokens,
                    disabled: isVisualDisabled,
                  ),
                ),
              ),
              if (!widget.props.hideTextInput) ...[
                const SizedBox(width: _Styles.inputGap),
                companionInput,
              ],
            ],
          ),
          if (statusMessage != null && statusMessage.isNotEmpty) ...[
            const SizedBox(height: _Styles.messageMarginTop),
            CText(
              data: statusMessage,
              enable: !isVisualDisabled,
              style: TextStyle(
                fontSize: _Styles.messageFontSize,
                fontWeight: FontWeight.w400,
                color: isVisualDisabled ? tokens.textDisabled : statusColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
