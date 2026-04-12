import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The About header link routes to the dedicated About page.
// - The About page renders its headline and the three content cards.
// - The Home header item routes back to the landing page.
// - The logo click also routes back to the landing page.
void main() {
  testWidgets('navigates to the about page from the header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('About').first);
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
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('About').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').first);
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });

  testWidgets('returns home when the logo is tapped from the about page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('About').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('TryMyDay').first);
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });
}
