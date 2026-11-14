import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Spacing and geometry values for [CAILabel].
abstract final class CAILabelStyles {
  static const double iconSize = Spacing.v16px1remSpacing05;
  static const double panelMaxWidth = 320;
  static const double panelRadius = 0;
  static const Duration animationDuration = Duration(milliseconds: 160);

  static const EdgeInsets compactPadding = EdgeInsets.symmetric(
    horizontal: Spacing.v8px05remSpacing03,
    vertical: Spacing.v4px025remSpacing02,
  );
  static const EdgeInsets standardPadding = EdgeInsets.symmetric(
    horizontal: Spacing.v12px075remSpacing04,
    vertical: Spacing.v8px05remSpacing03,
  );
  static const EdgeInsets panelPadding = EdgeInsets.all(
    Spacing.v16px1remSpacing05,
  );
}
