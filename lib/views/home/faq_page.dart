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
    return const _PageShell(
      selectedNav: _NavDestination.faq,
      children: [_FaqSection(), _Footer()],
    );
  }
}
