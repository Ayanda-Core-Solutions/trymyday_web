part of 'home_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _ContactPageBody());
  }
}

class _ContactPageBody extends StatelessWidget {
  const _ContactPageBody();

  @override
  Widget build(BuildContext context) {
    return const _PageShell(
      selectedNav: _NavDestination.contact,
      children: [_ContactSection(), _Footer()],
    );
  }
}
