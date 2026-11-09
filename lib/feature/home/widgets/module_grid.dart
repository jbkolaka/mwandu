import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;
import 'package:mwandu/feature/home/widgets/module_card.dart';

/// Responsive grid of [ModuleCard]s with sample module data.
///
/// Layout uses the Carbon grid variables ([GridMode]) for end margins,
/// gutters, and column width instead of hardcoded values.
class ModuleGrid extends StatelessWidget {
  const ModuleGrid({super.key});

  static const _modules = [
    (
      'Identity Module',
      'Manages users, roles, and authentication across the enterprise.',
      ModuleStatus.active,
      Icons.security_outlined,
    ),
    (
      'Billing Module',
      'Handles invoicing, subscriptions, and payment integrations.',
      ModuleStatus.active,
      Icons.credit_card_outlined,
    ),
    (
      'Reports Module',
      'Generates scheduled and on-demand analytics reports.',
      ModuleStatus.draft,
      Icons.analytics_outlined,
    ),
    (
      'Audit Module',
      'Tracks security events and compliance trails.',
      ModuleStatus.active,
      Icons.fact_check_outlined,
    ),
    (
      'Notifications Module',
      'Sends email, SMS, and in-app alerts to users.',
      ModuleStatus.draft,
      Icons.notifications_outlined,
    ),
    (
      'Legacy Sync Module',
      'Synchronizes data with older systems.',
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
        final crossAxisCount =
            ((availableWidth + gutter) / (GridMode.v4ColumnWidth + gutter))
                .floor()
                .clamp(1, 4);

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
            mainAxisExtent: 280,
          ),
          itemBuilder: (context, index) {
            final (title, description, status, icon) = _modules[index];
            return Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 320,
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
