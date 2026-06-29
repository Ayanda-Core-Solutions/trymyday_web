part of '../home/home_page.dart';

class AuthMagicLinkPage extends StatelessWidget {
  const AuthMagicLinkPage({super.key, required this.hasToken});

  final bool hasToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _PageShell(
        selectedNav: _NavDestination.home,
        children: [
          _AuthMagicLinkSection(hasToken: hasToken),
          const _Footer(),
        ],
      ),
    );
  }
}

class _AuthMagicLinkSection extends StatelessWidget {
  const _AuthMagicLinkSection({required this.hasToken});

  final bool hasToken;

  @override
  Widget build(BuildContext context) {
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
          constraints: const BoxConstraints(maxWidth: 620),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 28,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(AppImages.smileyWhite),
                ),
                const SizedBox(height: 24),
                Text(
                  hasToken
                      ? 'Open this link in TryMyDay'
                      : 'This sign-in link is incomplete',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  hasToken
                      ? 'For your security, this magic link is verified inside the TryMyDay app. If the app is installed, open this same email link from Mail, Notes, WhatsApp, or Messages on your phone.'
                      : 'Request a new sign-in email from the TryMyDay app, then open the latest link on your phone.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMuted,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 28),
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
      ),
    );
  }
}
