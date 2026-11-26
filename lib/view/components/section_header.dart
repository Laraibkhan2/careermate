import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Section title with an optional link on the right ("See all", "Edit").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (actionText != null)
          TextButton(onPressed: onAction, child: Text(actionText!)),
      ],
    );
  }
}
