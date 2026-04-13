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
    expect(find.text('Build your profile'), findsOneWidget);
    expect(find.text('Set availability'), findsOneWidget);
    expect(find.text('Earn while giving back'), findsOneWidget);
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
