part of 'home_page.dart';

class ProfessionalsPage extends StatelessWidget {
  const ProfessionalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _ProfessionalsPageBody());
  }
}

class _ProfessionalsPageBody extends StatelessWidget {
  const _ProfessionalsPageBody();

  @override
  Widget build(BuildContext context) {
    return const _PageShell(
      selectedNav: _NavDestination.professionals,
      children: [_ProfessionalsHeroSection(), _Footer()],
    );
  }
}
