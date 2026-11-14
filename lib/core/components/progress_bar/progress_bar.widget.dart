import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/text/index.dart';

import 'progress_bar.props.dart';
import 'progress_bar.styles.dart';

typedef _Styles = CProgressBarStyles;

/// Carbon Progress Bar component.
///
/// Communicates the status and progress of ongoing processes either as
/// a determinate percentage-based bar or as a continuous indeterminate loader.
class CProgressBar extends StatefulWidget {
  const CProgressBar({
    super.key,
    this.label,
    this.helperText,
    this.hideLabel = false,
    this.value,
    this.max = 100.0,
    this.size = CProgressBarSize.big,
    this.status = CProgressBarStatus.active,
    this.type = CProgressBarType.defaultType,
  });

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

  /// The vertical track thickness of the progress bar.
  final CProgressBarSize size;

  /// Current state of the progress operation.
  final CProgressBarStatus status;

  /// Structural layout variation of the progress bar.
  final CProgressBarType type;

  @override
  State<CProgressBar> createState() => _CProgressBarState();
}

class _CProgressBarState extends State<CProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _indeterminateController;

  bool get _isIndeterminate => widget.value == null;

  @override
  void initState() {
    super.initState();
    if (_isIndeterminate) {
      _startIndeterminateAnimation();
    }
  }

  @override
  void didUpdateWidget(CProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isIndeterminate && _indeterminateController == null) {
      _startIndeterminateAnimation();
    } else if (!_isIndeterminate && _indeterminateController != null) {
      _stopIndeterminateAnimation();
    }
  }

  void _startIndeterminateAnimation() {
    _indeterminateController = AnimationController(
      vsync: this,
      duration: _Styles.indeterminateCycleDuration,
    )..repeat();
  }

  void _stopIndeterminateAnimation() {
    _indeterminateController?.dispose();
    _indeterminateController = null;
  }

  @override
  void dispose() {
    _indeterminateController?.dispose();
    super.dispose();
  }

  Widget _buildTrack(BuildContext context) {
    final tokens = context.tokens;
    final double trackHeight = _Styles.trackHeight(widget.size);
    final Color trackColor = _Styles.trackColor(tokens);
    final Color barColor = _Styles.barColor(tokens, widget.status);

    final double effectiveRatio = widget.status == CProgressBarStatus.finished
        ? 1.0
        : (widget.value == null
              ? 0.0
              : (widget.value! / widget.max).clamp(0.0, 1.0));

    Widget barContent;

    if (_isIndeterminate && widget.status != CProgressBarStatus.finished) {
      barContent = AnimatedBuilder(
        animation: _indeterminateController!,
        builder: (context, child) {
          final double t = _indeterminateController!.value;
          // Calculate start and end offsets to create Carbon-style sliding bar
          final double startOffset = (t * 1.5 - 0.5).clamp(0.0, 1.0);
          final double endOffset = (t * 1.5).clamp(0.0, 1.0);
          final double widthFraction = (endOffset - startOffset).clamp(
            0.15,
            0.5,
          );

          return Align(
            alignment: Alignment(-1.0 + 2.0 * t, 0.0),
            child: FractionallySizedBox(
              widthFactor: widthFraction,
              heightFactor: 1.0,
              child: Container(color: barColor),
            ),
          );
        },
      );
    } else {
      barContent = TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: effectiveRatio),
        duration: _Styles.fillAnimationDuration,
        curve: _Styles.fillAnimationCurve,
        builder: (context, value, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              heightFactor: 1.0,
              child: Container(color: barColor),
            ),
          );
        },
      );
    }

    return Container(
      height: trackHeight,
      width: double.infinity,
      color: trackColor,
      child: barContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final Color labelColor = _Styles.labelColor(tokens);
    final Color helperColor = _Styles.helperColor(tokens, widget.status);

    Widget? labelWidget;
    if (!widget.hideLabel && widget.label != null && widget.label!.isNotEmpty) {
      labelWidget = CText(
        data: widget.label!,
        style: TextStyle(
          fontSize: _Styles.labelFontSize,
          fontWeight: FontWeight.w400,
          color: labelColor,
        ),
      );
    }

    Widget? helperWidget;
    if (widget.helperText != null && widget.helperText!.isNotEmpty) {
      helperWidget = CText(
        data: widget.helperText!,
        style: TextStyle(
          fontSize: _Styles.helperFontSize,
          fontWeight: FontWeight.w400,
          color: helperColor,
        ),
      );
    }

    Widget trackWidget = _buildTrack(context);

    if (widget.type == CProgressBarType.inline) {
      return Semantics(
        label: widget.label,
        value: widget.value != null
            ? '${((widget.value! / widget.max) * 100).round()}%'
            : 'In progress',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (labelWidget != null) ...[
              labelWidget,
              const SizedBox(width: _Styles.inlineGap),
            ],
            Expanded(child: trackWidget),
            if (helperWidget != null) ...[
              const SizedBox(width: _Styles.inlineGap),
              helperWidget,
            ],
          ],
        ),
      );
    }

    return Semantics(
      label: widget.label,
      value: widget.value != null
          ? '${((widget.value! / widget.max) * 100).round()}%'
          : 'In progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelWidget != null) ...[
            labelWidget,
            const SizedBox(height: _Styles.labelMarginBottom),
          ],
          trackWidget,
          if (helperWidget != null) ...[
            const SizedBox(height: _Styles.helperMarginTop),
            helperWidget,
          ],
        ],
      ),
    );
  }
}
