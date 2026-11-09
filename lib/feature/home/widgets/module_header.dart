import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

/// Key Modules header card: description on the left, template actions on the right.
class ModuleHeader extends StatelessWidget {
  const ModuleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.v24px15remSpacing06),
      decoration: BoxDecoration(color: tokens.layer01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side: Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Key Modules',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: tokens.textPrimary),
                ),
                const SizedBox(height: Spacing.v8px05remSpacing03),
                Text(
                  'A key module establishes the foundational capabilities of your enterprise application,\ndetailing the required entities, business logic, and third-party integrations. You can develop\na module from scratch, copy an existing module to create a new variant, or edit the parameters of a live module.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: tokens.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(width: Spacing.v48px3remSpacing09),

          // Right Side: Side-by-side Buttons
          Wrap(
            spacing: Spacing.v12px075remSpacing04,
            runSpacing: Spacing.v12px075remSpacing04,
            alignment: WrapAlignment.end,
            children: [
              // Edit Button (Outlined)
              OutlinedButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Edit template'),
                    const SizedBox(width: Spacing.v8px05remSpacing03),
                    Icon(Icons.edit, size: Spacing.v16px1remSpacing05),
                  ],
                ),
              ),

              // Create Button (Elevated/Filled)
              ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Create template'),
                    const SizedBox(width: Spacing.v8px05remSpacing03),
                    Icon(Icons.add, size: Spacing.v16px1remSpacing05),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
