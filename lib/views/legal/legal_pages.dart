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
        'If you have privacy questions, please contact support@trymayday.co.za.',
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
        'For cancellation or refund enquiries, contact support@trymayday.co.za.',
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

class AccountDeletionPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LegalDocumentPageBody(
        selectedNav: null,
        documentId: 'account_deletion',
        fallback: fallback,
        eyebrow: 'Account and data controls',
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
