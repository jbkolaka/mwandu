import 'package:flutter/widgets.dart';

/// Configuration properties for Carbon Slider.
class CSliderProps {
  const CSliderProps({
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.step = 1.0,
    this.label,
    this.labelText,
    this.hideLabel = false,
    this.hideTextInput = false,
    this.minLabel,
    this.maxLabel,
    this.enable = true,
    this.readOnly = false,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.onChange,
    this.onChangeEnd,
    this.formatLabel,
  }) : assert(max > min, 'max must be greater than min');

  /// Current slider value.
  final double value;

  /// Minimum boundary value of the slider range.
  final double min;

  /// Maximum boundary value of the slider range.
  final double max;

  /// Stepping interval granularity.
  final double step;

  /// Primary label displayed above the slider.
  final String? label;

  /// Alias for [label] matching Carbon React spec.
  final String? labelText;

  /// Effective label text.
  String? get effectiveLabel => label ?? labelText;

  /// Whether the primary label is visually hidden.
  final bool hideLabel;

  /// Whether the companion numeric input field is hidden.
  final bool hideTextInput;

  /// Custom label text displayed for the minimum boundary.
  final String? minLabel;

  /// Custom label text displayed for the maximum boundary.
  final String? maxLabel;

  /// Whether the slider is interactive.
  final bool enable;

  /// Whether the slider is in a read-only state.
  final bool readOnly;

  /// Whether the slider is currently in an invalid error state.
  final bool invalid;

  /// Error message shown when [invalid] is true.
  final String? invalidText;

  /// Whether the slider is currently in a warning state.
  final bool warn;

  /// Warning message shown when [warn] is true.
  final String? warnText;

  /// Called continuously as the slider handle is dragged or value changes.
  final ValueChanged<double>? onChange;

  /// Called when dragging ends or numeric input loses focus.
  final ValueChanged<double>? onChangeEnd;

  /// Custom formatter for displaying values in companion text and tooltips.
  final String Function(double value)? formatLabel;

  /// Normalized ratio clamped between 0.0 and 1.0.
  double get ratio => ((value - min) / (max - min)).clamp(0.0, 1.0);
}
