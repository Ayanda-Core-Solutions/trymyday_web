import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - Footer legal links navigate to the new legal pages.
// - Each legal page renders its expected fallback heading when Firestore data
//   is absent in the test environment.
void main() {
  Future<void> pumpDesktopApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const TryMyDayApp());
    await tester.pumpAndSettle();
  }

  testWidgets('navigates to the privacy policy page from the footer', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.ensureVisible(find.text('Privacy Policy').last);
    await tester.tap(find.text('Privacy Policy').last);
    await tester.pumpAndSettle();

    expect(find.text('Privacy Policy'), findsWidgets);
    expect(find.textContaining('Version 1.0'), findsOneWidget);
  });

  testWidgets('navigates to the terms and conditions page from the footer', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.ensureVisible(find.text('Terms and Conditions').last);
    await tester.tap(find.text('Terms and Conditions').last);
    await tester.pumpAndSettle();

    expect(find.text('Terms & Conditions'), findsOneWidget);
    expect(find.textContaining('Effective 8 Feb 2026'), findsOneWidget);
  });

  testWidgets(
    'navigates to the refunds and cancellation policy page from the footer',
    (WidgetTester tester) async {
      await pumpDesktopApp(tester);

      await tester.ensureVisible(find.text('Refunds/Cancellation Policy'));
      await tester.tap(find.text('Refunds/Cancellation Policy'));
      await tester.pumpAndSettle();

      expect(
        find.text('Cancellation & Refund Policy (South Africa)'),
        findsOneWidget,
      );
      expect(find.textContaining('South African Rand (ZAR)'), findsOneWidget);
    },
  );

  testWidgets('navigates to the account deletion page from the footer', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.ensureVisible(find.text('Account Deletion'));
    await tester.tap(find.text('Account Deletion'));
    await tester.pumpAndSettle();

    expect(find.text('Account Deletion'), findsWidgets);
    expect(find.textContaining('Delete my TryMyDay account'), findsOneWidget);
    expect(find.textContaining('hello@trymyday.co.za'), findsOneWidget);
    expect(
      find.textContaining(
        'Deletion requests are normally processed within 30 days',
      ),
      findsOneWidget,
    );
  });
}
