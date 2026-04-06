// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';

void main() {
  testWidgets('renders TryMyDay landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const TryMyDayApp());

    expect(find.text('Guidance that\ngets you there.'), findsOneWidget);
    expect(
      find.text('Simple on the surface.\nUseful when it counts.'),
      findsOneWidget,
    );
    expect(
      find.text('Share what you know.\nHelp someone move faster.'),
      findsOneWidget,
    );
    expect(find.text('Get the App'), findsOneWidget);
    expect(find.byIcon(Icons.apple), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });
}
