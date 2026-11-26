import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Rounded tag you can tap. When [isSelected] it fills with blue and a
/// check mark slides in, all animated.
class SkillChip extends StatelessWidget {
  const SkillChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected ? AppColors.onPrimary : AppColors.textPrimary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.primary : AppColors.primaryLight,
          shape: const StadiumBorder(),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: isSelected
                        ? Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(Icons.check_rounded, size: 16, color: textColor),
                    )
                        : const SizedBox.shrink(),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}