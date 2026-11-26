import 'package:flutter/material.dart';

/// Which animated mini-scene a slide shows.
enum OnboardingScene { match, skills, tracker }

class OnboardingModel {
  const OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.scene,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final OnboardingScene scene;

  /// The two colors of the stage gradient. While swiping, the stage blends
  /// from the colors of one slide to the next.
  final List<Color> colors;
}

/// The onboarding slides. Add or edit a slide here and the screen updates
/// (a new slide also needs its scene in onboarding_scenes.dart).
const onboardingPages = [
  OnboardingModel(
    title: 'Jobs that fit your skills',
    subtitle: 'Every job shows a match score, so you apply where you have a real chance.',
    scene: OnboardingScene.match,
    colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
  ),
  OnboardingModel(
    title: 'Know what to learn next',
    subtitle: 'See the skills a job asks for that you do not have yet, and close the gap.',
    scene: OnboardingScene.skills,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  ),
  OnboardingModel(
    title: 'Track every application',
    subtitle: 'Follow each one from saved to interview and get an alert when an employer replies.',
    scene: OnboardingScene.tracker,
    colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
  ),
];
