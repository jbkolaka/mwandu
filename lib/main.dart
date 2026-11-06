import 'package:flutter/material.dart';
import 'package:mwandu/feature/authentication/screen/login.dart';

import 'core/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppThemeController _themeController = AppThemeController(
    AppThemeMode.white,
  );

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: _themeController,
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) => MaterialApp(
          title: 'Mwandu',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeDataFor(_themeController.value),
          home: Login(),
        ),
      ),
    );
  }
}
