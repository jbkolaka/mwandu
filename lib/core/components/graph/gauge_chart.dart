import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Status thresholds that determine the gauge arc color, matching
/// Carbon Charts gauge semantics.
enum GaugeStatus {
  /// Below warning threshold — uses [AppThemeTokens.supportSuccess].
  normal,

  /// Between warning and danger thresholds — uses [AppThemeTokens.supportWarning].
  warning,

  /// Above danger threshold — uses [AppThemeTokens.supportError].
  danger,
}

/// A semicircular, needle-free gauge chart styled with Carbon design tokens.
///
/// Matches the Carbon Charts gauge implementation: a 180° arc track with a
/// filled portion proportional to [value] / [max]. No needle — the value is
/// conveyed by the colored arc segment and a centered numeric readout.
///
/// All colors, spacing, and typography are resolved from [AppThemeTokens].
class GaugeChart extends StatelessWidget {
  const GaugeChart({
    super.key,
    required this.value,
    this.max = 100,
    this.title,
    this.unit,
    this.warningThreshold = 60,
    this.dangerThreshold = 85,
    this.status,
    this.height = 200,
    this.arcThickness = Spacing.v16px1remSpacing05,
  });

  /// Current value to display (clamped to [0, max]).
  final double value;

  /// Maximum value of the gauge scale. Defaults to 100.
  final double max;

  /// Optional title rendered above the gauge.
  final String? title;

  /// Optional unit suffix appended to the numeric readout (e.g. '%', 'GB').
  final String? unit;

  /// Value at or above which the arc turns warning color.
  final double warningThreshold;

  /// Value at or above which the arc turns danger color.
  final double dangerThreshold;

  /// Override the status color mapping. If not set, it is derived from
  /// [value] vs [warningThreshold] / [dangerThreshold].
  final GaugeStatus? status;

  /// Canvas height for the gauge area.
  final double height;

  /// Thickness of the arc track and fill.
  final double arcThickness;

  /// Resolves the status from the current value and thresholds.
  GaugeStatus get _resolvedStatus =>
      status ??
      (value >= dangerThreshold
          ? GaugeStatus.danger
          : value >= warningThreshold
          ? GaugeStatus.warning
          : GaugeStatus.normal);

  /// Returns the support color token for the resolved status.
  Color _statusColor(AppThemeTokens tokens) {
    switch (_resolvedStatus) {
      case GaugeStatus.normal:
        return tokens.supportSuccess;
      case GaugeStatus.warning:
        return tokens.supportWarning;
      case GaugeStatus.danger:
        return tokens.supportError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final clampedValue = value.clamp(0.0, max);
    final fraction = max > 0 ? clampedValue / max : 0.0;
    final statusColor = _statusColor(tokens);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle00),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.v8px05remSpacing03),
          ],
          SizedBox(
            height: height,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  painter: _GaugePainter(
                    fraction: fraction,
                    statusColor: statusColor,
                    trackColor: tokens.borderSubtle01,
                    textColor: tokens.textPrimary,
                    secondaryTextColor: tokens.textSecondary,
                    arcThickness: arcThickness,
                    value: clampedValue,
                    max: max,
                    unit: unit,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.fraction,
    required this.statusColor,
    required this.trackColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.arcThickness,
    required this.value,
    required this.max,
    required this.unit,
  });

  /// Fraction of the arc to fill (0.0 – 1.0).
  final double fraction;

  /// Color of the filled arc segment.
  final Color statusColor;

  /// Color of the background track arc.
  final Color trackColor;

  /// Color for the large numeric readout.
  final Color textColor;

  /// Color for the "0" and "max" scale labels.
  final Color secondaryTextColor;

  /// Stroke width of both arcs.
  final double arcThickness;

  /// The numeric value to render in the center.
  final double value;

  /// Maximum value of the scale.
  final double max;

  /// Optional unit suffix.
  final String? unit;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Center the semicircle. The arc spans the full width with some margin
    // for the scale labels.
    final labelMargin = Spacing.v16px1remSpacing05;
    final arcDiameter = (w - labelMargin * 2).clamp(0.0, h * 2);
    final radius = arcDiameter / 2;
    final center = Offset(w / 2, h - arcThickness / 2);

    // Semicircular arc: 180° (π) starting from the left (π) going clockwise
    // to the right (0). In Flutter's canvas, 0 is at the 3-o'clock position
    // and angles increase clockwise. We draw from π to 2π (i.e. the top
    // half is not used; the bottom semicircle from left to right).
    const startAngle = math.pi; // 180° — leftmost point
    const sweepAngle = math.pi; // 180° sweep → rightmost point

    // --- Track (full semicircle, faint) ---
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcThickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // --- Fill (value portion) ---
    final fillSweep = sweepAngle * fraction;
    final fillPaint = Paint()
      ..color = statusColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcThickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fillSweep,
      false,
      fillPaint,
    );

    // --- Scale labels: "0" left, "max" right ---
    _drawScaleLabel(
      canvas,
      '0',
      Offset(center.dx - radius, center.dx + 0),
      center,
      radius,
      true,
    );
    _drawScaleLabel(
      canvas,
      _formatMax(),
      Offset(center.dx + radius, center.dx),
      center,
      radius,
      false,
    );

    // --- Numeric readout centered ---
    _drawValueReadout(canvas, size, center, radius);
  }

  void _drawScaleLabel(
    Canvas canvas,
    String text,
    Offset point,
    Offset center,
    double radius,
    bool isLeft,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    double lx;
    if (isLeft) {
      lx = center.dx - radius - tp.width - Spacing.v4px025remSpacing02;
    } else {
      lx = center.dx + radius + Spacing.v4px025remSpacing02;
    }
    final ly = center.dy - tp.height / 2;
    tp.paint(canvas, Offset(lx, ly));
  }

  void _drawValueReadout(
    Canvas canvas,
    Size size,
    Offset center,
    double radius,
  ) {
    final valueStr = _formatValue();
    final unitStr = unit ?? '';

    // Large value number.
    final valueTp = TextPainter(
      text: TextSpan(
        text: '$valueStr$unitStr',
        style: TextStyle(
          color: textColor,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    valueTp.layout();
    final vx = center.dx - valueTp.width / 2;
    // Position the readout inside the semicircle, slightly above the
    // bottom edge.
    final vy = center.dy - radius * 0.55 - valueTp.height / 2;
    valueTp.paint(canvas, Offset(vx, vy));
  }

  String _formatValue() {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }

  String _formatMax() {
    if (max == max.roundToDouble()) {
      return max.round().toString();
    }
    return max.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      fraction != oldDelegate.fraction ||
      statusColor != oldDelegate.statusColor ||
      value != oldDelegate.value ||
      unit != oldDelegate.unit;
}
