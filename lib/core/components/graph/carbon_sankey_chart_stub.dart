// Non-web stub for CarbonSankeyChart.
// On Android/iOS/desktop, webview_flutter can be wired up here.
// For now a placeholder tile is shown.
import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'carbon_sankey_chart.dart';

class CarbonSankeyChartState extends State<CarbonSankeyChart> {
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
      child: Center(
        child: Text(
          'Carbon Charts (Sankey) — web only in this build',
          style: TextStyle(color: tokens.textSecondary, fontSize: 13),
        ),
      ),
    );
  }
}
