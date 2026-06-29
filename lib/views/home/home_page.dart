import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../core/config/app_environment.dart';
import '../../core/components/store_button.dart';
import '../../core/services/contact_email_service.dart';
import '../../core/services/app_remote_config.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/external_link.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/app_images.dart';

part '../../core/components/layout/footer.dart';
part '../../core/components/layout/page_shell.dart';
part '../about/about_page.dart';
part '../about/about_section.dart';
part '../auth/auth_magic_link_page.dart';
part '../contact/contact_page.dart';
part '../contact/contact_section.dart';
part '../faq/faq_page.dart';
part '../faq/faq_section.dart';
part '../legal/legal_pages.dart';
part '../professionals/professional_public_profile_page.dart';
part '../professionals/professionals_page.dart';
part '../professionals/professionals_section.dart';
part 'sections/hero_section.dart';
part 'sections/how_it_works_section.dart';

const String homeRoute = '/';
const String aboutRoute = '/about';
const String faqRoute = '/faq';
const String contactRoute = '/contact';
const String professionalsRoute = '/professionals';
const String professionalProfileRoute = '/meet/:id';
const String authMagicLinkRoute = '/auth/magic';
const String privacyPolicyRoute = '/privacy-policy';
const String termsConditionsRoute = '/terms-and-conditions';
const String refundsPolicyRoute = '/refunds-cancellation-policy';
const String homeTargetHowItWorks = 'how-it-works';
const String homeTargetAppStores = 'app-stores';

String _homeLocation({HomeScrollTarget? target}) {
  final targetValue = switch (target) {
    HomeScrollTarget.howItWorks => homeTargetHowItWorks,
    HomeScrollTarget.appStores => homeTargetAppStores,
    null => null,
  };

  if (targetValue == null) return homeRoute;

  return Uri(
    path: homeRoute,
    queryParameters: {'target': targetValue},
  ).toString();
}

String _faqTopicLocation(String topicSlug) {
  return Uri(path: faqRoute, queryParameters: {'topic': topicSlug}).toString();
}

String _currentRoutePath(BuildContext context) {
  return GoRouterState.of(context).uri.path;
}

class _Breakpoints {
  static const double md = 720;
  static const double navCompact = 900;
  static const double heroWide = 980;
  static const double heroShowcaseCompact = 1020;
  static const double lg = 1040;
  static const double phoneCompact = 420;
  static const double howItWorksGrid = 680;
  static const double heroCompactActions = 560;
}

class PageLoadingController {
  static final ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);

  static void show() => isVisible.value = true;

  static void hide() => isVisible.value = false;
}

Future<void> _scrollToTarget(
  BuildContext targetContext, {
  required double viewportAlignment,
}) async {
  final renderObject = targetContext.findRenderObject();
  if (renderObject is! RenderBox) return;

  final scrollableState = Scrollable.of(targetContext);

  final viewport = RenderAbstractViewport.of(renderObject);

  final position = scrollableState.position;
  final targetOffset = viewport
      .getOffsetToReveal(renderObject, viewportAlignment)
      .offset;
  final clampedOffset = targetOffset.clamp(
    position.minScrollExtent,
    position.maxScrollExtent,
  );

  await position.animateTo(
    clampedOffset,
    duration: const Duration(milliseconds: 320),
    curve: Curves.easeOutCubic,
  );
}

class _AppStoreLinks {
  static final Uri appStore = Uri.parse(
    'https://apps.apple.com/us/search?term=TryMyDay',
  );
  static final Uri googlePlay = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.acs.trymyday',
  );
}

bool _isPhoneDevice(BuildContext context) {
  final shortestSide = MediaQuery.sizeOf(context).shortestSide;
  return shortestSide < 700;
}

bool _isAndroidPhone(BuildContext context) {
  return _isPhoneDevice(context) &&
      defaultTargetPlatform == TargetPlatform.android;
}

bool _isIosPhone(BuildContext context) {
  return _isPhoneDevice(context) && defaultTargetPlatform == TargetPlatform.iOS;
}

Future<void> _launchGooglePlay() async {
  await openExternalUrl(_AppStoreLinks.googlePlay);
}

Future<void> _launchAppStore() async {
  await openExternalUrl(_AppStoreLinks.appStore);
}

Uri? _storeUriForPhone(BuildContext context) {
  if (_isAndroidPhone(context)) {
    return _AppStoreLinks.googlePlay;
  }

  if (_isIosPhone(context)) {
    return _AppStoreLinks.appStore;
  }

  return null;
}

enum HomeScrollTarget { howItWorks, appStores }

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.initialTarget});

  final HomeScrollTarget? initialTarget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _LandingPage(initialTarget: initialTarget));
  }
}

class _LandingPage extends StatefulWidget {
  const _LandingPage({this.initialTarget});

  final HomeScrollTarget? initialTarget;

  @override
  State<_LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<_LandingPage> {
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _appStoresKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = switch (widget.initialTarget) {
        HomeScrollTarget.howItWorks => _howItWorksKey.currentContext,
        HomeScrollTarget.appStores => _appStoresKey.currentContext,
        null => null,
      };

      if (targetContext != null) {
        final viewportAlignment = switch (widget.initialTarget) {
          HomeScrollTarget.howItWorks => 0.02,
          HomeScrollTarget.appStores => 0.42,
          null => 0.02,
        };

        _scrollToTarget(targetContext, viewportAlignment: viewportAlignment);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      selectedNav: _NavDestination.home,
      children: [
        _HeroSection(appStoresKey: _appStoresKey),
        KeyedSubtree(key: _howItWorksKey, child: const _HowItWorksSection()),
        const _Footer(),
      ],
    );
  }
}
