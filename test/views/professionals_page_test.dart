import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The For Professionals header link routes to the dedicated page.
// - The page renders the main hero copy and the three professional benefit cards.
// - The logo remains usable as a global way back to the landing page.
void main() {
  testWidgets('navigates to the professionals page from the header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('For Professionals').first);
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
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('For Professionals').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('TryMyDay').first);
    await tester.pumpAndSettle();

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
  });
}
