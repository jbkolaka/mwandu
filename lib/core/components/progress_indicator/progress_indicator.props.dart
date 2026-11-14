import 'package:flutter/widgets.dart';

/// Progress state of an individual step in a progress indicator.
enum CProgressStepState {
  /// The step has already been completed.
  complete,

  /// The step is currently in progress / active.
  current,

  /// The step has not been reached yet.
  incomplete,

  /// The step has failed validation or encountered an error.
  invalid,
}

/// Configuration data for a single step within a [CProgressIndicator].
class CProgressStepProps {
  const CProgressStepProps({
    required this.label,
    this.description,
    this.secondaryLabel,
    this.state,
    this.complete,
    this.current,
    this.invalid = false,
    this.disabled = false,
    this.onTap,
  });

  /// Primary label of the step.
  final String label;

  /// Optional accessible description or tooltip text.
  final String? description;

  /// Optional secondary supporting label (e.g. error message or status summary).
  final String? secondaryLabel;

  /// Explicit state of the step. If omitted, deduced from the indicator's currentIndex.
  final CProgressStepState? state;

  /// Explicitly marks the step as complete.
  final bool? complete;

  /// Explicitly marks the step as the current active step.
  final bool? current;

  /// Whether the step is in an error/invalid state.
  final bool invalid;

  /// Whether the step is disabled.
  final bool disabled;

  /// Callback when this step is tapped in an interactive progress indicator.
  final VoidCallback? onTap;
}

/// Configuration properties for [CProgressIndicator].
class CProgressIndicatorProps {
  const CProgressIndicatorProps({
    this.currentIndex = 0,
    this.vertical = false,
    this.spaceEqually = false,
    this.enable = true,
    this.onChange,
    this.steps = const [],
  });

  /// Index of the currently active step (0-indexed).
  final int currentIndex;

  /// Whether to arrange steps vertically stacked rather than horizontally.
  final bool vertical;

  /// Whether horizontal steps should expand to divide available width equally.
  final bool spaceEqually;

  /// Whether the entire progress indicator is interactive.
  final bool enable;

  /// Called when a step is selected in an interactive progress indicator.
  final ValueChanged<int>? onChange;

  /// The collection of step widgets or configurations.
  final List<Widget> steps;
}
