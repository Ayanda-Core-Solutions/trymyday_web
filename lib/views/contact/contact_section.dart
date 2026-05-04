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
              final supportTopics = _faqItems.take(4).toList();

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
                  child: const _ContactForm(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Support topics',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (final (index, item) in supportTopics.indexed) ...[
                        _SupportTopic(
                          text: item.question,
                          onTap: () => _openFaqTopic(context, item.slug),
                        ),
                        if (index < supportTopics.length - 1)
                          const SizedBox(height: 14),
                      ],
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
                    'Questions about TryMyDay? We’re here to help.',
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
                    'Send us a message about bookings, accounts, payments, or partnerships and we’ll point you in the right direction.',
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

  void _openFaqTopic(BuildContext context, String topicSlug) {
    PageLoadingController.show();
    context.go(_faqTopicLocation(topicSlug));
  }
}

enum _ContactSubmitState { idle, sending, success, error }

Future<void> _sendContactEmail({
  required String name,
  required String email,
  required String message,
  String? mobile,
}) {
  return ContactEmailService().send(
    name: name,
    email: email,
    message: message,
    mobile: mobile,
  );
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  _ContactSubmitState _submitState = _ContactSubmitState.idle;
  String? _statusMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (_submitState) {
      _ContactSubmitState.success => AppColors.primary,
      _ContactSubmitState.error => const Color(0xFFB3261E),
      _ => AppColors.textMuted,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Send us a message',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 20),
        const _ContactFieldLabel(label: 'Name'),
        const SizedBox(height: 10),
        _ContactInput(
          controller: _nameController,
          hintText: 'Your full name',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 22),
        const _ContactFieldLabel(label: 'Email'),
        const SizedBox(height: 10),
        _ContactInput(
          controller: _emailController,
          hintText: 'you@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 22),
        const _ContactFieldLabel(label: 'Mobile number (optional)'),
        const SizedBox(height: 10),
        _ContactInput(
          controller: _mobileController,
          hintText: '+27 82 123 4567',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 22),
        const _ContactFieldLabel(label: 'How can we help?'),
        const SizedBox(height: 10),
        _ContactInput(
          controller: _messageController,
          hintText: 'Tell us more...',
          maxLines: 5,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 18),
        _ContactSubmitButton(
          sending: _submitState == _ContactSubmitState.sending,
          onTap: _submit,
        ),
        if (_statusMessage != null) ...[
          const SizedBox(height: 14),
          Text(
            _statusMessage!,
            style: TextStyle(
              color: statusColor,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _submit() async {
    if (_submitState == _ContactSubmitState.sending) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      setState(() {
        _submitState = _ContactSubmitState.error;
        _statusMessage = 'Please add your name, email, and message.';
      });
      return;
    }

    setState(() {
      _submitState = _ContactSubmitState.sending;
      _statusMessage = null;
    });

    try {
      await _sendContactEmail(
        name: name,
        email: email,
        mobile: mobile.isEmpty ? null : mobile,
        message: message,
      );
      if (!mounted) return;

      setState(() {
        _submitState = _ContactSubmitState.success;
        _statusMessage = 'Message sent. We’ll get back to you soon.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _submitState = _ContactSubmitState.error;
        _statusMessage =
            'We could not send your message. Please try again or email ${AppEnvironment.contactEmailAddress} directly.';
      });
    }
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
  const _ContactInput({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
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
  const _ContactSubmitButton({required this.sending, required this.onTap});

  final bool sending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: sending ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 22),
          decoration: BoxDecoration(
            color: sending
                ? AppColors.primary.withValues(alpha: 0.72)
                : AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            sending ? 'Sending...' : 'Submit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportTopic extends StatelessWidget {
  const _SupportTopic({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              height: 1.35,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
