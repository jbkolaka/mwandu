/// Height variants for Carbon ProgressBar.
enum CProgressBarSize {
  /// Small progress bar (track height 4px).
  small,

  /// Big progress bar (track height 8px, default).
  big,
}

/// Status states for Carbon ProgressBar.
enum CProgressBarStatus {
  /// Progress is actively ongoing.
  active,

  /// Progress completed successfully.
  finished,

  /// Progress encountered an error and halted.
  error,
}

/// Visual layout type for Carbon ProgressBar.
enum CProgressBarType {
  /// Standard full-width stacked layout.
  defaultType,

  /// Inline progress bar with label beside track.
  inline,

  /// Indented progress bar.
  indented,
}

/// Configuration properties for [CProgressBar].
class CProgressBarProps {
  const CProgressBarProps({
    this.label,
    this.helperText,
    this.hideLabel = false,
    this.value,
    this.max = 100.0,
    this.size = CProgressBarSize.big,
    this.status = CProgressBarStatus.active,
    this.type = CProgressBarType.defaultType,
  }) : assert(max > 0, 'max must be greater than 0');

  /// Primary label text positioned above the progress track.
  final String? label;

  /// Supplementary descriptive or status text displayed beneath the progress track.
  final String? helperText;

  /// If true, visually hides the label while preserving accessibility announcements.
  final bool hideLabel;

  /// The current progress value between 0 and [max].
  ///
  /// When null, the progress bar operates in indeterminate mode.
  final double? value;

  /// The maximum value of the progress bar (default 100.0).
  final double max;

  /// The vertical size / track thickness of the progress bar.
  final CProgressBarSize size;

  /// Current state of the progress operation.
  final CProgressBarStatus status;

  /// Structural layout variation of the progress bar.
  final CProgressBarType type;

  /// Whether the progress bar is in indeterminate mode.
  bool get isIndeterminate => value == null;

  /// Normalized progress ratio clamped between 0.0 and 1.0.
  double get normalizedRatio {
    if (value == null) return 0.0;
    return (value! / max).clamp(0.0, 1.0);
  }
}
