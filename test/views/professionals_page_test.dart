import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The For Professionals header link routes to the dedicated page.
// - The page renders the main hero copy and the three professional benefit cards.
// - The logo remains usable as a global way back to the landing page.
void main() {
  Future<void> pumpDesktopApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const TryMyDayApp());
    await tester.pumpAndSettle();
  }

  testWidgets('navigates to the professionals page from the header', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-professionals')));
    await tester.pumpAndSettle();

    expect(
      find.text('Share your experience. Help someone move forward.'),
      findsOneWidget,
    );
    expect(find.text('1. Create your profile'), findsOneWidget);
    expect(find.text('2. Add your first session'), findsOneWidget);
    expect(find.text('3. Review and go live'), findsOneWidget);
  });

  testWidgets('collects a coarse service area for online sessions', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await tester.tap(find.byKey(const ValueKey('nav-professionals')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Step 1 of 2 · Tell us the essentials. You do not need an account to get started.',
      ),
      findsOneWidget,
    );
    expect(find.text('What can someone book you to discuss?'), findsNothing);
    expect(
      find.text(
        'All sessions are online. We only use your province and area to help people discover relevant professionals.',
      ),
      findsOneWidget,
    );

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Sam Professional');
    await tester.enterText(fields.at(1), 'sam@example.com');
    await tester.enterText(fields.at(2), 'Product Manager');
    await tester.enterText(fields.at(3), '8');
    await tester.enterText(fields.at(4), 'Sandton');
    final provinceField = find.byKey(const ValueKey('professional-province'));
    await tester.ensureVisible(provinceField);
    await tester.tap(provinceField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gauteng').last);
    await tester.pumpAndSettle();
    final continueButton = find.byKey(
      const ValueKey('professional-application-continue'),
    );
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.text('Set up your first session'), findsOneWidget);
  });

  testWidgets('returns home when the logo is tapped from professionals', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-professionals')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-brand')));
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });
}
