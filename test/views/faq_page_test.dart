import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

// Covered scenarios:
// - The FAQ header link routes to the dedicated FAQ page.
// - FAQ answers are collapsed by default.
// - Tapping a question expands its answer.
// - Tapping the same question again collapses the answer.
void main() {
  Future<void> pumpDesktopApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const TryMyDayApp());
    await tester.pumpAndSettle();
  }

  testWidgets('navigates to the faq page and expands an answer', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);

    await tester.tap(find.byKey(const ValueKey('nav-faq')));
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
