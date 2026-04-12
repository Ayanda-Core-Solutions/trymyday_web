import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trymyday_web/app.dart';
import 'package:trymyday_web/core/utils/app_images.dart';

// Covered scenarios:
// - The landing page renders the main hero and key marketing sections.
// - Primary CTAs and store download buttons are visible on first load.
// - The phone preview screenshot asset is loaded into the home hero.
void main() {
  testWidgets('renders the home page with its core sections', (
    WidgetTester tester,
  ) async {
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

  testWidgets('loads the phone preview asset in the hero showcase', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TryMyDayApp());

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == AppImages.phonePreview,
      ),
      findsOneWidget,
    );
  });
}
