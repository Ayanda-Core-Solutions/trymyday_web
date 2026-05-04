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
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            ValueListenableBuilder<bool>(
              valueListenable: PageLoadingController.isVisible,
              builder: (context, isVisible, _) {
                return IgnorePointer(
                  ignoring: !isVisible,
                  child: TickerMode(
                    enabled: isVisible,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 160),
                      opacity: isVisible ? 1 : 0,
                      child: Container(
                        color: AppColors.primary.withValues(alpha: 0.22),
                        alignment: Alignment.center,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 24,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => const HomePage(),
        aboutRoute: (context) => const AboutPage(),
        faqRoute: (context) => const FaqPage(),
        contactRoute: (context) => const ContactPage(),
        professionalsRoute: (context) => const ProfessionalsPage(),
        privacyPolicyRoute: (context) => const PrivacyPolicyPage(),
        termsConditionsRoute: (context) => const TermsConditionsPage(),
        refundsPolicyRoute: (context) => const RefundsCancellationPolicyPage(),
      },
    );
  }
}
