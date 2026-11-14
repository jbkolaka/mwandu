import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Carbon spacing and animation values used by [CAccordion].
abstract final class CAccordionStyles {
  static const EdgeInsets itemPadding = EdgeInsets.symmetric(
    horizontal: Spacing.v16px1remSpacing05,
  );
  static const EdgeInsets bodyPadding = EdgeInsets.fromLTRB(
    Spacing.v16px1remSpacing05,
    0,
    Spacing.v16px1remSpacing05,
    Spacing.v16px1remSpacing05,
  );

  static const double iconSize = Spacing.v16px1remSpacing05;
  static const double smallHeaderHeight = Spacing.v40px25remSpacing08;
  static const double mediumHeaderHeight = Spacing.v48px3remSpacing09;
  static const double largeHeaderHeight = Spacing.v64px4remSpacing10;
  static const Duration animationDuration = Duration(milliseconds: 180);
}
