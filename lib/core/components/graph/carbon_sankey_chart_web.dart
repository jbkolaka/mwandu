// Web implementation of CarbonSankeyChart.
// Uses dart:ui_web to register a platform view that embeds an <iframe>
// pointing at the bundled assets/carbon_sankey.html.
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../../theme/theme.dart';
import 'carbon_sankey_chart.dart';

// Each widget instance gets a unique view-type id so multiple charts can
// coexist on the same page.
int _viewCounter = 0;

class CarbonSankeyChartState extends State<CarbonSankeyChart> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'carbon-sankey-${_viewCounter++}';

    // Register a factory that creates an <iframe> loading our asset.
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement
        ..src = 'assets/carbon_sankey.html'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle00),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.v16px1remSpacing05,
                Spacing.v12px075remSpacing04,
                Spacing.v16px1remSpacing05,
                0,
              ),
              child: Text(
                widget.title!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: tokens.textPrimary,
                ),
              ),
            ),
          Expanded(
            child: HtmlElementView(viewType: _viewType),
          ),
        ],
      ),
    );
  }
}
