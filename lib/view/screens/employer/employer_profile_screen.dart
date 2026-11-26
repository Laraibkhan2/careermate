import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_card.dart';
import '../../components/app_page.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/screen_header.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (user) => AppPage(
        children: [
          const ScreenHeader(
            title: 'Profile',
            subtitle: 'Your employer account.',
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const Text(
                  'Employer',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            text: 'Log out',
            isOutlined: true,
            color: AppColors.error,
            onPressed: user.logout,
          ),
        ],
      ),
    );
  }
}