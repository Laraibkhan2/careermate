import 'package:flutter/material.dart';

class OnboardingModel {
  const OnboardingModel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

const onboardingPages = [
  OnboardingModel(
    icon: Icons.work_outline_rounded,
    title: 'Jobs that fit your skills',
    subtitle: 'See your match score for every job and what you still need to learn.',
  ),
  OnboardingModel(
    icon: Icons.lightbulb_outline_rounded,
    title: 'Know what to learn next',
    subtitle: 'Spot the skills you are missing and see how close you are.',
  ),
  OnboardingModel(
    icon: Icons.notifications_active_outlined,
    title: 'Track every application',
    subtitle: 'Save jobs, update their status and get alerts so nothing is missed.',
  ),
];
