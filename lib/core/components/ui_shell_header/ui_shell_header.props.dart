import 'package:flutter/widgets.dart';

/// A navigation link displayed in a [CUiShellHeader].
class CUiShellHeaderLink {
  const CUiShellHeaderLink({
    required this.label,
    this.onPressed,
    this.isCurrent = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isCurrent;
}

/// An accessible icon action displayed at the end of a [CUiShellHeader].
class CUiShellHeaderAction {
  const CUiShellHeaderAction({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
}

/// Configuration for a Carbon-style application header.
class CUiShellHeaderProps {
  const CUiShellHeaderProps({
    required this.title,
    this.prefix,
    this.links = const [],
    this.actions = const [],
    this.onMenuPressed,
    this.onTitlePressed,
    this.showMenuButton = true,
    this.height,
  });

  final String title;
  final String? prefix;
  final List<CUiShellHeaderLink> links;
  final List<CUiShellHeaderAction> actions;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onTitlePressed;
  final bool showMenuButton;
  final double? height;
}
