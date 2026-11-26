import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/onboarding_controller.dart';
import '../../../model/onboarding_model.dart';
import '../../../utils/app_colors.dart';
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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopBar(showSkip: !c.isLast, onSkip: c.finish),
                const SizedBox(height: 16),
                Expanded(
                  child: OnboardingStage(
                    controller: c.pageController,
                    onPageChanged: c.onPageChanged,
                  ),
                ),
                const SizedBox(height: 28),
                // The text can be swiped too, not only the picture above it.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (velocity < -200) c.go(1);
                    if (velocity > 200) c.go(-1);
                  },
                  child: OnboardingCopy(controller: c.pageController),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    PageDots(
                      count: onboardingPages.length,
                      controller: c.pageController,
                    ),
                    const Spacer(),
                    _NextButton(isLast: c.isLast, onPressed: c.next),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.showSkip, required this.onSkip});

  final bool showSkip;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const SizedBox(
            width: 34,
            height: 34,
            child: Icon(Icons.work_rounded, size: 18, color: AppColors.onPrimary),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'CareerMate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Visibility(
          visible: showSkip,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: TextButton(onPressed: onSkip, child: const Text('Skip')),
        ),
      ],
    );
  }
}

/// Round arrow button that grows into a "Get started" button on the last page.
class _NextButton extends StatelessWidget {
  const _NextButton({required this.isLast, required this.onPressed});

  final bool isLast;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isLast ? 'Get started' : 'Next',
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        width: isLast ? 172 : 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.32),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onPressed,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLast
                    ? const Text(
                        'Get started',
                        key: ValueKey('start'),
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : const Icon(
                        Icons.arrow_forward_rounded,
                        key: ValueKey('next'),
                        color: AppColors.onPrimary,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
