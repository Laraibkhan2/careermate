import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_card.dart';
import '../../components/app_page.dart';
import '../../components/gradient_card.dart';
import '../../components/profile_avatar.dart';
import '../../components/screen_header.dart';
import '../../components/section_header.dart';
import '../../components/settings_tile.dart';
import '../../components/tag_chip.dart';
import '../skills/add_skills_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (user) => AppPage(
        children: [
          const ScreenHeader(
            title: 'Profile',
            subtitle: 'Manage your account and skills.',
          ),
          GradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    ProfileAvatar(initials: user.initials),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimary,
                            ),
                          ),
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 13, color: AppColors.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile completion',
                          style: TextStyle(fontSize: 13, color: AppColors.onPrimary),
                        ),
                        Text(
                          '${user.completion}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: user.completion / 100),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.onPrimary,
                        backgroundColor: AppColors.onPrimary.withValues(alpha: 0.28),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                SectionHeader(
                  title: 'My skills',
                  actionText: 'Edit',
                  onAction: () => Get.to(() => const AddSkillsScreen()),
                ),
                if (user.skills.isEmpty)
                  const Text(
                    'No skills yet. Tap Edit to add some.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final skill in user.skills) TagChip(label: skill)],
                  ),
              ],
            ),
          ),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.notifications_none_rounded,
                title: 'Push notifications',
                trailing: Switch(value: user.pushEnabled, onChanged: user.togglePush),
              ),
              SettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit profile',
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Get.to(() => const EditProfileScreen()),
              ),
              SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Log out',
                color: AppColors.error,
                onTap: user.logout,
              ),
            ],
          ),
        ],
      ),
    );
  }
}