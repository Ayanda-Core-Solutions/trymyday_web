part of '../../../views/home/home_page.dart';

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
    final currentRoute = _currentRoutePath(context);
    if (currentRoute == homeRoute) {
      return;
    }
    _pushLocation(context, _homeLocation());
  }

  void _goAbout(BuildContext context) {
    final currentRoute = _currentRoutePath(context);
    if (currentRoute == aboutRoute) {
      return;
    }
    _pushLocation(context, aboutRoute);
  }

  void _goHowItWorks(BuildContext context) {
    _pushLocation(context, _homeLocation(target: HomeScrollTarget.howItWorks));
  }

  void _goProfessionals(BuildContext context) {
    final currentRoute = _currentRoutePath(context);
    if (currentRoute == professionalsRoute) {
      return;
    }
    _pushLocation(context, professionalsRoute);
  }

  void _goFaq(BuildContext context) {
    final currentRoute = _currentRoutePath(context);
    if (currentRoute == faqRoute) {
      return;
    }
    _pushLocation(context, faqRoute);
  }

  void _goContact(BuildContext context) {
    final currentRoute = _currentRoutePath(context);
    if (currentRoute == contactRoute) {
      return;
    }
    _pushLocation(context, contactRoute);
  }

  void _pushLocation(BuildContext context, String location) {
    PageLoadingController.show();
    context.go(location);
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

    final currentRoute = _currentRoutePath(context);
    if (currentRoute == homeRoute) {
      final targetContext =
          AppDownloadSectionController.targetKey.currentContext;
      if (targetContext != null) {
        _scrollToTarget(targetContext, viewportAlignment: 0.42);
      }
      return;
    }

    PageLoadingController.show();
    context.go(_homeLocation(target: HomeScrollTarget.appStores));
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
