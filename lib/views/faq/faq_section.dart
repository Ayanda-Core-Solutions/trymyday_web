part of '../home/home_page.dart';

const _faqItems = [
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

class _FaqSection extends StatelessWidget {
  const _FaqSection({this.initialExpandedQuestion});

  final String? initialExpandedQuestion;

  @override
  Widget build(BuildContext context) {
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
                  'Find quick answers about coffee chats, paid sessions, scheduling, and booking again.',
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
                      children: _faqItems
                          .map(
                            (item) => SizedBox(
                              width: (constraints.maxWidth - 48) / 3,
                              child: _FaqCard(
                                question: item.question,
                                answer: item.answer,
                                initiallyExpanded:
                                    item.question == initialExpandedQuestion,
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
                      children: _faqItems
                          .map(
                            (item) => SizedBox(
                              width: (constraints.maxWidth - 18) / 2,
                              child: _FaqCard(
                                question: item.question,
                                answer: item.answer,
                                initiallyExpanded:
                                    item.question == initialExpandedQuestion,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }

                  return Column(
                    children: _faqItems
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: _FaqCard(
                              question: item.question,
                              answer: item.answer,
                              initiallyExpanded:
                                  item.question == initialExpandedQuestion,
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
  const _FaqCard({
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  final String question;
  final String answer;
  final bool initiallyExpanded;

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(_FaqCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question ||
        oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
    }
  }

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
