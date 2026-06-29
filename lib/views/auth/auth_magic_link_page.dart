part of '../home/home_page.dart';

class AuthMagicLinkPage extends StatelessWidget {
  const AuthMagicLinkPage({super.key, required this.token});

  final String? token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _PageShell(
        selectedNav: _NavDestination.home,
        children: [
          _AuthMagicLinkSection(token: token),
          const _Footer(),
        ],
      ),
    );
  }
}

class _AuthMagicLinkSection extends StatelessWidget {
  const _AuthMagicLinkSection({required this.token});

  final String? token;

  bool get hasToken => token != null && token!.trim().isNotEmpty;

  Uri? get appUri {
    final value = token?.trim();
    if (value == null || value.isEmpty) return null;
    return Uri(
      scheme: 'trymyday',
      host: 'auth',
      path: '/magic',
      queryParameters: {'token': value},
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLink = appUri;

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
                      ? 'For your security, this magic link is verified inside the TryMyDay app. If the app is installed, tap below to continue.'
                      : 'Request a new sign-in email from the TryMyDay app, then open the latest link on your phone.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMuted,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 28),
                if (appLink != null) ...[
                  FilledButton.icon(
                    onPressed: () async {
                      await openExternalUrl(appLink, target: '_self');
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open TryMyDay app'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'If nothing happens, make sure the latest TryMyDay app is installed, then request a new link.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
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
