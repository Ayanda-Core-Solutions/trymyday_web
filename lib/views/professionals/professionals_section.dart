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

enum _ProfessionalApplicationSubmitState {
  idle,
  sending,
  success,
  duplicate,
  error,
}

class _ProfessionalWebApplicationSection extends StatefulWidget {
  const _ProfessionalWebApplicationSection();

  @override
  State<_ProfessionalWebApplicationSection> createState() =>
      _ProfessionalWebApplicationSectionState();
}

class _ProfessionalWebApplicationSectionState
    extends State<_ProfessionalWebApplicationSection> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _companyController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _sessionTopicController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _motivationController = TextEditingController();

  _ProfessionalApplicationSubmitState _submitState =
      _ProfessionalApplicationSubmitState.idle;
  String? _statusMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    _sessionTopicController.dispose();
    _availabilityController.dispose();
    _linkedinController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < _Breakpoints.lg;
              final intro = Expanded(
                flex: stacked ? 0 : 5,
                child: const _ProfessionalApplicationIntro(),
              );
              final form = Expanded(
                flex: stacked ? 0 : 7,
                child: _buildFormCard(),
              );

              return stacked
                  ? Column(children: [intro, const SizedBox(height: 24), form])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [intro, const SizedBox(width: 28), form],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    final statusColor = switch (_submitState) {
      _ProfessionalApplicationSubmitState.success => AppColors.primary,
      _ProfessionalApplicationSubmitState.duplicate => AppColors.primary,
      _ProfessionalApplicationSubmitState.error => const Color(0xFFB3261E),
      _ => AppColors.textMuted,
    };

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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start your application',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Web applicants can start without signing in. We use your email to prevent duplicate applications and contact you during review.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            _ApplicationInput(
              controller: _fullNameController,
              label: 'Full name',
            ),
            _ApplicationInput(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            _ApplicationInput(
              controller: _phoneController,
              label: 'Phone number',
              required: false,
              keyboardType: TextInputType.phone,
            ),
            _ApplicationInput(
              controller: _roleController,
              label: 'Current role',
            ),
            _ApplicationInput(
              controller: _companyController,
              label: 'Company or practice',
              required: false,
            ),
            _ApplicationInput(
              controller: _experienceController,
              label: 'Years of experience',
              keyboardType: TextInputType.number,
            ),
            _ApplicationInput(
              controller: _locationController,
              label: 'Professional location',
            ),
            _ApplicationInput(
              controller: _sessionTopicController,
              label: 'One session people can book with you',
            ),
            _ApplicationInput(
              controller: _availabilityController,
              label: 'Availability idea',
              hintText:
                  'Example: Weekdays at 09:00 and 13:00, coffee chats 12:00-13:00',
              maxLines: 3,
            ),
            _ApplicationInput(
              controller: _linkedinController,
              label: 'LinkedIn or portfolio',
              required: false,
            ),
            _ApplicationInput(
              controller: _motivationController,
              label: 'Why should people book you?',
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed:
                  _submitState == _ProfessionalApplicationSubmitState.sending
                  ? null
                  : _submit,
              icon: _submitState == _ProfessionalApplicationSubmitState.sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_forward_rounded),
              label: Text(
                _submitState == _ProfessionalApplicationSubmitState.sending
                    ? 'Submitting...'
                    : 'Submit Application',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            if (_statusMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _statusMessage!,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitState = _ProfessionalApplicationSubmitState.sending;
      _statusMessage = null;
    });

    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'submitWebProfessionalApplication',
      );
      final result = await callable.call<Map<String, dynamic>>({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': _roleController.text.trim(),
        'company': _companyController.text.trim(),
        'experience': _experienceController.text.trim(),
        'location': _locationController.text.trim(),
        'sessionTopic': _sessionTopicController.text.trim(),
        'availability': _availabilityController.text.trim(),
        'linkedin': _linkedinController.text.trim(),
        'motivation': _motivationController.text.trim(),
      });
      final data = result.data;
      final alreadyExists = data['alreadyExists'] == true;
      setState(() {
        _submitState = alreadyExists
            ? _ProfessionalApplicationSubmitState.duplicate
            : _ProfessionalApplicationSubmitState.success;
        _statusMessage = alreadyExists
            ? 'We already have an application or profile for this email. We will continue from the existing record.'
            : 'Application submitted. We will review it and contact you by email.';
      });
    } catch (_) {
      setState(() {
        _submitState = _ProfessionalApplicationSubmitState.error;
        _statusMessage = 'Could not submit your application. Please try again.';
      });
    }
  }
}

class _ProfessionalApplicationIntro extends StatelessWidget {
  const _ProfessionalApplicationIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Become a Professional',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 40,
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Start with your expertise, one bookable session, and a practical availability plan. After approval your profile can go live for bookings.',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              height: 1.5,
            ),
          ),
          SizedBox(height: 28),
          _ApplicationChecklistItem(
            icon: Icons.mail_outline_rounded,
            text:
                'Email-based duplicate checks reduce unnecessary applications.',
          ),
          SizedBox(height: 14),
          _ApplicationChecklistItem(
            icon: Icons.verified_user_outlined,
            text: 'The review team approves profiles before they go live.',
          ),
          SizedBox(height: 14),
          _ApplicationChecklistItem(
            icon: Icons.event_available_outlined,
            text:
                'Your session and availability are shaped around real bookable slots.',
          ),
        ],
      ),
    );
  }
}

class _ApplicationChecklistItem extends StatelessWidget {
  const _ApplicationChecklistItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ApplicationInput extends StatelessWidget {
  const _ApplicationInput({
    required this.controller,
    required this.label,
    this.hintText,
    this.required = true,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool required;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? label : '$label (optional)',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: (value) {
              if (!required) return null;
              if ((value ?? '').trim().isEmpty) return 'Required';
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
