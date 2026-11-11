import 'package:flutter/widgets.dart';

/// A selectable view in a [CContentSwitcher].
class CContentSwitcherOption {
  const CContentSwitcherOption({
    required this.label,
    this.content,
    this.icon,
    this.enabled = true,
  });

  /// Text shown in the switcher control.
  final String label;

  /// Optional icon shown before [label].
  final Widget? icon;

  /// Optional content displayed below the switcher when selected.
  final Widget? content;

  /// Whether this option can be selected.
  final bool enabled;
}

/// Density variants for a content switcher.
enum CContentSwitcherSize { sm, md, lg }

/// Configuration for [CContentSwitcher].
class CContentSwitcherProps {
  const CContentSwitcherProps({
    required this.options,
    this.initialIndex = 0,
    this.size = CContentSwitcherSize.md,
    this.lowContrast = true,
    this.expand = true,
    this.onSelectionChanged,
  });

  /// Available views. The list may be empty while options are being loaded.
  final List<CContentSwitcherOption> options;

  /// Index selected on first build.
  final int initialIndex;

  /// Control height variant.
  final CContentSwitcherSize size;

  /// Uses the theme's low contrast switcher surface when true.
  final bool lowContrast;

  /// Gives each option equal width when true.
  final bool expand;

  /// Called after the selected option changes.
  final ValueChanged<int>? onSelectionChanged;
}
