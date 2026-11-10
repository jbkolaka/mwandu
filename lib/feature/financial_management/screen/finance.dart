import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// A financial management module shown in the left panel.
class FinanceNavItem {
  const FinanceNavItem({
    required this.label,
    required this.description,
    required this.icon,
  });

  final String label;
  final String description;
  final IconData icon;
}

/// UI shell for the financial management area.
///
/// A fixed left panel holds the module navigation. The panel can be
/// collapsed down to an icon rail and expands again from the toggle.
class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  /// Expanded left panel width (Carbon UI shell aside, 256).
  static const double _panelWidth = Breakpoint.asideLeftMinWidth;

  /// Collapsed left rail width (Carbon 2 column grid, 48).
  static const double _railWidth = Breakpoint.wideGrid2ColumnWidth;

  /// Viewport below which the panel starts collapsed.
  static const double _narrowViewport = BreakpointMD672px.viewportSize;

  static const List<FinanceNavItem> _modules = [
    FinanceNavItem(
      label: 'Overview',
      description: 'A snapshot of the financial position of the business.',
      icon: CIcons.dashboard,
    ),
    FinanceNavItem(
      label: 'General ledger',
      description:
          'Every financial transaction recorded in one place, with a full audit trail.',
      icon: CIcons.book,
    ),
    FinanceNavItem(
      label: 'Accounts payable',
      description:
          'Track what the business owes suppliers and when payments are due.',
      icon: CIcons.wallet,
    ),
    FinanceNavItem(
      label: 'Accounts receivable',
      description:
          'Track what customers owe the business and when it is expected.',
      icon: CIcons.currency,
    ),
    FinanceNavItem(
      label: 'Invoicing',
      description:
          'Create, issue and manage customer invoices and credit notes.',
      icon: CIcons.receipt,
    ),
    FinanceNavItem(
      label: 'Banking',
      description:
          'Manage bank accounts, transfers, and reconciliation of statements.',
      icon: CIcons.building,
    ),
    FinanceNavItem(
      label: 'Cash flow',
      description:
          'Monitor money moving in and out of the business over time.',
      icon: CIcons.flow,
    ),
    FinanceNavItem(
      label: 'Budgeting',
      description:
          'Plan budgets, compare them to actuals, and control variance.',
      icon: CIcons.scale,
    ),
    FinanceNavItem(
      label: 'Costing',
      description:
          'Understand product, project, and activity costs to protect margin.',
      icon: CIcons.calculator,
    ),
    FinanceNavItem(
      label: 'Payroll',
      description:
          'Run payroll, manage employee deductions, and record liabilities.',
      icon: CIcons.account,
    ),
    FinanceNavItem(
      label: 'Reporting',
      description:
          'Build financial statements and scheduled management reporting.',
      icon: CIcons.chartLine,
    ),
    FinanceNavItem(
      label: 'Audit trail',
      description:
          'Review who changed which financial record and when.',
      icon: CIcons.certificate,
    ),
  ];

  bool _collapsed = false;
  int _selectedIndex = 0;

  void _toggleCollapsed() {
    setState(() => _collapsed = !_collapsed);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < _narrowViewport;
        final collapsed = _collapsed || isNarrow;

        return Scaffold(
          backgroundColor: tokens.background,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LeftPanel(
                modules: _modules,
                selectedIndex: _selectedIndex,
                collapsed: collapsed,
                panelWidth: _panelWidth,
                railWidth: _railWidth,
                onToggle: _toggleCollapsed,
                onSelect: (index) => setState(() => _selectedIndex = index),
              ),
              Expanded(
                child: _FinanceContent(
                  module: _modules[_selectedIndex],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The fixed left navigation panel of the UI shell.
class _LeftPanel extends StatelessWidget {
  const _LeftPanel({
    required this.modules,
    required this.selectedIndex,
    required this.collapsed,
    required this.panelWidth,
    required this.railWidth,
    required this.onToggle,
    required this.onSelect,
  });

  final List<FinanceNavItem> modules;
  final int selectedIndex;
  final bool collapsed;
  final double panelWidth;
  final double railWidth;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      width: collapsed ? railWidth : panelWidth,
      color: tokens.layer01,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Panel header with the collapse toggle.
          Container(
            height: Spacing.v48px3remSpacing09,
            padding: EdgeInsets.symmetric(
              horizontal: collapsed
                  ? Spacing.v8px05remSpacing03
                  : Spacing.v16px1remSpacing05,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: tokens.borderSubtle00),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CIcons.wallet,
                  size: Spacing.v16px1remSpacing05,
                  color: tokens.iconPrimary,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: Spacing.v8px05remSpacing03),
                  Expanded(
                    child: Text(
                      'Finance',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Module navigation.
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: Spacing.v8px05remSpacing03,
                horizontal: collapsed
                    ? Spacing.v4px025remSpacing02
                    : Spacing.v8px05remSpacing03,
              ),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                final isSelected = index == selectedIndex;

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.v2px0125remSpacing01,
                  ),
                  child: Material(
                    color: isSelected
                        ? tokens.layerSelected01
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelect(index),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: collapsed
                              ? Spacing.v8px05remSpacing03
                              : Spacing.v12px075remSpacing04,
                          vertical: Spacing.v8px05remSpacing03,
                        ),
                        child: Row(
                          mainAxisAlignment: collapsed
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Icon(
                              module.icon,
                              size: Spacing.v16px1remSpacing05,
                              color: isSelected
                                  ? tokens.linkPrimary
                                  : tokens.iconSecondary,
                            ),
                            if (!collapsed) ...[
                              const SizedBox(
                                width: Spacing.v12px075remSpacing04,
                              ),
                              Expanded(
                                child: Text(
                                  module.label,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: isSelected
                                        ? tokens.linkPrimary
                                        : tokens.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Collapse toggle.
          Container(
            padding: EdgeInsets.all(
              collapsed
                  ? Spacing.v8px05remSpacing03
                  : Spacing.v12px075remSpacing04,
            ),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: tokens.borderSubtle00)),
            ),
            child: Align(
              alignment: collapsed
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: IconButton(
                onPressed: onToggle,
                tooltip: collapsed ? 'Expand panel' : 'Collapse panel',
                icon: Icon(
                  collapsed ? CIcons.chevronRight : CIcons.chevronLeft,
                  size: Spacing.v16px1remSpacing05,
                  color: tokens.iconSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The content area of the UI shell.
class _FinanceContent extends StatelessWidget {
  const _FinanceContent({required this.module});

  final FinanceNavItem module;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.v24px15remSpacing06),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
        decoration: BoxDecoration(
          color: tokens.layer01,
          border: Border.all(color: tokens.borderSubtle01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              module.label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.v8px05remSpacing03),
            Text(
              module.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: tokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
