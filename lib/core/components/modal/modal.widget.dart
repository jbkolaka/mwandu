import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'modal.props.dart';
import 'modal.styles.dart';

/// Opens a themed modal using Flutter's accessible dialog route.
Future<T?> showCModal<T>(BuildContext context, CModalProps props) {
  final tokens = context.tokens;
  return showDialog<T>(
    context: context,
    barrierDismissible: props.barrierDismissible,
    barrierColor: tokens.overlay,
    builder: (_) => CModal(props: props),
  );
}

/// Reusable Carbon-inspired modal surface.
///
/// Use [showCModal] to present it and receive route-managed focus behavior.
class CModal extends StatelessWidget {
  const CModal({super.key, required this.props});

  final CModalProps props;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final viewport = MediaQuery.sizeOf(context);
    final availableWidth = math
        .max(0.0, viewport.width - Spacing.v32px2remSpacing07)
        .toDouble();
    final availableHeight = math
        .max(0.0, viewport.height - Spacing.v32px2remSpacing07)
        .toDouble();

    return Dialog(
      insetPadding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      backgroundColor: CModalStyles.background(tokens),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: math
              .min(CModalStyles.width(props.size), availableWidth)
              .toDouble(),
          maxHeight: availableHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, tokens),
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: CModalStyles.bodyHorizontalPadding,
                  right: CModalStyles.bodyHorizontalPadding,
                  bottom: CModalStyles.bodyBottomPadding,
                ),
                child: props.body,
              ),
            ),
            if (props.actions.isNotEmpty) _buildFooter(context, tokens),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppThemeTokens tokens) {
    return Padding(
      padding: const EdgeInsets.only(
        left: CModalStyles.headerHorizontalPadding,
        top: CModalStyles.headerTopPadding,
        right: Spacing.v16px1remSpacing05,
        bottom: Spacing.v16px1remSpacing05,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  props.title,
                  style: TextStyle(
                    color: CModalStyles.titleColor(tokens),
                    fontSize: CModalStyles.titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (props.description != null) ...[
                  const SizedBox(height: Spacing.v8px05remSpacing03),
                  Text(
                    props.description!,
                    style: TextStyle(
                      color: CModalStyles.descriptionColor(tokens),
                      fontSize: CModalStyles.descriptionFontSize,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (props.showCloseButton)
            IconButton(
              tooltip: 'Close dialog',
              onPressed: () {
                props.onClose?.call();
                Navigator.of(context).maybePop();
              },
              icon: const Icon(Icons.close),
              color: tokens.iconPrimary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AppThemeTokens tokens) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: CModalStyles.border(tokens))),
      ),
      padding: const EdgeInsets.all(CModalStyles.footerPadding),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: Spacing.v8px05remSpacing03,
        runSpacing: Spacing.v8px05remSpacing03,
        children: [
          for (final action in props.actions)
            _buildAction(context, tokens, action),
        ],
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    AppThemeTokens tokens,
    CModalAction action,
  ) {
    final background = action.enabled
        ? CModalStyles.actionBackground(tokens, action.kind)
        : CModalStyles.disabledActionBackground(tokens);
    final foreground = action.enabled
        ? CModalStyles.actionForeground(tokens, action.kind)
        : tokens.textDisabled;

    return Semantics(
      button: true,
      enabled: action.enabled,
      label: action.label,
      child: Material(
        color: background,
        child: InkWell(
          onTap: action.enabled
              ? () {
                  action.onPressed?.call();
                  if (action.dismissOnPressed && context.mounted) {
                    Navigator.of(context).maybePop();
                  }
                }
              : null,
          focusColor: tokens.focus,
          hoverColor: tokens.buttonPrimaryHover,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: Spacing.v80px5remSpacing11,
              minHeight: CModalStyles.actionHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.v16px1remSpacing05,
                vertical: Spacing.v12px075remSpacing04,
              ),
              child: Center(
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
