import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Circle that fills up to [percent] (counting up from 0) with the
/// number in the middle.
class MatchRing extends StatelessWidget {
  const MatchRing({
    super.key,
    required this.percent,
    this.size = 72,
    this.color = AppColors.success,
    this.trackColor = AppColors.border,
    this.textColor = AppColors.textPrimary,
  });

  final int percent;
  final double size;
  final Color color;
  final Color trackColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$percent% match',
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: percent / 100),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: size * 0.11,
                strokeCap: StrokeCap.round,
                color: color,
                backgroundColor: trackColor,
              ),
              Center(
                child: Text(
                  '${(value * 100).round()}%',
                  style: TextStyle(
                    fontSize: size * 0.26,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}