import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../core/components/store_button.dart';
import '../../core/services/app_remote_config.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/external_link.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/app_images.dart';

part 'about_page.dart';
part 'contact_page.dart';
part 'faq_page.dart';
part 'legal_pages.dart';
part 'professionals_page.dart';

const String homeRoute = '/';
const String aboutRoute = '/about';
const String faqRoute = '/faq';
const String contactRoute = '/contact';
const String professionalsRoute = '/professionals';
const String privacyPolicyRoute = '/privacy-policy';
const String termsConditionsRoute = '/terms-and-conditions';
const String refundsPolicyRoute = '/refunds-cancellation-policy';

class _Breakpoints {
  static const double md = 720;
  static const double navCompact = 900;
  static const double professionalsStack = 930;
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
  final targetOffset =
      viewport.getOffsetToReveal(renderObject, viewportAlignment).offset;
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

        _scrollToTarget(
          targetContext,
          viewportAlignment: viewportAlignment,
        );
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
        const _ForProfessionalsSection(),
        const _Footer(),
      ],
    );
  }
}

class _PageShell extends StatefulWidget {
  const _PageShell({required this.selectedNav, required this.children});

  final _NavDestination? selectedNav;
  final List<Widget> children;

  @override
  State<_PageShell> createState() => _PageShellState();
}

class _PageShellState extends State<_PageShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PageLoadingController.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FBF5), Color(0xFFF3F7F0), Color(0xFFF8F8F2)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _Header(selectedNav: widget.selectedNav),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: widget.children),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _NavDestination { home, about, faq, contact, professionals }

enum _HeaderMenuAction { home, about, howItWorks, professionals, faq, contact }

class _Header extends StatelessWidget {
  const _Header({required this.selectedNav});

  final _NavDestination? selectedNav;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.45)),
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.65)),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120B2F2B),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1360),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < _Breakpoints.navCompact;
              final navSpacing = constraints.maxWidth < 1280 ? 20.0 : 36.0;
              final actionGap = constraints.maxWidth < 1280 ? 24.0 : 42.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 20 : 48,
                  vertical: compact ? 18 : 14,
                ),
                child: compact
                    ? Row(
                        children: [
                          Expanded(
                            child: _Brand(
                              key: const ValueKey('nav-brand'),
                              onTap: () => _goHome(context),
                            ),
                          ),
                          PopupMenuButton<_HeaderMenuAction>(
                            tooltip: 'Open menu',
                            color: AppColors.surface,
                            surfaceTintColor: AppColors.surface,
                            elevation: 8,
                            position: PopupMenuPosition.under,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            icon: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.menu_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            onSelected: (action) {
                              switch (action) {
                                case _HeaderMenuAction.home:
                                  _goHome(context);
                                case _HeaderMenuAction.about:
                                  _goAbout(context);
                                case _HeaderMenuAction.howItWorks:
                                  _goHowItWorks(context);
                                case _HeaderMenuAction.professionals:
                                  _goProfessionals(context);
                                case _HeaderMenuAction.faq:
                                  _goFaq(context);
                                case _HeaderMenuAction.contact:
                                  _goContact(context);
                              }
                            },
                            itemBuilder: (context) => [
                              _mobileMenuItem(
                                label: 'Home',
                                value: _HeaderMenuAction.home,
                                active: selectedNav == _NavDestination.home,
                              ),
                              _mobileMenuItem(
                                label: 'About',
                                value: _HeaderMenuAction.about,
                                active: selectedNav == _NavDestination.about,
                              ),
                              if (selectedNav != _NavDestination.home)
                                _mobileMenuItem(
                                  label: 'How it works',
                                  value: _HeaderMenuAction.howItWorks,
                                ),
                              _mobileMenuItem(
                                label: 'For Professionals',
                                value: _HeaderMenuAction.professionals,
                                active:
                                    selectedNav ==
                                    _NavDestination.professionals,
                              ),
                              _mobileMenuItem(
                                label: 'FAQ',
                                value: _HeaderMenuAction.faq,
                                active: selectedNav == _NavDestination.faq,
                              ),
                              _mobileMenuItem(
                                label: 'Contact Us',
                                value: _HeaderMenuAction.contact,
                                active: selectedNav == _NavDestination.contact,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          _Brand(
                            key: const ValueKey('nav-brand'),
                            onTap: () => _goHome(context),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _NavItem(
                                          key: const ValueKey('nav-home'),
                                          label: 'Home',
                                          active:
                                              selectedNav ==
                                              _NavDestination.home,
                                          onTap: () => _goHome(context),
                                        ),
                                        SizedBox(width: navSpacing),
                                        _NavItem(
                                          key: const ValueKey('nav-about'),
                                          label: 'About',
                                          active:
                                              selectedNav ==
                                              _NavDestination.about,
                                          onTap: () => _goAbout(context),
                                        ),
                                        if (selectedNav != _NavDestination.home)
                                          SizedBox(width: navSpacing),
                                        if (selectedNav != _NavDestination.home)
                                          _NavItem(
                                            key: const ValueKey(
                                              'nav-how-it-works',
                                            ),
                                            label: 'How it works',
                                            onTap: () => _goHowItWorks(context),
                                          ),
                                        SizedBox(width: navSpacing),
                                        _NavItem(
                                          key: const ValueKey(
                                            'nav-professionals',
                                          ),
                                          label: 'For Professionals',
                                          active:
                                              selectedNav ==
                                              _NavDestination.professionals,
                                          onTap: () =>
                                              _goProfessionals(context),
                                        ),
                                        SizedBox(width: navSpacing),
                                        _NavItem(
                                          key: const ValueKey('nav-faq'),
                                          label: 'FAQ',
                                          active:
                                              selectedNav ==
                                              _NavDestination.faq,
                                          onTap: () => _goFaq(context),
                                        ),
                                        SizedBox(width: navSpacing),
                                        _NavItem(
                                          key: const ValueKey('nav-contact'),
                                          label: 'Contact Us',
                                          active:
                                              selectedNav ==
                                              _NavDestination.contact,
                                          onTap: () => _goContact(context),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: actionGap),
                                    const _GetAppButton(
                                      key: ValueKey('header-get-app'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == homeRoute || currentRoute == null) {
      return;
    }
    _replaceWithFade(context, const HomePage());
  }

  void _goAbout(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == aboutRoute) {
      return;
    }
    _replaceWithFade(context, const AboutPage(), routeName: aboutRoute);
  }

  void _goHowItWorks(BuildContext context) {
    _replaceWithFade(
      context,
      const HomePage(initialTarget: HomeScrollTarget.howItWorks),
      routeName: homeRoute,
    );
  }

  void _goProfessionals(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == professionalsRoute) {
      return;
    }
    _replaceWithFade(
      context,
      const ProfessionalsPage(),
      routeName: professionalsRoute,
    );
  }

  void _goFaq(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == faqRoute) {
      return;
    }
    _replaceWithFade(context, const FaqPage(), routeName: faqRoute);
  }

  void _goContact(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == contactRoute) {
      return;
    }
    _replaceWithFade(context, const ContactPage(), routeName: contactRoute);
  }

  void _replaceWithFade(
    BuildContext context,
    Widget page, {
    String routeName = homeRoute,
  }) {
    PageLoadingController.show();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        settings: RouteSettings(name: routeName),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 180),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  PopupMenuItem<_HeaderMenuAction> _mobileMenuItem({
    required String label,
    required _HeaderMenuAction value,
    bool active = false,
  }) {
    return PopupMenuItem<_HeaderMenuAction>(
      value: value,
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 15,
          fontWeight: active ? FontWeight.w900 : FontWeight.w700,
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: _BrandLockup(),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({
    this.iconAsset = AppImages.smileyWhite,
    this.textColor = AppColors.primary,
    this.iconSize = 40,
    this.fontSize = 22,
    this.iconBackground,
    this.iconColor = Colors.white,
  });

  final String iconAsset;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final Color? iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final background = iconBackground ?? AppColors.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          padding: EdgeInsets.all(iconSize * 0.14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(iconSize * 0.36),
          ),
          child: SvgPicture.asset(
            iconAsset,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        SizedBox(width: iconSize * 0.28),
        Text(
          'TryMyDay',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            decoration: active ? TextDecoration.underline : null,
            decorationColor: AppColors.primary,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}

class _GetAppButton extends StatelessWidget {
  const _GetAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _InteractiveGetAppButton(onTap: () => _handleGetApp(context));
  }

  Future<void> _handleGetApp(BuildContext context) async {
    final storeUri = _storeUriForPhone(context);
    if (storeUri != null) {
      await openExternalUrl(storeUri);
      return;
    }

    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == homeRoute || currentRoute == null) {
      final targetContext =
          AppDownloadSectionController.targetKey.currentContext;
      if (targetContext != null) {
        _scrollToTarget(
          targetContext,
          viewportAlignment: 0.42,
        );
      }
      return;
    }

    PageLoadingController.show();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        settings: const RouteSettings(name: homeRoute),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(initialTarget: HomeScrollTarget.appStores),
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 180),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class AppDownloadSectionController {
  static final GlobalKey targetKey = GlobalKey();
}

class _InteractiveGetAppButton extends StatefulWidget {
  const _InteractiveGetAppButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_InteractiveGetAppButton> createState() =>
      _InteractiveGetAppButtonState();
}

class _InteractiveGetAppButtonState extends State<_InteractiveGetAppButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        scale: _pressed ? 0.97 : (_hovered ? 1.015 : 1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(
                  alpha: _hovered ? 0.2 : 0.12,
                ),
                blurRadius: _hovered ? 20 : 16,
                offset: Offset(0, _hovered ? 12 : 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: _pressed
                    ? const Color(0xFFD2D846)
                    : (_hovered
                          ? const Color(0xFFE8EE61)
                          : AppColors.secondary),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(
                    alpha: _hovered ? 0.14 : 0.08,
                  ),
                ),
              ),
              child: InkWell(
                onTap: widget.onTap,
                onHighlightChanged: (value) {
                  if (_pressed != value) {
                    setState(() => _pressed = value);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: AppColors.primary.withValues(alpha: 0.12),
                highlightColor: AppColors.primary.withValues(alpha: 0.08),
                hoverColor: AppColors.primary.withValues(alpha: 0.04),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Text(
                    'Get the App',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.appStoresKey});

  final GlobalKey appStoresKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= _Breakpoints.heroWide;
              final compactButtons =
                  constraints.maxWidth < _Breakpoints.heroCompactActions;
              final compactStats =
                  constraints.maxWidth < _Breakpoints.heroCompactActions;
              final nearbyBadgeCount =
                  AppRemoteConfig.instance.nearbyBadgeCount;

              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guidance that\ngets you there.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: wide ? 72 : 48,
                      height: 0.95,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: const Text(
                      'Book sessions with experienced professionals ready to share insights, advice, and honest perspective on the path you want to take.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 19,
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  KeyedSubtree(
                    key: appStoresKey,
                    child: compactButtons
                        ? Row(
                            children: [
                              Expanded(
                                child: StoreButton(
                                  icon: AppIcons.apple,
                                  upperLabel: 'Download on the',
                                  lowerLabel: 'App Store',
                                  compact: true,
                                  onTap: _launchAppStore,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StoreButton(
                                  icon: AppIcons.googlePlay,
                                  upperLabel: 'Get it on',
                                  lowerLabel: 'Google Play',
                                  compact: true,
                                  onTap: _launchGooglePlay,
                                ),
                              ),
                            ],
                          )
                        : Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              StoreButton(
                                icon: AppIcons.apple,
                                upperLabel: 'Download on the',
                                lowerLabel: 'App Store',
                                onTap: _launchAppStore,
                              ),
                              StoreButton(
                                icon: AppIcons.googlePlay,
                                upperLabel: 'Get it on',
                                lowerLabel: 'Google Play',
                                onTap: _launchGooglePlay,
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 24),
                  compactStats
                      ? Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: _StatCard(
                                title: 'Nearby',
                                body: 'professionals',
                                badgeText: nearbyBadgeCount != null
                                    ? '+$nearbyBadgeCount'
                                    : null,
                                compact: true,
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: const _StatCard(
                                title: 'Paid',
                                body: 'deeper sessions',
                                compact: true,
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: const _StatCard(
                                title: 'Free',
                                body: 'coffee chats',
                                compact: true,
                              ),
                            ),
                          ],
                        )
                      : Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            _StatCard(
                              title: 'Nearby',
                              body: 'professionals',
                              badgeText: nearbyBadgeCount != null
                                  ? '+$nearbyBadgeCount'
                                  : null,
                            ),
                            const _StatCard(
                              title: 'Paid',
                              body: 'deeper sessions',
                            ),
                            const _StatCard(
                              title: 'Free',
                              body: 'coffee chats',
                            ),
                          ],
                        ),
                ],
              );

              final visual = _PhoneShowcase(
                compactVisual:
                    constraints.maxWidth < _Breakpoints.heroShowcaseCompact,
              );

              return wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 11, child: copy),
                        const SizedBox(width: 32),
                        Expanded(flex: 9, child: visual),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        copy,
                        const SizedBox(height: 36),
                        Align(alignment: Alignment.center, child: visual),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.body,
    this.badgeText,
    this.compact = false,
  });

  final String title;
  final String body;
  final String? badgeText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? null : 184,
      padding: EdgeInsets.all(compact ? 16 : 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: compact ? 22 : 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: compact ? 16 : 18,
                  height: 1.25,
                ),
              ),
            ],
          ),
          if (badgeText != null)
            Positioned(
              top: -6,
              right: -2,
              child: Container(
                width: compact ? 38 : 44,
                height: compact ? 38 : 44,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: compact ? 11 : 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PhoneShowcase extends StatelessWidget {
  const _PhoneShowcase({this.compactVisual = false});

  final bool compactVisual;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const baseFrameWidth = 340.0;
        const baseFrameHeight = 636.0;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : baseFrameWidth;
        final compact =
            compactVisual || availableWidth < _Breakpoints.phoneCompact;
        final scale = compact
            ? (availableWidth / baseFrameWidth).clamp(0.82, 1.0)
            : 1.0;
        final frameWidth = baseFrameWidth * scale;
        final frameHeight = baseFrameHeight * scale;
        final stageHeight = compact ? frameHeight + 56 : 680.0;
        final glowSize = compact ? 300.0 * scale : 470.0;
        final glowBottom = compact ? 8.0 : 0.0;

        return SizedBox(
          height: stageHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: glowBottom,
                child: Container(
                  width: glowSize,
                  height: glowSize,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      237,
                      241,
                      103,
                    ).withValues(alpha: compact ? 0.36 : 0.62),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0x40D5DF51,
                        ).withValues(alpha: compact ? 0.22 : 0.36),
                        blurRadius: compact ? 36 : 70,
                        spreadRadius: compact ? 0 : 8,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: frameWidth,
                height: frameHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!compact) ...const [
                      Positioned(
                        left: 6,
                        top: 128,
                        child: _PhoneSideButton(height: 34, width: 6),
                      ),
                      Positioned(
                        left: 6,
                        top: 182,
                        child: _PhoneSideButton(height: 64, width: 6),
                      ),
                      Positioned(
                        left: 6,
                        top: 262,
                        child: _PhoneSideButton(height: 64, width: 6),
                      ),
                      Positioned(
                        right: 6,
                        top: 208,
                        child: _PhoneSideButton(height: 92, width: 6),
                      ),
                    ],
                    Container(
                      width: 324 * scale,
                      height: frameHeight,
                      padding: EdgeInsets.all(4 * scale),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1A18),
                        borderRadius: BorderRadius.circular(52 * scale),
                        border: Border.all(
                          color: const Color(0xFFB7792D),
                          width: compact ? 1.8 : 2.6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0x4D000000,
                            ).withValues(alpha: compact ? 0.18 : 0.30),
                            blurRadius: compact ? 18 : 42,
                            offset: Offset(compact ? 0 : 18, compact ? 12 : 26),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(44 * scale),
                        ),
                        child: Stack(
                          children: [
                            const Positioned.fill(child: _PhoneScreen()),
                            Positioned(
                              top: 14 * scale,
                              left: 0,
                              right: 0,
                              child: const Center(child: _PhoneNotch()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhoneSideButton extends StatelessWidget {
  const _PhoneSideButton({required this.height, this.width = 6});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFB7792D),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _PhoneNotch extends StatelessWidget {
  const _PhoneNotch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98,
      height: 26,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF2A2435),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _PhoneScreen extends StatelessWidget {
  const _PhoneScreen();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(44),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8F8F5),
                  Color(0xFFF8F8F5),
                  Color(0xFF8DD3E7),
                  Color(0xFFF7F8F4),
                ],
                stops: [0.0, 0.16, 0.42, 1.0],
              ),
            ),
          ),
          Image.asset(
            AppImages.phonePreview,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            gaplessPlayback: true,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  child: child,
                );
              }

              return const SizedBox.expand();
            },
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    const cards = [
      (
        icon: Icons.gps_fixed_rounded,
        title: 'Our mission',
        body:
            'Make quality career insight easier to reach by connecting curiosity with lived professional experience.',
      ),
      (
        icon: Icons.handshake_outlined,
        title: 'Our Promise',
        body:
            'Real professionals. Real conversations. Real context for the decisions people make about their future.',
      ),
      (
        icon: Icons.groups_2_outlined,
        title: 'Who it’s for',
        body:
            'Students, graduates, career switchers, and anyone who needs clarity before making their next move.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= _Breakpoints.lg;
              final isMedium = constraints.maxWidth >= _Breakpoints.md;

              Widget cardsLayout;
              if (isWide) {
                cardsLayout = IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(cards.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == cards.length - 1 ? 0 : 18,
                          ),
                          child: _AboutCard(
                            icon: cards[index].icon,
                            title: cards[index].title,
                            body: cards[index].body,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              } else if (isMedium) {
                cardsLayout = Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: cards
                      .map(
                        (card) => SizedBox(
                          width: (constraints.maxWidth - 18) / 2,
                          child: _AboutCard(
                            icon: card.icon,
                            title: card.title,
                            body: card.body,
                          ),
                        ),
                      )
                      .toList(),
                );
              } else {
                cardsLayout = Column(
                  children: List.generate(cards.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == cards.length - 1 ? 0 : 18,
                      ),
                      child: _AboutCard(
                        icon: cards[index].icon,
                        title: cards[index].title,
                        body: cards[index].body,
                      ),
                    );
                  }),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About TryMyDay',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Helping people access the kind of advice that changes direction.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: isWide ? 64 : 44,
                      height: 1.02,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                    ),
                  ),
                  const SizedBox(height: 26),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: const Text(
                      'TryMyDay exists to make career guidance more human, more accessible, and more practical. Instead of guessing what a role is really like, users can connect directly with professionals and hear it from someone doing the work.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 19,
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  cardsLayout,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < _Breakpoints.lg;

    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          compact
              ? Row(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: Colors.white, size: 34),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: Colors.white, size: 46),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
          SizedBox(height: compact ? 16 : 18),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessionalsHeroSection extends StatelessWidget {
  const _ProfessionalsHeroSection();

  @override
  Widget build(BuildContext context) {
    const cards = [
      (
        icon: Icons.badge_outlined,
        title: 'Build your profile',
        body:
            'Add your role, company, experience, highlights, and certifications to create trust.',
        highlighted: false,
      ),
      (
        icon: Icons.schedule_outlined,
        title: 'Set availability',
        body:
            'Create session windows, choose session type, set location, and define your hourly rate.',
        highlighted: false,
      ),
      (
        icon: Icons.paid_outlined,
        title: 'Earn while giving back',
        body:
            'Use free coffee chats for quick discovery and paid sessions for more focused mentorship.',
        highlighted: false,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= _Breakpoints.lg;
              final isMedium = constraints.maxWidth >= _Breakpoints.md;

              Widget cardsLayout;
              if (isWide) {
                cardsLayout = IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(cards.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == cards.length - 1 ? 0 : 18,
                          ),
                          child: _ProfessionalFeatureCard(
                            icon: cards[index].icon,
                            title: cards[index].title,
                            body: cards[index].body,
                            highlighted: cards[index].highlighted,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              } else if (isMedium) {
                cardsLayout = Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: cards
                      .map(
                        (card) => SizedBox(
                          width: (constraints.maxWidth - 18) / 2,
                          child: _ProfessionalFeatureCard(
                            icon: card.icon,
                            title: card.title,
                            body: card.body,
                            highlighted: card.highlighted,
                          ),
                        ),
                      )
                      .toList(),
                );
              } else {
                cardsLayout = Column(
                  children: List.generate(cards.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == cards.length - 1 ? 0 : 18,
                      ),
                      child: _ProfessionalFeatureCard(
                        icon: cards[index].icon,
                        title: cards[index].title,
                        body: cards[index].body,
                        highlighted: cards[index].highlighted,
                      ),
                    );
                  }),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'For Professionals',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Share your experience. Help someone move forward.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: isWide ? 64 : 44,
                      height: 1.02,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: const Text(
                      'Professionals can create profiles, set availability, offer quick coffee chats, and earn from paid sessions. This page is designed to feel credible and light, with enough structure to reassure busy experts that the platform is easy to manage.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 19,
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),
                  cardsLayout,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfessionalFeatureCard extends StatelessWidget {
  const _ProfessionalFeatureCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.highlighted,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < _Breakpoints.lg;

    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: highlighted ? const Color(0xFF2495F1) : AppColors.border,
          width: highlighted ? 4 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          compact
              ? Row(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: Colors.white, size: 34),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: Colors.white, size: 46),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
          SizedBox(height: compact ? 16 : 18),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        question: 'What is a free coffee chat?',
        answer:
            'A short casual video or voice conversation that helps you ask quick questions before committing to a paid session.',
      ),
      (
        question: 'How do I book a paid session?',
        answer:
            'Search for a professional, open their profile, review their availability, then select a paid booking option.',
      ),
      (
        question: 'Can I reschedule a session?',
        answer:
            'Yes, your activity and schedule areas are designed to support rescheduling where the booking terms allow it.',
      ),
      (
        question: 'Do professionals set their own rates?',
        answer:
            'Yes. Professionals can define their rates and availability from their side of the platform.',
      ),
      (
        question: 'How do I join a session?',
        answer:
            'When it’s time, go to your schedule area and tap into the session room.',
      ),
      (
        question: 'Can I book the same professional again?',
        answer:
            'Yes, the activity history encourages repeat bookings for ongoing mentorship and support.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FAQ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Helpful answers before you book.',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 64,
                  height: 1.02,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.8,
                ),
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: const Text(
                  'Aligned to the app’s booking, profile, coffee chat, scheduling, and payment patterns.',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 19,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 44),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= _Breakpoints.lg;
                  final isMedium = constraints.maxWidth >= _Breakpoints.md;

                  if (isWide) {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: items
                          .map(
                            (item) => SizedBox(
                              width: (constraints.maxWidth - 48) / 3,
                              child: _FaqCard(
                                question: item.question,
                                answer: item.answer,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }

                  if (isMedium) {
                    return Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: items
                          .map(
                            (item) => SizedBox(
                              width: (constraints.maxWidth - 18) / 2,
                              child: _FaqCard(
                                question: item.question,
                                answer: item.answer,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }

                  return Column(
                    children: items
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: _FaqCard(
                              question: item.question,
                              answer: item.answer,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqCard extends StatefulWidget {
  const _FaqCard({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedRotation(
                    turns: _expanded ? 0.125 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      _expanded ? Icons.close_rounded : Icons.add_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: _expanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: Text(
                          widget.answer,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            height: 1.45,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 980;

              final formCard = Expanded(
                flex: stacked ? 0 : 8,
                child: Container(
                  padding: const EdgeInsets.all(44),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send us a message',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 20),
                      _ContactFieldLabel(label: 'Name'),
                      SizedBox(height: 10),
                      _ContactInput(hintText: 'Your full name'),
                      SizedBox(height: 22),
                      _ContactFieldLabel(label: 'Email'),
                      SizedBox(height: 10),
                      _ContactInput(hintText: 'you@example.com'),
                      SizedBox(height: 22),
                      _ContactFieldLabel(label: 'How can we help?'),
                      SizedBox(height: 10),
                      _ContactInput(hintText: 'Tell us more...', maxLines: 5),
                      SizedBox(height: 18),
                      _ContactSubmitButton(),
                    ],
                  ),
                ),
              );

              final topicsCard = Expanded(
                flex: stacked ? 0 : 4,
                child: Container(
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support topics',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 20),
                      _SupportTopic(text: 'Booking issues'),
                      SizedBox(height: 14),
                      _SupportTopic(text: 'Account and profile help'),
                      SizedBox(height: 14),
                      _SupportTopic(text: 'Payments and refunds'),
                      SizedBox(height: 14),
                      _SupportTopic(text: 'Partnerships and media'),
                    ],
                  ),
                ),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Questions, support, or partnership enquiries.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: constraints.maxWidth >= _Breakpoints.lg
                          ? 64
                          : 44,
                      height: 1.02,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'The contact page is designed to feel light, trustworthy, and easy to use.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 19,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 34),
                  stacked
                      ? Column(
                          children: [
                            formCard,
                            const SizedBox(height: 24),
                            topicsCard,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formCard,
                            const SizedBox(width: 28),
                            topicsCard,
                          ],
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContactFieldLabel extends StatelessWidget {
  const _ContactFieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ContactInput extends StatelessWidget {
  const _ContactInput({required this.hintText, this.maxLines = 1});

  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF6B7484), fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: maxLines == 1 ? 16 : 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _ContactSubmitButton extends StatelessWidget {
  const _ContactSubmitButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SupportTopic extends StatelessWidget {
  const _SupportTopic({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 18,
        height: 1.35,
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        title: 'Search',
        body:
            'Browse professionals by field, company, interest, distance, price, or availability.',
      ),
      (
        title: 'Discover',
        body:
            'Open profiles to learn about their background, highlights, certifications, and session options.',
      ),
      (
        title: 'Connect',
        body:
            'Start with a free coffee chat for quick insight or book a paid session for more depth.',
      ),
      (
        title: 'Grow',
        body:
            'Join the session, revisit activity history, and book again as your goals evolve.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 56),
      child: Container(
        width: double.infinity,
        color: AppColors.surface,
        padding: const EdgeInsets.symmetric(vertical: 44),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > _Breakpoints.heroWide;
                  final isMedium =
                      constraints.maxWidth > _Breakpoints.howItWorksGrid;
                  final cardMinHeight = isWide
                      ? 232.0
                      : isMedium
                      ? 188.0
                      : 156.0;

                  final intro = const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How It Works',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'From search to session in four simple steps.',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 40,
                          height: 1.02,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.2,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'This page translates the app’s main journey into plain language so new visitors know exactly what to expect.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                    ],
                  );

                  final cards = isWide
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(steps.length, (index) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index == steps.length - 1 ? 0 : 18,
                                  ),
                                  child: _StepCard(
                                    number: '${index + 1}',
                                    title: steps[index].title,
                                    body: steps[index].body,
                                    minHeight: cardMinHeight,
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      : isMedium
                      ? Wrap(
                          spacing: 18,
                          runSpacing: 18,
                          children: List.generate(steps.length, (index) {
                            return SizedBox(
                              width: (constraints.maxWidth - 18) / 2,
                              child: _StepCard(
                                number: '${index + 1}',
                                title: steps[index].title,
                                body: steps[index].body,
                                minHeight: cardMinHeight,
                              ),
                            );
                          }),
                        )
                      : Column(
                          children: List.generate(steps.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == steps.length - 1 ? 0 : 18,
                              ),
                              child: _StepCard(
                                number: '${index + 1}',
                                title: steps[index].title,
                                body: steps[index].body,
                                minHeight: cardMinHeight,
                              ),
                            );
                          }),
                        );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      intro,
                      SizedBox(height: isWide ? 28 : 24),
                      cards,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.body,
    required this.minHeight,
  });

  final String number;
  final String title;
  final String body;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < _Breakpoints.lg;

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          compact
              ? Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
          SizedBox(height: compact ? 8 : 20),
          if (!compact)
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                height: 1.1,
                fontWeight: FontWeight.w800,
              ),
            ),
          SizedBox(height: compact ? 6 : 12),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForProfessionalsSection extends StatelessWidget {
  const _ForProfessionalsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < _Breakpoints.professionalsStack;

              final content = Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: stacked
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProfessionalCopy(),
                          SizedBox(height: 26),
                          _ProfessionalPanel(),
                        ],
                      )
                    : const Row(
                        children: [
                          Expanded(child: _ProfessionalCopy()),
                          SizedBox(width: 28),
                          Expanded(child: _ProfessionalPanel()),
                        ],
                      ),
              );

              return content;
            },
          ),
        ),
      ),
    );
  }
}

class _ProfessionalCopy extends StatelessWidget {
  const _ProfessionalCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'For professionals',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Share what you know.\nHelp someone move faster.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 44,
            height: 1,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.4,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'TryMyDay gives experienced professionals a clear way to offer coffee chats, paid sessions, and practical advice without the noise of a generic social platform.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.78),
            fontSize: 18,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DarkFeaturePill(label: 'Profile visibility'),
            _DarkFeaturePill(label: 'Flexible session types'),
            _DarkFeaturePill(label: 'Direct bookings'),
          ],
        ),
      ],
    );
  }
}

class _DarkFeaturePill extends StatelessWidget {
  const _DarkFeaturePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfessionalPanel extends StatelessWidget {
  const _ProfessionalPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: const [
          _MetricRow(
            value: '10 min',
            title: 'Coffee chat intro',
            body: 'A low-pressure way to start meaningful guidance.',
          ),
          SizedBox(height: 14),
          _MetricRow(
            value: '1:1',
            title: 'Focused sessions',
            body: 'Go deeper when the conversation needs real working time.',
          ),
          SizedBox(height: 14),
          _MetricRow(
            value: 'Local',
            title: 'Nearby discovery',
            body: 'Keep recommendations and connections grounded in place.',
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.value,
    required this.title,
    required this.body,
  });

  final String value;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < _Breakpoints.navCompact;
                final currentRoute = ModalRoute.of(context)?.settings.name;
                final canGoHome =
                    currentRoute != homeRoute && currentRoute != null;

                final brandBlock = _FooterBrandBlock(
                  canGoHome: canGoHome,
                  onTap: canGoHome
                      ? () => _navigateWithFade(
                          context,
                          const HomePage(),
                          routeName: homeRoute,
                        )
                      : null,
                );

                final exploreColumn = _FooterColumn(
                  title: 'Explore',
                  items: [
                    (
                      label: 'About',
                      onTap: () => _navigateWithFade(
                        context,
                        const AboutPage(),
                        routeName: aboutRoute,
                      ),
                    ),
                    (
                      label: 'How it works',
                      onTap: () => _navigateWithFade(
                        context,
                        const HomePage(
                          initialTarget: HomeScrollTarget.howItWorks,
                        ),
                        routeName: homeRoute,
                      ),
                    ),
                    (
                      label: 'For Professionals',
                      onTap: () => _navigateWithFade(
                        context,
                        const ProfessionalsPage(),
                        routeName: professionalsRoute,
                      ),
                    ),
                    (
                      label: 'FAQ',
                      onTap: () => _navigateWithFade(
                        context,
                        const FaqPage(),
                        routeName: faqRoute,
                      ),
                    ),
                  ],
                );

                final legalColumn = _FooterColumn(
                  title: 'Legal',
                  items: [
                    (
                      label: 'Privacy Policy',
                      onTap: () => _navigateWithFade(
                        context,
                        const PrivacyPolicyPage(),
                        routeName: privacyPolicyRoute,
                      ),
                    ),
                    (
                      label: 'Terms and Conditions',
                      onTap: () => _navigateWithFade(
                        context,
                        const TermsConditionsPage(),
                        routeName: termsConditionsRoute,
                      ),
                    ),
                    (label: '© 2026 TryMyDay', onTap: null),
                    (
                      label: 'Refunds/Cancellation Policy',
                      onTap: () => _navigateWithFade(
                        context,
                        const RefundsCancellationPolicyPage(),
                        routeName: refundsPolicyRoute,
                      ),
                    ),
                  ],
                );

                return compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          brandBlock,
                          const SizedBox(height: 32),
                          Wrap(
                            spacing: 40,
                            runSpacing: 24,
                            children: [exploreColumn, legalColumn],
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 7, child: brandBlock),
                          const SizedBox(width: 56),
                          Expanded(flex: 2, child: exploreColumn),
                          const SizedBox(width: 56),
                          Expanded(flex: 3, child: legalColumn),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _navigateWithFade(
    BuildContext context,
    Widget page, {
    required String routeName,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName && page is! HomePage) {
      return;
    }

    PageLoadingController.show();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        settings: RouteSettings(name: routeName),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 180),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _FooterBrandBlock extends StatefulWidget {
  const _FooterBrandBlock({required this.canGoHome, this.onTap});

  final bool canGoHome;
  final VoidCallback? onTap;

  @override
  State<_FooterBrandBlock> createState() => _FooterBrandBlockState();
}

class _FooterBrandBlockState extends State<_FooterBrandBlock> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.canGoHome ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.white.withValues(alpha: 0.18),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          hoverColor: Colors.white.withValues(alpha: 0.08),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 140),
            opacity: _hovered && widget.canGoHome ? 0.92 : 1,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BrandLockup(
                    iconAsset: AppImages.smileyWhite,
                    textColor: Colors.white,
                    iconSize: 42,
                    fontSize: 18,
                    iconBackground: Colors.white,
                    iconColor: AppColors.primary,
                  ),
                  SizedBox(height: 22),
                  SizedBox(
                    width: 370,
                    child: Text(
                      'Career guidance through real conversations. Discover professionals, start with a coffee chat, and book sessions that move you forward.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.items});

  final String title;
  final List<({String label, VoidCallback? onTap})> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 245,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _FooterLink(label: item.label, onTap: item.onTap),
            ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.white.withValues(alpha: 0.18),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          hoverColor: Colors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              style: TextStyle(
                color: Colors.white.withValues(alpha: _hovered ? 1 : 0.94),
                fontSize: 16,
                height: 1.4,
                decoration: _hovered ? TextDecoration.underline : null,
                decorationColor: Colors.white.withValues(alpha: 0.92),
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}
