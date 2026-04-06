import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';

class StoreButton extends StatelessWidget {
  const StoreButton({
    super.key,
    required this.icon,
    required this.upperLabel,
    required this.lowerLabel,
  });

  final IconData icon;
  final String upperLabel;
  final String lowerLabel;

  @override
  Widget build(BuildContext context) {
    const upperFontSize = 11.0;
    const lowerFontSize = 21.0;
    const iconSlotSize = lowerFontSize + 15;
    final iconSize = _iconScale(icon) * iconSlotSize;
    final iconWidget = icon.fontPackage == 'font_awesome_flutter'
        ? FaIcon(icon, color: Colors.white, size: iconSize)
        : Icon(icon, color: Colors.white, size: iconSize);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconSlotSize,
            height: iconSlotSize,
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                upperLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: upperFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                lowerLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: lowerFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _iconScale(IconData value) {
    if (value == FontAwesomeIcons.apple) {
      return 0.83;
    }
    if (value == FontAwesomeIcons.googlePlay) {
      return 0.75;
    }
    return 0.82;
  }
}
