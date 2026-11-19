import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/app_colors.dart';
import 'view/screens/onboarding/onboarding_screen.dart';

void main() => runApp(const CareerMateApp());

class CareerMateApp extends StatelessWidget {
  const CareerMateApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'CareerMate',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
      ).copyWith(primary: AppColors.primary, error: AppColors.error),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),
    home: const OnboardingScreen(),
  );
}
