import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Small read-only label. Use [TagChip.matched] and [TagChip.missing]
/// for skills the user has or still needs.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.background = AppColors.primaryLight,
    this.foreground = AppColors.textPrimary,
    this.icon,
  });

  const TagChip.matched({super.key, required this.label})
      : background = AppColors.successLight,
        foreground = AppColors.onSuccessLight,
        icon = Icons.check_rounded;

  const TagChip.missing({super.key, required this.label})
      : background = AppColors.warningLight,
        foreground = AppColors.onWarningLight,
        icon = null;

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (icon != null) Icon(icon, size: 14, color: foreground),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
