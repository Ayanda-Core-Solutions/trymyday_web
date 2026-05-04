part of '../home_page.dart';

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
