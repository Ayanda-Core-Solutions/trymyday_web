import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/views/launch/launch_countdown_page.dart';

void main() {
  testWidgets('renders the launch countdown screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LaunchCountdownPage(
          launchAt: DateTime.now().add(const Duration(days: 12, hours: 3)),
        ),
      ),
    );

    expect(find.text('TryMyDay launches June 1.'), findsOneWidget);
    expect(find.text('Days'), findsOneWidget);
    expect(find.text('Hours'), findsOneWidget);
    expect(find.text('Minutes'), findsOneWidget);
    expect(find.text('Seconds'), findsOneWidget);
  });
}
