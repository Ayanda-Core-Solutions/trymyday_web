import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';

class StoreButton extends StatefulWidget {
  const StoreButton({
    super.key,
    required this.icon,
    required this.upperLabel,
    required this.lowerLabel,
    this.compact = false,
    this.onTap,
  });

  final FaIconData icon;
  final String upperLabel;
  final String lowerLabel;
  final bool compact;
  final VoidCallback? onTap;

  @override
  State<StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<StoreButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final upperFontSize = widget.compact ? 9.5 : 11.0;
    final lowerFontSize = widget.compact ? 16.0 : 21.0;
    final iconSlotSize = lowerFontSize + (widget.compact ? 10 : 15);
    final iconSize = _iconScale(widget.icon) * iconSlotSize;
    final iconWidget = FaIcon(widget.icon, color: Colors.white, size: iconSize);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        scale: _pressed ? 0.97 : (_hovered ? 1.015 : 1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(
                  alpha: _hovered ? 0.2 : 0.12,
                ),
                blurRadius: _hovered ? 20 : 16,
                offset: Offset(0, _hovered ? 12 : 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: _pressed
                    ? const Color(0xFF114A46)
                    : (_hovered ? const Color(0xFF1B6661) : AppColors.primary),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: _hovered ? 0.18 : 0.08),
                ),
              ),
              child: InkWell(
                onTap: widget.onTap ?? () {},
                onHighlightChanged: (value) {
                  if (_pressed != value) {
                    setState(() => _pressed = value);
                  }
                },
                borderRadius: BorderRadius.circular(18),
                splashColor: Colors.white.withValues(alpha: 0.18),
                highlightColor: Colors.white.withValues(alpha: 0.08),
                hoverColor: Colors.white.withValues(alpha: 0.04),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.compact ? 12 : 18,
                    vertical: widget.compact ? 12 : 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: iconSlotSize,
                        height: iconSlotSize,
                        child: Center(child: iconWidget),
                      ),
                      SizedBox(width: widget.compact ? 10 : 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.upperLabel,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: upperFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.lowerLabel,
                            style: TextStyle(
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _iconScale(FaIconData value) {
    if (value == FontAwesomeIcons.apple) {
      return 0.83;
    }
    if (value == FontAwesomeIcons.googlePlay) {
      return 0.75;
    }
    return 0.82;
  }
}
