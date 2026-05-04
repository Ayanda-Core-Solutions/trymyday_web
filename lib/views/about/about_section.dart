part of '../home/home_page.dart';

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
