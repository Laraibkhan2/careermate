import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Blue gradient card with soft decorative circles. Put white text inside.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            const Positioned(right: -30, top: -30, child: _Circle(size: 130, alpha: 0.10)),
            const Positioned(right: 40, bottom: -50, child: _Circle(size: 110, alpha: 0.08)),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.onPrimary.withValues(alpha: alpha),
      ),
    );
  }
}