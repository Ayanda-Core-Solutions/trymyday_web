part of 'home_page.dart';

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
              _Header(selectedNav: _NavDestination.about),
              _AboutSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
