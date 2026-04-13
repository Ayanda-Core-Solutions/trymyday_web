import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The About header link routes to the dedicated About page.
// - The About page renders its headline and the three content cards.
// - The Home header item routes back to the landing page.
// - The logo click also routes back to the landing page.
void main() {
  Future<void> pumpDesktopApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const TryMyDayApp());
    await tester.pumpAndSettle();
  }

  testWidgets('navigates to the about page from the header', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-about')));
    await tester.pumpAndSettle();

    expect(find.text('About TryMyDay'), findsOneWidget);
    expect(
      find.text(
        'Helping people access the kind of advice that changes direction.',
      ),
      findsOneWidget,
    );
    expect(find.text('Our mission'), findsOneWidget);
    expect(find.text('Our Promise'), findsOneWidget);
    expect(find.text('Who it’s for'), findsOneWidget);
  });

  testWidgets('returns home when Home is tapped from the about page', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-about')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-home')));
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });

  testWidgets('returns home when the logo is tapped from the about page', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-about')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-brand')));
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });
}
