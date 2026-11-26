import 'package:flutter/material.dart';

import '../../model/onboarding_model.dart';
import '../../utils/page_offset.dart';
import '../../utils/app_colors.dart';
import 'onboarding_scenes.dart';

/// The big rounded stage of the onboarding. Its colors blend from one slide
/// to the next while you swipe, and the animated scene on each slide moves
/// slower than the page itself (parallax).
class OnboardingStage extends StatelessWidget {
  const OnboardingStage({
    super.key,
    required this.controller,
    required this.onPageChanged,
  });

  final PageController controller;
  final ValueChanged<int> onPageChanged;

  static const _radius = 36.0;

  Widget _sceneFor(OnboardingScene scene, int index) => switch (scene) {
    OnboardingScene.match => MatchScene(controller: controller, index: index),
    OnboardingScene.skills => SkillsScene(controller: controller, index: index),
    OnboardingScene.tracker => TrackerScene(controller: controller, index: index),
  };

  @override
  Widget build(BuildContext context) {
    final pager = PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: onboardingPages.length,
      itemBuilder: (context, index) => _ParallaxPage(
        controller: controller,
        index: index,
        child: _sceneFor(onboardingPages[index].scene, index),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      child: pager,
      builder: (context, child) {
        final page = pageOf(controller);
        final last = onboardingPages.length - 1;
        final from = page.floor().clamp(0, last).toInt();
        final to = (from + 1).clamp(0, last).toInt();
        final mix = (page - from).clamp(0.0, 1.0).toDouble();

        final top = Color.lerp(
          onboardingPages[from].colors[0],
          onboardingPages[to].colors[0],
          mix,
        )!;
        final bottom = Color.lerp(
          onboardingPages[from].colors[1],
          onboardingPages[to].colors[1],
          mix,
        )!;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [top, bottom],
            ),
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: bottom.withValues(alpha: 0.32),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: Stack(
              children: [
                Positioned(
                  right: -50 - page * 30,
                  top: -40,
                  child: const _Circle(size: 190, alpha: 0.10),
                ),
                Positioned(
                  left: -60 + page * 20,
                  bottom: -70,
                  child: const _Circle(size: 210, alpha: 0.08),
                ),
                Positioned.fill(child: child!),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Fades the scene and slides it a little slower than the page.
class _ParallaxPage extends StatelessWidget {
  const _ParallaxPage({
    required this.controller,
    required this.index,
    required this.child,
  });

  final PageController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => AnimatedBuilder(
        animation: controller,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: kSceneWidth,
              height: kSceneHeight,
              child: child,
            ),
          ),
        ),
        builder: (context, inner) {
          final delta = index - pageOf(controller);
          return Opacity(
            opacity: (1 - delta.abs() * 0.9).clamp(0.0, 1.0).toDouble(),
            child: Transform.translate(
              offset: Offset(-delta * box.maxWidth * 0.35, 0),
              child: inner,
            ),
          );
        },
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.onPrimary.withValues(alpha: alpha),
      ),
    );
  }
}

/// Title and subtitle of every slide, stacked on top of each other. While
/// swiping, the old text slides away and fades out as the new one comes in.
class OnboardingCopy extends StatelessWidget {
  const OnboardingCopy({super.key, required this.controller});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = pageOf(controller);
        return Stack(
          children: [
            for (final (i, slide) in onboardingPages.indexed)
              _CopyBlock(slide: slide, delta: i - page),
          ],
        );
      },
    );
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock({required this.slide, required this.delta});

  final OnboardingModel slide;

  /// How far this slide is from the current page (0 = the current one).
  final double delta;

  @override
  Widget build(BuildContext context) {
    final distance = delta.abs();

    return ExcludeSemantics(
      excluding: distance > 0.5,
      child: Opacity(
        opacity: (1 - distance * 1.6).clamp(0.0, 1.0).toDouble(),
        child: Transform.translate(
          offset: Offset(delta * 56, 0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slide.title,
                  style: const TextStyle(
                    fontSize: 30,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slide.subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
