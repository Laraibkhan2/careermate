import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Row of dots that shows which page is current (the active one is longer).
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: List.generate(
        count,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: index == current ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == current ? AppColors.primary : AppColors.textHint,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
