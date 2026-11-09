import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;
import 'package:mwandu/feature/home/widgets/module_card.dart';

/// Responsive grid of [ModuleCard]s with sample module data.
///
/// All layout values come from the Carbon layout grid variables
/// ([GridMode] for gutters and end margins, [GridModeCondensed] for the
/// 320px card column width) — no hardcoded dimensions.
class ModuleGrid extends StatelessWidget {
  const ModuleGrid({super.key});

  /// Card column width: 320 from the layout grid variables.
  static const double cardColumnWidth = GridModeCondensed.v4ColumnWidth;

  /// Card height derived from the grid variables (320 − 32 = 288).
  static const double cardHeight = cardColumnWidth - Spacing.v32px2remSpacing07;

  static const _modules = [
    (
      'Identity Module',
      'Manages users, roles, and authentication across the enterprise.',
      ModuleStatus.active,
      Icons.security_outlined,
    ),
    (
      'Financial management',
      'By tracking accounts payable and accounts receivable, plus helping to manage the general ledger, this module puts your current financial picture and outlook into focus. It also generates and stores balance sheets, payment receipts, and other key financial documents.',
      ModuleStatus.active,
      Icons.credit_card_outlined,
    ),
    (
      'Procurement',
      'It automates, tracks, and analyzes quotes while helping to prepare and send purchase orders. Using a list of approved vendors, the module can automate purchases of specific items, which speeds up the process, enforces compliant spending, improves supplier relationships.',
      ModuleStatus.draft,
      Icons.analytics_outlined,
    ),
    (
      'Risk management',
      'A risk management and compliance module uses artificial intelligence (AI) and machine learning to enhance financial controls, enabling finance teams to prevent cash leaks, enforce audits, and protect against emerging risks—all while saving hours of manual work.',
      ModuleStatus.active,
      Icons.fact_check_outlined,
    ),
    (
      'Supply chain management',
      'Track how supplies and goods move through your supply chain: from suppliers and sub-suppliers to manufacturers all the way to distributors and retailers or consumers. It lets you efficiently plan demand, supply, order fulfillment, and production across your business to reduce disruptions and minimize costs, ensuring the right inventory is available at the right time and in the right place.',
      ModuleStatus.draft,
      Icons.notifications_outlined,
    ),
    (
      'Enterprise performance management',
      'Enhance the processes that help your business plan, budget, forecast, and report on performance. They enable connected planning (versus old-school siloed planning) by giving a unified view of financial, operational, and line-of-business planning. These modules also use automation to accelerate the reporting of financial results.',
      ModuleStatus.deprecated,
      Icons.sync_problem_outlined,
    ),
    (
      'Manufacturing process',
      'It’s easier for your business to plan and manage production runs. That includes making sure your facility has the raw materials on hand to meet demand, can efficiently run a shop floor, and keep costs down—all while ensuring the quality of finished goods.',
      ModuleStatus.deprecated,
      Icons.sync_problem_outlined,
    ),
    (
      'Customer relationship management',
      'Help you manage customers by improving sales and marketing processes, especially those supporting sales leads. These modules store all information on customers and prospects, including every customer interaction and purchase history, and offer segmentation data and targeted cross-sell recommendations.',
      ModuleStatus.deprecated,
      Icons.sync_problem_outlined,
    ),
    (
      'Human resources',
      'Contains detailed records on all employees, including performance reviews, job descriptions, benefits selections, and attendance/time off. Like other ERP modules, it supplants annual spreadsheets with automation that continuously gathers data companywide, reducing duplicate data and increasing accuracy, an important benefit given the sheer amount of HR data most businesses have.',
      ModuleStatus.deprecated,
      Icons.sync_problem_outlined,
    ),
    (
      'Project management',
      'With shared visualization tools that help to track schedules, budgets, and resources. For example, you can see multiple project plans in a single view, which lets you easily allocate (and reallocate) resources. You can assemble the right project team by using search filters for roles, skills, and location. You can also better manage budgets by standardizing how you capture costs throughout the business. Advanced project management tools also help you maximize cash flow by automating customer invoices and project billing.',
      ModuleStatus.deprecated,
      Icons.sync_problem_outlined,
    ),
    (
      'ERP analytics',
      'module helps finance, procurement, and project management professionals understand the factors that drive profitability, improve the use of working capital, and control business expenditures.',
      ModuleStatus.deprecated,
      Icons.sync_problem_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const gutter = GridMode.gutter;
        final availableWidth =
            width - GridMode.leftEndMargin - GridMode.rightEndMargin;
        // Shrink to fit on narrow screens instead of overflowing.
        final cardWidth = math.min(cardColumnWidth, availableWidth);
        final crossAxisCount =
            ((availableWidth + gutter) / (cardWidth + gutter)).floor().clamp(
              1,
              _modules.length,
            );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _modules.length,
          padding: const EdgeInsets.only(
            left: GridMode.leftEndMargin,
            right: GridMode.rightEndMargin,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: gutter,
            mainAxisSpacing: gutter,
            mainAxisExtent: cardHeight,
          ),
          itemBuilder: (context, index) {
            final (title, description, status, icon) = _modules[index];
            return Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: cardWidth,
                child: ModuleCard(
                  title: title,
                  description: description,
                  status: status,
                  icon: icon,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
