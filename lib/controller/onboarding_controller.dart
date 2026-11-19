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

  /// "Next" goes to the following page; on the last page it finishes.
  void next() {
    if (isLast) {
      finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
