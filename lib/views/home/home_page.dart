import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/components/store_button.dart';
import '../../core/services/app_remote_config.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/app_images.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _LandingPage());
  }
}

class _LandingPage extends StatelessWidget {
  const _LandingPage();

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
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _Header(),
              _HeroSection(),
              _HowItWorksSection(),
              _ForProfessionalsSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
              final compact = constraints.maxWidth < 900;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 20 : 48,
                  vertical: compact ? 18 : 14,
                ),
                child: compact
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Brand(),
                          SizedBox(height: 18),
                          Wrap(
                            spacing: 18,
                            runSpacing: 14,
                            children: [
                              _NavItem(label: 'About'),
                              _NavItem(label: 'How it works'),
                              _NavItem(label: 'For Professionals'),
                              _NavItem(label: 'FAQ'),
                              _NavItem(label: 'Contact Us'),
                            ],
                          ),
                          SizedBox(height: 18),
                          _GetAppButton(),
                        ],
                      )
                    : const Row(
                        children: [
                          _Brand(),
                          Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _NavItem(label: 'About'),
                              SizedBox(width: 36),
                              _NavItem(label: 'How it works'),
                              SizedBox(width: 36),
                              _NavItem(label: 'For Professionals'),
                              SizedBox(width: 36),
                              _NavItem(label: 'FAQ'),
                              SizedBox(width: 36),
                              _NavItem(label: 'Contact Us'),
                            ],
                          ),
                          SizedBox(width: 42),
                          _GetAppButton(),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return const _BrandLockup();
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
  const _NavItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _GetAppButton extends StatelessWidget {
  const _GetAppButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Get the App',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 980;
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
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      StoreButton(
                        icon: AppIcons.apple,
                        upperLabel: 'Download on the',
                        lowerLabel: 'App Store',
                      ),
                      StoreButton(
                        icon: AppIcons.googlePlay,
                        upperLabel: 'Get it on',
                        lowerLabel: 'Google Play',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
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
                      _StatCard(title: 'Paid', body: 'deeper sessions'),
                      _StatCard(title: 'Free', body: 'coffee chats'),
                    ],
                  ),
                ],
              );

              final visual = const _PhoneShowcase();

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
                      children: [copy, const SizedBox(height: 36), visual],
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.body, this.badgeText});

  final String title;
  final String body;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 184,
      padding: const EdgeInsets.all(18),
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
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 18,
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
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
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
  const _PhoneShowcase();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 680,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 470,
              height: 470,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  237,
                  241,
                  103,
                ).withValues(alpha: 0.62),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40D5DF51),
                    blurRadius: 70,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 340,
            height: 636,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  left: 6,
                  top: 128,
                  child: _PhoneSideButton(height: 34, width: 6),
                ),
                const Positioned(
                  left: 6,
                  top: 182,
                  child: _PhoneSideButton(height: 64, width: 6),
                ),
                const Positioned(
                  left: 6,
                  top: 262,
                  child: _PhoneSideButton(height: 64, width: 6),
                ),
                const Positioned(
                  right: 6,
                  top: 208,
                  child: _PhoneSideButton(height: 92, width: 6),
                ),
                Container(
                  width: 324,
                  height: 636,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1A18),
                    borderRadius: BorderRadius.circular(52),
                    border: Border.all(
                      color: const Color(0xFFB7792D),
                      width: 2.6,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4D000000),
                        blurRadius: 42,
                        offset: Offset(18, 26),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: Column(
                      children: const [
                        SizedBox(height: 12),
                        _PhoneNotch(),
                        Expanded(child: _PhoneScreen()),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              const _BrandLockup(iconSize: 16, fontSize: 12),
              const Spacer(),
              const Icon(AppIcons.search, color: AppColors.textMuted, size: 18),
              const SizedBox(width: 10),
              const Icon(
                AppIcons.notifications,
                color: AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.surfaceMuted,
                child: const Icon(
                  AppIcons.person,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(AppIcons.search, color: AppColors.textMuted, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search professionals...',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFDCE7DA), Color(0xFFEEF4E8)],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  Positioned(
                    top: 32,
                    left: 18,
                    child: _MapMarker(label: 'Marketing'),
                  ),
                  Positioned(
                    top: 86,
                    right: 36,
                    child: _MapMarker(label: 'Design'),
                  ),
                  Positioned(
                    top: 134,
                    left: 92,
                    child: _MapMarker(label: 'Tech'),
                  ),
                  Positioned(
                    top: 188,
                    right: 92,
                    child: _MapMarker(label: 'Law'),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _SessionBanner(),
                        SizedBox(height: 12),
                        _ProfessionalCard(
                          name: 'Alex Chen',
                          role: 'Senior Software Engineer at Google',
                          rate: 'R250/hour',
                        ),
                        SizedBox(height: 10),
                        _ProfessionalCard(
                          name: 'Sarah Johnson',
                          role: 'Marketing Director at Spotify',
                          rate: 'Free coffee chat',
                          highlighted: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SessionBanner extends StatelessWidget {
  const _SessionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(AppIcons.schedule, size: 16, color: AppColors.primary),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Session in 1 hour with Alex',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  const _ProfessionalCard({
    required this.name,
    required this.role,
    required this.rate,
    this.highlighted = true,
  });

  final String name;
  final String role;
  final String rate;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  rate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: highlighted
                        ? AppColors.primary
                        : AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 220;

              final action = Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: highlighted
                      ? AppColors.secondary
                      : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  highlighted ? 'Book' : 'View profile',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );

              final stats = const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(AppIcons.star, color: Color(0xFFF2B51F), size: 14),
                  SizedBox(width: 4),
                  Text(
                    '4.9',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '10+ sessions',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [stats, const SizedBox(height: 8), action],
                );
              }

              return Row(children: [stats, const Spacer(), action]);
            },
          ),
        ],
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
        title: 'Discover nearby professionals',
        body:
            'Explore a clean map-first experience built around real people, local insight, and transparent session options.',
      ),
      (
        title: 'Start with a coffee chat',
        body:
            'Use a lighter first conversation to test fit, ask direct questions, and decide where to go deeper.',
      ),
      (
        title: 'Book paid sessions when needed',
        body:
            'Move into focused guidance sessions when you need structured advice, clearer planning, or accountability.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: AppColors.border),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;

                final intro = const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Simple on the surface.\nUseful when it counts.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 38,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.2,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'The landing page keeps the same tone as the mobile app: practical, direct, and built around conversations that move people forward.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                  ],
                );

                final cards = Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: List.generate(
                    steps.length,
                    (index) => _StepCard(
                      number: '0${index + 1}',
                      title: steps[index].title,
                      body: steps[index].body,
                      width: isWide
                          ? (constraints.maxWidth - 82) / 3
                          : double.infinity,
                    ),
                  ),
                );

                return isWide
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [intro, const SizedBox(height: 28), cards],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [intro, const SizedBox(height: 24), cards],
                      );
              },
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
    required this.width,
  });

  final String number;
  final String title;
  final String body;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                height: 1.1,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
                height: 1.55,
              ),
            ),
          ],
        ),
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
              final stacked = constraints.maxWidth < 930;

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 900;

                final brandBlock = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BrandLockup(
                      iconAsset: AppImages.smileyWhite,
                      textColor: Colors.white,
                      iconSize: 44,
                      fontSize: 18,
                      iconBackground: Color(0xFF0F4A46),
                      iconColor: Colors.white,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Career guidance through real conversations. Discover professionals, start with a coffee chat, and book sessions that move you forward.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 16,
                        height: 1.7,
                      ),
                    ),
                  ],
                );

                final links = const Wrap(
                  spacing: 52,
                  runSpacing: 24,
                  children: [
                    _FooterColumn(
                      title: 'Explore',
                      items: [
                        'About',
                        'How it works',
                        'For Professionals',
                        'FAQ',
                      ],
                    ),
                    _FooterColumn(
                      title: 'Legal',
                      items: [
                        'Privacy Policy',
                        'Terms and Conditions',
                        'Refunds/Cancellation Policy',
                        '© 2026 TryMyDay',
                      ],
                    ),
                  ],
                );

                return compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          brandBlock,
                          const SizedBox(height: 30),
                          links,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: brandBlock),
                          const SizedBox(width: 40),
                          Expanded(flex: 4, child: links),
                        ],
                      );
              },
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
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFBAC8B5)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minorPaint = Paint()
      ..color = const Color(0xFFD8E1D4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roads = [
      [
        Offset(size.width * 0.08, size.height * 0.18),
        Offset(size.width * 0.92, size.height * 0.18),
      ],
      [
        Offset(size.width * 0.15, size.height * 0.35),
        Offset(size.width * 0.84, size.height * 0.55),
      ],
      [
        Offset(size.width * 0.22, size.height * 0.08),
        Offset(size.width * 0.28, size.height * 0.84),
      ],
      [
        Offset(size.width * 0.62, size.height * 0.12),
        Offset(size.width * 0.72, size.height * 0.88),
      ],
    ];

    final minorRoads = [
      [
        Offset(size.width * 0.04, size.height * 0.52),
        Offset(size.width * 0.9, size.height * 0.42),
      ],
      [
        Offset(size.width * 0.1, size.height * 0.72),
        Offset(size.width * 0.84, size.height * 0.72),
      ],
      [
        Offset(size.width * 0.42, size.height * 0.04),
        Offset(size.width * 0.48, size.height * 0.92),
      ],
    ];

    for (final segment in roads) {
      canvas.drawLine(segment.first, segment.last, roadPaint);
    }

    for (final segment in minorRoads) {
      canvas.drawLine(segment.first, segment.last, minorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
