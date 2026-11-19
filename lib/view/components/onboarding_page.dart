import 'package:flutter/material.dart';

import '../../model/onboarding_model.dart';
import '../../utils/app_colors.dart';
import 'screen_header.dart';

/// One slide inside the onboarding PageView.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.page});

  final OnboardingModel page;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(page.icon, size: 96, color: AppColors.primary),
          ),
        ),
        ScreenHeader(title: page.title, subtitle: page.subtitle),
      ],
    );
  }
}
