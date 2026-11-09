import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;
import 'package:mwandu/feature/home/widgets/module_card.dart';

/// Responsive grid of [ModuleCard]s with sample module data.
class ModuleGrid extends StatelessWidget {
  const ModuleGrid({super.key});

  static const _modules = [
    (
      'Identity Module',
      'Manages users, roles, and authentication across the enterprise.',
      ModuleStatus.active,
    ),
    (
      'Billing Module',
      'Handles invoicing, subscriptions, and payment integrations.',
      ModuleStatus.active,
    ),
    (
      'Reports Module',
      'Generates scheduled and on-demand analytics reports.',
      ModuleStatus.draft,
    ),
    (
      'Audit Module',
      'Tracks security events and compliance trails.',
      ModuleStatus.active,
    ),
    (
      'Notifications Module',
      'Sends email, SMS, and in-app alerts to users.',
      ModuleStatus.draft,
    ),
    (
      'Legacy Sync Module',
      'Synchronizes data with older systems.',
      ModuleStatus.deprecated,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1024
            ? 3
            : width >= 640
            ? 2
            : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _modules.length,
          padding: const EdgeInsets.all(Spacing.v24px15remSpacing06),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Spacing.v16px1remSpacing05,
            mainAxisSpacing: Spacing.v16px1remSpacing05,
            mainAxisExtent: 280,
          ),
          itemBuilder: (context, index) {
            final (title, description, status) = _modules[index];
            return ModuleCard(
              title: title,
              description: description,
              status: status,
            );
          },
        );
      },
    );
  }
}
