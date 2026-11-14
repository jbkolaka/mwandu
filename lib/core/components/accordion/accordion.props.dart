import 'package:flutter/widgets.dart';

/// Content and initial state for one accordion item.
class CAccordionItem {
  const CAccordionItem({
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.disabled = false,
  });

  final String title;
  final Widget content;
  final bool initiallyExpanded;
  final bool disabled;
}

/// Configuration for [CAccordion].
class CAccordionProps {
  const CAccordionProps({
    required this.items,
    this.allowMultiple = false,
    this.disabled = false,
    this.ordered = false,
    this.flush = false,
    this.size = CAccordionSize.md,
    this.onExpansionChanged,
  });

  final List<CAccordionItem> items;
  final bool allowMultiple;
  final bool disabled;
  final bool ordered;
  final bool flush;
  final CAccordionSize size;
  final ValueChanged<CAccordionExpansion>? onExpansionChanged;
}

/// Header and body sizing for [CAccordion].
enum CAccordionSize { sm, md, lg }

/// Expansion event emitted by [CAccordion].
class CAccordionExpansion {
  const CAccordionExpansion({required this.index, required this.isExpanded});

  final int index;
  final bool isExpanded;
}
