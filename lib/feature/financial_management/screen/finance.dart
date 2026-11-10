import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/components/ui_shell/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// UI shell for the financial management area.
///
/// The left panel navigation is provided by the shared [CUiShell] component
/// so the same shell can be reused by other pages.
class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  static const List<CUiShellNavItem> _modules = [
    CUiShellNavItem(
      label: 'Overview',
      description: 'A snapshot of the financial position of the business.',
      icon: CIcons.dashboard,
    ),
    CUiShellNavItem(
      label: 'General ledger',
      description:
          'Every financial transaction recorded in one place, with a full audit trail.',
      icon: CIcons.book,
    ),
    CUiShellNavItem(
      label: 'Accounts payable',
      description:
          'Track what the business owes suppliers and when payments are due.',
      icon: CIcons.wallet,
    ),
    CUiShellNavItem(
      label: 'Accounts receivable',
      description:
          'Track what customers owe the business and when it is expected.',
      icon: CIcons.currency,
    ),
    CUiShellNavItem(
      label: 'Invoicing',
      description:
          'Create, issue and manage customer invoices and credit notes.',
      icon: CIcons.receipt,
    ),
    CUiShellNavItem(
      label: 'Banking',
      description:
          'Manage bank accounts, transfers, and reconciliation of statements.',
      icon: CIcons.building,
    ),
    CUiShellNavItem(
      label: 'Cash flow',
      description:
          'Monitor money moving in and out of the business over time.',
      icon: CIcons.flow,
    ),
    CUiShellNavItem(
      label: 'Budgeting',
      description:
          'Plan budgets, compare them to actuals, and control variance.',
      icon: CIcons.scale,
    ),
    CUiShellNavItem(
      label: 'Costing',
      description:
          'Understand product, project, and activity costs to protect margin.',
      icon: CIcons.calculator,
    ),
    CUiShellNavItem(
      label: 'Payroll',
      description:
          'Run payroll, manage employee deductions, and record liabilities.',
      icon: CIcons.account,
    ),
    CUiShellNavItem(
      label: 'Reporting',
      description:
          'Build financial statements and scheduled management reporting.',
      icon: CIcons.chartLine,
    ),
    CUiShellNavItem(
      label: 'Audit trail',
      description:
          'Review who changed which financial record and when.',
      icon: CIcons.certificate,
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final module = _modules[_selectedIndex];

    return CUiShell(
      props: CUiShellProps(
        items: _modules,
        title: 'Finance',
        titleIcon: CIcons.wallet,
        selectedIndex: _selectedIndex,
        onSelect: (index) => setState(() => _selectedIndex = index),
      ),
      child: SingleChildScrollView(
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
                module.description ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
