part of '../home_page.dart';

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
