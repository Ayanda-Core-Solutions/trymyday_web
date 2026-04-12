import 'package:flutter/material.dart';

import 'core/utils/app_colors.dart';
import 'views/home/home_page.dart';

class TryMyDayApp extends StatelessWidget {
  const TryMyDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);

    return MaterialApp(
      title: 'TryMyDay',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
        textTheme: baseTheme.textTheme.apply(
          fontFamily: 'Trebuchet MS',
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => const HomePage(),
        aboutRoute: (context) => const AboutPage(),
        faqRoute: (context) => const FaqPage(),
        contactRoute: (context) => const ContactPage(),
        professionalsRoute: (context) => const ProfessionalsPage(),
      },
    );
  }
}
