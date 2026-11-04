import 'package:flutter/material.dart';

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
        builder: (context, _) {
          return MaterialApp(
            title: 'Mwandu Carbon Theme',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeDataFor(_themeController.value),
            home: const ThemeShowcaseScreen(),
          );
        },
      ),
    );
  }
}

class ThemeShowcaseScreen extends StatefulWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  State<ThemeShowcaseScreen> createState() => _ThemeShowcaseScreenState();
}

class _ThemeShowcaseScreenState extends State<ThemeShowcaseScreen> {
  int _counter = 0;
  final TextEditingController _textController = TextEditingController(
    text: 'Carbon Design System in Flutter',
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final currentMode = context.themeMode;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('Mwandu Theme System'),
        actions: [
          IconButton(
            tooltip: 'Toggle Light / Dark',
            icon: Icon(
              currentMode.isDark ? Icons.light_mode : Icons.dark_mode,
              color: tokens.iconPrimary,
            ),
            onPressed: () => context.toggleBrightness(),
          ),
          const SizedBox(width: Spacing.v8px05remSpacing03),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Theme Mode Selector
            _buildThemeSelector(context, currentMode, tokens),
            const SizedBox(height: Spacing.v24px15remSpacing06),

            // Token Info Card
            _buildLayerCard(
              tokens: tokens,
              title: 'Active Theme Tokens: ${tokens.name}',
              subtitle: 'All colors, spacings, borders, and layers are derived dynamically from the design system tokens.',
              child: Column(
                children: [
                  _buildColorSampleRow(
                    label: 'Background',
                    color: tokens.background,
                    textColor: tokens.textPrimary,
                    borderColor: tokens.borderSubtle01,
                  ),
                  const SizedBox(height: Spacing.v8px05remSpacing03),
                  _buildColorSampleRow(
                    label: 'Layer 01',
                    color: tokens.layer01,
                    textColor: tokens.textPrimary,
                    borderColor: tokens.borderSubtle01,
                  ),
                  const SizedBox(height: Spacing.v8px05remSpacing03),
                  _buildColorSampleRow(
                    label: 'Layer 02',
                    color: tokens.layer02,
                    textColor: tokens.textPrimary,
                    borderColor: tokens.borderSubtle01,
                  ),
                  const SizedBox(height: Spacing.v8px05remSpacing03),
                  _buildColorSampleRow(
                    label: 'Button Primary',
                    color: tokens.buttonPrimary,
                    textColor: tokens.textOnColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.v24px15remSpacing06),

            // Notification / Alert Banners
            _buildAlertBanner(
              tokens: tokens,
              color: tokens.supportSuccess,
              icon: Icons.check_circle_outline,
              title: 'Success Token',
              message:
                  'supportSupportSuccess: Theme variables are properly linked!',
            ),
            const SizedBox(height: Spacing.v8px05remSpacing03),
            _buildAlertBanner(
              tokens: tokens,
              color: tokens.supportWarning,
              icon: Icons.warning_amber_rounded,
              title: 'Warning Token',
              message: 'supportSupportWarning: High contrast support across 4 themes.',
            ),
            const SizedBox(height: Spacing.v8px05remSpacing03),
            _buildAlertBanner(
              tokens: tokens,
              color: tokens.supportError,
              icon: Icons.error_outline,
              title: 'Error Token',
              message: 'supportSupportError: Accessible and tokenized color.',
            ),
            const SizedBox(height: Spacing.v24px15remSpacing06),

            // Interactive Form / Field Demonstration
            _buildLayerCard(
              tokens: tokens,
              title: 'Input Fields & Typography',
              subtitle: 'Styled with field01, borderStrong01, focus, and text tokens.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Text Input Field',
                      helperText: 'Uses textHelper and focus tokens',
                    ),
                  ),
                  const SizedBox(height: Spacing.v16px1remSpacing05),
                  Text(
                    'Primary Text Token: textPrimary',
                    style: TextStyle(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: Spacing.v4px025remSpacing02),
                  Text(
                    'Secondary Text Token: textSecondary',
                    style: TextStyle(color: tokens.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: Spacing.v4px025remSpacing02),
                  Text(
                    'Placeholder Text Token: textPlaceholder',
                    style: TextStyle(
                      color: tokens.textPlaceholder,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.v24px15remSpacing06),

            // Buttons & Actions
            _buildLayerCard(
              tokens: tokens,
              title: 'Button Tokens & Interactive Counter',
              subtitle:
                  'Button primary, secondary, danger, and spacing tokens.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: Spacing.v8px05remSpacing03,
                    runSpacing: Spacing.v8px05remSpacing03,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: Text('Counter: $_counter'),
                        onPressed: () => setState(() => _counter++),
                      ),
                      OutlinedButton(
                        onPressed: () => setState(() => _counter = 0),
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tokens.buttonDangerPrimary,
                          foregroundColor: tokens.textOnColor,
                        ),
                        onPressed: () => setState(() => _counter--),
                        child: const Text('Decrement'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.v32px2remSpacing07),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tokens.buttonPrimary,
        foregroundColor: tokens.textOnColor,
        tooltip: 'Increment',
        onPressed: () => setState(() => _counter++),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    AppThemeMode currentMode,
    AppThemeTokens tokens,
  ) {
    return Container(
      padding: const EdgeInsets.all(Spacing.v4px025remSpacing02),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle01),
      ),
      child: Row(
        children: AppThemeMode.values.map((mode) {
          final isSelected = mode == currentMode;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.setThemeMode(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.v12px075remSpacing04,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? tokens.buttonPrimary : Colors.transparent,
                ),
                child: Text(
                  mode.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? tokens.textOnColor : tokens.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLayerCard({
    required AppThemeTokens tokens,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(color: tokens.borderSubtle00),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.v4px025remSpacing02),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: tokens.textSecondary),
          ),
          const SizedBox(height: Spacing.v16px1remSpacing05),
          child,
        ],
      ),
    );
  }

  Widget _buildColorSampleRow({
    required String label,
    required Color color,
    required Color textColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v12px075remSpacing04,
        vertical: Spacing.v8px05remSpacing03,
      ),
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          Text(
            '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}',
            style: TextStyle(
              color: textColor,
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner({
    required AppThemeTokens tokens,
    required Color color,
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(Spacing.v12px075remSpacing04),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border(
          left: BorderSide(color: color, width: 4),
          top: BorderSide(color: tokens.borderSubtle00),
          right: BorderSide(color: tokens.borderSubtle00),
          bottom: BorderSide(color: tokens.borderSubtle00),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: Spacing.v12px075remSpacing04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: tokens.textPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(color: tokens.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
