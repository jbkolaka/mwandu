import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text(
          'Welcome home',
          style: TextStyle(color: tokens.textPrimary, fontSize: 24),
        ),
      ),
    );
  }
}
