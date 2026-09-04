part of '../home/home_page.dart';

class LegalDocumentModel {
  const LegalDocumentModel({
    required this.id,
    required this.title,
    required this.version,
    required this.effectiveDate,
    required this.content,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.latestAppVersion,
  });

  final String id;
  final String title;
  final String version;
  final String effectiveDate;
  final String content;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? latestAppVersion;

  factory LegalDocumentModel.fromMap(Map<String, dynamic> map) {
    return LegalDocumentModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      version: (map['version'] ?? '').toString(),
      effectiveDate: (map['effectiveDate'] ?? '').toString(),
      content: (map['content'] ?? '').toString(),
      createdBy: _asStringOrNull(map['createdBy']),
      updatedBy: _asStringOrNull(map['updatedBy']),
      createdAt: _asDateStringOrNull(map['createdAt']),
      updatedAt: _asDateStringOrNull(map['updatedAt']),
      latestAppVersion: _asStringOrNull(map['latestAppVersion']),
    );
  }

  static String? _asStringOrNull(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String? _asDateStringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is DateTime) return value.toIso8601String();
    return value.toString();
  }
}

class LegalDocumentService {
  LegalDocumentService({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  Stream<LegalDocumentModel?> watchById(String id) {
    if (Firebase.apps.isEmpty) {
      return Stream<LegalDocumentModel?>.value(null);
    }

    return _watchFirestoreDocument(id);
  }

  Stream<LegalDocumentModel?> _watchFirestoreDocument(String id) async* {
    try {
      final firestore = _firestore ?? FirebaseFirestore.instance;

      await for (final doc
          in firestore.collection('legal_documents').doc(id).snapshots()) {
        if (!doc.exists) {
          yield null;
          continue;
        }

        final data = doc.data();
        if (data == null) {
          yield null;
          continue;
        }

        yield LegalDocumentModel.fromMap({
          ...data,
          if ((data['id'] ?? '').toString().isEmpty) 'id': doc.id,
        });
      }
    } catch (_) {
      yield null;
    }
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const LegalDocumentModel fallback = LegalDocumentModel(
    id: 'privacy_policy',
    title: 'Privacy Policy',
    version: '1.0',
    effectiveDate: '8 Feb 2026',
    content:
        '1. Overview\n'
        'This Privacy Policy explains how TryMyDay collects, uses, stores, and protects your personal information when you use the app.\n\n'
        '2. Information We Collect\n'
        'We may collect your name, email address, phone number, profile details, payment-related details, and booking/session history.\n\n'
        '3. How We Use Your Information\n'
        'We use your information to create and manage your account, process bookings and payments, improve the app experience, and communicate important service updates.\n\n'
        '4. Sharing of Information\n'
        'We do not sell your personal information. We may share limited information with professionals you book with and trusted providers (such as payment processors) only where necessary to deliver the service.\n\n'
        '5. Data Security\n'
        'We apply reasonable technical and organizational safeguards to protect your data from unauthorized access, loss, or misuse.\n\n'
        '6. Data Retention\n'
        'We retain your information only as long as needed for service delivery, legal compliance, and legitimate business purposes.\n\n'
        '7. Your Rights\n'
        'You may request access, correction, or deletion of your personal information, subject to applicable law.\n\n'
        '8. Cookies and Analytics\n'
        'We may use cookies or similar technologies to improve functionality, understand usage patterns, and enhance performance.\n\n'
        '9. Policy Updates\n'
        'We may update this Privacy Policy from time to time. Continued use of the app after updates means you accept the revised policy.\n\n'
        '10. Contact\n'
        'If you have privacy questions, please contact support@trymyday.co.za.',
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LegalDocumentPageBody(
        selectedNav: null,
        documentId: 'privacy_policy',
        fallback: fallback,
        eyebrow: 'Legal',
      ),
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  static const LegalDocumentModel fallback = LegalDocumentModel(
    id: 'terms_conditions',
    title: 'Terms & Conditions',
    version: '1.0',
    effectiveDate: '8 Feb 2026',
    content:
        'By accessing or using the TryMyDay mobile application (“the App”), you agree to be bound by these Terms & Conditions.\n\n'
        '1. Eligibility: You must be at least 18 years old to use TryMyDay, or have parental consent.\n'
        '2. Use of Services: TryMyDay connects individuals with professionals for career insights. You agree to use the App for lawful purposes only.\n'
        '3. Booking & Payments: All bookings are subject to the professional’s availability. Paid sessions must be paid in full at the time of booking.\n'
        '4. Cancellations & Refunds: You may cancel or reschedule up to 24 hours before the session. After this, cancellation fees may apply.\n'
        '5. Prohibited Conduct: You agree not to engage in harassment, abuse, or any activity that violates local laws.\n'
        '6. Modifications: TryMyDay reserves the right to update these Terms at any time. Continued use constitutes acceptance of changes.',
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LegalDocumentPageBody(
        selectedNav: null,
        documentId: 'terms_conditions',
        fallback: fallback,
        eyebrow: 'Legal',
      ),
    );
  }
}

class RefundsCancellationPolicyPage extends StatelessWidget {
  const RefundsCancellationPolicyPage({super.key});

  static const LegalDocumentModel fallback = LegalDocumentModel(
    id: 'cancellation_policy',
    title: 'Cancellation & Refund Policy (South Africa)',
    version: '1.0',
    effectiveDate: '8 Feb 2026',
    content:
        '1. Overview\n'
        'This policy governs cancellations and refunds for paid sessions booked on TryMyDay. All amounts are in South African Rand (ZAR). By booking a paid session, you agree to the terms below.\n\n'
        '2. Cancellation Windows\n\n'
        'More than 24 hours before the session start:\n'
        'Full refund to the original payment method.\n'
        'Between 24 hours and 6 hours before the session start:\n'
        '50% refund.\n'
        'Less than 6 hours before the session start or no-show:\n'
        'No refund.\n\n'
        '3. Rescheduling\n\n'
        'Rescheduling is allowed up to 12 hours before the session start, subject to availability.\n'
        'Rescheduled sessions follow the same cancellation rules based on the new time.\n\n'
        '4. Provider Cancellations\n'
        'If the professional cancels, you’ll receive:\n\n'
        'A full refund, or\n'
        'The option to reschedule at no extra cost.\n\n'
        '5. Payment Method & Processing Time\n'
        'Refunds are processed back to the original payment method (Payfast/Ozow/card/EFT).\n'
        'Typical processing times:\n\n'
        'Card/Payfast: 3–7 business days\n'
        'Ozow/EFT: 2–5 business days\n'
        'Actual times may vary by bank.\n\n'
        '6. Fees & Charges\n\n'
        'Platform or payment processing fees may be non-refundable where permitted by law.\n'
        'Any non-refundable amounts will be displayed at checkout.\n\n'
        '7. Technical Issues\n'
        'If the session is disrupted due to a platform issue, we will evaluate and may offer:\n\n'
        'A partial or full refund, or\n'
        'A rescheduled session.\n\n'
        '8. Consumer Protection Act (CPA)\n'
        'This policy is intended to comply with the Consumer Protection Act (CPA) and other applicable South African laws. If any provision conflicts with law, the law takes precedence.\n\n'
        '9. Contact & Disputes\n'
        'For cancellation or refund enquiries, contact support@trymyday.co.za.',
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LegalDocumentPageBody(
        selectedNav: null,
        documentId: 'cancellation_policy',
        fallback: fallback,
        eyebrow: 'Legal',
      ),
    );
  }
}

class AccountDeletionPage extends StatefulWidget {
  const AccountDeletionPage({super.key});

  static const LegalDocumentModel fallback = LegalDocumentModel(
    id: 'account_deletion',
    title: 'Account Deletion',
    version: '1.0',
    effectiveDate: '29 Jun 2026',
    content:
        'TryMyDay lets users request deletion of their account and associated personal data.\n\n'
        'How to request account deletion\n'
        '1. Send an email to hello@trymyday.co.za from the email address linked to your TryMyDay account.\n'
        '2. Use the subject line: Delete my TryMyDay account.\n'
        '3. Include your full name and the email address used in the app.\n'
        '4. We may ask you to confirm the request before deletion is processed.\n\n'
        'What we delete\n'
        'When your request is verified, we delete or anonymise personal account data where deletion is technically and legally possible. This includes profile information, app preferences, favourites, push notification tokens, and non-essential account records.\n\n'
        'What may be retained\n'
        'Some information may be retained where required for legal, security, fraud-prevention, accounting, payment, dispute-resolution, or platform integrity purposes. This may include payment records, booking records, consent records, support correspondence, safety reports, transaction audit logs, and records needed to comply with applicable law.\n\n'
        'Retention period\n'
        'Deletion requests are normally processed within 30 days after verification. Data that must be retained for legal, accounting, security, or dispute-resolution reasons is kept only for as long as reasonably required for those purposes.\n\n'
        'Partial data deletion\n'
        'You can also request deletion or correction of specific personal data without deleting your full account by emailing hello@trymyday.co.za and describing the data you want removed or corrected.\n\n'
        'Developer\n'
        'TryMyDay is provided by Ayanda Core Solutions (Pty) Ltd.',
  );

  @override
  State<AccountDeletionPage> createState() => _AccountDeletionPageState();
}

class _AccountDeletionPageState extends State<AccountDeletionPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _reasonController = TextEditingController();
  final _service = AccountDeletionRequestService();

  bool _isSubmitting = false;
  AccountDeletionRequestResult? _result;
  String? _error;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _PageShell(
        selectedNav: null,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 56),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(34),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 20,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 820;
                      final details = _AccountDeletionDetails(
                        document: AccountDeletionPage.fallback,
                      );
                      final form = _result == null
                          ? _AccountDeletionForm(
                              formKey: _formKey,
                              fullNameController: _fullNameController,
                              emailController: _emailController,
                              reasonController: _reasonController,
                              isSubmitting: _isSubmitting,
                              error: _error,
                              onSubmit: _submit,
                            )
                          : _AccountDeletionSuccess(result: _result!);

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [details, const SizedBox(height: 28), form],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: details),
                          const SizedBox(width: 34),
                          SizedBox(width: 390, child: form),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const _Footer(),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final result = await _service.submit(
        fullName: _fullNameController.text,
        email: _emailController.text,
        reason: _reasonController.text,
      );
      if (!mounted) return;
      setState(() => _result = result);
    } on FirebaseFunctionsException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message ?? 'Request failed.');
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _error =
            'We could not submit your request. Please try again or email hello@trymyday.co.za.',
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _AccountDeletionDetails extends StatelessWidget {
  const _AccountDeletionDetails({required this.document});

  final LegalDocumentModel document;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account and data controls',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          document.title,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 44,
            height: 1.02,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.4,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Version ${document.version} · Effective ${document.effectiveDate}',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 28),
        const _DeletionPoint(
          icon: Icons.app_registration_rounded,
          title: 'Use the form first',
          body:
              'Submit your request here and we will verify and process it directly.',
        ),
        const _DeletionPoint(
          icon: Icons.delete_outline_rounded,
          title: 'What we delete',
          body:
              'We delete or anonymise personal account data where deletion is technically and legally possible, including profile details, preferences, favourites, push tokens, and non-essential account records.',
        ),
        const _DeletionPoint(
          icon: Icons.receipt_long_rounded,
          title: 'What may be retained',
          body:
              'Payment, booking, consent, support, safety, dispute, and audit records may be retained where required.',
        ),
        const _DeletionPoint(
          icon: Icons.manage_accounts_rounded,
          title: 'Specific data requests',
          body:
              'You can request correction or deletion of specific personal data without deleting your full account. Use the form and describe what you want corrected or removed.',
        ),
        const _DeletionPoint(
          icon: Icons.schedule_rounded,
          title: 'Processing time',
          body:
              'Deletion requests are normally processed within 30 days after verification.',
        ),
        const SizedBox(height: 18),
        const _DeletionInfoPanel(),
        const SizedBox(height: 16),
        const Text(
          'Email fallback: hello@trymyday.co.za',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DeletionInfoPanel extends StatelessWidget {
  const _DeletionInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What deleting your account means',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          _DeletionBullet(
            text:
                'You may lose access to your TryMyDay account, profile, saved professionals, notification preferences, and app settings.',
          ),
          _DeletionBullet(
            text:
                'Upcoming or completed bookings, payments, refunds, support cases, safety reports, and consent records may be retained where required for legal, payment, security, dispute-resolution, or audit purposes.',
          ),
          _DeletionBullet(
            text:
                'If you only want one item corrected or removed, say that clearly in the form instead of requesting full account deletion.',
          ),
          _DeletionBullet(
            text:
                'We may contact you to verify ownership before processing the request.',
          ),
        ],
      ),
    );
  }
}

class _DeletionBullet extends StatelessWidget {
  const _DeletionBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeletionPoint extends StatelessWidget {
  const _DeletionPoint({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
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

class _AccountDeletionForm extends StatelessWidget {
  const _AccountDeletionForm({
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.reasonController,
    required this.isSubmitting,
    required this.error,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController reasonController;
  final bool isSubmitting;
  final String? error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Submit deletion request',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Use the email address linked to your TryMyDay account if you still know it.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            _DeletionTextField(
              label: 'Full name',
              controller: fullNameController,
              textInputAction: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your full name.'
                  : null,
            ),
            const SizedBox(height: 14),
            _DeletionTextField(
              label: 'Email address',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),
            const SizedBox(height: 14),
            _DeletionTextField(
              label: 'Reason (optional)',
              controller: reasonController,
              minLines: 4,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 16),
            const _RetentionNotice(),
            if (error != null) ...[
              const SizedBox(height: 14),
              Text(
                error!,
                style: const TextStyle(
                  color: Color(0xFFB3261E),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: isSubmitting ? null : onSubmit,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.surface,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  isSubmitting ? 'Submitting...' : 'Submit request',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Enter your email address.';
    final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(trimmed);
    return valid ? null : 'Enter a valid email address.';
  }
}

class _DeletionTextField extends StatelessWidget {
  const _DeletionTextField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _RetentionNotice extends StatelessWidget {
  const _RetentionNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'By submitting this request, you acknowledge that some records may be retained where required for legal, payment, security, or dispute-resolution purposes.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDeletionSuccess extends StatelessWidget {
  const _AccountDeletionSuccess({required this.result});

  final AccountDeletionRequestResult result;

  @override
  Widget build(BuildContext context) {
    final title = result.alreadyExists
        ? 'Request already received'
        : 'Request received';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'We will review your request and may contact you to verify it before deletion is processed.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Request ref: ${result.requestId}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalDocumentPageBody extends StatelessWidget {
  const _LegalDocumentPageBody({
    required this.selectedNav,
    required this.documentId,
    required this.fallback,
    required this.eyebrow,
  });

  final _NavDestination? selectedNav;
  final String documentId;
  final LegalDocumentModel fallback;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      selectedNav: selectedNav,
      children: [
        _LegalDocumentSection(
          documentId: documentId,
          fallback: fallback,
          eyebrow: eyebrow,
        ),
        const _Footer(),
      ],
    );
  }
}

class _LegalDocumentSection extends StatelessWidget {
  const _LegalDocumentSection({
    required this.documentId,
    required this.fallback,
    required this.eyebrow,
  });

  final String documentId;
  final LegalDocumentModel fallback;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    final service = LegalDocumentService();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: StreamBuilder<LegalDocumentModel?>(
            stream: service.watchById(documentId),
            builder: (context, snapshot) {
              final document = snapshot.data ?? fallback;

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(34),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 20,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      document.title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 44,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Version ${document.version} • Effective ${document.effectiveDate}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) ...[
                      const SizedBox(height: 18),
                      const LinearProgressIndicator(
                        minHeight: 3,
                        color: AppColors.primary,
                        backgroundColor: AppColors.surfaceMuted,
                      ),
                    ],
                    const SizedBox(height: 28),
                    SelectableText(
                      document.content,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        height: 1.7,
                      ),
                    ),
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
