import 'package:flutter/material.dart';

void main() {
  runApp(const TryMyDayApp());
}

class TryMyDayApp extends StatelessWidget {
  const TryMyDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF6EFE5);
    const surface = Color(0xFFFFFBF5);
    const ink = Color(0xFF1F2A1F);
    const accent = Color(0xFF2F6B4F);
    const highlight = Color(0x0ffd9958);

    final baseTheme = ThemeData.light(useMaterial3: true);

    return MaterialApp(
      title: 'TryMyDay',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.light(
          primary: accent,
          secondary: highlight,
          surface: surface,
        ),
        textTheme: baseTheme.textTheme.apply(
          bodyColor: ink,
          displayColor: ink,
          fontFamily: 'Georgia',
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2E2CF), Color(0xFFF6EFE5), Color(0xFFFFFBF5)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _TopBar(),
                _HeroSection(),
                _FeatureSection(),
                _SupportSection(),
                _DownloadSection(),
                _FooterSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;

          if (compact) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BrandLockup(),
                SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _NavChip(label: 'Product'),
                    _NavChip(label: 'Support'),
                    _NavChip(label: 'Download'),
                  ],
                ),
              ],
            );
          }

          return const Row(
            children: [
              _BrandLockup(),
              Spacer(),
              Wrap(
                spacing: 12,
                children: [
                  _NavChip(label: 'Product'),
                  _NavChip(label: 'Support'),
                  _NavChip(label: 'Download'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF2F6B4F),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Text(
            'T',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'TryMyDay',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD9C7B1)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 920;
          final heroCopy = [
            const Text(
              'Plan better days with one clear mobile companion.',
              style: TextStyle(
                fontSize: 52,
                height: 1.05,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.4,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'TryMyDay is the official destination for product information, help resources, and direct access to the mobile app.',
              style: TextStyle(
                fontSize: wide ? 19 : 18,
                height: 1.5,
                color: const Color(0xFF435046),
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: const [
                _PrimaryButton(label: 'Download the app'),
                _SecondaryButton(label: 'Visit support'),
              ],
            ),
            const SizedBox(height: 26),
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _StatPill(value: 'Simple', label: 'daily planning'),
                _StatPill(value: 'Fast', label: 'support access'),
                _StatPill(value: 'Official', label: 'app download hub'),
              ],
            ),
          ];

          final previewCard = Container(
            constraints: const BoxConstraints(maxWidth: 460),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2A1F),
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2A1F2A1F),
                  blurRadius: 30,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD99058),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1D1A8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7CB38C),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Inside TryMyDay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Everything your users need before they install, while they use the app, and when they need help.',
                  style: TextStyle(
                    color: Color(0xFFD7E2D8),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                const _PreviewTile(
                  title: 'Product overview',
                  body:
                      'Explain what TryMyDay does and why it fits into a daily routine.',
                ),
                const SizedBox(height: 14),
                const _PreviewTile(
                  title: 'Support resources',
                  body:
                      'Direct users to troubleshooting, FAQs, and contact options.',
                ),
                const SizedBox(height: 14),
                const _PreviewTile(
                  title: 'App download',
                  body:
                      'Keep installation links visible and easy to access from any device.',
                ),
              ],
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 32, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: heroCopy,
                    ),
                  ),
                ),
                previewCard,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...heroCopy, const SizedBox(height: 28), previewCard],
          );
        },
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection();

  @override
  Widget build(BuildContext context) {
    const cards = [
      _InfoCardData(
        title: 'Product information that explains the value quickly',
        body:
            'Use the site to show what TryMyDay offers, who it helps, and how the mobile experience fits into daily life.',
      ),
      _InfoCardData(
        title: 'User support that is easy to find',
        body:
            'Keep support routes visible with answers for common issues, account guidance, and direct contact details.',
      ),
      _InfoCardData(
        title: 'Download paths designed for mobile users',
        body:
            'Guide visitors straight to the app with clear calls to action for iPhone and Android installs.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What this website needs to do',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text(
            'The landing experience should work as the official public front door for TryMyDay.',
            style: TextStyle(
              fontSize: 34,
              height: 1.15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 3
                  : constraints.maxWidth >= 720
                  ? 2
                  : 1;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: cards
                    .map(
                      (card) => SizedBox(
                        width: columns == 1
                            ? constraints.maxWidth
                            : columns == 2
                            ? (constraints.maxWidth - 18) / 2
                            : (constraints.maxWidth - 36) / 3,
                        child: _InfoCard(data: card),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE7F0E8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 860;

            const intro = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User support',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
                Text(
                  'Help people solve problems without making them search.',
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'This section should link out to FAQs, troubleshooting, account help, and direct support channels.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.55,
                    color: Color(0xFF435046),
                  ),
                ),
              ],
            );

            const checklist = Column(
              children: [
                _ChecklistTile(label: 'Frequently asked questions'),
                SizedBox(height: 12),
                _ChecklistTile(label: 'Account and sign-in help'),
                SizedBox(height: 12),
                _ChecklistTile(label: 'Bug reporting and contact details'),
              ],
            );

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: intro),
                  const SizedBox(width: 24),
                  const Expanded(child: checklist),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [intro, SizedBox(height: 20), checklist],
            );
          },
        ),
      ),
    );
  }
}

class _DownloadSection extends StatelessWidget {
  const _DownloadSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFD99058),
          borderRadius: BorderRadius.circular(30),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 860;

            final content = [
              const Text(
                'Download TryMyDay',
                style: TextStyle(
                  color: Color(0xFF1F2A1F),
                  fontSize: 36,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Place the mobile app front and center so visitors can move from discovery to install with minimal friction.',
                style: TextStyle(
                  color: Color(0xFF2D241C),
                  fontSize: 17,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _StoreButton(
                    icon: Icons.apple,
                    label: 'Download on the App Store',
                    dark: wide,
                  ),
                  _StoreButton(
                    icon: Icons.android,
                    label: 'Get it on Google Play',
                    dark: wide,
                  ),
                ],
              ),
            ];

            final sideCard = Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Launch goals',
                    style: TextStyle(
                      color: Color(0xFF1F2A1F),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Make app links obvious, keep support visible, and reinforce the official brand in one page.',
                    style: TextStyle(
                      color: Color(0xFF2D241C),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );

            if (wide) {
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: content,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: sideCard),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...content, const SizedBox(height: 20), sideCard],
            );
          },
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 640;

          return Column(
            children: [
              const Divider(color: Color(0xFFD9C7B1)),
              const SizedBox(height: 16),
              if (compact)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TryMyDay official website',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5A675C),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Product | Support | Download',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5A675C),
                        ),
                      ),
                    ),
                  ],
                )
              else
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'TryMyDay official website',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5A675C),
                        ),
                      ),
                    ),
                    Text(
                      'Product | Support | Download',
                      style: TextStyle(fontSize: 14, color: Color(0xFF5A675C)),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2F6B4F),
        borderRadius: BorderRadius.circular(18),
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

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD9C7B1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1F2A1F),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF1F2A1F)),
          children: [
            TextSpan(
              text: '$value ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: label),
          ],
        ),
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFFD7E2D8),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCardData {
  const _InfoCardData({required this.title, required this.body});

  final String title;
  final String body;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.data});

  final _InfoCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2D3BF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2F6B4F).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.north_east, color: Color(0xFF2F6B4F)),
          ),
          const SizedBox(height: 18),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF5A675C),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF2F6B4F),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreButton extends StatelessWidget {
  const _StoreButton({
    required this.icon,
    required this.label,
    required this.dark,
  });

  final IconData icon;
  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1F2A1F) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: dark ? Colors.white : const Color(0xFF1F2A1F)),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: dark ? Colors.white : const Color(0xFF1F2A1F),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
