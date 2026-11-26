import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/page_offset.dart';

/// Dots that follow the finger: the dot of the page you are moving to
/// stretches while the one you leave shrinks.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.controller});

  final int count;
  final PageController controller;

  static const _inactive = Color(0xFFCBD5E1);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = pageOf(controller);
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            for (var i = 0; i < count; i++)
              _Dot(active: 1 - (page - i).abs().clamp(0.0, 1.0).toDouble()),
          ],
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  /// 0 = far from the current page, 1 = the current page.
  final double active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8 + 20 * active,
      height: 8,
      decoration: BoxDecoration(
        color: Color.lerp(PageDots._inactive, AppColors.primary, active),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
