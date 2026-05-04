part of '../home/home_page.dart';

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
