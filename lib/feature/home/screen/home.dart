import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(title: const Text('Mwandu')),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.v24px15remSpacing06),
            decoration: BoxDecoration(
              color: tokens.layer01,
              border: Border.all(color: tokens.borderSubtle01),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Key Modules',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Spacing.v8px05remSpacing03),
                      Text(
                        'A key module establishes the foundational capabilities of your enterprise application, detailing the required entities, business logic, and third-party integrations. You can develop a module from scratch, copy an existing module to create a new variant, or edit the parameters of a live module.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.v32px2remSpacing07),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(CIcons.add, size: Spacing.v16px1remSpacing05),
                      label: const Text('Create template'),
                    ),
                    const SizedBox(height: Spacing.v12px075remSpacing04),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(CIcons.edit, size: Spacing.v16px1remSpacing05),
                      label: const Text('Edit template'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
