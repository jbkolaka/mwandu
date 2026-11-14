import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

import 'accordion.props.dart';
import 'accordion.styles.dart';

/// Carbon-inspired accordion. Supports single or multiple open items.
class CAccordion extends StatefulWidget {
  const CAccordion({super.key, required this.props});

  final CAccordionProps props;

  @override
  State<CAccordion> createState() => _CAccordionState();
}

class _CAccordionState extends State<CAccordion> {
  late Set<int> _expandedItems = {
    for (var i = 0; i < widget.props.items.length; i++)
      if (widget.props.items[i].initiallyExpanded) i,
  };

  @override
  void didUpdateWidget(covariant CAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props.items.length != widget.props.items.length) {
      _expandedItems = _expandedItems
          .where((index) => index < widget.props.items.length)
          .toSet();
    }
  }

  void _toggleItem(int index) {
    final item = widget.props.items[index];
    if (widget.props.disabled || item.disabled) return;

    final shouldExpand = !_expandedItems.contains(index);
    setState(() {
      if (shouldExpand) {
        if (!widget.props.allowMultiple) _expandedItems.clear();
        _expandedItems.add(index);
      } else {
        _expandedItems.remove(index);
      }
    });
    widget.props.onExpansionChanged?.call(
      CAccordionExpansion(index: index, isExpanded: shouldExpand),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < widget.props.items.length; index++)
          _buildItem(context, tokens, index),
      ],
    );
  }

  Widget _buildItem(BuildContext context, AppThemeTokens tokens, int index) {
    final item = widget.props.items[index];
    final expanded = _expandedItems.contains(index);
    final disabled = widget.props.disabled || item.disabled;
    final headerHeight = switch (widget.props.size) {
      CAccordionSize.sm => CAccordionStyles.smallHeaderHeight,
      CAccordionSize.md => CAccordionStyles.mediumHeaderHeight,
      CAccordionSize.lg => CAccordionStyles.largeHeaderHeight,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(
          top: BorderSide(color: tokens.borderSubtle01),
          bottom: index == widget.props.items.length - 1
              ? BorderSide(color: tokens.borderSubtle01)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            enabled: !disabled,
            child: InkWell(
              onTap: disabled ? null : () => _toggleItem(index),
              child: SizedBox(
                height: headerHeight,
                child: Padding(
                  padding: CAccordionStyles.itemPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.props.ordered ? '${index + 1}. ${item.title}' : item.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: disabled
                                ? tokens.textDisabled
                                : tokens.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.v8px05remSpacing03),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: CAccordionStyles.animationDuration,
                        child: Icon(
                          CIcons.chevronDown,
                          size: CAccordionStyles.iconSize,
                          color: disabled
                              ? tokens.iconSecondary
                              : tokens.iconPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: CAccordionStyles.animationDuration,
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Padding(
                      padding: CAccordionStyles.bodyPadding,
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: tokens.textPrimary,
                        ),
                        child: item.content,
                      ),
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ),
        ],
      ),
    );
  }
}
