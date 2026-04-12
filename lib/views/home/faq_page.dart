part of 'home_page.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _FaqPageBody());
  }
}

class _FaqPageBody extends StatelessWidget {
  const _FaqPageBody();

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
              _Header(selectedNav: _NavDestination.faq),
              _FaqSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
