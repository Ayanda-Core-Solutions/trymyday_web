part of '../home/home_page.dart';

class ProfessionalPublicProfilePage extends StatelessWidget {
  const ProfessionalPublicProfilePage({
    super.key,
    required this.professionalId,
    this.professionalService,
  });

  final String professionalId;
  final PublicProfessionalService? professionalService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: (professionalService ?? PublicProfessionalService())
            .fetchByIdOrSlug(professionalId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          if (data == null) {
            return const _PageShell(
              selectedNav: _NavDestination.professionals,
              children: [_MissingProfessionalProfileSection(), _Footer()],
            );
          }

          return _PageShell(
            selectedNav: _NavDestination.professionals,
            children: [
              _ProfessionalPublicProfileSection(data: data),
              const _Footer(),
            ],
          );
        },
      ),
    );
  }
}

class _ProfessionalPublicProfileSection extends StatelessWidget {
  const _ProfessionalPublicProfileSection({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final personalDetails = data['personalDetails'];
    final displayName =
        personalDetails is Map && personalDetails['displayName'] is String
        ? personalDetails['displayName'] as String
        : data['displayName'] as String? ??
              data['name'] as String? ??
              'Professional';
    final role = data['role'] as String? ?? 'Professional';
    final company = data['company'] as String? ?? '';
    final about = data['about'] as String?;
    final rate = data['rate'];
    final imageUrl = data['imageUrl'] as String?;
    final subtitle = company.isEmpty ? role : '$role at $company';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 128, 24, 96),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.background],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              CircleAvatar(
                radius: 58,
                backgroundColor: AppColors.surface,
                backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl == null || imageUrl.isEmpty
                    ? const Icon(
                        Icons.person_rounded,
                        size: 58,
                        color: AppColors.primary,
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                displayName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.surface.withValues(alpha: 0.86),
                ),
              ),
              if (rate != null) ...[
                const SizedBox(height: 20),
                Text(
                  'Paid sessions from R$rate',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              if (about != null && about.trim().isNotEmpty) ...[
                const SizedBox(height: 28),
                Text(
                  about,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.surface,
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 34),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 14,
                runSpacing: 14,
                children: [
                  StoreButton(
                    icon: AppIcons.apple,
                    upperLabel: 'Download on the',
                    lowerLabel: 'App Store',
                    onTap: _launchAppStore,
                  ),
                  StoreButton(
                    icon: AppIcons.googlePlay,
                    upperLabel: 'Get it on',
                    lowerLabel: 'Google Play',
                    onTap: _launchGooglePlay,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingProfessionalProfileSection extends StatelessWidget {
  const _MissingProfessionalProfileSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 128, 24, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            children: [
              Text(
                'Profile not found',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'This TryMyDay professional profile may no longer be available.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
