part of '../home/home_page.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key, this.initialExpandedTopicSlug});

  final String? initialExpandedTopicSlug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _FaqPageBody(initialExpandedTopicSlug: initialExpandedTopicSlug),
    );
  }
}

class _FaqPageBody extends StatelessWidget {
  const _FaqPageBody({this.initialExpandedTopicSlug});

  final String? initialExpandedTopicSlug;

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      selectedNav: _NavDestination.faq,
      children: [
        _FaqSection(initialExpandedTopicSlug: initialExpandedTopicSlug),
        const _Footer(),
      ],
    );
  }
}
