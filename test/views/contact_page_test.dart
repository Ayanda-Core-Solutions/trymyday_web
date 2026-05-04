import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The Contact Us header link routes to the dedicated contact page.
// - The page renders the support form and the topics panel.
// - Support topics open the matching FAQ answer.
// - The Home header item routes back to the landing page from contact.
void main() {
  Future<void> pumpDesktopApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const TryMyDayApp());
    await tester.pumpAndSettle();
  }

  testWidgets('navigates to the contact page from the header', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-contact')));
    await tester.pumpAndSettle();

    expect(
      find.text('Questions about TryMyDay? We’re here to help.'),
      findsOneWidget,
    );
    expect(find.text('Send us a message'), findsOneWidget);
    expect(find.text('Mobile number (optional)'), findsOneWidget);
    expect(find.text('+27 82 123 4567'), findsOneWidget);
    expect(find.text('Support topics'), findsOneWidget);
    expect(find.text('What is a free coffee chat?'), findsOneWidget);
    expect(find.text('How do I book a paid session?'), findsOneWidget);
    expect(find.text('Can I reschedule a session?'), findsOneWidget);
    expect(find.text('Do professionals set their own rates?'), findsOneWidget);
    expect(find.text('How do I join a session?'), findsNothing);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('returns home when Home is tapped from the contact page', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-contact')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-home')));
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });

  testWidgets('opens the selected support topic on the faq page', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-contact')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('How do I book a paid session?'));
    await tester.pumpAndSettle();

    expect(find.text('Helpful answers before you book.'), findsOneWidget);
    expect(
      find.text(
        'Search for a professional, open their profile, review their availability, then select a paid booking option.',
      ),
      findsOneWidget,
    );
  });
}
