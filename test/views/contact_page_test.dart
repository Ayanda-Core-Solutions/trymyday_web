import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The Contact Us header link routes to the dedicated contact page.
// - The page renders the support form and the topics panel.
// - The Home header item routes back to the landing page from contact.
void main() {
  testWidgets('navigates to the contact page from the header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('Contact Us').first);
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
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('Contact Us').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').first);
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });
}
