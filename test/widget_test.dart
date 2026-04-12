// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

void main() {
  testWidgets('renders TryMyDay landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const TryMyDayApp());

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
    expect(
      find.text('From search to session in four simple steps.'),
      findsOneWidget,
    );
    expect(
      find.text('Share what you know.\nHelp someone move faster.'),
      findsOneWidget,
    );
    expect(find.text('Get the App'), findsOneWidget);
    expect(find.text('App Store'), findsOneWidget);
    expect(find.text('Google Play'), findsOneWidget);
  });

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
  });

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
}
