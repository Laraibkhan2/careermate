import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Round avatar with the user's initials.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.initials, this.size = 64});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
