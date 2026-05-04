part of '../home/home_page.dart';

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
