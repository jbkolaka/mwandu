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

/// A single module card matching the IBM reference layout.
class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon, // Added icon requirement
    this.status = ModuleStatus.draft,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final ModuleStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final statusColor = status.color(tokens);

    return Container(
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle01),
      ),
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Top Row: Icon and 3-dot menu + Status ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module Icon (Top Left)
              Icon(icon, size: 32, color: tokens.textPrimary),

              // Status Badge & 3-dot menu (Top Right)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.v8px05remSpacing03,
                      vertical: Spacing.v4px025remSpacing02,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1), // Subtle background
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // // 3-dot Menu
                  // Icon(Icons.more_vert, size: 20, color: tokens.textSecondary),
                ],
              ),
            ],
          ),

          const SizedBox(height: Spacing.v16px1remSpacing05),

          // --- Title ---
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: tokens.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Spacing.v8px05remSpacing03),

          // --- Description ---
          // Expanded pushes the bottom button to the very bottom of the card
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: tokens.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: Spacing.v16px1remSpacing05),

          // --- Bottom Button ---
          SizedBox(
            width: double.infinity, // Forces button to fill width
            height: 40,
            child: OutlinedButton(
              onPressed: onTap ?? () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Configure module',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Spacing.v8px05remSpacing03),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: tokens.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
