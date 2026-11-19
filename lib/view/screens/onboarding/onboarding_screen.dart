import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/onboarding_controller.dart';
import '../../../model/onboarding_model.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/onboarding_page.dart';
import '../../components/page_dots.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      init: OnboardingController(),
      builder: (c) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              spacing: 24,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Visibility(
                    visible: !c.isLast,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: TextButton(
                      onPressed: c.finish,
                      child: const Text('Skip'),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: c.pageController,
                    onPageChanged: c.onPageChanged,
                    itemCount: onboardingPages.length,
                    itemBuilder: (_, index) =>
                        OnboardingPage(page: onboardingPages[index]),
                  ),
                ),
                PageDots(
                  count: onboardingPages.length,
                  current: c.currentPage,
                ),
                CustomButton(
                  text: c.isLast ? 'Get started' : 'Next',
                  onPressed: c.next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
