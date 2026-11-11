import 'package:flutter/widgets.dart';

/// Modal width variants.
enum CModalSize { small, medium, large }

/// Visual style of a modal action button.
enum CModalActionKind { primary, secondary, danger }

/// An action displayed in the modal footer.
class CModalAction {
  const CModalAction({
    required this.label,
    this.onPressed,
    this.kind = CModalActionKind.secondary,
    this.dismissOnPressed = true,
    this.enabled = true,
  });

  /// Button label.
  final String label;

  /// Called when the action is activated.
  final VoidCallback? onPressed;

  /// Button appearance.
  final CModalActionKind kind;

  /// Whether the modal closes after this action is activated.
  final bool dismissOnPressed;

  /// Whether this action can be activated.
  final bool enabled;
}

/// Configuration for [CModal].
class CModalProps {
  const CModalProps({
    required this.title,
    required this.body,
    this.description,
    this.actions = const <CModalAction>[],
    this.size = CModalSize.medium,
    this.barrierDismissible = true,
    this.showCloseButton = true,
    this.onClose,
  });

  /// Modal heading.
  final String title;

  /// Main modal content.
  final Widget body;

  /// Optional supporting text below the heading.
  final String? description;

  /// Footer actions. Actions render in the order supplied.
  final List<CModalAction> actions;

  /// Maximum modal width variant.
  final CModalSize size;

  /// Whether tapping the backdrop dismisses the modal.
  final bool barrierDismissible;

  /// Whether to show the close icon in the heading.
  final bool showCloseButton;

  /// Called when the close icon is activated.
  final VoidCallback? onClose;
}
