import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/app_binding.dart';
import 'firebase_options.dart';
import 'services/push_service.dart';
import 'utils/app_colors.dart';
import 'view/screens/onboarding/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PushService.listenInForeground();
  runApp(const CareerMateApp());
}

class CareerMateApp extends StatelessWidget {
  const CareerMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme,
    );

    return GetMaterialApp(
      title: 'CareerMate',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ).copyWith(primary: AppColors.primary, error: AppColors.error),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          scrolledUnderElevation: 0,
          titleTextStyle: textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: AppColors.primaryLight,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}