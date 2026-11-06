import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mwandu/core/components/alerts/alerts.dart';
import 'package:mwandu/core/theme/theme.dart';
import 'package:mwandu/main.dart';

void main() {
  testWidgets('Theme system, AlertsNeutral, and counter smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial theme is White
    expect(find.text('Active Theme Tokens: White'), findsOneWidget);

    // Verify AlertsNeutral, AlertsWithButtons, and AlertsWithLink are rendered
    expect(find.text('This is a neutral alert'), findsOneWidget);
    expect(
      find.text('This is a neutral alert with the button down below'),
      findsOneWidget,
    );
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Dismiss'), findsOneWidget);
    expect(
      find.text('This is a neutral alert with an action link.'),
      findsOneWidget,
    );
    expect(find.text('Action link'), findsOneWidget);
    expect(find.text('Critical Alert'), findsOneWidget);
    expect(find.text('Resolve Issue'), findsOneWidget);

    // Switch theme to Gray 100
    await tester.tap(find.text('Gray 100 (Dark)'));
    await tester.pumpAndSettle();

    // Verify theme changed to Gray 100
    expect(find.text('Active Theme Tokens: Gray 100'), findsOneWidget);
    expect(find.text('This is a neutral alert'), findsOneWidget);

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

  testWidgets('AlertsNeutral standalone token styling test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.whiteTheme,
        home: const Scaffold(body: AlertsNeutral()),
      ),
    );

    // Verify text
    expect(find.text('This is a neutral alert'), findsOneWidget);

    // Verify circle container with icon
    final containerFinder = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final box = widget.decoration as BoxDecoration;
        return box.shape == BoxShape.circle;
      }
      return false;
    });
    expect(containerFinder, findsOneWidget);

    final circleContainer = tester.widget<Container>(containerFinder);
    final boxDecoration = circleContainer.decoration as BoxDecoration;
    expect(boxDecoration.shape, BoxShape.circle);
    expect(boxDecoration.color, AppThemeTokens.white().supportInfo);
  });

  testWidgets(
    'AlertsWithButtons buttons down below and secondary button choice test',
    (WidgetTester tester) async {
      // 1. Test with showSecondaryButton: false (only primary button down below)
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.whiteTheme,
          home: const Scaffold(
            body: AlertsWithButtons(
              message: 'Alert with primary only below',
              primaryButtonText: 'Action',
              showSecondaryButton: false,
            ),
          ),
        ),
      );

      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Dismiss'), findsNothing);

      // Verify the button is positioned down below the message text
      final messageOffset = tester.getTopLeft(
        find.text('Alert with primary only below'),
      );
      final buttonOffset = tester.getTopLeft(find.text('Action'));
      expect(
        buttonOffset.dy,
        greaterThan(messageOffset.dy),
        reason: 'The button should be down not in the row',
      );

      // 2. Test with showSecondaryButton: true (both primary and secondary buttons)
      var primaryTapped = false;
      var secondaryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.whiteTheme,
          home: Scaffold(
            body: AlertsWithButtons(
              title: 'Notice',
              message: 'Alert with both buttons',
              primaryButtonText: 'Confirm',
              onPrimaryPressed: () => primaryTapped = true,
              showSecondaryButton: true,
              secondaryButtonText: 'Cancel',
              onSecondaryPressed: () => secondaryTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tap primary button
      await tester.tap(find.text('Confirm'));
      expect(primaryTapped, isTrue);

      // Tap secondary button
      await tester.tap(find.text('Cancel'));
      expect(secondaryTapped, isTrue);
    },
  );

  testWidgets(
    'AlertsWithLink interaction with circle icon and no arrow icon test',
    (WidgetTester tester) async {
      var linkTapped = false;
      var closeTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.whiteTheme,
          home: Scaffold(
            body: AlertsWithLink(
              message: 'This is a neutral alert with an action link.',
              linkText: 'Learn more',
              onLinkTap: () => linkTapped = true,
              onClose: () => closeTapped = true,
            ),
          ),
        ),
      );

      expect(
        find.text('This is a neutral alert with an action link.'),
        findsOneWidget,
      );
      expect(find.text('Learn more'), findsOneWidget);

      // Verify the leading circle icon container IS present
      final circleFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final box = widget.decoration as BoxDecoration;
          return box.shape == BoxShape.circle;
        }
        return false;
      });
      expect(circleFinder, findsOneWidget);

      // Verify there is NO arrow icon in the link
      expect(find.byIcon(Icons.arrow_forward), findsNothing);

      // Tap the link
      await tester.tap(find.text('Learn more'));
      expect(linkTapped, isTrue);

      // Tap the close button
      await tester.tap(find.byIcon(Icons.close));
      expect(closeTapped, isTrue);
    },
  );

  testWidgets('AlertsCritical interaction and styling test', (
    WidgetTester tester,
  ) async {
    var primaryTapped = false;
    var closeTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.whiteTheme,
        home: Scaffold(
          body: AlertsCritical(
            title: 'Critical Failure',
            message: 'A critical service has stopped responding.',
            primaryButtonText: 'Restart',
            onPrimaryPressed: () => primaryTapped = true,
            onClose: () => closeTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Critical Failure'), findsOneWidget);
    expect(
      find.text('A critical service has stopped responding.'),
      findsOneWidget,
    );
    expect(find.text('Restart'), findsOneWidget);

    // Verify error icon
    expect(find.byIcon(Icons.error_outline), findsOneWidget);

    // Tap primary button
    await tester.tap(find.text('Restart'));
    expect(primaryTapped, isTrue);

    // Tap close button
    await tester.tap(find.byIcon(Icons.close));
    expect(closeTapped, isTrue);
  });

}
