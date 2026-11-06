import 'package:flutter/material.dart';

import 'carbon_sankey_chart_impl.dart'
    if (dart.library.html) 'carbon_sankey_chart_web.dart'
    if (dart.library.io) 'carbon_sankey_chart_stub.dart'
    as impl;

/// A Carbon Charts Alluvial (Sankey) chart.
///
/// On **Flutter Web** this renders the bundled `assets/carbon_sankey.html`
/// inside an `<iframe>` via [HtmlElementView].
/// On **non-web** targets a placeholder tile is shown (the asset can be
/// loaded via `webview_flutter` if needed — add the dependency back for
/// Android/iOS builds).
class CarbonSankeyChart extends StatefulWidget {
  const CarbonSankeyChart({
    super.key,
    this.title,
    this.height = 480,
  });

  final String? title;
  final double height;

  @override
  State<CarbonSankeyChart> createState() => impl.CarbonSankeyChartState();
}
