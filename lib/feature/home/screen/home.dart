import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;
import 'package:mwandu/feature/home/widgets/module_grid.dart';
import 'package:mwandu/feature/home/widgets/module_header.dart';

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
      appBar: AppBar(
        title: const Text('Mwandu'),
        backgroundColor: tokens.backgroundBackgroundInverse,
      ),
      body: const SingleChildScrollView(
        child: Column(children: [ModuleHeader(), ModuleGrid()]),
      ),
    );
  }
}
