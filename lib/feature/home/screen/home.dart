import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/shared/styles/variables/spacing.style.dart';
import 'package:mwandu/core/theme/variables.dart';

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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
          decoration: BoxDecoration(
            color: tokens.layer01,
            border: Border.all(color: tokens.borderSubtle01),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(CIcons.add, size: Spacing.v16px1remSpacing05),
                label: const Text('Create template'),
              ),
              const SizedBox(width: Spacing.v12px075remSpacing04),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(CIcons.edit, size: Spacing.v16px1remSpacing05),
                label: const Text('Edit template'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
