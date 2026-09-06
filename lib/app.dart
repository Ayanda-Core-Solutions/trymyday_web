import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/utils/app_colors.dart';
import 'core/config/app_environment.dart';
import 'views/launch/launch_countdown_page.dart';
import 'views/home/home_page.dart';

const String launchRoute = '/launch';

class TryMyDayApp extends StatelessWidget {
  const TryMyDayApp({super.key});

  static final GoRouter _router = GoRouter(
    redirect: (context, state) {
      final launchGate = _LaunchGate.fromEnvironment();
      final isLaunchRoute = state.uri.path == launchRoute;

      if (!launchGate.isActive) {
        return isLaunchRoute ? homeRoute : null;
      }

      if (launchGate.hasAdminAccess(state.uri)) {
        _LaunchGateSession.unlock();
        return isLaunchRoute ? homeRoute : null;
      }

      if (_LaunchGateSession.isUnlocked) return null;

      return isLaunchRoute ? null : launchRoute;
    },
    routes: [
      GoRoute(
        path: launchRoute,
        pageBuilder: (context, state) => _fadePage(
          state,
          LaunchCountdownPage(launchAt: _LaunchGate.fromEnvironment().endAt),
        ),
      ),
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
        path: professionalProfileRoute,
        pageBuilder: (context, state) {
          final professionalId = state.pathParameters['id']!;
          return _fadePage(
            state,
            ProfessionalPublicProfilePage(professionalId: professionalId),
          );
        },
      ),
      GoRoute(
        path: authMagicLinkRoute,
        pageBuilder: (context, state) => _fadePage(
          state,
          AuthMagicLinkPage(token: state.uri.queryParameters['token']),
        ),
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
      GoRoute(
        path: accountDeletionRoute,
        pageBuilder: (context, state) =>
            _fadePage(state, const AccountDeletionPage()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);

    return MaterialApp.router(
      title: 'TryMyDay | Career Guidance from Experienced Professionals',
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

class _LaunchGate {
  const _LaunchGate({
    required this.isEnabled,
    required this.endAt,
    required this.adminToken,
  });

  factory _LaunchGate.fromEnvironment() {
    return _LaunchGate(
      isEnabled: AppEnvironment.launchGateEnabled,
      endAt: DateTime.parse(AppEnvironment.launchGateEndAt),
      adminToken: AppEnvironment.launchGateAdminToken.trim(),
    );
  }

  final bool isEnabled;
  final DateTime endAt;
  final String adminToken;

  bool get isActive => isEnabled && DateTime.now().isBefore(endAt);

  bool hasAdminAccess(Uri uri) {
    if (adminToken.isEmpty) return false;

    final token =
        uri.queryParameters['admin'] ?? uri.queryParameters['preview'];

    return token == adminToken;
  }
}

class _LaunchGateSession {
  static bool isUnlocked = false;

  static void unlock() {
    isUnlocked = true;
  }
}
