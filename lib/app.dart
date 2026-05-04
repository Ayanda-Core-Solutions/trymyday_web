import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/utils/app_colors.dart';
import 'views/home/home_page.dart';

class TryMyDayApp extends StatelessWidget {
  const TryMyDayApp({super.key});

  static final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: homeRoute,
        pageBuilder: (context, state) => _fadePage(
          state,
          HomePage(initialTarget: _homeTargetFromUri(state.uri)),
        ),
      ),
      GoRoute(
        path: aboutRoute,
        pageBuilder: (context, state) => _fadePage(state, const AboutPage()),
      ),
      GoRoute(
        path: faqRoute,
        pageBuilder: (context, state) => _fadePage(
          state,
          FaqPage(initialExpandedTopicSlug: state.uri.queryParameters['topic']),
        ),
      ),
      GoRoute(
        path: contactRoute,
        pageBuilder: (context, state) => _fadePage(state, const ContactPage()),
      ),
      GoRoute(
        path: professionalsRoute,
        pageBuilder: (context, state) =>
            _fadePage(state, const ProfessionalsPage()),
      ),
      GoRoute(
        path: privacyPolicyRoute,
        pageBuilder: (context, state) =>
            _fadePage(state, const PrivacyPolicyPage()),
      ),
      GoRoute(
        path: termsConditionsRoute,
        pageBuilder: (context, state) =>
            _fadePage(state, const TermsConditionsPage()),
      ),
      GoRoute(
        path: refundsPolicyRoute,
        pageBuilder: (context, state) =>
            _fadePage(state, const RefundsCancellationPolicyPage()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);

    return MaterialApp.router(
      title: 'TryMyDay',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
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
                        child: TickerMode(
                          enabled: isVisible,
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
    );
  }

  static Page<void> _fadePage(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static HomeScrollTarget? _homeTargetFromUri(Uri uri) {
    return switch (uri.queryParameters['target']) {
      homeTargetHowItWorks => HomeScrollTarget.howItWorks,
      homeTargetAppStores => HomeScrollTarget.appStores,
      _ => null,
    };
  }
}
