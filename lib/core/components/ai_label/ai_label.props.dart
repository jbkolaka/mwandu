import 'package:flutter/widgets.dart';

/// Visual style of a [CAILabel].
enum CAILabelKind { standard, inline }

/// Sizing options for a [CAILabel].
enum CAILabelSize { xs, sm, md, lg, xl }

/// Configuration for a Carbon AI Label and its expandable details panel.
class CAILabelProps {
  const CAILabelProps({
    this.label = 'AI',
    this.accessibilityLabel = 'Show AI information',
    this.kind = CAILabelKind.standard,
    this.size = CAILabelSize.md,
    this.content,
    this.actions,
    this.initiallyOpen = false,
    this.isReverted = false,
    this.revertLabel = 'Revert to AI input',
    this.onRevert,
    this.onOpenChanged,
  });

  final String label;
  final String accessibilityLabel;
  final CAILabelKind kind;
  final CAILabelSize size;
  final Widget? content;
  final Widget? actions;
  final bool initiallyOpen;
  final bool isReverted;
  final String revertLabel;
  final VoidCallback? onRevert;
  final ValueChanged<bool>? onOpenChanged;
}
