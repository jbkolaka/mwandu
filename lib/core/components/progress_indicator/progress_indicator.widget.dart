import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/components/text/index.dart';

import 'progress_indicator.props.dart';
import 'progress_indicator.styles.dart';

typedef _Styles = CProgressIndicatorStyles;

/// Scope passing coordination state from [CProgressIndicator] to [CProgressStep].
class _CProgressIndicatorScope extends InheritedWidget {
  const _CProgressIndicatorScope({
    required this.currentIndex,
    required this.vertical,
    required this.spaceEqually,
    required this.enable,
    required this.onChange,
    required super.child,
  });

  final int currentIndex;
  final bool vertical;
  final bool spaceEqually;
  final bool enable;
  final ValueChanged<int>? onChange;

  static _CProgressIndicatorScope? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_CProgressIndicatorScope>();
  }

  @override
  bool updateShouldNotify(_CProgressIndicatorScope oldWidget) {
    return currentIndex != oldWidget.currentIndex ||
        vertical != oldWidget.vertical ||
        spaceEqually != oldWidget.spaceEqually ||
        enable != oldWidget.enable;
  }
}

/// Carbon Progress Indicator component.
///
/// Directs users through a linear, multi-step process by presenting completed,
/// current, and future steps with accessible state indicators.
class CProgressIndicator extends StatelessWidget {
  CProgressIndicator({
    super.key,
    int currentIndex = 0,
    bool vertical = false,
    bool spaceEqually = false,
    bool enable = true,
    ValueChanged<int>? onChange,
    List<Widget> steps = const [],
  }) : props = CProgressIndicatorProps(
         currentIndex: currentIndex,
         vertical: vertical,
         spaceEqually: spaceEqually,
         enable: enable,
         onChange: onChange,
         steps: steps,
       );

  final CProgressIndicatorProps props;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = context.inheritedEnable && props.enable;

    if (props.vertical) {
      return _CProgressIndicatorScope(
        currentIndex: props.currentIndex,
        vertical: true,
        spaceEqually: false,
        enable: isEnabled,
        onChange: props.onChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < props.steps.length; i++)
              _StepWrapper(
                index: i,
                isLast: i == props.steps.length - 1,
                child: props.steps[i],
              ),
          ],
        ),
      );
    }

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: props.spaceEqually ? MainAxisSize.max : MainAxisSize.min,
      children: [
        for (int i = 0; i < props.steps.length; i++)
          if (props.spaceEqually)
            Expanded(
              child: _StepWrapper(
                index: i,
                isLast: i == props.steps.length - 1,
                child: props.steps[i],
              ),
            )
          else
            _StepWrapper(
              index: i,
              isLast: i == props.steps.length - 1,
              child: props.steps[i],
            ),
      ],
    );

    return _CProgressIndicatorScope(
      currentIndex: props.currentIndex,
      vertical: false,
      spaceEqually: props.spaceEqually,
      enable: isEnabled,
      onChange: props.onChange,
      child: content,
    );
  }
}

class _StepWrapper extends StatelessWidget {
  const _StepWrapper({
    required this.index,
    required this.isLast,
    required this.child,
  });

  final int index;
  final bool isLast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _CStepContext(index: index, isLast: isLast, child: child);
  }
}

class _CStepContext extends InheritedWidget {
  const _CStepContext({
    required this.index,
    required this.isLast,
    required super.child,
  });

  final int index;
  final bool isLast;

  static _CStepContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CStepContext>();
  }

  @override
  bool updateShouldNotify(_CStepContext oldWidget) {
    return index != oldWidget.index || isLast != oldWidget.isLast;
  }
}

/// An individual step item inside a [CProgressIndicator].
class CProgressStep extends StatelessWidget {
  CProgressStep({
    super.key,
    required String label,
    String? description,
    String? secondaryLabel,
    CProgressStepState? state,
    bool? complete,
    bool? current,
    bool invalid = false,
    bool disabled = false,
    VoidCallback? onTap,
  }) : props = CProgressStepProps(
         label: label,
         description: description,
         secondaryLabel: secondaryLabel,
         state: state,
         complete: complete,
         current: current,
         invalid: invalid,
         disabled: disabled,
         onTap: onTap,
       );

  final CProgressStepProps props;

  Widget _buildStepIcon({
    required BuildContext context,
    required AppThemeTokens tokens,
    required CProgressStepState state,
    required bool isDisabled,
  }) {
    final Color iconColor = _Styles.iconColor(
      tokens: tokens,
      state: state,
      disabled: isDisabled,
    );

    switch (state) {
      case CProgressStepState.complete:
        return Icon(
          CIcons.checkmarkOutline,
          size: _Styles.iconSize,
          color: iconColor,
        );
      case CProgressStepState.current:
        return Container(
          width: _Styles.iconSize,
          height: _Styles.iconSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: iconColor, width: 2.0),
          ),
          child: Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor),
          ),
        );
      case CProgressStepState.invalid:
        return Icon(
          CIcons.warningFilled,
          size: _Styles.iconSize,
          color: iconColor,
        );
      case CProgressStepState.incomplete:
        return Container(
          width: _Styles.iconSize,
          height: _Styles.iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: iconColor, width: 1.0),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final scope = _CProgressIndicatorScope.of(context);
    final stepContext = _CStepContext.of(context);

    final int stepIndex = stepContext?.index ?? 0;
    final bool isLast = stepContext?.isLast ?? true;
    final int currentIndex = scope?.currentIndex ?? 0;
    final bool isVertical = scope?.vertical ?? false;
    final bool isScopeEnabled = scope?.enable ?? true;
    final bool isDisabled = !isScopeEnabled || props.disabled;

    final CProgressStepState effectiveState =
        props.state ??
        (props.invalid
            ? CProgressStepState.invalid
            : (props.complete ?? (stepIndex < currentIndex))
            ? CProgressStepState.complete
            : (props.current ?? (stepIndex == currentIndex))
            ? CProgressStepState.current
            : CProgressStepState.incomplete);

    final bool isLineActive = stepIndex < currentIndex;
    final Color lineColor = _Styles.lineColor(
      tokens: tokens,
      isActive: isLineActive,
      disabled: isDisabled,
    );

    final Widget iconWidget = _buildStepIcon(
      context: context,
      tokens: tokens,
      state: effectiveState,
      isDisabled: isDisabled,
    );

    final Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CText(
          data: props.label,
          enable: !isDisabled,
          style: TextStyle(
            fontSize: _Styles.labelFontSize,
            fontWeight: _Styles.labelFontWeight(effectiveState),
            color: _Styles.labelColor(
              tokens: tokens,
              state: effectiveState,
              disabled: isDisabled,
            ),
          ),
        ),
        if (props.secondaryLabel != null &&
            props.secondaryLabel!.isNotEmpty) ...[
          const SizedBox(height: _Styles.labelSecondaryGap),
          CText(
            data: props.secondaryLabel!,
            enable: !isDisabled,
            style: TextStyle(
              fontSize: _Styles.secondaryLabelFontSize,
              fontWeight: FontWeight.w400,
              color: _Styles.secondaryLabelColor(
                tokens: tokens,
                state: effectiveState,
                disabled: isDisabled,
              ),
            ),
          ),
        ],
      ],
    );

    void handleTap() {
      if (isDisabled) return;
      props.onTap?.call();
      scope?.onChange?.call(stepIndex);
    }

    final bool isInteractive =
        (!isDisabled && (props.onTap != null || scope?.onChange != null));

    if (isVertical) {
      return InkWell(
        onTap: isInteractive ? handleTap : null,
        mouseCursor: isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  iconWidget,
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: _Styles.lineThickness,
                        color: lineColor,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: _Styles.iconTextGap),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0.0 : _Styles.verticalStepGap,
                  ),
                  child: textContent,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Horizontal layout
    return InkWell(
      onTap: isInteractive ? handleTap : null,
      mouseCursor: isInteractive
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minWidth: _Styles.minStepWidth),
        padding: const EdgeInsets.only(right: Spacing.v16px1remSpacing05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top connecting line
            Container(
              height: _Styles.lineThickness,
              width: double.infinity,
              color: isLast ? Colors.transparent : lineColor,
              margin: const EdgeInsets.only(bottom: Spacing.v8px05remSpacing03),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconWidget,
                const SizedBox(width: _Styles.iconTextGap),
                Flexible(child: textContent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
