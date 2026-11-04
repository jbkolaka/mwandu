import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mwandu/main.dart';

void main() {
  testWidgets('Theme system and counter smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial theme is White
    expect(find.text('Active Theme Tokens: White'), findsOneWidget);

    // Switch theme to Gray 100
    await tester.tap(find.text('Gray 100 (Dark)'));
    await tester.pumpAndSettle();

    // Verify theme changed to Gray 100
    expect(find.text('Active Theme Tokens: Gray 100'), findsOneWidget);

    // Verify counter starts at 0
    expect(find.text('Counter: 0'), findsOneWidget);
    expect(find.text('Counter: 1'), findsNothing);

    // Tap the floating action button and trigger a frame.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify counter incremented to 1
    expect(find.text('Counter: 0'), findsNothing);
    expect(find.text('Counter: 1'), findsOneWidget);
  });
}
