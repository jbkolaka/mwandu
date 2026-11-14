import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/components/text/index.dart';

import 'toggle_tip.props.dart';
import 'toggle_tip.styles.dart';

typedef _Styles = CToggletipStyles;

/// Carbon Toggletip component.
///
/// Used to provide additional contextual information upon click/tap.
/// Supports rich interactive content including text descriptions, links, and action buttons.
class CToggletip extends StatefulWidget {
  CToggletip({
    super.key,
    CToggletipAlignment align = CToggletipAlignment.bottom,
    bool defaultOpen = false,
    bool? open,
    ValueChanged<bool>? onOpenChange,
    String? label,
    String? labelText,
    String buttonLabel = 'Show information',
    String? bodyText,
    Widget? trigger,
    Widget? content,
    Widget? actions,
    bool closeOnTapOutside = true,
    bool enable = true,
  }) : props = CToggletipProps(
         align: align,
         defaultOpen: defaultOpen,
         open: open,
         onOpenChange: onOpenChange,
         label: label,
         labelText: labelText,
         buttonLabel: buttonLabel,
         bodyText: bodyText,
         trigger: trigger,
         content: content,
         actions: actions,
         closeOnTapOutside: closeOnTapOutside,
         enable: enable,
       );

  final CToggletipProps props;

  @override
  State<CToggletip> createState() => _CToggletipState();
}

class _CToggletipState extends State<CToggletip> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;

  bool get _isOpen => widget.props.open ?? _internalOpen;

  @override
  void initState() {
    super.initState();
    _internalOpen = widget.props.defaultOpen;
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
    }
  }

  @override
  void didUpdateWidget(CToggletip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.open != null &&
        widget.props.open != oldWidget.props.open) {
      if (widget.props.open!) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _toggle() {
    final nextState = !_isOpen;
    if (widget.props.open == null) {
      setState(() {
        _internalOpen = nextState;
      });
      if (nextState) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    }
    widget.props.onOpenChange?.call(nextState);
  }

  void _handleTapOutside() {
    if (widget.props.open == null) {
      setState(() {
        _internalOpen = false;
      });
      _hideOverlay();
    }
    widget.props.onOpenChange?.call(false);
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final tokens = context.tokens;
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlayContent(tokens),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  Alignment _targetAnchor(CToggletipAlignment align) {
    return switch (align) {
      CToggletipAlignment.top => Alignment.topCenter,
      CToggletipAlignment.topStart => Alignment.topLeft,
      CToggletipAlignment.topEnd => Alignment.topRight,
      CToggletipAlignment.bottom => Alignment.bottomCenter,
      CToggletipAlignment.bottomStart => Alignment.bottomLeft,
      CToggletipAlignment.bottomEnd => Alignment.bottomRight,
      CToggletipAlignment.left => Alignment.centerLeft,
      CToggletipAlignment.leftStart => Alignment.topLeft,
      CToggletipAlignment.leftEnd => Alignment.bottomLeft,
      CToggletipAlignment.right => Alignment.centerRight,
      CToggletipAlignment.rightStart => Alignment.topRight,
      CToggletipAlignment.rightEnd => Alignment.bottomRight,
    };
  }

  Alignment _followerAnchor(CToggletipAlignment align) {
    return switch (align) {
      CToggletipAlignment.top => Alignment.bottomCenter,
      CToggletipAlignment.topStart => Alignment.bottomLeft,
      CToggletipAlignment.topEnd => Alignment.bottomRight,
      CToggletipAlignment.bottom => Alignment.topCenter,
      CToggletipAlignment.bottomStart => Alignment.topLeft,
      CToggletipAlignment.bottomEnd => Alignment.topRight,
      CToggletipAlignment.left => Alignment.centerRight,
      CToggletipAlignment.leftStart => Alignment.topRight,
      CToggletipAlignment.leftEnd => Alignment.bottomRight,
      CToggletipAlignment.right => Alignment.centerLeft,
      CToggletipAlignment.rightStart => Alignment.topLeft,
      CToggletipAlignment.rightEnd => Alignment.bottomLeft,
    };
  }

  Offset _alignmentOffset(CToggletipAlignment align, double offset) {
    final double distance = offset + _Styles.caretHeight;

    return switch (align) {
      CToggletipAlignment.top ||
      CToggletipAlignment.topStart ||
      CToggletipAlignment.topEnd => Offset(0, -distance),
      CToggletipAlignment.bottom ||
      CToggletipAlignment.bottomStart ||
      CToggletipAlignment.bottomEnd => Offset(0, distance),
      CToggletipAlignment.left ||
      CToggletipAlignment.leftStart ||
      CToggletipAlignment.leftEnd => Offset(-distance, 0),
      CToggletipAlignment.right ||
      CToggletipAlignment.rightStart ||
      CToggletipAlignment.rightEnd => Offset(distance, 0),
    };
  }

  Widget _buildOverlayContent(AppThemeTokens tokens) {
    final Color bgColor = _Styles.backgroundColor(tokens);
    final Color borderColor = _Styles.borderColor(tokens);
    final Color textColor = _Styles.textColor(tokens);

    Widget body;
    if (widget.props.content != null) {
      body = widget.props.content!;
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.props.bodyText != null)
            CText(
              data: widget.props.bodyText!,
              style: TextStyle(
                fontSize: _Styles.bodyFontSize,
                color: textColor,
              ),
            ),
          if (widget.props.actions != null) ...[
            const SizedBox(height: _Styles.actionsMarginTop),
            widget.props.actions!,
          ],
        ],
      );
    }

    return Stack(
      children: [
        if (widget.props.closeOnTapOutside)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _handleTapOutside,
            ),
          ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: _targetAnchor(widget.props.align),
          followerAnchor: _followerAnchor(widget.props.align),
          offset: _alignmentOffset(widget.props.align, _Styles.defaultOffset),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _Styles.maxWidth),
            child: Material(
              type: MaterialType.transparency,
              child: _ToggletipSurface(
                align: widget.props.align,
                backgroundColor: bgColor,
                borderColor: borderColor,
                child: Padding(padding: _Styles.defaultPadding, child: body),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bool isEnabled = context.inheritedEnable && widget.props.enable;

    final Widget buttonWidget;
    if (widget.props.trigger != null) {
      buttonWidget = GestureDetector(
        onTap: isEnabled ? _toggle : null,
        child: widget.props.trigger!,
      );
    } else {
      buttonWidget = IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(
          width: _Styles.triggerSize,
          height: _Styles.triggerSize,
        ),
        icon: Icon(
          CIcons.information,
          size: _Styles.iconSize,
          color: _Styles.iconColor(
            tokens: tokens,
            isOpen: _isOpen,
            disabled: !isEnabled,
          ),
        ),
        tooltip: widget.props.buttonLabel,
        onPressed: isEnabled ? _toggle : null,
      );
    }

    final Widget anchor = CompositedTransformTarget(
      link: _layerLink,
      child: buttonWidget,
    );

    final String? label = widget.props.effectiveLabel;
    if (label != null && label.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CText(
            data: label,
            enable: isEnabled,
            style: TextStyle(
              fontSize: _Styles.labelFontSize,
              fontWeight: FontWeight.w400,
              color: _Styles.labelColor(tokens: tokens, disabled: !isEnabled),
            ),
          ),
          const SizedBox(width: _Styles.labelSpacing),
          anchor,
        ],
      );
    }

    return anchor;
  }
}

/// Floating container surface with triangular caret and drop shadow.
class _ToggletipSurface extends StatelessWidget {
  const _ToggletipSurface({
    required this.align,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
  });

  final CToggletipAlignment align;
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Widget container = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: _Styles.borderRadius,
        border: Border.all(color: borderColor, width: _Styles.borderWidth),
        boxShadow: _Styles.dropShadow(),
      ),
      child: child,
    );

    return CustomPaint(
      painter: _ToggletipCaretPainter(
        align: align,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
      ),
      child: container,
    );
  }
}

/// Painter for the triangular caret tip pointing from toggletip to trigger button.
class _ToggletipCaretPainter extends CustomPainter {
  const _ToggletipCaretPainter({
    required this.align,
    required this.backgroundColor,
    required this.borderColor,
  });

  final CToggletipAlignment align;
  final Color backgroundColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = borderColor
      ..strokeWidth = _Styles.borderWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    final double w = _Styles.caretWidth;
    final double h = _Styles.caretHeight;

    switch (align) {
      case CToggletipAlignment.bottom:
      case CToggletipAlignment.bottomStart:
      case CToggletipAlignment.bottomEnd:
        final double centerX = align == CToggletipAlignment.bottomStart
            ? w
            : (align == CToggletipAlignment.bottomEnd
                  ? size.width - w
                  : size.width / 2);
        path.moveTo(centerX - w / 2, 0);
        path.lineTo(centerX, -h);
        path.lineTo(centerX + w / 2, 0);
        path.close();
      case CToggletipAlignment.top:
      case CToggletipAlignment.topStart:
      case CToggletipAlignment.topEnd:
        final double centerX = align == CToggletipAlignment.topStart
            ? w
            : (align == CToggletipAlignment.topEnd
                  ? size.width - w
                  : size.width / 2);
        path.moveTo(centerX - w / 2, size.height);
        path.lineTo(centerX, size.height + h);
        path.lineTo(centerX + w / 2, size.height);
        path.close();
      case CToggletipAlignment.right:
      case CToggletipAlignment.rightStart:
      case CToggletipAlignment.rightEnd:
        final double centerY = align == CToggletipAlignment.rightStart
            ? w
            : (align == CToggletipAlignment.rightEnd
                  ? size.height - w
                  : size.height / 2);
        path.moveTo(0, centerY - w / 2);
        path.lineTo(-h, centerY);
        path.lineTo(0, centerY + w / 2);
        path.close();
      case CToggletipAlignment.left:
      case CToggletipAlignment.leftStart:
      case CToggletipAlignment.leftEnd:
        final double centerY = align == CToggletipAlignment.leftStart
            ? w
            : (align == CToggletipAlignment.leftEnd
                  ? size.height - w
                  : size.height / 2);
        path.moveTo(size.width, centerY - w / 2);
        path.lineTo(size.width + h, centerY);
        path.lineTo(size.width, centerY + w / 2);
        path.close();
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_ToggletipCaretPainter oldDelegate) {
    return align != oldDelegate.align ||
        backgroundColor != oldDelegate.backgroundColor ||
        borderColor != oldDelegate.borderColor;
  }
}

/// Convenience component for toggletip action links or buttons row.
class CToggletipActions extends StatelessWidget {
  const CToggletipActions({
    super.key,
    required this.children,
    this.spacing = Spacing.v16px1remSpacing05,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          children[i],
        ],
      ],
    );
  }
}

/// Convenience component for toggletip text content.
class CToggletipContent extends StatelessWidget {
  const CToggletipContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Convenience component for an external toggletip label.
class CToggletipLabel extends StatelessWidget {
  const CToggletipLabel({super.key, required this.label, this.enable = true});

  final String label;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bool isEnabled = context.inheritedEnable && enable;

    return CText(
      data: label,
      enable: isEnabled,
      style: TextStyle(
        fontSize: _Styles.labelFontSize,
        fontWeight: FontWeight.w400,
        color: _Styles.labelColor(tokens: tokens, disabled: !isEnabled),
      ),
    );
  }
}
