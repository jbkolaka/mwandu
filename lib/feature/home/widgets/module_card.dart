import 'package:carbon_flutter/features/icon/index.dart';
import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Status of a module, mapped to Carbon support colors.
enum ModuleStatus {
  active,
  draft,
  deprecated;

  String get label {
    switch (this) {
      case ModuleStatus.active:
        return 'Active';
      case ModuleStatus.draft:
        return 'Draft';
      case ModuleStatus.deprecated:
        return 'Deprecated';
    }
  }

  Color color(AppThemeTokens tokens) {
    switch (this) {
      case ModuleStatus.active:
        return tokens.supportSuccess;
      case ModuleStatus.draft:
        return tokens.supportWarning;
      case ModuleStatus.deprecated:
        return tokens.supportError;
    }
  }
}

/// A single module card: title, description, status badge, action button.
class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.title,
    required this.description,
    this.status = ModuleStatus.draft,
    this.onTap,
  });

  final String title;
  final String description;
  final ModuleStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final statusColor = status.color(tokens);
    return Container(
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: tokens.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.v8px05remSpacing03,
                  vertical: Spacing.v4px025remSpacing02,
                ),
                color: statusColor,
                child: Text(
                  status.label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: tokens.textOnColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: tokens.textSecondary),
          ),
          const SizedBox(height: Spacing.v12px075remSpacing04),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: onTap ?? () {},
              icon: Icon(CIcons.edit, size: Spacing.v16px1remSpacing05),
              label: const Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }
}
