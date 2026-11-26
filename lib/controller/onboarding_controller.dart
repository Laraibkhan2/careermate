import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/onboarding_model.dart';
import '../view/screens/auth/login_screen.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  int currentPage = 0;

  bool get isLast => currentPage == onboardingPages.length - 1;

  /// Called by the PageView whenever the visible page changes.
  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  /// Moves [step] pages forward (1) or back (-1). Does nothing at the ends.
  void go(int step) {
    final target =
        (currentPage + step).clamp(0, onboardingPages.length - 1).toInt();
    if (target == currentPage) return;
    pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  /// "Next" goes to the following page; on the last page it finishes.
  void next() {
    if (isLast) {
      finish();
    } else {
      go(1);
    }
  }

  void finish() {
    // TODO: save "onboarding seen" in local_storage so it is shown only once.
    Get.offAll(() => const LoginScreen());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
