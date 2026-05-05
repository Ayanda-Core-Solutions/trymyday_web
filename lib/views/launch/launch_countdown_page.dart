import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_images.dart';
import '../home/home_page.dart';

class LaunchCountdownPage extends StatefulWidget {
  const LaunchCountdownPage({super.key, required this.launchAt});

  final DateTime launchAt;

  @override
  State<LaunchCountdownPage> createState() => _LaunchCountdownPageState();
}

class _LaunchCountdownPageState extends State<LaunchCountdownPage> {
  late Duration _remaining = _remainingUntilLaunch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final nextRemaining = _remainingUntilLaunch();
      setState(() {
        _remaining = nextRemaining;
      });
      if (nextRemaining == Duration.zero) {
        context.go(homeRoute);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 720;
    final countdownItems = _CountdownParts.fromDuration(_remaining).items;

    return Scaffold(
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: size.height),
        color: AppColors.background,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 22 : 48,
              vertical: compact ? 28 : 42,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppImages.smileyWhite,
                            width: 34,
                            height: 34,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'TryMyDay',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: compact ? 64 : 96),
                    Text(
                      'TryMyDay launches June 1.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: compact ? 48 : 78,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'A new way to make the right conversations happen is coming soon.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 21,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: compact ? 44 : 64),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final twoColumns = constraints.maxWidth < 680;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: countdownItems.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: twoColumns ? 2 : 4,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: twoColumns ? 1.45 : 1.25,
                              ),
                          itemBuilder: (context, index) {
                            final item = countdownItems[index];
                            return _CountdownTile(
                              value: item.value,
                              label: item.label,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: compact ? 40 : 56),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'The full website will open when the countdown reaches zero.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Duration _remainingUntilLaunch() {
    final remaining = widget.launchAt.difference(DateTime.now());
    if (remaining.isNegative) return Duration.zero;

    return remaining;
  }
}

class _CountdownTile extends StatelessWidget {
  const _CountdownTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 52,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownParts {
  const _CountdownParts({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory _CountdownParts.fromDuration(Duration duration) {
    return _CountdownParts(
      days: duration.inDays,
      hours: duration.inHours.remainder(24),
      minutes: duration.inMinutes.remainder(60),
      seconds: duration.inSeconds.remainder(60),
    );
  }

  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  List<_CountdownItem> get items {
    return [
      _CountdownItem(days.toString(), 'Days'),
      _CountdownItem(_twoDigits(hours), 'Hours'),
      _CountdownItem(_twoDigits(minutes), 'Minutes'),
      _CountdownItem(_twoDigits(seconds), 'Seconds'),
    ];
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class _CountdownItem {
  const _CountdownItem(this.value, this.label);

  final String value;
  final String label;
}
