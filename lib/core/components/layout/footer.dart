part of '../../../views/home/home_page.dart';

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
                final currentRoute = _currentRoutePath(context);
                final canGoHome = currentRoute != homeRoute;

                final brandBlock = _FooterBrandBlock(
                  canGoHome: canGoHome,
                  onTap: canGoHome
                      ? () => _navigateWithFade(context, _homeLocation())
                      : null,
                );

                final exploreColumn = _FooterColumn(
                  title: 'Explore',
                  items: [
                    (
                      label: 'About',
                      onTap: () => _navigateWithFade(context, aboutRoute),
                    ),
                    (
                      label: 'How it works',
                      onTap: () => _navigateWithFade(
                        context,
                        _homeLocation(target: HomeScrollTarget.howItWorks),
                      ),
                    ),
                    (
                      label: 'For Professionals',
                      onTap: () =>
                          _navigateWithFade(context, professionalsRoute),
                    ),
                    (
                      label: 'FAQ',
                      onTap: () => _navigateWithFade(context, faqRoute),
                    ),
                  ],
                );

                final legalColumn = _FooterColumn(
                  title: 'Legal',
                  items: [
                    (
                      label: 'Privacy Policy',
                      onTap: () =>
                          _navigateWithFade(context, privacyPolicyRoute),
                    ),
                    (
                      label: 'Terms and Conditions',
                      onTap: () =>
                          _navigateWithFade(context, termsConditionsRoute),
                    ),
                    (label: '© 2026 TryMyDay', onTap: null),
                    (
                      label: 'Refunds/Cancellation Policy',
                      onTap: () =>
                          _navigateWithFade(context, refundsPolicyRoute),
                    ),
                    (
                      label: 'Account Deletion',
                      onTap: () =>
                          _navigateWithFade(context, accountDeletionRoute),
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

  void _navigateWithFade(BuildContext context, String location) {
    final currentRoute = _currentRoutePath(context);
    final targetRoute = Uri.parse(location).path;
    if (currentRoute == targetRoute && targetRoute != homeRoute) {
      return;
    }

    PageLoadingController.show();
    context.go(location);
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
