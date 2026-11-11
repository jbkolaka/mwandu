import 'package:flutter/widgets.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'modal.props.dart';

/// Layout dimensions and theme token bindings for [CModal].
abstract final class CModalStyles {
  static const double smallWidth = ModalSmall.largeModalMaxWidth;
  static const double mediumWidth = ModalMedium.mediumModalMaxWidth;
  static const double largeWidth = Modal.largeModalMaxWidth;
  static const double headerTopPadding = Spacing.v24px15remSpacing06;
  static const double headerHorizontalPadding = Spacing.v24px15remSpacing06;
  static const double bodyHorizontalPadding = Spacing.v24px15remSpacing06;
  static const double bodyBottomPadding = Spacing.v32px2remSpacing07;
  static const double footerPadding = Spacing.v16px1remSpacing05;
  static const double titleFontSize = 20;
  static const double descriptionFontSize = 14;
  static const double borderWidth = 1;
  static const double actionHeight = Spacing.v48px3remSpacing09;

  static double width(CModalSize size) => switch (size) {
    CModalSize.small => smallWidth,
    CModalSize.medium => mediumWidth,
    CModalSize.large => largeWidth,
  };

  static Color background(AppThemeTokens tokens) => tokens.layer01;
  static Color border(AppThemeTokens tokens) => tokens.borderSubtle01;
  static Color titleColor(AppThemeTokens tokens) => tokens.textPrimary;
  static Color descriptionColor(AppThemeTokens tokens) => tokens.textSecondary;

  static Color actionBackground(AppThemeTokens tokens, CModalActionKind kind) =>
      switch (kind) {
        CModalActionKind.primary => tokens.buttonPrimary,
        CModalActionKind.secondary => tokens.buttonSecondary,
        CModalActionKind.danger => tokens.buttonDangerPrimary,
      };

  static Color actionForeground(AppThemeTokens tokens, CModalActionKind kind) =>
      switch (kind) {
        CModalActionKind.primary => tokens.textOnColor,
        CModalActionKind.secondary => tokens.textPrimary,
        CModalActionKind.danger => tokens.textOnColor,
      };

  static Color disabledActionBackground(AppThemeTokens tokens) =>
      tokens.buttonDisabled;
}
