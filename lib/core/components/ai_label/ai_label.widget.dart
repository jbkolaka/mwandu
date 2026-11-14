import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

import 'ai_label.props.dart';
import 'ai_label.styles.dart';

/// Carbon-inspired AI Label with an optional expandable information panel.
class CAILabel extends StatefulWidget {
  const CAILabel({super.key, this.props = const CAILabelProps()});

  final CAILabelProps props;

  @override
  State<CAILabel> createState() => _CAILabelState();
}

class _CAILabelState extends State<CAILabel> {
  late bool _isOpen = widget.props.initiallyOpen;

  @override
  void didUpdateWidget(covariant CAILabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props.initiallyOpen != widget.props.initiallyOpen) {
      _isOpen = widget.props.initiallyOpen;
    }
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    widget.props.onOpenChanged?.call(_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final compact = widget.props.size == CAILabelSize.xs ||
        widget.props.size == CAILabelSize.sm;
    final textSize = switch (widget.props.size) {
      CAILabelSize.xs => 11.0,
      CAILabelSize.sm => 12.0,
      CAILabelSize.md => 14.0,
      CAILabelSize.lg => 16.0,
      CAILabelSize.xl => 18.0,
    };
    final dark = tokens.isDark;
    final gradient = dark
        ? const [
            AI.aISlugDarkThemeEnabledAISlugGradientStop1,
            AI.aISlugDarkThemeEnabledAISlugGradientStop2,
          ]
        : const [
            AI.aISlugLightThemeEnabledAISlugGradientStop1,
            AI.aISlugLightThemeEnabledAISlugGradientStop2,
          ];
    final pillColor = dark
        ? AI.aISlugDarkThemeEnabledAISlugGradientBackground
        : AI.aISlugLightThemeEnabledAISlugGradientBackground;

    return Semantics(
      container: true,
      label: widget.props.accessibilityLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggle,
              borderRadius: BorderRadius.circular(CAILabelStyles.panelRadius),
              child: Container(
                padding: compact
                    ? CAILabelStyles.compactPadding
                    : CAILabelStyles.standardPadding,
                decoration: BoxDecoration(
                  color: widget.props.kind == CAILabelKind.inline
                      ? tokens.layer01
                      : pillColor,
                  gradient: widget.props.kind == CAILabelKind.standard
                      ? LinearGradient(colors: gradient)
                      : null,
                  border: widget.props.kind == CAILabelKind.inline
                      ? Border.all(color: tokens.borderSubtle01)
                      : null,
                  borderRadius: BorderRadius.circular(CAILabelStyles.panelRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CIcons.aiResults,
                      size: CAILabelStyles.iconSize,
                      color: widget.props.kind == CAILabelKind.inline
                          ? tokens.iconPrimary
                          : (dark ? tokens.textPrimary : tokens.textInverse),
                    ),
                    const SizedBox(width: Spacing.v4px025remSpacing02),
                    Text(
                      widget.props.label,
                      style: TextStyle(
                        color: widget.props.kind == CAILabelKind.inline
                            ? tokens.textPrimary
                            : (dark ? tokens.textPrimary : tokens.textInverse),
                        fontSize: textSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.props.content != null || widget.props.actions != null)
            AnimatedSize(
              duration: CAILabelStyles.animationDuration,
              curve: Curves.easeInOut,
              alignment: Alignment.topLeft,
              child: _isOpen
                  ? Container(
                      constraints: const BoxConstraints(
                        maxWidth: CAILabelStyles.panelMaxWidth,
                      ),
                      margin: const EdgeInsets.only(
                        top: Spacing.v8px05remSpacing03,
                      ),
                      padding: CAILabelStyles.panelPadding,
                      decoration: BoxDecoration(
                        color: tokens.layer01,
                        border: Border.all(color: tokens.borderSubtle01),
                        borderRadius: BorderRadius.circular(
                          CAILabelStyles.panelRadius,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.props.content != null)
                            DefaultTextStyle(
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: tokens.textPrimary),
                              child: widget.props.content!,
                            ),
                          if (widget.props.actions != null) ...[
                            if (widget.props.content != null)
                              const SizedBox(
                                height: Spacing.v12px075remSpacing04,
                              ),
                            widget.props.actions!,
                          ],
                          if (widget.props.isReverted &&
                              widget.props.onRevert != null) ...[
                            const SizedBox(
                              height: Spacing.v12px075remSpacing04,
                            ),
                            TextButton(
                              onPressed: widget.props.onRevert,
                              child: Text(widget.props.revertLabel),
                            ),
                          ],
                        ],
                      ),
                    )
                  : const SizedBox(width: CAILabelStyles.panelMaxWidth),
            ),
        ],
      ),
    );
  }
}
