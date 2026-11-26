import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/role_controller.dart';
import '../../../model/user_role.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_card.dart';
import '../../components/app_page.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/screen_header.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const _icons = {
    UserRole.seeker: Icons.search_rounded,
    UserRole.employer: Icons.business_center_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoleController>(
      init: RoleController(),
      builder: (c) => AppPage(
        children: [
          const ScreenHeader(
            title: 'How will you use CareerMate?',
            subtitle: 'Choose one. You cannot change it later.',
          ),
          for (final role in UserRole.values)
            _RoleCard(
              role: role,
              icon: _icons[role]!,
              isSelected: c.selected == role,
              onTap: () => c.select(role),
            ),
        ],
        bottom: CustomButton(
          text: 'Continue',
          isLoading: c.isLoading,
          onPressed: c.selected == null ? null : c.confirm,
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final UserRole role;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: isSelected ? AppColors.primaryLight : AppColors.whiteColour,
      borderColor: isSelected ? AppColors.primary : AppColors.border,
      child: Row(
        spacing: 14,
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  role.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  role.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}