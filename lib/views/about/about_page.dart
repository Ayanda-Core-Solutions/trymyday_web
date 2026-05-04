part of '../home/home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _AboutPageBody());
  }
}

class _AboutPageBody extends StatelessWidget {
  const _AboutPageBody();

  @override
  Widget build(BuildContext context) {
    return const _PageShell(
      selectedNav: _NavDestination.about,
      children: [_AboutSection(), _Footer()],
    );
  }
}
