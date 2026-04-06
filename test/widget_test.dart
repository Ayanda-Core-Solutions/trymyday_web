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
}
