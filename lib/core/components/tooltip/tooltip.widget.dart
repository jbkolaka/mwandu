import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;
import 'package:mwandu/core/components/enable/index.dart';

import 'tooltip.props.dart';
import 'tooltip.styles.dart';

typedef _Styles = CTooltipStyles;

/// Carbon Tooltip component.
///
/// Displays brief, contextual helper text when users hover or focus on an interactive element.
class CTooltip extends StatefulWidget {
  CTooltip({
    super.key,
    required String label,
    CTooltipAlignment align = CTooltipAlignment.bottom,
    Duration enterDelay = const Duration(milliseconds: 100),
    Duration leaveDelay = const Duration(milliseconds: 300),
    bool autoAlign = true,
    bool closeOnActivation = true,
    bool highContrast = true,
    bool caret = true,
    bool enable = true,
    required this.child,
  }) : props = CTooltipProps(
         label: label,
         align: align,
         enterDelay: enterDelay,
         leaveDelay: leaveDelay,
         autoAlign: autoAlign,
         closeOnActivation: closeOnActivation,
         highContrast: highContrast,
         caret: caret,
         enable: enable,
       );

  final CTooltipProps props;
  final Widget child;

  @override
  State<CTooltip> createState() => _CTooltipState();
}

class _CTooltipState extends State<CTooltip> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _showTimer;
  Timer? _hideTimer;
  bool _isVisible = false;

  @override
  void dispose() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _hideOverlay();
    super.dispose();
  }

  void _scheduleShow() {
    _hideTimer?.cancel();
    if (_isVisible) return;

    _showTimer?.cancel();
    _showTimer = Timer(widget.props.enterDelay, () {
      if (mounted) {
        _showOverlay();
      }
    });
  }

  void _scheduleHide() {
    _showTimer?.cancel();
    if (!_isVisible) return;

    _hideTimer?.cancel();
    _hideTimer = Timer(widget.props.leaveDelay, () {
      if (mounted) {
        _hideOverlay();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) return;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final tokens = context.tokens;
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlayContent(tokens),
    );
    overlay.insert(_overlayEntry!);
    _isVisible = true;
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    _isVisible = false;
  }

  Alignment _targetAnchor(CTooltipAlignment align) {
    return switch (align) {
      CTooltipAlignment.top => Alignment.topCenter,
      CTooltipAlignment.topStart => Alignment.topLeft,
      CTooltipAlignment.topEnd => Alignment.topRight,
      CTooltipAlignment.bottom => Alignment.bottomCenter,
      CTooltipAlignment.bottomStart => Alignment.bottomLeft,
      CTooltipAlignment.bottomEnd => Alignment.bottomRight,
      CTooltipAlignment.left => Alignment.centerLeft,
      CTooltipAlignment.leftStart => Alignment.topLeft,
      CTooltipAlignment.leftEnd => Alignment.bottomLeft,
      CTooltipAlignment.right => Alignment.centerRight,
      CTooltipAlignment.rightStart => Alignment.topRight,
      CTooltipAlignment.rightEnd => Alignment.bottomRight,
    };
  }

  Alignment _followerAnchor(CTooltipAlignment align) {
    return switch (align) {
      CTooltipAlignment.top => Alignment.bottomCenter,
      CTooltipAlignment.topStart => Alignment.bottomLeft,
      CTooltipAlignment.topEnd => Alignment.bottomRight,
      CTooltipAlignment.bottom => Alignment.topCenter,
      CTooltipAlignment.bottomStart => Alignment.topLeft,
      CTooltipAlignment.bottomEnd => Alignment.topRight,
      CTooltipAlignment.left => Alignment.centerRight,
      CTooltipAlignment.leftStart => Alignment.topRight,
      CTooltipAlignment.leftEnd => Alignment.bottomRight,
      CTooltipAlignment.right => Alignment.centerLeft,
      CTooltipAlignment.rightStart => Alignment.topLeft,
      CTooltipAlignment.rightEnd => Alignment.bottomLeft,
    };
  }

  Offset _alignmentOffset(
    CTooltipAlignment align,
    double offset,
    bool hasCaret,
  ) {
    final double extra = hasCaret ? _Styles.caretHeight : 0.0;
    final double distance = offset + extra;

    return switch (align) {
      CTooltipAlignment.top ||
      CTooltipAlignment.topStart ||
      CTooltipAlignment.topEnd => Offset(0, -distance),
      CTooltipAlignment.bottom ||
      CTooltipAlignment.bottomStart ||
      CTooltipAlignment.bottomEnd => Offset(0, distance),
      CTooltipAlignment.left ||
      CTooltipAlignment.leftStart ||
      CTooltipAlignment.leftEnd => Offset(-distance, 0),
      CTooltipAlignment.right ||
      CTooltipAlignment.rightStart ||
      CTooltipAlignment.rightEnd => Offset(distance, 0),
    };
  }

  Widget _buildOverlayContent(AppThemeTokens tokens) {
    final Color bgColor = _Styles.backgroundColor(
      tokens: tokens,
      highContrast: widget.props.highContrast,
    );
    final Color textColor = _Styles.textColor(
      tokens: tokens,
      highContrast: widget.props.highContrast,
    );
    final Color borderColor = _Styles.borderColor(
      tokens: tokens,
      highContrast: widget.props.highContrast,
    );

    return CompositedTransformFollower(
      link: _layerLink,
      showWhenUnlinked: false,
      targetAnchor: _targetAnchor(widget.props.align),
      followerAnchor: _followerAnchor(widget.props.align),
      offset: _alignmentOffset(
        widget.props.align,
        _Styles.defaultOffset,
        widget.props.caret,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _Styles.maxWidth),
        child: Material(
          type: MaterialType.transparency,
          child: _TooltipSurface(
            align: widget.props.align,
            caret: widget.props.caret,
            backgroundColor: bgColor,
            borderColor: borderColor,
            child: Padding(
              padding: _Styles.padding,
              child: Text(
                widget.props.label,
                style: TextStyle(
                  color: textColor,
                  fontSize: _Styles.fontSize,
                  fontWeight: _Styles.fontWeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = context.inheritedEnable && widget.props.enable;

    if (!isEnabled || widget.props.label.isEmpty) {
      return widget.child;
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _scheduleShow(),
        onExit: (_) => _scheduleHide(),
        child: Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _scheduleShow();
            } else {
              _scheduleHide();
            }
          },
          child: GestureDetector(
            onTap: widget.props.closeOnActivation
                ? () {
                    _showTimer?.cancel();
                    _hideOverlay();
                  }
                : null,
            behavior: HitTestBehavior.translucent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Floating tooltip surface with optional caret triangle and drop shadow.
class _TooltipSurface extends StatelessWidget {
  const _TooltipSurface({
    required this.align,
    required this.caret,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
  });

  final CTooltipAlignment align;
  final bool caret;
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

    if (!caret) return container;

    return CustomPaint(
      painter: _TooltipCaretPainter(
        align: align,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
      ),
      child: container,
    );
  }
}

/// Painter for the triangular caret tip pointing toward the target element.
class _TooltipCaretPainter extends CustomPainter {
  const _TooltipCaretPainter({
    required this.align,
    required this.backgroundColor,
    required this.borderColor,
  });

  final CTooltipAlignment align;
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
      case CTooltipAlignment.bottom:
      case CTooltipAlignment.bottomStart:
      case CTooltipAlignment.bottomEnd:
        final double centerX = align == CTooltipAlignment.bottomStart
            ? w
            : (align == CTooltipAlignment.bottomEnd
                  ? size.width - w
                  : size.width / 2);
        path.moveTo(centerX - w / 2, 0);
        path.lineTo(centerX, -h);
        path.lineTo(centerX + w / 2, 0);
        path.close();
      case CTooltipAlignment.top:
      case CTooltipAlignment.topStart:
      case CTooltipAlignment.topEnd:
        final double centerX = align == CTooltipAlignment.topStart
            ? w
            : (align == CTooltipAlignment.topEnd
                  ? size.width - w
                  : size.width / 2);
        path.moveTo(centerX - w / 2, size.height);
        path.lineTo(centerX, size.height + h);
        path.lineTo(centerX + w / 2, size.height);
        path.close();
      case CTooltipAlignment.right:
      case CTooltipAlignment.rightStart:
      case CTooltipAlignment.rightEnd:
        final double centerY = align == CTooltipAlignment.rightStart
            ? w
            : (align == CTooltipAlignment.rightEnd
                  ? size.height - w
                  : size.height / 2);
        path.moveTo(0, centerY - w / 2);
        path.lineTo(-h, centerY);
        path.lineTo(0, centerY + w / 2);
        path.close();
      case CTooltipAlignment.left:
      case CTooltipAlignment.leftStart:
      case CTooltipAlignment.leftEnd:
        final double centerY = align == CTooltipAlignment.leftStart
            ? w
            : (align == CTooltipAlignment.leftEnd
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
  bool shouldRepaint(_TooltipCaretPainter oldDelegate) {
    return align != oldDelegate.align ||
        backgroundColor != oldDelegate.backgroundColor ||
        borderColor != oldDelegate.borderColor;
  }
}

/// Carbon Definition Tooltip component.
///
/// Underlines a definition term with a dashed/dotted line, revealing definition text on hover.
class CDefinitionTooltip extends StatelessWidget {
  const CDefinitionTooltip({
    super.key,
    required this.definition,
    required this.term,
    this.align = CTooltipAlignment.bottom,
    this.openOnHover = true,
  });

  /// The explanation or definition revealed by the tooltip.
  final String definition;

  /// The term widget or word being defined.
  final Widget term;

  /// Placement of the definition tooltip.
  final CTooltipAlignment align;

  /// Whether hovering triggers the definition tooltip.
  final bool openOnHover;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return CTooltip(
      label: definition,
      align: align,
      enable: openOnHover,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: tokens.borderStrong01,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: term,
      ),
    );
  }
}
