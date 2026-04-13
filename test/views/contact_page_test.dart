import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The Contact Us header link routes to the dedicated contact page.
// - The page renders the support form and the topics panel.
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
      find.text('Questions, support, or partnership enquiries.'),
      findsOneWidget,
    );
    expect(find.text('Send us a message'), findsOneWidget);
    expect(find.text('Support topics'), findsOneWidget);
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
}
