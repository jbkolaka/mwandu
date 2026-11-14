import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Layout values for [CUiShellHeader], based on Carbon spacing variables.
abstract final class CUiShellHeaderStyles {
  static const double height = Spacing.v48px3remSpacing09;
  static const double iconSize = Spacing.v24px15remSpacing06;
  static const double horizontalPadding = Spacing.v16px1remSpacing05;
  static const double linkHorizontalPadding = Spacing.v16px1remSpacing05;
  static const double actionWidth = Spacing.v48px3remSpacing09;

  static const EdgeInsets linkPadding = EdgeInsets.symmetric(
    horizontal: linkHorizontalPadding,
  );
}
