part of '../home/home_page.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key, this.initialExpandedQuestion});

  final String? initialExpandedQuestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _FaqPageBody(initialExpandedQuestion: initialExpandedQuestion),
    );
  }
}

class _FaqPageBody extends StatelessWidget {
  const _FaqPageBody({this.initialExpandedQuestion});

  final String? initialExpandedQuestion;

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      selectedNav: _NavDestination.faq,
      children: [
        _FaqSection(initialExpandedQuestion: initialExpandedQuestion),
        const _Footer(),
      ],
    );
  }
}
