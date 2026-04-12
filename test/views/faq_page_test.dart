import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The FAQ header link routes to the dedicated FAQ page.
// - FAQ answers are collapsed by default.
// - Tapping a question expands its answer.
// - Tapping the same question again collapses the answer.
void main() {
  testWidgets('navigates to the faq page and expands an answer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TryMyDayApp());

    await tester.tap(find.text('FAQ').first);
    await tester.pumpAndSettle();

    expect(find.text('Helpful answers before you book.'), findsOneWidget);
    expect(find.text('What is a free coffee chat?'), findsOneWidget);
    expect(
      find.text(
        'A short casual video or voice conversation that helps you ask quick questions before committing to a paid session.',
      ),
      findsNothing,
    );

    await tester.ensureVisible(find.text('What is a free coffee chat?'));
    await tester.tap(find.text('What is a free coffee chat?'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'A short casual video or voice conversation that helps you ask quick questions before committing to a paid session.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('What is a free coffee chat?'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'A short casual video or voice conversation that helps you ask quick questions before committing to a paid session.',
      ),
      findsNothing,
    );
  });
}
