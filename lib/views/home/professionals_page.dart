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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FBF5), Color(0xFFF3F7F0), Color(0xFFF8F8F2)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _Header(selectedNav: _NavDestination.professionals),
              _ProfessionalsHeroSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
